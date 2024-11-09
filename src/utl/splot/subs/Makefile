
DIR=../../../../
include $(DIR)config.mk

LIBSPS  = $(LIB)libpspak.a
LIBSXB  = $(LIB)libxpakb.a
LIBSXW  = $(LIB)libxpakw.a

TARGETS = $(LIBSPS) $(LIBSXB) $(LIBSXW)

all: $(TARGETS)

clean:
	$(CLEAN) $(TARGETS) $(OBJ)

$(LIBSPS): ps_comm.o ps_colr.o cfopen.o
	$(AR) rv $@ $^

$(LIBSXW): xpakw.o xtra.o cfopen.o
	$(AR) rv $@ $^

$(LIBSXB): xpakb.o xtra.o cfopen.o
	$(AR) rv $@ $^
