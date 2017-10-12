# Makefile for hev-scgi-handler-vala
 
PROJECT=hev-scgi-handler-vala

VC=valac

VCFLAGS=--vapidir=../hev-scgi-server-library/vapi \
		--girdir=../hev-scgi-server-library/gir \
		--pkg hev-scgi-1.0 --library hev-scgi-handler-vala \
		-g -X -fPIC -X -shared -X -I../hev-scgi-server-library/include \
		-X -L../hev-scgi-server-library/bin -X -lhev-scgi-server
 
SRCDIR=src
BINDIR=bin
BUILDDIR=build
 
TARGET=../$(BINDIR)/libhev-scgi-handler-vala.so

VFILES=$(wildcard ./src/*.vala)

BUILDMSG="\e[1;31mBUILD\e[0m $<"
CLEANMSG="\e[1;34mCLEAN\e[0m $(PROJECT)"

V :=
ECHO_PREFIX := @
ifeq ($(V),1)
	undefine ECHO_PREFIX
endif

all : $(TARGET)

clean :
	$(ECHO_PREFIX) $(RM) -rf $(BINDIR)/* $(BUILDDIR)/*
	@echo -e $(CLEANMSG)

$(TARGET) : $(VFILES)
	$(ECHO_PREFIX) $(VC) -d $(BUILDDIR) -o $@ $^ $(VCFLAGS)
	@echo -e $(BUILDMSG)

