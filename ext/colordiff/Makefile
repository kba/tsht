BINDIR := $(PREFIX)/bin
URL := https://cdn.jsdelivr.net/gh/daveewart/colordiff@current/colordiff.pl

$(BINDIR)/colordiff:
	@mkdir -p "$(BINDIR)"
	@wget -O "$@" "$(URL)"
	@chmod a+x "$@"

install: $(BINDIR)/colordiff
