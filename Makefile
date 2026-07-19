PREFIX ?= /usr/local
BINDIR := $(DESTDIR)$(PREFIX)/bin

.PHONY: install uninstall test

install:
	install -d "$(BINDIR)"
	ln -sf "$(CURDIR)/pdfclean" "$(BINDIR)/pdfclean"
	@command -v cpdf >/dev/null 2>&1 || echo "pdfclean: warning: 'cpdf' not found on PATH — see README.md#requirements" >&2

uninstall:
	rm -f "$(BINDIR)/pdfclean"

test:
	bats tests/pdfclean.bats
