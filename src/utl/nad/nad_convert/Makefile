
DIR=../../../../
include $(DIR)config.mk

BINDAT=../../bin/

NAD2RFI = $(BIN)nad2rfi$(EXE)
RFI2NAD = $(BIN)rfi2nad$(EXE)
NAD2NAD = $(BIN)nad2nad$(EXE)
NAD2ASC = $(BIN)nad2asc$(EXE)
ASC2NAD = $(BIN)asc2nad$(EXE)
NAD_SUN2DEC = $(BIN)nad_sun2dec$(EXE)

TARGETS = $(NAD2RFI) $(RFI2NAD) $(NAD2NAD) $(NAD2ASC) $(ASC2NAD)

all: $(TARGETS)
    
clean:
	$(CLEAN) $(TARGETS) $(OBJ)

$(RFI2NAD): rfi2nad.o
	$(FC) $(FFLAGS) $^ $(LIBS) -o $@
	cd $(DIR)data/demo_results; \
	$(CLEAN) na.nad_demo ; \
	$(BINDAT)rfi2nad rfi_models_500_20_2 na.nad_demo ; \
	\ln -sf na.nad_demo na.nad_500_20_2 ; \
	$(CLEAN) junk

$(NAD_SUN2DEC): nad_sun2dec.o
	$(FC) $(FFLAGS) $^ $(LIBS) -o $@
	cd $(DIR)/data/demo_results; \
	$(BINDAT)rfi2nad na.nad_demo_sun na.nad_demo_dec ; \
	ln -sf na.nad_demo_dec na.nad_500_20_2
