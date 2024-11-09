
DIR=../../../
include $(DIR)config.mk

GLIB = arc.o arcn.o axis.o axs.o ccirc1.o cellsize.o circ1.o circle.o \
      csymbl.o dashln.o fcell.o fcellg.o frame.o newpage.o newpen.o \
      number.o origin.o penw.o plot.o plote.o plots.o plus.o rot.o \
      rotate.o scale.o sqr.o star.o symbol.o tri.o xnumber.o \
      xplot.o xsymbol.o 

TARGETS = $(LIB)libglib.a

all: $(TARGETS)

clean:
	$(CLEAN) $(TARGETS) $(OBJ)

$(TARGETS): $(GLIB)
	$(AR) rv $@ $^
