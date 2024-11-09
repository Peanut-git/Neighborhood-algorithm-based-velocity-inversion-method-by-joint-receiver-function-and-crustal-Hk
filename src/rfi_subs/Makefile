
DIR=../../
include $(DIR)config.mk

RFI = theo.o qlayer.o read_data.o read_seed.o \
      forward_modelling.o calcmisfit.o display_model.o \
      display_final.o lofw.o four1.o \
      output_summary.o read_vmodelNA.o write_data.o \
      ran3.o theo_noise.o indexx.o write_srf.o

LIBRFI_SUBS = $(LIB)librfi_subs.a

TARGETS = $(LIBRFI_SUBS)

all: $(TARGETS)

clean:
	$(CLEAN) $(TARGETS) $(OBJ)

$(LIBRFI_SUBS): $(RFI)
	$(AR) rv $@ $^
