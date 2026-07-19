# Next Session

## Completed last session ✓

- [x] ~~`--version` shows cpdf backend version~~
- [x] ~~Switched backend from commercial `cpdfsqueeze` to open-source `cpdf -squeeze`~~
- [x] ~~Fixed 16 stale bats tests (were testing for output strings the script never produced)~~
- [x] ~~Tracked pre-commit hook: hooks/pre-commit + hooks/install.sh~~
- [x] ~~Tagged and published v1.1.0 on GitHub~~
- [x] ~~pdftools CONVENTIONS.md: cross-tool Unix citizenship standards~~

## Carried over

- Decide: start M1 (multi-backend) in bash, or jump straight to Go rewrite
- If staying in bash: audit available tools on the system (gs, qpdf, mutool, cpdf) as first M1 task
- Benchmark `cpdf -squeeze` on a set of real PDFs to establish a baseline before adding new backends

## Start-of-session checklist

Run `bats tests/pdfclean.bats` first — before writing any new code — to catch pre-existing failures early.

## Technical notes

**Parallel batch processing (backlog item):** Doable in bash with `&` + `wait`,
but three things get ugly: (1) exit codes — subshells can't write back to the
parent, requiring `wait $pid` checks or temp-file status passing; (2) output
interleaving — concurrent jobs scramble output without per-job buffering;
(3) trap cleanup — parent can't track subshell temp files on Ctrl-C without
extra bookkeeping. For a typical handful-of-PDFs workload the gain is marginal
anyway. In Go this would be trivial (goroutines + WaitGroup). Parallel
processing is a mild argument for the Go rewrite.

**Metadata preservation:** `cpdf -squeeze` overwrites the PDF `Producer` field —
this is backend behaviour, nothing pdfclean can do about it. All other metadata
(Title, Author, Creator, Create Date) is preserved. File permissions and xattrs
are now explicitly preserved by pdfclean.
