# Next Session

## Completed last session ✓

- [x] ~~Unix citizenship polish (verbosity, error format, -h, silence non-events)~~
- [x] ~~Preserve file permissions after compression~~
- [x] ~~Preserve extended attributes (Finder tags, Spotlight comments)~~
- [x] ~~Released v1.1.0~~

## Carried over

- Decide: start M1 (multi-backend) in bash, or jump straight to Go rewrite
- If staying in bash: audit available tools on the system (gs, qpdf, mutool, cpdfsqueeze) as first M1 task
- Benchmark cpdfsqueeze on a set of real PDFs to establish a baseline before adding new backends

## Technical notes

**Parallel batch processing (backlog item):** Doable in bash with `&` + `wait`,
but three things get ugly: (1) exit codes — subshells can't write back to the
parent, requiring `wait $pid` checks or temp-file status passing; (2) output
interleaving — concurrent jobs scramble output without per-job buffering;
(3) trap cleanup — parent can't track subshell temp files on Ctrl-C without
extra bookkeeping. For a typical handful-of-PDFs workload the gain is marginal
anyway. In Go this would be trivial (goroutines + WaitGroup). Parallel
processing is a mild argument for the Go rewrite.

**Metadata preservation:** cpdfsqueeze overwrites the PDF `Producer` field —
this is backend behaviour, nothing pdfclean can do about it. All other metadata
(Title, Author, Creator, Create Date) is preserved. File permissions and xattrs
are now explicitly preserved by pdfclean.
