# Makefile for hev-scgi-server
 
VC=valac
CPP=cpp
CC=gcc

VCFLAGS=--vapidir=../hev-scgi-server-library/vapi --girdir=../hev-scgi-server-library/gir --pkg hev-scgi-1.0 --library hev-scgi-server-vala
CCFLAGS=-g -fPIC `pkg-config --cflags gio-2.0` -I../hev-scgi-server-library/include
LDFLAGS=-shared `pkg-config --libs gio-2.0` -L../hev-scgi-server-library/bin -lhev-scgi-server
 
SRCDIR=src
BINDIR=bin
BUILDDIR=build
 
TARGET=$(BINDIR)/libhev-scgi-server-vala.so

VFILES=$(wildcard ./src/*.vala)
CFILES=$(patsubst ./$(SRCDIR)/%.vala,./$(BUILDDIR)/$(SRCDIR)/%.c,$(VFILES))
COBJFILES=$(patsubst %.c,%.o,$(CFILES))

DEPEND=$(COBJFILES:.o=.dep)

.PHONY: all clean

all : $(TARGET)

clean :
	@echo -n "Clean ... " && $(RM) -rf $(BINDIR)/* $(BUILDDIR)/* && echo "OK"

$(CFILES) : $(VFILES)
	@echo -n "Building $^ ... " && $(VC) $(VCFLAGS) -C -d $(BUILDDIR) $^ && echo "OK"

$(TARGET) : $(COBJFILES)
	@echo -n "Linking $^ to $@ ... " && $(CC) -o $@ $^ $(LDFLAGS) && echo "OK"

$(BUILDDIR)/%.dep : $(BUILDDIR)/%.c
	@$(CPP) $(CCFLAGS) -MM -MT $(@:.dep=.o) -o $@ $<

$(BUILDDIR)/%.o : $(BUILDDIR)/%.c
	@echo -n "Building $< ... " && $(CC) $(CCFLAGS) -c -o $@ $< && echo "OK"

-include $(DEPEND)

