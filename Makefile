PKG_NAME = tsht
PKG_VERSION = 0.0.1

MKDIR = mkdir -p
CP = cp -rfv
RM = rm -rfv

PREFIX = $(DESTDIR)/usr/local
SHAREDIR = $(PREFIX)/share/$(PKG_NAME)
BINDIR = $(PREFIX)/bin

LIBS = lib/*

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
	sed -n '1,/<!-- Begin API -->/p' README.md >> README.new &&\
		./doc/apidoc.pl --heading-prefix='##' $(LIBS) >> README.new &&\
		sed -n '/<!-- End API -->/,$$p' README.md >> README.new &&\
		mv README.new README.md
	sed -n '1,/<!-- Begin API TOC -->/p' README.md >> README.new &&\
		./doc/apidoc.pl --toc --no-body --toc-prefix='	' $(LIBS) >> README.new &&\
		sed -n '/<!-- End API TOC -->/,$$p' README.md >> README.new &&\
		mv README.new README.md
 
