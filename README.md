# pdfclean

Batch PDF compression tool. Compresses PDF files in-place, keeping the original if no size reduction is achieved.

## Usage

```bash
pdfclean .                        # compress all *.pdf / *.PDF in current directory
pdfclean -a                       # same
pdfclean report.pdf notes.pdf     # compress specific files
pdfclean -n .                     # dry-run: report what would change, modify nothing
pdfclean -q .                     # quiet: no output unless there's an error
pdfclean -- -oddly-named.pdf      # use -- to pass filenames starting with -
```

## Options

| Flag | Long form | Description |
|------|-----------|-------------|
| `.` or `-a` | `--all` | Process all `*.pdf` / `*.PDF` in current directory |
| `-n` | `--dry-run` | Report sizes without modifying files |
| `-q` | `--quiet` | Suppress all non-error output |
| | `--version` | Print version and backend version, then exit |
| `-h` | `--help` | Print help and exit |
| `--` | | End of options; treat remaining args as filenames |

## Installation

```bash
git clone https://github.com/marekkowalczyk/pdfclean.git
ln -s "$PWD/pdfclean/pdfclean" /usr/local/bin/pdfclean
```

Or install the full [pdftools](https://github.com/marekkowalczyk/pdftools) suite.

## Requirements

- [cpdfsqueeze](https://www.coherentpdf.com/cpdfsqueeze/) (commercial PDF optimizer)
- bash

## How it works

For each PDF file:

1. Compresses to a temp file (via `mktemp`) in the same directory as the source
2. Compares sizes — replaces the original only if the result is smaller
3. Copies file permissions and extended attributes (Finder tags, Spotlight comments) to the replacement
4. Reports the reduction in bytes and percentage
5. Cleans up the temp file on exit, even if interrupted

No data is ever lost. If compression doesn't help, the original is kept unchanged.

## Development

Install the pre-commit hook (runs the test suite before every commit):

```bash
bash hooks/install.sh
```

Run tests manually:

```bash
bats tests/pdfclean.bats
```

24 tests using mock `cpdfsqueeze` binaries — no real PDFs required.

## License

MIT
