# pdfclean

Batch PDF compression tool. Compresses PDF files in-place, keeping the original if no size reduction is achieved.

## Usage

```bash
# Compress specific files
pdfclean report.pdf presentation.pdf

# Compress all PDFs in current directory
pdfclean
```

## Installation

1. Clone this repo
2. Symlink to your PATH:
   ```bash
   ln -s /path/to/pdfclean/pdfclean /usr/local/bin/pdfclean
   ```

## Requirements

- [cpdfsqueeze](https://www.coherentpdf.com/cpdfsqueeze/) (commercial PDF optimizer)
- bash

## How it works

For each PDF file:

1. Compresses to a temporary file using `cpdfsqueeze`
2. Compares sizes — replaces the original only if the result is smaller
3. Reports the reduction in bytes and percentage

No data is lost. If compression doesn't help, the original is kept unchanged.

## License

MIT
