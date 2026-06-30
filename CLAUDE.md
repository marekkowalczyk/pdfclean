# pdfclean

PDF compression wrapper. Currently uses `cpdfsqueeze` as its backend.

## Start/End

Every session begins with `/start` and ends with `/close`.

## What it does

- Accepts one or more PDF files as arguments; `.` / `--all` / `-a` processes all `*.pdf` / `*.PDF` in the current directory
- Errors if called with no arguments
- Compresses each file in-place using `cpdfsqueeze`
- Only replaces the original if the compressed version is actually smaller
- Reports per-file size reduction (bytes and percentage)
- Warns and skips duplicate filenames

## Structure

Single bash script: `pdfclean`. Symlinked from `/usr/local/bin/pdfclean`.

## Dependencies

- `cpdfsqueeze` (commercial, must be installed separately)
- `awk` (for percentage calculation)
- `stat` (macOS `stat -f%z` with Linux `stat --format="%s"` fallback)

## Design decisions

- Files are compressed to a `mktemp` file in the same directory as the source (same filesystem → atomic `mv`), swapped only if smaller. Temp file is cleaned up via `trap` on exit/interrupt.
- No recursive directory walking by design. User controls which files are processed.
- Progress output uses ANSI inverted colors, but only when stdout is a TTY.
- All errors and warnings go to stderr; exit code reflects any failures.

## Key documents

- **dev/VISION.md** — where the project is headed, success criteria, open questions. Read before proposing new features.
- **dev/TODO.md** — milestones and tasks. Update as work is completed. All development is guided by this file.
- **dev/AAR.md** — after action reviews, continuous improvement log.
