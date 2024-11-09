
DIR=../../../
include $(DIR)config.mk

SPLOT-X  = $(BIN)splot-x$(EXE)
SPLOT-XB = $(BIN)splot-xb$(EXE)
SPLOT-P  = $(BIN)splot-p$(EXE)

TARGETS  = $(SPLOT-X) $(SPLOT-XB) $(SPLOT-P)

all: $(TARGETS)

clean: subs.clean
	$(CLEAN) $(TARGETS) $(OBJ)

$(SPLOT-X): splot-x.o subs.all
	$(FC) $(FFLAGS) $< -lxpakw $(LIBS) -o $@

$(SPLOT-XB): splot-xb.o subs.all
	$(FC) $(FFLAGS) $< -lxpakb $(LIBS) -o $@

$(SPLOT-P): splot-p.o subs.all
	$(FC) $(FFLAGS) $< -lpspak $(LIBS) -o $@

splot-x.o: splot.F
	$(FC) $(FFLAGS) $(INCLUDES) -DC_INTERFACE=1 $^ -c -o $@

splot-xb.o: splot.F
	$(FC) $(FFLAGS) $(INCLUDES) -DC_INTERFACE=1 $^ -c -o $@

splot-p.o: splot.F
	$(FC) $(FFLAGS) $(INCLUDES) -DC_INTERFACE=0 $^ -c -o $@
