# Putting a compiled program on a small hard-disk image and booting Snow with it

Companion to `snow-floppy-howto.md`. Same goal — get a compiled classic-Mac
program in front of the [Snow](https://snowemu.com) emulator — but using a
small (5 MB) SCSI **hard-disk** image instead of a floppy. Compared with a
floppy this route:

- mounts automatically at boot (no ROM eject / manual re-insert),
- is writable and **persists** everything the emulated Mac writes back to
  the host file when Snow quits cleanly,
- can be read and written from the host with the same hfsutils commands.

The one extra ingredient is a tool that wraps an HFS volume in the
partition map + SCSI driver a Macintosh expects on a hard disk. Verified
with Snow v1.5.0 (Macintosh II FDHD, System 7.1), hfsutils, and Disk
Jockey Jr 2.1.0.

## Prerequisites

| Need | Where to get it |
|------|-----------------|
| Snow | <https://snowemu.com> — `Snow.app`; CLI binary `Snow.app/Contents/MacOS/Snow`. |
| A workspace (`.snoww`) that already boots a system disk at SCSI ID 0 | Set up once in the Snow GUI (Workspace > Save) or hand-written JSON (see §3). The new image is attached as a *second* disk. |
| **hfsutils** (`hformat`, `hmount`, `hcopy`, `hls`, `humount`) | `brew install hfsutils`, distro packages, or a Retro68 toolchain's `toolchain/bin/`. |
| **Disk Jockey Jr** (`djjr`) — builds Mac *device* images | <https://diskjockey.onegeekarmy.eu/djjr/> — macOS `.pkg` (installs `/usr/local/bin/djjr`), or Linux x86_64/arm64 tarballs. To use it without installing, extract the pkg: `pkgutil --expand-full djjr-2.1.0.pkg out && chmod +x out/djjr.pkg/Payload/djjr`. |
| The program | MacBinary `.bin` preferred (keeps resource fork + type/creator). |

Why `djjr`: Snow (like BlueSCSI/PiSCSI) wants **device images** — a whole
drive: block-0 driver descriptor, Apple Partition Map, an `Apple_Driver`
partition holding the SCSI driver, and the HFS partition. hfsutils alone
only makes bare HFS *volume* images (what floppies and Mini vMac use); a
bare volume attached as a SCSI disk will not be recognised by the Mac
because there is no driver to load. `djjr` supplies the map and driver.
(The GUI *Disk Jockey* app does the same thing interactively; Snow's own
*Drives > SCSI #n > Create new HDD image…* makes a blank drive you must then
initialise inside the Mac with *HD SC Setup* — both work, neither is
scriptable.)

> hfsutils keeps a single "current volume" in `~/.hcwd`; point `HOME` at a
> scratch dir when scripting, and never touch an image with hfsutils while
> Snow has it open.

## 1. Build the image (two equivalent routes)

### Route A — volume first, then wrap (reuses the floppy recipe exactly)

```sh
export HOME="$PWD/hfs-scratch"; mkdir -p "$HOME"

dd if=/dev/zero of=vol.dsk bs=1m count=5 status=none    # 5 MB raw HFS volume
hformat -l "My HD" vol.dsk
hmount vol.dsk
hcopy -m MyProgram.bin :                                  # MacBinary: forks + type/creator kept
hcopy -t README.txt :                                     # text (LF->CR, type TEXT)
hls -l
humount

djjr convert to-device vol.dsk MyHD.hda                   # add partition map + SCSI driver
```

### Route B — device image first, then format its HFS partition

```sh
djjr create mac-device MyHD.hda -sM 5      # map + driver + unformatted HFS partition
hformat -l "My HD" MyHD.hda 1              # trailing 1 = format partition #1 of the device image
hmount MyHD.hda                            # hmount auto-selects the HFS partition
hcopy -m MyProgram.bin :
hls -l
humount
```

Either way you end up with `MyHD.hda` (~5.3 MB: 5 MB volume + 64 KB of map
and driver; always a multiple of 512 bytes, as Snow requires). `file
MyHD.hda` should say `Apple Driver Map … Apple_partition_map … Apple_Driver43
… Apple_HFS`. `djjr analyze MyHD.hda` prints the same in detail.

## 2. Attach it to the workspace

Floppies can be passed on the command line; hard disks are part of the
workspace. Either edit the `.snoww` JSON (it's plain JSON, paths relative
to the file, absolute paths fine) so SCSI ID 1 points at the image:

```json
"scsi_targets": [ { "Disk": "hdd0.img" }, { "Disk": "MyHD.hda" }, "None", "None", "None", "None", "None" ]
```

…or, with Snow running, use *Drives > SCSI #1 > Load HDD disk image…* and
then *Machine > Reset* — a disk attached while running is only seen after
a restart. Keep the boot disk at ID 0. (Snow's docs: "After mounting a
disk, you must reset or restart the emulated system for it to be
recognized.")

For scripted runs, write the workspace fresh each time, e.g.:

```sh
python3 - <<'EOF'
import json
ws = json.load(open("MyMac.snoww"))          # your known-good boot workspace
ws["scsi_targets"][1] = {"Disk": "MyHD.hda"}   # same directory as the .snoww
json.dump(ws, open("MyMac-with-hd.snoww", "w"), indent=2)
EOF
```

## 3. Start Snow

```sh
SNOW=/Applications/Snow.app/Contents/MacOS/Snow   # in this repo: snow/ClarusSnow
"$SNOW" "$PWD/MyMac-with-hd.snoww" > snow.log 2>&1 &
SNOW_PID=$!
```

In this repo the launch path is `snow/ClarusSnow`, a symlink into our own
`snow/Snow.app` copy, so a test boot never collides with a Snow someone
else is already running: `pgrep -x Snow` finds THAT one, `pgrep -x
ClarusSnow` finds ours. Never touch a running Snow you did not start.

`snow.log` shows `SCSI ID #1: loaded image file …/MyHD.hda` at start. The
System boots from ID 0 and the new volume appears on the desktop under its
`-l` name (~30–60 s after launch on a Mac II/System 7.1) — no eject, no
menu fiddling. Double-click the program to run it.

Stop Snow cleanly by SIGTERMing the pid you launched — `kill -TERM
"$SNOW_PID"`, or `kill -TERM "$(pgrep -x ClarusSnow)"` in this repo. Do
NOT use `osascript -e 'quit app "Snow"'`: `Snow` by name may be a
different instance than yours, and quitting by name takes that one down
instead. A forced `kill -9` can leave the image's HFS structures
half-written.

## 4. Getting results back out

This is where the hard-disk route pays off: everything the emulated Mac
wrote to the volume is in `MyHD.hda` once Snow has exited. Then:

```sh
hmount MyHD.hda            # Snow must NOT be running
hls -l                     # e.g. an 'out' file your program created
hcopy -t :out ./out.txt    # text (CR->LF)
hcopy -m :Result ./Result.bin   # anything with a resource fork, as MacBinary
humount
```

Snow writes through to the image file; the bytes are reliably complete
only after Snow's process has exited. Don't read the image mid-session.

## Complete script

```sh
#!/bin/sh
set -e
SNOW=/Applications/Snow.app/Contents/MacOS/Snow   # in this repo: snow/ClarusSnow
WS=/path/to/MyMac.snoww          # boots a system disk at SCSI 0
PROG=/path/to/MyProgram.bin      # MacBinary
DIR="$PWD/run"; mkdir -p "$DIR"; cd "$DIR"
export HOME="$DIR/hfs-scratch"; mkdir -p "$HOME"

dd if=/dev/zero of=vol.dsk bs=1m count=5 status=none
hformat -l "My HD" vol.dsk
hmount vol.dsk; hcopy -m "$PROG" :; humount
djjr convert to-device vol.dsk MyHD.hda

python3 - "$WS" <<'EOF'
import json, sys, os
src = sys.argv[1]; ws = json.load(open(src))
base = os.path.dirname(os.path.abspath(src))
for k in ("rom_path", "display_card_rom_path", "pram_path"):   # absolutize
    if ws.get(k) and not os.path.isabs(ws[k]): ws[k] = os.path.join(base, ws[k])
d = ws["scsi_targets"][0]["Disk"]
if not os.path.isabs(d): ws["scsi_targets"][0]["Disk"] = os.path.join(base, d)
ws["scsi_targets"][1] = {"Disk": "MyHD.hda"}
json.dump(ws, open("run.snoww", "w"), indent=2)
EOF

"$SNOW" "$DIR/run.snoww" > snow.log 2>&1 &
echo "Snow pid $!. 'My HD' mounts on the desktop after boot (~30-60 s)."
echo "After quitting Snow: hmount $DIR/MyHD.hda; hls -l; hcopy ..."
```

(For automated runs also copy the boot disk/PRAM to `$DIR` and point the
workspace at the copies, so the originals are never mutated.)

## Troubleshooting

| Symptom | Cause / fix |
|---------|-------------|
| Volume never appears; log shows `SCSI ID #1: loaded image file` | The image is a bare HFS volume (hfsutils output used directly) — no partition map/driver, so the Mac can't see it. Run `djjr convert to-device` on it. |
| Snow refuses the image | Size not a multiple of 512 bytes, or not a full device image. `djjr` output is always valid; if you hand-built something, `djjr analyze` it. |
| Attached via the Drives menu but not mounted | Needs *Machine > Reset* (or a Finder restart) after attaching. |
| Program shows a generic document icon / won't launch | Copied without its resource fork (`hcopy -r`/`-t` or non-MacBinary source). Re-copy with `hcopy -m` from a `.bin`. |
| `hmount` can't open the `.hda` / shows the wrong volume | Stale `~/.hcwd` — `humount` first or give hfsutils a fresh `HOME`. Also make sure Snow has quit. |
| Files written by the Mac are missing on the host | Snow was killed rather than quit; or you read the image while Snow was still running. |
