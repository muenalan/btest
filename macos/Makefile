PKGNAME=$(shell cat ../PKGNAME)
REVISION=$(shell cat ../VERSION)

deb:
	echo macos version of: dpkg-deb --build $(PKGNAME)

test:
	btest /usr/local/lib/$(PKGNAME)/t

install: deb
	echo macos version of: sudo dpkg -i $(PKGNAME).deb

uninstall:
	echo macos version of: sudo dpkg --remove $(PKGNAME)

clean:
	rm $(PKGNAME).deb
	find . -name '*~' |zip -rm $(shell mktemp -d)/$(PKGNAME)-bak.zip -@

