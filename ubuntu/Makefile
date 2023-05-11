PKGNAME=btest

deb:
	dpkg-deb --build $(PKGNAME)

test:
	btest /usr/local/lib/btest/t

install: deb
	sudo dpkg -i $(PKGNAME).deb

uninstall:
	sudo dpkg --remove $(PKGNAME)

clean:
	rm $(PKGNAME).deb
	find . -name '*~' |zip -rm $(shell mktemp -d)/btest-bak.zip -@

