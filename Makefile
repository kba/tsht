PKG_NAME = tsht
PKG_VERSION = 0.0.1

MKDIR = mkdir -p
CP = cp -rfv
RM = rm -rfv

PREFIX = $(DESTDIR)/usr/local
SHAREDIR = $(PREFIX)/share/$(PKG_NAME)
BINDIR = $(PREFIX)/bin

LIBS = tsht-core.sh

.PHONY: test doc

test:
	@if which tap-spec >/dev/null;then \
		./test/tsht | tap-spec; \
	else \
		./test/tsht; \
	fi

install:
	$(MKDIR) $(SHAREDIR)
	$(CP) -t $(SHAREDIR) tsht-*.sh doc LICENSE README.md
	$(MKDIR) $(BINDIR)
	sed '1a TSHTLIB=$(SHAREDIR)' tsht > $(BINDIR)/tsht
	chmod a+x $(BINDIR)/tsht

uninstall:
	$(RM) $(SHAREDIR)
	$(RM) $(BINDIR)/tsht

doc: $(LIBS)
	./doc/apidoc.pl $^ > doc/api.md

 
