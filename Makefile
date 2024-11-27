
OSTYPE ?= $(shell echo $$OSTYPE)

.PHONY: setup

setup:
	echo $(OSTYPE) >build/.configureplus/global/CONFIGUREPLUS/SESSION


