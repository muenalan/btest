
.PHONY: setup

setup:
	OSTYPE ?= $(shell echo $$OSTYPE)
	echo $(OSTYPE) >build/.configureplus/global/CONFIGUREPLUS/SESSION

setup-linux-gnu:
	OSTYPE ?= $(shell echo $$OSTYPE)
	echo $(OSTYPE) >build/.configureplus/global/CONFIGUREPLUS/SESSION


