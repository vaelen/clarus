/* Copyright 2026, Andrew C. Young <andrew@vaelen.org>
 * SPDX-License-Identifier: MIT
 *
 * uiblob FILE -- structurally decode a Clarus UI descriptor blob (the
 * clar_ui_blob[] bytes clarusc/uiblob.cla's uibBuild() produces) into a
 * one-line-per-item text dump on stdout. Ported from the uiBlobDecoder in
 * internal/emitui/emitui_test.go (go-retirement Task 5): same big-endian
 * int32 reader, same Str255-with-(-1)-sentinel string reader, same walk
 * order (header -> windows -> menus -> menu handlers -> every -> app),
 * with a bounds check before every read.
 *
 * Independent decoder: this file includes NO compiler source. Every field
 * list/order below is uiblob.cla's own emission order (uibBuild and its
 * uibEmit* helpers); the field NAMES match the Go decoder's local
 * variable names so a reader can cross-check the dump against the Go
 * assertions line by line.
 *
 * Every integer field is a big-endian int32 at a 4-byte-aligned,
 * BLOB-ABSOLUTE offset (never section-relative); a string is a Str255
 * (one length byte + raw bytes) referenced the same way, with -1 marking
 * "absent" -- printed as `-` rather than a quoted value.
 *
 * Truncation/out-of-range anywhere prints `decode error at offset N:
 * reason` on stderr and exits 1.
 *
 * Line shapes (indices identify the owner chain, outermost first):
 *   header <field>=<n>...
 *   window <wi> <field>=<n>...
 *   widget <wi> <i> <field>=<n>...
 *   table  <wi> <i> <field>=<n>...
 *   col    <wi> <i> <ci> <field>=<n>...
 *   form   <wi> <field>=<n>...
 *   bind   <wi> <bi> <field>=<n>...
 *   layout <tag> <field>=<n>...          tag = form<wi> | table<wi>.<i>
 *   field  <tag> <fi> <field>=<n>...
 *   enum   <tag> <fi> <ei> label=<s> value=<n>
 *   menu   <mi> <field>=<n>...
 *   item   <mi> <ii> <field>=<n>...
 *   handler <hi> <field>=<n>...
 *   every  <ei> ticks=<n>
 *   app    <field>=<n>...
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

/* Record sizes, in bytes, from uiblob.cla's own emission order. */
#define HEADER_SIZE 44 /* 11 int32 */
#define WINDOW_SIZE 48 /* 12 int32 */
#define WIDGET_SIZE 52 /* 13 int32 */
#define MENU_SIZE 20   /*  5 int32 */
#define ITEM_SIZE 16   /*  4 int32 */
#define MH_SIZE 24     /*  6 int32 */
#define EVERY_SIZE 4   /*  1 int32 */
#define BIND_SIZE 8    /*  2 int32 */
#define COL_SIZE 16    /*  4 int32 */
#define LFIELD_SIZE 24 /*  6 int32 per Layout field entry */

static unsigned char *blob;
static long blobLen;

static void bad(long off, const char *why) {
    fprintf(stderr, "decode error at offset %ld: %s (blob is %ld bytes)\n",
            off, why, blobLen);
    exit(1);
}

/* i32 reads a big-endian int32 at a blob-absolute offset. */
static long i32(long off) {
    uint32_t u;
    if (off < 0 || off + 4 > blobLen) bad(off, "int32 read out of range");
    u = ((uint32_t)blob[off] << 24) | ((uint32_t)blob[off + 1] << 16) |
        ((uint32_t)blob[off + 2] << 8) | (uint32_t)blob[off + 3];
    return (long)(int32_t)u;
}

/* putStr prints a Str255 at a blob-absolute offset as "text", or `-` for
 * the -1 absent sentinel. Backslash, double quote and non-printable bytes
 * are escaped so the dump stays one line per item. */
static void putStr(long off) {
    long n, i;
    if (off == -1) {
        fputs("-", stdout);
        return;
    }
    if (off < 0 || off >= blobLen) bad(off, "string offset out of range");
    n = blob[off];
    if (off + 1 + n > blobLen) bad(off, "string runs past blob end");
    putchar('"');
    for (i = 0; i < n; i++) {
        unsigned char c = blob[off + 1 + i];
        if (c == '\\' || c == '"') printf("\\%c", c);
        else if (c < 0x20 || c >= 0x7f) printf("\\x%02x", c);
        else putchar((int)c);
    }
    putchar('"');
}

/* dumpLayout walks one Layout entry (uibEmitLayout): recSize, nFields,
 * then nFields x {ftype, offset, strCap, enumCount, enumLabelsOff,
 * enumValuesOff}, following the enum label/value int32 arrays. */
static void dumpLayout(const char *tag, long off) {
    long nFields, fi;
    if (off == -1) return;
    nFields = i32(off + 4);
    printf("layout %s recSize=%ld nFields=%ld\n", tag, i32(off), nFields);
    if (nFields < 0) bad(off + 4, "negative nFields");
    for (fi = 0; fi < nFields; fi++) {
        long fb = off + 8 + fi * LFIELD_SIZE;
        long enumCount = i32(fb + 12);
        long labelsOff = i32(fb + 16);
        long valuesOff = i32(fb + 20);
        long ei;
        printf("field %s %ld ftype=%ld offset=%ld strCap=%ld enumCount=%ld"
               " enumLabelsOff=%ld enumValuesOff=%ld\n",
               tag, fi, i32(fb), i32(fb + 4), i32(fb + 8), enumCount,
               labelsOff, valuesOff);
        if (enumCount < 0) bad(fb + 12, "negative enumCount");
        for (ei = 0; ei < enumCount; ei++) {
            printf("enum %s %ld %ld label=", tag, fi, ei);
            putStr(i32(labelsOff + ei * 4));
            printf(" value=%ld\n", i32(valuesOff + ei * 4));
        }
    }
}

int main(int argc, char **argv) {
    FILE *f;
    long n, off, i;
    long nWins, winsOff, nMenus, menusOff, nMH, mhOff, nEvery, everyOff, appOff;
    char tag[64];

    if (argc != 2) {
        fprintf(stderr, "usage: uiblob FILE\n");
        return 2;
    }
    f = fopen(argv[1], "rb");
    if (!f) {
        fprintf(stderr, "uiblob: cannot open %s\n", argv[1]);
        return 2;
    }
    if (fseek(f, 0, SEEK_END) != 0 || (n = ftell(f)) < 0 ||
        fseek(f, 0, SEEK_SET) != 0) {
        fprintf(stderr, "uiblob: cannot size %s\n", argv[1]);
        fclose(f);
        return 2;
    }
    blob = malloc((size_t)n + 1);
    if (!blob) {
        fprintf(stderr, "uiblob: out of memory\n");
        fclose(f);
        return 2;
    }
    if (n > 0 && fread(blob, 1, (size_t)n, f) != (size_t)n) {
        fprintf(stderr, "uiblob: short read on %s\n", argv[1]);
        fclose(f);
        return 2;
    }
    fclose(f);
    blobLen = n;

    /* --- header: 11 int32 (uibBuild's uibHeader) ------------------- */
    if (blobLen < HEADER_SIZE) bad(0, "blob shorter than the 44-byte header");
    nWins = i32(8);
    winsOff = i32(12);
    nMenus = i32(16);
    menusOff = i32(20);
    nMH = i32(24);
    mhOff = i32(28);
    nEvery = i32(32);
    everyOff = i32(36);
    appOff = i32(40);
    printf("header magic=0x%08lX version=%ld nWins=%ld winsOff=%ld nMenus=%ld"
           " menusOff=%ld nMenuHandlers=%ld mhOff=%ld nEvery=%ld everyOff=%ld"
           " appOff=%ld\n",
           (unsigned long)i32(0) & 0xffffffffUL, i32(4), nWins, winsOff,
           nMenus, menusOff, nMH, mhOff, nEvery, everyOff, appOff);

    /* --- windows, each with its widgets (and a widget's table/cols and
     * the window's form/binds), all nested under the window --------- */
    if (nWins < 0) bad(8, "negative nWins");
    for (i = 0; i < nWins; i++) {
        long base = winsOff + i * WINDOW_SIZE;
        long nWidgets = i32(base + 28);
        long widgetsOff = i32(base + 32);
        long formOff = i32(base + 44);
        long wi;
        printf("window %ld name=", i);
        putStr(i32(base));
        printf(" title=");
        putStr(i32(base + 4));
        printf(" w=%ld h=%ld resizable=%ld minW=%ld minH=%ld nWidgets=%ld"
               " widgetsOff=%ld stateSize=%ld handlerMask=%ld formOff=%ld\n",
               i32(base + 8), i32(base + 12), i32(base + 16), i32(base + 20),
               i32(base + 24), nWidgets, widgetsOff, i32(base + 36),
               i32(base + 40), formOff);

        if (nWidgets < 0) bad(base + 28, "negative nWidgets");
        for (wi = 0; wi < nWidgets; wi++) {
            long wb = widgetsOff + wi * WIDGET_SIZE;
            long tableOff = i32(wb + 48);
            printf("widget %ld %ld kind=%ld name=", i, wi, i32(wb));
            putStr(i32(wb + 4));
            printf(" caption=");
            putStr(i32(wb + 8));
            printf(" atKind=%ld x=%ld yIsBottom=%ld y=%ld widthIsFill=%ld"
                   " width=%ld fillBoth=%ld flags=%ld eventMask=%ld"
                   " tableOff=%ld\n",
                   i32(wb + 12), i32(wb + 16), i32(wb + 20), i32(wb + 24),
                   i32(wb + 28), i32(wb + 32), i32(wb + 36), i32(wb + 40),
                   i32(wb + 44), tableOff);
            if (tableOff != -1) {
                long layoutOff = i32(tableOff + 4);
                long nCols = i32(tableOff + 8);
                long colsOff = i32(tableOff + 12);
                long ci;
                printf("table %ld %ld rowsIdx=%ld layoutOff=%ld nCols=%ld"
                       " colsOff=%ld\n",
                       i, wi, i32(tableOff), layoutOff, nCols, colsOff);
                if (nCols < 0) bad(tableOff + 8, "negative nCols");
                for (ci = 0; ci < nCols; ci++) {
                    long cb = colsOff + ci * COL_SIZE;
                    printf("col %ld %ld %ld header=", i, wi, ci);
                    putStr(i32(cb));
                    printf(" widthPx=%ld widthFill=%ld fieldIndex=%ld\n",
                           i32(cb + 4), i32(cb + 8), i32(cb + 12));
                }
                snprintf(tag, sizeof tag, "table%ld.%ld", i, wi);
                dumpLayout(tag, layoutOff);
            }
        }

        if (formOff != -1) {
            long layoutOff = i32(formOff);
            long nBinds = i32(formOff + 4);
            long bindsOff = i32(formOff + 8);
            long bi;
            printf("form %ld layoutOff=%ld nBinds=%ld bindsOff=%ld\n", i,
                   layoutOff, nBinds, bindsOff);
            if (nBinds < 0) bad(formOff + 4, "negative nBinds");
            for (bi = 0; bi < nBinds; bi++) {
                long bb = bindsOff + bi * BIND_SIZE;
                printf("bind %ld %ld widgetIndex=%ld fieldIndex=%ld\n", i, bi,
                       i32(bb), i32(bb + 4));
            }
            snprintf(tag, sizeof tag, "form%ld", i);
            dumpLayout(tag, layoutOff);
        }
    }

    /* --- menus, each with its items -------------------------------- */
    if (nMenus < 0) bad(16, "negative nMenus");
    for (i = 0; i < nMenus; i++) {
        long base = menusOff + i * MENU_SIZE;
        long nItems = i32(base + 8);
        long itemsOff = i32(base + 12);
        long ii;
        printf("menu %ld name=", i);
        putStr(i32(base));
        printf(" title=");
        putStr(i32(base + 4));
        printf(" nItems=%ld itemsOff=%ld isStd=%ld\n", nItems, itemsOff,
               i32(base + 16));
        if (nItems < 0) bad(base + 8, "negative nItems");
        for (ii = 0; ii < nItems; ii++) {
            long ib = itemsOff + ii * ITEM_SIZE;
            printf("item %ld %ld name=", i, ii);
            putStr(i32(ib));
            printf(" caption=");
            putStr(i32(ib + 4));
            printf(" key=%ld separator=%ld\n", i32(ib + 8), i32(ib + 12));
        }
    }

    /* --- menu handlers --------------------------------------------- */
    if (nMH < 0) bad(24, "negative nMenuHandlers");
    for (i = 0; i < nMH; i++) {
        long base = mhOff + i * MH_SIZE;
        printf("handler %ld menuIdx=%ld itemIdx=%ld handlerIdx=%ld"
               " scopeWinIdx=%ld menuName=",
               i, i32(base), i32(base + 4), i32(base + 8), i32(base + 12));
        putStr(i32(base + 16));
        printf(" itemName=");
        putStr(i32(base + 20));
        putchar('\n');
    }

    /* --- every blocks ---------------------------------------------- */
    if (nEvery < 0) bad(32, "negative nEvery");
    for (i = 0; i < nEvery; i++) {
        off = everyOff + i * EVERY_SIZE;
        printf("every %ld ticks=%ld\n", i, i32(off));
    }

    /* --- app section (absent -> appOff == -1) ---------------------- */
    if (appOff != -1) {
        printf("app name=");
        putStr(i32(appOff));
        printf(" version=");
        putStr(i32(appOff + 4));
        printf(" author=");
        putStr(i32(appOff + 8));
        printf(" about=");
        putStr(i32(appOff + 12));
        putchar('\n');
    } else {
        printf("app absent\n");
    }
    return 0;
}
