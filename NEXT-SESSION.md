# Next Session

## Completed last session ✓

- [x] ~~Switched backend from commercial `cpdfsqueeze` to open-source `cpdf -squeeze` (script, 24 bats tests, all docs updated)~~
- [x] ~~Added `Makefile` with `install` / `uninstall` / `test` / `deps` targets, replacing manual `ln -s` instructions~~
- [x] ~~`install` warns (doesn't fail) if `cpdf` isn't on `PATH`; `deps` optionally runs `brew install cpdf`, kept separate from `install` on purpose~~
- [x] ~~Verified against `pdftools/CONVENTIONS.md` line by line — fully compliant~~
- [x] ~~Bumped to v1.2.0, tagged, and published GitHub release~~

## Carried over

- **Disk space is critically low on this machine** (~164Mi free / 99% full at last check) — caused a `brew install cpdf` failure mid-session. Not a pdfclean bug, but worth a cleanup pass before it breaks something else.
- The `cpdf` binary currently installed on this machine came from a manual download to `~/Downloads`, not `brew`/`make deps` — works fine, but there's no record of its provenance/version pinning. Low priority; revisit if `make deps` becomes the norm.
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
