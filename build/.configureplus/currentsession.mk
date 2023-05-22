CONFIGUREPLUS_SESSION=$(shell cat .configureplus/global/CONFIGUREPLUS_SESSION)

include .configureplus/session/$(CONFIGUREPLUS_SESSION).mk
