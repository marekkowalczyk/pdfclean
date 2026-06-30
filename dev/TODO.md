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
- [x] Add --dry-run flag (report sizes without compressing)

## M1: Multi-backend compression

- [ ] Audit available tools on the system (gs, qpdf, mutool, cpdfsqueeze)
- [ ] Add Ghostscript compression path
- [ ] Add qpdf optimization path
- [ ] Run all available backends, keep smallest result
- [ ] Make cpdfsqueeze optional (use if present, skip if not)
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
- [ ] Quiet mode (--quiet / -q)
- [ ] Verbose mode (--verbose / -v) with per-backend results
- [ ] Test on Linux (stat, gs flags, etc.)
- [ ] Write man page or extended --help

## Backlog (unscheduled)

- [ ] Config file support (~/.pdfcleanrc or similar)
- [ ] Homebrew formula
- [ ] Parallel processing for large batches
- [ ] Preserve/strip metadata options
