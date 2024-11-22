CONFIGUREPLUS_SESSION=$(shell cat .configureplus/global/CONFIGUREPLUS/SESSION)

include .configureplus/session/$(CONFIGUREPLUS_SESSION).mk
