$(PREFIX)/bin/shxml:
	tempdir=`mktemp -d --tmpdir` && \
		cd $$tempdir && \
		git clone https://github.com/kba/shxml && \
		cd shxml && \
		make PREFIX=$(PREFIX) install && \
		cd - && \
		rm -rf $$tempdir

install: $(PREFIX)/bin/shxml
