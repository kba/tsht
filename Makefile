PKG_NAME = tsht
PKG_VERSION = 0.0.1

.PHONY: test

test:
	@./test/tsht

doc: doc/tsht-core.md

doc/%.md: %.sh
	@mkdir -p doc
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
 
