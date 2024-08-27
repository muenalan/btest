
platform-current:
	echo $(OSTYPE) >build/.configureplus/global/CONFIGUREPLUS_SESSION
	cd build/ && configureplus --detect-os
	cd build/ && configureplus 
	
test:
	btest t/

clean:
	-rm configure.sh
	-find . -name '*~' |zip -rm bak.zip -@
	-find . -name '*.bak' |zip -rm bak.zip -@
	-cd build/ && configureplus
	-cd build/ && make clean
