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
	zip -r9 ../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-src.zip .
	cd $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME) && zip -r9 $(PWD)/../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).zip .

tar.gz:
	tar cfz ../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-src.tar.gz .
	cd $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME) && tar cfz $(PWD)/../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).tar.gz .

clean:
	-find . -name '*~' |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-bak.zip -@
	-find . -name '*.bak' |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-bak.zip -@
	-rm -r .configureplus/session/$(CONFIGUREPLUS_SESSION)*



