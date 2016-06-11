PKG_NAME = tsht
PKG_VERSION = 0.0.1

MKDIR = mkdir -p
CP = cp -rfv
RM = rm -rfv

PREFIX = $(DESTDIR)/usr/local
SHAREDIR = $(PREFIX)/share/$(PKG_NAME)
BINDIR = $(PREFIX)/bin

TSHT_ARGS =

LIBS = lib/*

.PHONY: test doc README.md

test: test/.tsht test/tsht
	./test/tsht --color "$(TSHT_ARGS)"
#     @rm -r $^
# test/tsht:
#     @cp -rt test tsht
# test/.tsht:
#     @$(MKDIR) $@
#     @cp -rt $@ tsht-runner.sh lib extension

install:
	$(MKDIR) $(SHAREDIR)
	$(CP) -t $(SHAREDIR) tsht-*.sh doc LICENSE README.md
	$(MKDIR) $(BINDIR)
	sed '1a TSHTLIB=$(SHAREDIR)' tsht > $(BINDIR)/tsht
	chmod a+x $(BINDIR)/tsht

uninstall:
	$(RM) $(SHAREDIR)
	$(RM) $(BINDIR)/tsht

README.md:
	shinclude -i -c xml README.md
# sed -n '1,/<!-- Begin CLI -->/p' README.md >> README.new &&\
#     echo '```' >> README.new &&\
#     ./test/tsht --help >> README.new &&\
#     echo '```' >> README.new &&\
#     sed -n '/<!-- End CLI -->/,$$p' README.md >> README.new &&\
#     mv README.new README.md
# sed -n '1,/<!-- Begin tsht -->/p' README.md >> README.new &&\
#     echo '```' >> README.new &&\
#     ./test/tsht | tap-spec >> README.new &&\
#     echo '```' >> README.new &&\
#     sed -n '/<!-- End tsht -->/,$$p' README.md >> README.new &&\
#     mv README.new README.md
# sed -n '1,/<!-- Begin API -->/p' README.md >> README.new &&\
#     ./doc/apidoc.pl --heading-prefix='##' $(LIBS) >> README.new &&\
#     sed -n '/<!-- End API -->/,$$p' README.md >> README.new &&\
#     mv README.new README.md
# sed -n '1,/<!-- Begin API TOC -->/p' README.md >> README.new &&\
#     echo >> README.new &&\
#     ./doc/apidoc.pl --toc --no-body --toc-prefix='	' $(LIBS) >> README.new &&\
#     echo >> README.new &&\
#     sed -n '/<!-- End API TOC -->/,$$p' README.md >> README.new &&\
#     mv README.new README.md
 
