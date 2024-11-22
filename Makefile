
OSTYPE ?= $(shell echo $$OSTYPE)

.PHONY: status info install init test zip tar.gz clean

setup:
	echo $(OSTYPE) >build/.configureplus/global/CONFIGUREPLUS/SESSION
