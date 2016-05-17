PKG_NAME = tsht
PKG_VERSION = 0.0.1

MKDIR = mkdir -p
CP = cp -rfv
RM = rm -rfv

PREFIX = $(DESTDIR)/usr/local
SHAREDIR = $(PREFIX)/share/$(PKG_NAME)
BINDIR = $(PREFIX)/bin

.PHONY: test

test:
	@./test/tsht

install:
	$(MKDIR) $(SHAREDIR)
	$(CP) -t $(SHAREDIR) tsht-*.sh doc LICENSE
	$(MKDIR) $(BINDIR)
	sed '1a TSHTLIB=$(SHAREDIR)' tsht > $(BINDIR)/tsht
	chmod a+x $(BINDIR)/tsht

uninstall:
	$(RM) $(SHAREDIR)
	$(RM) $(BINDIR)/tsht

doc: doc/tsht-core.md

doc/%.md: %.sh
	@$(MKDIR) doc
	grep '^#' "$<" \
		| grep -v '#!' \
		| sed 's/^#\s\?//' \
		> "$@"
	touch $@.toc
	echo "# API of $<" >> $@.toc
	echo "" >> $@.toc
	grep '^##' $@ \
		| sed 's,^#*\s\(.*\),- [\1](#\1),' \
		>> $@.toc
	echo "" >> $@.toc
	cat $@.toc $@ > $@.tmp
	mv $@.tmp $@
	rm $@.toc
 
