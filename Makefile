PKG_NAME = tsht
PKG_VERSION = 0.0.1

PREFIX = $(DESTDIR)/usr/local
SHAREDIR = $(PREFIX)/share/$(PKG_NAME)
BINDIR = $(PREFIX)/bin

MKDIR = mkdir -p
CP = cp -rfv
RM = rm -rfv

TSHT_ARGS =
SHINCLUDE_ARGS =

LIBS = lib/*

.PHONY: test doc README.md

test: test/.tsht test/tsht
	./test/tsht --color "$(TSHT_ARGS)"

README.md:
	shinclude -i -c xml $(SHINCLUDE_ARGS) README.md

install:
	$(MKDIR) $(SHAREDIR)
	$(CP) -t $(SHAREDIR) tsht-*.sh doc LICENSE README.md
	$(MKDIR) $(BINDIR)
	sed '1a TSHTLIB=$(SHAREDIR)' tsht > $(BINDIR)/tsht
	chmod a+x $(BINDIR)/tsht

uninstall:
	$(RM) $(SHAREDIR)
	$(RM) $(BINDIR)/tsht
