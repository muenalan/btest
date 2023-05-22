
setup:
	echo $(CONFIGURE_PKGNAME) > build/.configureplus/global/CONFIGURE_PKGNAME
	CONFIGURE_PKGNAME=$(CONFIGURE_PKGNAME) ./bin/setup.sh >configure.sh
	sh ./configure.sh

platform-current:
	cd build/ && configureplus --detect-os

test:
	btest t/

clean:
	-rm configure.sh
	-find . -name '*~' |zip -rm bak.zip -@
	-find . -name '*.bak' |zip -rm bak.zip -@
	-cd build/ && configureplus
	-cd build/ && make clean
