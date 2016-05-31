PKG_VERSION = 1.5
BASEURL = https://github.com/stedolan/jq/releases/download/jq-$(PKG_VERSION)
UNAME := $(shell uname)
ARCH := $(shell uname -m)
BINDIR := $(PREFIX)/bin

ifeq ($(UNAME), Linux)
  ifeq ($(ARCH), x86_64)
    URL := "$(BASEURL)/jq-linux64"
  else ifeq ($(ARCH), i386) 
    URL := "$(BASEURL)/jq-linux32"
  endif
else ifeq ($(UNAME), Darwin)
  ifeq ($(ARCH), x86_64)
    URL := "$(BASEURL)/jq-osx-amd64"
  endif
endif

$(BINDIR)/jq:
	@mkdir -p bin $(BINDIR)
	@wget -O $@ "$(URL)"
	@chmod a+x $@

install: $(BINDIR)/jq
