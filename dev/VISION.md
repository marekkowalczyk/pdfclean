# pdfclean — Vision

## Where we are

A single bash script that wraps `cpdf -squeeze` (an open-source, LGPL PDF optimizer). It works well for personal use:

- Batch-compresses PDFs in-place
- Safe: only replaces originals when compression actually helps
- Reports per-file savings

**Limitations of the current state:**

- Single compression strategy — whatever `cpdf -squeeze` decides to do
- No control over compression aggressiveness
- No insight into *why* a PDF is large (images? fonts? metadata?)
- No CLI niceties (--help, --version, --dry-run)

## Where we want to go

A PDF optimization tool that is **better than any single backend** by intelligently combining multiple open-source tools.

### Core idea

No single PDF optimizer wins on every file. Ghostscript is best for some PDFs, qpdf for others, and image recompression matters most for scan-heavy documents. pdfclean should:

1. **Try multiple strategies** and keep the smallest result
2. **Be smart about what makes a PDF large** — analyze before compressing
3. **Remain simple to use** — zero-config by default, options for power users

### Target capabilities

- **Multi-backend compression**: Ghostscript, qpdf, and direct image recompression (via pikepdf or similar). Run all, keep the winner.
- **PDF analysis mode**: Before compressing, report what's taking space — images, fonts, metadata, duplicated objects — so the user understands the opportunity.
- **Image-aware optimization**: Extract embedded images, recompress with modern settings, reinsert. This is where the biggest wins are for most real-world PDFs.
- **Lossless and lossy modes**: Default to lossless (structure optimization, better deflate, deduplication). Offer a lossy mode for aggressive image recompression.
- **Batch processing with summary**: Total savings across a run, sorted by impact.
- **Dry-run mode**: Show what would happen without touching files.

### Non-goals

- Not a general PDF manipulation tool (no merge, split, rotate, encrypt)
- Not a PDF reader or renderer
- No GUI — CLI only
- No recursive directory walking — the user decides which files to process

### Success criteria

- Matches or beats `cpdf -squeeze` on the majority of real-world PDFs
- Installable via a single `git clone` + symlink (or brew eventually)
- Works on macOS and Linux

## Decision: Implementation language

The current script is bash. As the tool grows beyond shell orchestration, we need a real language. The candidates:

### Option A: Go (recommended)

- **Distribution**: `go install` or a single static binary. No runtime dependencies. Users don't need Python, pip, or a virtualenv.
- **CLI tooling**: Go's standard library and cobra/pflag ecosystem are purpose-built for CLI tools.
- **Consistency**: aligns with mdtopdf and the emerging pattern of Go-based CLI tools in this repo collection.
- **Shelling out**: Go's `os/exec` is clean and easy — orchestrating gs, qpdf, mutool is straightforward.
- **Concurrency**: trivial to run multiple backends in parallel with goroutines and pick the winner.
- **Weakness**: no native PDF object library comparable to pikepdf. For deep PDF manipulation (image extraction/reinsertion in M3), we'd rely on external tools or C bindings.

### Option B: Python (pikepdf)

- **PDF internals**: pikepdf (wrapping qpdf's C++ library) gives direct access to PDF objects, streams, images, fonts. This is the strongest argument.
- **Rapid prototyping**: faster to iterate on compression experiments.
- **Weakness**: distribution is painful — requires Python 3, pip, virtualenv. Users who just want to compress a PDF shouldn't need to manage a Python environment.
- **Weakness**: slower startup time for a CLI tool invoked frequently.

### Decision: hybrid Go + Python

Use both, each where it's strongest:

| Layer | Language | Why |
|---|---|---|
| CLI, orchestration, backend runner | Go | single binary, fast startup, easy parallelism, consistent with other tools |
| PDF object analysis, image extraction/recompression | Python (pikepdf) | best-in-class PDF internals, no equivalent in Go |

**How it works in practice:**

- `pdfclean` is a Go binary. It handles CLI parsing, runs backends (gs, qpdf, mutool) in parallel, compares results, reports to the user.
- A Python helper script (e.g., `pdfclean-images`) handles the image-aware optimization pipeline: extract images, recompress, reinsert. Go calls it like any other backend.
- Python is an **optional dependency**. The core tool (M0–M1) works with Go + system tools only. Image optimization (M3) requires Python + pikepdf. The Go binary detects what's available and uses what it can.

**Distribution:**

- `go install` gives you the core tool
- `pip install pikepdf` unlocks the image optimization backend
- Both are standard, well-understood install paths

## Open questions

- Should we keep `cpdf -squeeze` as an optional backend alongside gs/qpdf/mutool?
- What's the right default image quality for lossy mode?
- Do we need a config file, or are CLI flags enough?
- When (if ever) do we need direct PDF object access beyond what gs/qpdf/mutool provide?
