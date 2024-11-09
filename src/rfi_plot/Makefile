
DIR=../../
include $(DIR)config.mk

SYNRF=$(BIN)synrf$(EXE)
SYNRF_NOISE=$(BIN)synrf_noise$(EXE)
PLOT_MODEL=$(BIN)plot_model$(EXE)
PLOT_RF-X=$(BIN)plot_rf-x$(EXE)
PLOT_RF-P=$(BIN)plot_rf-p$(EXE)

TARGETS=$(SYNRF) $(SYNRF_NOISE) $(PLOT_MODEL) $(PLOT_RF-X) $(PLOT_RF-P)

.PHONY: bigendian litendian

all: $(ENDIAN) $(TARGETS)

clean: graphic.clean
	$(CLEAN) $(TARGETS) $(PLOT_RF-X) $(OBJ)

$(SYNRF): synrf.o
	$(FC) $(FFLAGS) $< -lrfi_subs $(LIBS) -o $@

$(SYNRF_NOISE): synrf_noise.o
	$(FC) $(FFLAGS) $< -lrfi_subs $(LIBS) -o $@
#	cd $(DATA)rfi_files/rfi_plot; \
#	./run_synns; \
#	mv NA_SRF/rec_func.syn ORF/rec_func ; \
#	cp ORF/rec_func ORF/rec_func_demo;

$(PLOT_MODEL): plot_model.o graphic.all
	$(FC) $(FFLAGS) $< -lrfi_subs -lglib $(LIBS) -o $@

$(PLOT_RF-X): plot_rf-x.o graphic.all
	$(FC) $(FFLAGS) $< -lrfi_subs -lxpakw $(LIBS) -o $@

$(PLOT_RF-P): plot_rf-p.o graphic.all
	$(FC) $(FFLAGS) $< -lrfi_subs -lpspak $(LIBS) -o $@

plot_rf-x.o: plot_rf.F
	$(FC) $(FFLAGS) $(INCLUDES) -DC_INTERFACE=1 -c $< -o $@

plot_rf-p.o: plot_rf.F
	$(FC) $(FFLAGS) $(INCLUDES) -DC_INTERFACE=0 -c $< -o $@

bigendian:
	cd $(DATA)rfi_files/NA_SRF ; \
#	ln -sf ../../demo_results/rec_func_500_20_2_sun rec_func_demo ; \
#        cd ../NA_ORF ; \
#	ln -sf rec_func_demo_sun rec_func_demo

littleendian: 
#	cd $(DATA)rfi_files/NA_SRF ; \
#	ln -sf ../../demo_results/rec_func_500_20_2_dec rec_func_demo ; \
#        cd ../NA_ORF ; \
#	ln -sf rec_func_demo_dec rec_func_demo
