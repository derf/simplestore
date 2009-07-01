prefix = /usr/local
perl_version = 5.10.0
perl_lib = lib/perl

build/Simplestore.3pm: lib/Simplestore.pm
	mkdir -p build
	pod2man $< > $@

install: build/Simplestore.3pm
	mkdir -p $(prefix)/$(perl_lib)/$(perl_version) $(prefix)/share/man/man3
	cp lib/Simplestore.pm $(prefix)/$(perl_lib)/$(perl_version)
	cp build/Simplestore.3pm $(prefix)/share/man/man3

uninstall:
	rm -f $(prefix)/$(perl_lib)/$(perl_version)/Simplestore.pm
	rm -f $(prefix)/share/man/man1/Simplestore.3pm

clean:
	rm -rf build

.PHONY: install uninstall clean
