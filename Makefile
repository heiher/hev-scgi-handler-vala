# Makefile for hev-scgi-server
 
CC=valac
FLAGS=--vapidir=../hev-scgi-server-library/vapi --girdir=../hev-scgi-server-library/gir --pkg hev-scgi-1.0 --library hev-scgi-server-vala -X -shared -X -fPIC -X -I../hev-scgi-server-library/include -X -L../hev-scgi-server-library/bin -X -lhev-scgi-server
 
SRCDIR=src
BINDIR=bin
VAPIDIR=vapi
 
TARGET=$(BINDIR)/libhev-scgi-server-vala.so
SRCFILES=$(SRCDIR)/hev-scgi-handler-module.vala \
		 $(SRCDIR)/hev-scgi-handler-vala.vala
VAPIFILE=$(VAPIDIR)/hev-scgi-server-vala.vapi
 
all : $(CCOBJSFILE) $(TARGET)
 
clean : 
	@echo -n "Clean ... " && $(RM) $(BINDIR)/* $(VAPIDIR)/* && echo "OK"
 
$(TARGET) : $(SRCFILES)
	@echo -n "Building $^ to $@ ... " && $(CC) -o $@ --vapi=$(VAPIFILE) $^ $(FLAGS) && echo "OK"
 
