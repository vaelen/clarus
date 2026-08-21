# Putting a compiled program on a floppy image and booting Snow with it

This is a generic, tool-agnostic recipe for:

1. building a classic-Mac (HFS) floppy disk image on a modern host,
2. copying a compiled Macintosh program onto it, and
3. starting the [Snow](https://snowemu.com) classic Macintosh emulator with
   that floppy already inserted.

It assumes nothing about how the program was compiled. Any program that
exists on the host as a MacBinary file (`.bin`), a raw data file, or a text
file can be placed on the image. The recipe was verified with Snow
v1.5.0 emulating a Macintosh II (FDHD) running System 7.1, with a 1.44 MB
raw HFS image created by hfsutils.

If you'd rather avoid the boot-time eject and get the Mac's writes back on
the host, see the companion `snow-hdd-howto.md` (same steps, 5 MB SCSI
hard-disk image instead).

## Prerequisites

| Need | Where to get it |
|------|-----------------|
| Snow | <https://snowemu.com> — installs as `Snow.app` on macOS; the CLI binary is `Snow.app/Contents/MacOS/Snow`. |
| A Snow workspace (`.snoww`) that already boots a system disk (SCSI hard-disk image + ROM + PRAM) | Set it up once in the Snow GUI ("Workspace > Save"), or write the JSON by hand (see below). Floppies are not persisted in workspaces, so you need a bootable hard-disk image regardless. |
| **hfsutils** (`hformat`, `hmount`, `hcopy`, `hls`, `humount`) | `brew install hfsutils` on macOS, distro packages on Linux, or the copies shipped in a Retro68 toolchain build (`toolchain/bin/`). |
| The program to ship | Preferably a MacBinary `.bin` (keeps resource fork + type/creator — executables *need* their resource fork). |

> hfsutils keeps a single global "current volume" in `~/.hcwd`. If several
> scripts might run concurrently, set `HOME` to a private scratch dir before
> invoking any `h*` command (shown below). Never mount an image with
> hfsutils while Snow has it open.

## 1. Create a blank HFS floppy image

Pick the size matching the drive of the Mac model you emulate:

| Model | Drive | Raw image size |
|-------|-------|----------------|
| Mac 128K/512K | 400K | 409 600 bytes (`count=400`) |
| 512Ke, Plus, SE, Mac II (non-FDHD) | 800K | 819 200 bytes (`count=800`) |
| SE FDHD, Classic, Mac II FDHD (SuperDrive) | 1.44 MB | 1 474 560 bytes (`count=1440`) |

A SuperDrive machine reads all three sizes; an 800K machine cannot read a
1.44 MB image.

```sh
export HOME="$PWD/hfs-scratch"; mkdir -p "$HOME"   # isolate hfsutils' ~/.hcwd

dd if=/dev/zero of=MyDisk.dsk bs=1024 count=1440 status=none
hformat -l "My Disk" MyDisk.dsk          # -l = volume name shown on the Mac desktop
```

`hformat` writes a valid, empty HFS volume into the zero-filled file. The
result is a plain sector-ordered ("raw") image, which Snow loads directly.

## 2. Copy the program (and any data files) onto it

```sh
hmount MyDisk.dsk                         # select the volume
hcopy -m MyProgram.bin :                  # MacBinary -> both forks + type/creator preserved
hcopy -t README.txt  :                    # text: LF -> CR translation, type TEXT
hcopy -r  data.bin   :Data                # raw bytes into the data fork only, no translation
hmkdir :Folder ; hcopy -m Other.bin :Folder:   # sub-folders use ':' as the separator
hls -l                                    # verify: type/creator, sizes
humount
```

`:` is the root of the mounted volume; `:Path:To:File` addresses paths.
Use `-m` for anything that must run (applications, code resources) — a
`-r` copy of an application drops its resource fork and it will not launch.

## 3. Start Snow with the floppy inserted

Snow has no headless mode; it opens its normal window and runs until quit.
Start it in the background:

```sh
SNOW=/Applications/Snow.app/Contents/MacOS/Snow
"$SNOW" path/to/MyMac.snoww --floppy "$PWD/MyDisk.dsk" > snow.log 2>&1 &
```

- The positional argument is a workspace (`.snoww`) or a ROM file; the
  workspace is what selects the machine, ROM, PRAM and the bootable SCSI
  disk.
- `--floppy FILE` inserts the image into the first floppy drive before
  power-on. Repeat the flag for a second drive. Use an absolute path (Snow's
  working directory may not be yours).
- **Expect an eject at boot.** The ROM tries the floppy first, finds it is
  not a System disk, and ejects it before the OS comes up (`snow.log`:
  `Drive 0: disk inserted … 'MyDisk.dsk'` followed by `disk ejected`). Once
  the desktop is up (~30–60 s on a Mac II/System 7.1), put it back with
  **Drives > Floppy #1 > Re-insert last ejected floppy**; it then mounts
  under its `-l` name with your files inside — double-click to run.
  (Snow may occasionally re-insert it by itself; don't rely on that.)
  Alternative that avoids the eject entirely: start Snow without
  `--floppy` and, after boot, use **Drives > Floppy #1 > Load image…**.
- Stop Snow cleanly from a script with `osascript -e 'quit app "Snow"'`
  (macOS); `kill` works too, but discards unsaved floppy/PRAM state.

Other useful flags: `--serial-bridge-a tcp:PORT` / `--serial-bridge-b …`
(SCC serial to TCP or PTY), `-f`/`--zen` (fullscreen/zen; need a
workspace/ROM argument). `Snow --help` lists them.

### Minimal workspace JSON

If you don't have a `.snoww` yet, this is the shape Snow writes. Paths are
relative to the workspace file (absolute paths also work):

```json
{
  "model": "MacIIFDHD",
  "rom_path": "MacII.rom",
  "display_card_rom_path": "AppleMacintoshDisplayCard8-24.bin",
  "pram_path": "mymac.pram",
  "scsi_targets": [ { "Disk": "hdd0.img" }, "None", "None", "None", "None", "None", "None" ],
  "init_args": { "ram_size": 134217728, "monitor": "HiRes14", "video_card": "Mdc12",
                 "mouse_mode": "Absolute", "audio_disabled": false,
                 "start_fastforward": false, "pmmu_enabled": false },
  "floppy_images": [],
  "viewport_scale": 2.0
}
```

The hard-disk image must already contain a System Folder (install it once
from System installer floppies, or reuse an existing bootable image). For
automated runs, copy the `.img`, `.pram` and `.snoww` to a scratch dir and
boot the copies, so the pristine originals never change.

## 4. Getting files back out / writes to the floppy

Snow only writes changes back to **MOOF** images. A raw `.dsk` (or
DiskCopy `.image`) is effectively read-only from the host's point of view:
the emulated Mac can write to it during the session, but after Snow exits
the file on disk is unchanged. Options if you need the guest's writes:

- When the floppy is first loaded, Snow can offer to convert it to a sibling
  `MyDisk.moof` and enable automatic writeback (configurable under
  *Options > Floppy*; "Always convert"/"Always enable" avoids the prompts
  in scripted runs). Writeback then updates `MyDisk.moof` as the guest
  writes.
- Or use *Drives > Floppy #n > Save image…* before quitting — always saves
  as MOOF.
- Or write results to the **hard-disk** image instead: its changes are
  flushed to `hdd0.img` when Snow exits cleanly, and `hmount hdd0.img`
  (hfsutils auto-selects the HFS partition of a full-device image) lets you
  `hcopy` them out with the same tools — again only while Snow is not
  running.

hfsutils cannot read MOOF, so pull files out of a MOOF by saving it back to
a raw/DiskCopy image from within Snow or by reading it with a MOOF-aware
tool; for round-tripping data to the host, the hard-disk route is the
simplest.

## Complete script

```sh
#!/bin/sh
set -e
SNOW=/Applications/Snow.app/Contents/MacOS/Snow
WS=/path/to/MyMac.snoww          # boots a system disk
PROG=/path/to/MyProgram.bin      # MacBinary
IMG="$PWD/MyDisk.dsk"

export HOME="$PWD/hfs-scratch"; mkdir -p "$HOME"
dd if=/dev/zero of="$IMG" bs=1024 count=1440 status=none
hformat -l "My Disk" "$IMG"
hmount "$IMG"
hcopy -m "$PROG" :
hls -l
humount

"$SNOW" "$WS" --floppy "$IMG" > snow.log 2>&1 &
echo "Snow pid $!. After boot (~30-60 s) the ROM will have ejected the floppy:"
echo "use Drives > Floppy #1 > 'Re-insert last ejected floppy' to mount it."
```

## Troubleshooting

| Symptom | Cause / fix |
|---------|-------------|
| Floppy never appears on the desktop; log shows `disk inserted` then `disk ejected` | Normal: the boot ROM ejects non-System floppies. Re-insert via *Drives > Floppy #1 > Re-insert last ejected floppy* after boot (§3). If it is ejected *again* after re-insert, the OS did not recognise the volume: check `hformat` ran on a file of one of the exact sizes above, and that the emulated Mac has a drive that can read it (no 1.44 MB images on non-SuperDrive models). |
| Program shows a generic document icon and "application could not be found" | It was copied without its resource fork (`hcopy -r`/`-t`, or the source was not MacBinary). Re-copy with `hcopy -m` from a `.bin`. |
| `hmount` says the volume is in use / wrong volume is selected | Stale `~/.hcwd`; run `humount`, or point `HOME` at a fresh directory. |
| Host file unchanged after the guest wrote to the floppy | Expected for raw images (see §4); use MOOF writeback or the hard disk. |
| Snow exits immediately | Workspace paths (ROM/PRAM/disk) don't resolve from the workspace file's directory; make them absolute. |
