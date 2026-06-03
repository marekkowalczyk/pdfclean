# pdfclean

PDF compression wrapper. Currently uses `cpdfsqueeze` as its backend.

## Start/End

Every session begins with `/start` and ends with `/close`.

## What it does

- Accepts one or more PDF files as arguments, or defaults to `*.pdf` in the current directory
- Compresses each file in-place using `cpdfsqueeze`
- Only replaces the original if the compressed version is actually smaller
- Reports per-file size reduction (bytes and percentage)

## Structure

Single bash script: `pdfclean`. Symlinked from `/usr/local/bin/pdfclean`.

## Dependencies

- `cpdfsqueeze` (commercial, must be installed separately)
- `awk` (for percentage calculation)
- `stat` (macOS `stat -f%z` with Linux `stat --format="%s"` fallback)

## Design decisions

- Files are compressed to a `.tmp` beside the original, then swapped only if smaller. This is the safety mechanism — never lose data.
- No recursive directory walking by design. User controls which files are processed.
- Progress output uses ANSI inverted colors for visibility in terminal.

## Key documents

- **VISION.md** — where the project is headed, success criteria, open questions. Read before proposing new features.
- **TODO.md** — milestones and tasks. Update as work is completed. All development is guided by this file.
