# Makefile for hev-scgi-handler-vala
 
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

all : $(TARGET)

clean :
	@echo -n "Clean ... " && $(RM) -rf $(BINDIR)/* $(BUILDDIR)/* && echo "OK"

$(TARGET) : $(VFILES)
	@echo -n "Building $^ to $@ ... " && $(VC) -d $(BUILDDIR) -o $@ $^ $(VCFLAGS) && echo "OK"

