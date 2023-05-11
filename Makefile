PKGNAME=$(shell cat PKGNAME)
REVISION=$(shell cat VERSION)
MKTEMP=$(shell mktemp -d)

ubuntu: 
	cp -r template/bin/* ubuntu/$(PKGNAME)/usr/local/bin/
	cp -r template/lib/* ubuntu/$(PKGNAME)/usr/local/lib/

macos:
	echo Not implemented yet.

zip:
	zip -r9 ../$(PKGNAME)-$(REVISION).zip .

clean:
	find ubuntu/$(PKGNAME)/usr/local/bin/* ubuntu/$(PKGNAME)/usr/local/lib/*|zip -rm $(MKTEMP)/$(PKGNAME)-bak.zip -@
	find . -name '*~' |zip -rm $(MKTEMP)/$(PKGNAME)-bak.zip -@

