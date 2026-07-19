# pdfclean — Tasks

Work items for developing pdfclean. Organized by milestone. Each task should be small enough to complete in one session.

Status key: `[ ]` todo, `[x]` done, `[~]` in progress, `[-]` dropped

---

## M0: Foundation (current script, housekeeping)

- [x] Create repo, move script, symlink to /usr/local/bin
- [x] Add CLAUDE.md and README.md
- [x] Write VISION.md
- [x] Write TODO.md
- [x] Add LICENSE file (MIT)
- [x] Add --help and --version flags
- [x] Add --dry-run / -n flag (report sizes without compressing)
- [x] Unix citizenship: exit codes, stderr for errors/warnings
- [x] Unix citizenship: TTY check for ANSI codes
- [x] Unix citizenship: --quiet / -q mode
- [x] Unix citizenship: -- end-of-options marker
- [x] Unix citizenship: short flags (-a, -n, -q)
- [x] Unix citizenship: mktemp in source dir + trap for cleanup
- [x] No-argument error; . / --all / -a for current directory
- [x] Match *.PDF in addition to *.pdf
- [x] Warn and skip duplicate filenames
- [x] bats test suite (24 tests, mock cpdf)
- [x] Move developer docs to dev/
- [x] Unix citizenship: -h alias for --help
- [x] Unix citizenship: progname-prefixed errors ('pdfclean: ...')
- [x] Unix citizenship: silence non-events (no output when file unchanged)
- [x] Unix citizenship: short hint on error instead of full usage block
- [x] Unix citizenship: suppress backend stdout unconditionally
- [x] Filename-prefixed result lines (gzip-style)
- [x] Release v1.0.0
- [x] Preserve file permissions after compression
- [x] Preserve extended attributes (Finder tags, Spotlight comments) after compression
- [x] Release v1.1.0
- [x] --version shows cpdf backend version
- [x] Tracked pre-commit hook (hooks/pre-commit + hooks/install.sh)
- [x] Tag and publish v1.1.0 on GitHub
- [x] pdftools CONVENTIONS.md (cross-tool Unix citizenship standards)

## M1: Multi-backend compression

- [ ] Audit available tools on the system (gs, qpdf, mutool, cpdf)
- [ ] Add Ghostscript compression path
- [ ] Add qpdf optimization path
- [ ] Run all available backends, keep smallest result
- [ ] Make cpdf -squeeze optional (use if present, skip if not)
- [ ] Benchmark: compare backends on a set of real PDFs

## M2: PDF analysis

- [ ] Report what's inside a PDF (image count/size, font count/size, page count, metadata)
- [ ] Add --analyze or --info flag (analyze without compressing)
- [ ] Use analysis to pick the best compression strategy

## M3: Image-aware optimization

- [ ] Extract embedded images from PDF
- [ ] Recompress images (lossy and lossless options)
- [ ] Reinsert recompressed images
- [ ] Add --lossy / --quality flags

## M4: Polish

- [ ] Summary stats at end of batch run (total saved, best/worst file)
- [x] Quiet mode (--quiet / -q) — done in M0
- [ ] Verbose mode (--verbose / -v) with per-backend results
- [ ] Test on Linux (stat, gs flags, etc.)
- [ ] Write man page or extended --help

## Backlog (unscheduled)

- [ ] Config file support (~/.pdfcleanrc or similar)
- [ ] Homebrew formula
- [ ] Parallel processing for large batches
- [ ] Preserve/strip metadata options
