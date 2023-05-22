
# call ./bin/configureplus before make

include .configureplus/currentsession.mk

install:
	-mkdir -p $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/bin   && cp -r $(CONFIGURE_DIR_TEMPLATE)/bin/* $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/bin/
	-mkdir -p $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/lib   && cp -r $(CONFIGURE_DIR_TEMPLATE)/lib/* $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/lib/
	-mkdir -p $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/var   && cp -r $(CONFIGURE_DIR_TEMPLATE)/var/* $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/var/
	-mkdir -p $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/share && cp -r $(CONFIGURE_DIR_TEMPLATE)/share/* $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/share/
	-mkdir ~/.config/$(CONFIGURE_PKGNAME)/
	-cp -r .configureplus ~/.config/$(CONFIGURE_PKGNAME)/
	cp .configureplus/global/CONFIGURE_PKGNAME $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/.configureplus/global/
	cd $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE) && configureplus
	$(info ******** Overwrite template folder to architecture-specific revision: $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE).. ***********)
	$(info ******** Continue with .. $ cd $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE) ***********)

init: 
	mkdir -p template/bin
	touch template/bin/$(CONFIGURE_PKGNAME)
	mkdir -p template/{lib,share/doc,var}/$(CONFIGURE_PKGNAME)

test:
	btest t/

zip:
	zip -r9 ../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-src.zip .
	cd $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME) && zip -r9 $(PWD)/../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).zip .

tar.gz:
	tar cfz ../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-src.tar.gz .
	cd $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME) && tar cfz $(PWD)/../$(CONFIGURE_PKGNAME)-$(CONFIGURE_VERSION)-$(CONFIGURE_OSTYPE).tar.gz .

clean:
	-find . -name '*~' |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-bak.zip -@
	-find . -name '*.bak' |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-bak.zip -@
	-find $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/bin/* |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-$(CONFIGURE_OSTYPE)-bak.zip -@
	-find $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/lib/* |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-$(CONFIGURE_OSTYPE)-bak.zip -@
	-find $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/var/* |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-$(CONFIGURE_OSTYPE)-bak.zip -@
	-find $(CONFIGURE_DIR_OUTPUT)/$(CONFIGURE_OSTYPE)/$(CONFIGURE_PKGNAME)/usr/local/share/* |zip -rm $(CONFIGURE_MKTEMP)/$(CONFIGURE_PKGNAME)-$(CONFIGURE_OSTYPE)-bak.zip -@
	-rm -r .configureplus/session/$(CONFIGUREPLUS_SESSION)*
	-rm .configureplus/global/CONFIGUREPLUS_SESSION
	-rm .configureplus/global.*
