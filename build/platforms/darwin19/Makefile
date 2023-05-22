# call before: ./configureplus/usr/local/bin/configureplus

include .configureplus/currentsession.mk

PRE=/usr/local
DIR_TEMPLATE=$(CONFIGURE_PKGNAME)/$(PRE)

install:
	./bin/install-userprofile.sh

uninstall:
	./bin/uninstall-userprofile.sh

install-systemwide:
	chmod +x $(DIR_TEMPLATE)/bin/*
	cp -r $(DIR_TEMPLATE)/bin/* $(PRE)/bin/
	mkdir -p $(PRE)/lib/$(CONFIGURE_PKGNAME)   && cp -r $(DIR_TEMPLATE)/lib/* $(PRE)/lib/$(CONFIGURE_PKGNAME)
	mkdir -p $(PRE)/var/$(CONFIGURE_PKGNAME)   && cp -r $(DIR_TEMPLATE)/var/* $(PRE)/var/$(CONFIGURE_PKGNAME)
	mkdir -p $(PRE)/share/$(CONFIGURE_PKGNAME) && cp -r $(DIR_TEMPLATE)/share/* $(PRE)/share/$(CONFIGURE_PKGNAME)
	-mkdir ~/.config/$(CONFIGURE_PKGNAME)/
	-cp -r .configureplus ~/.config/$(CONFIGURE_PKGNAME)/

uninstall-systemwide:
	$(info ****** uninstall-systemwide: Not implemented yet *******)

zip:
	zip -r9 packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).zip .

archive-master:
	wget https://github.com/muenalan/configureplus/archive/master.tar.gz -o ../$(CONFIGURE_PKGNAME)-master.tar.gz

archive:
	git init
	git add .
	git commit -m "release"
	git tag v0.0.1
	git archive --format=tar.gz -o ../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).tar.gz --prefix=v0.0.1/ master
	shasum -a 256 ../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).tar.gz >../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).tar.gz.sha256

package:
	mkdir -p  ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE) && cp -r . ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE)/
	mkdir -p  ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE)-homebrew &&	cp -r $(CONFIGURE_PKGNAME)/.brew ../packages/$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE)-homebrew/

clean:
	-find . -name '*~' |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-bak.zip -@
	-find . -name '*.bak' |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-bak.zip -@
	-rm -r .configureplus/session/$(CONFIGUREPLUS_SESSION)*



