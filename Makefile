MKTEMP=$(shell mktemp -d)

ubuntu: 
	cp -r template/bin/* ubuntu/btest/usr/local/bin/
	cp -r template/lib/* ubuntu/btest/usr/local/lib/

macos:
	echo Not implemented yet.

clean:
	find ubuntu/btest/usr/local/bin/* ubuntu/btest/usr/local/lib/*|zip -rm $(MKTEMP)/btest-bak.zip -@
	find . -name '*~' |zip -rm $(MKTEMP)/btest-bak.zip -@

