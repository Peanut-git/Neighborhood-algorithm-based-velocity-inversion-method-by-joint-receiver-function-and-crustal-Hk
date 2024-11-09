#
#	Make file for program NA.f
#

# Ways to use this make file 
#    > `make all' 
#    > `make clean'
#    
# For a more detail explanation see HTML manual
#
# Setup NA macros for compilers and archiver

DIR=../
include $(DIR)config.mk

#MPI = -DNA_MPI=1#           # MPI option (normal parallel NA only used if TYPE=mpi)
MPI = -DNA_MPIP=1#           # MPI option (continuous parallel NA only used if TYPE=mpi)

#---- start user specific make  (Edit below) ----------------------------------

# edit the three variables below to compile user routines and main program
# The present entries refer to the example program for fitting 
# Seismic receiver functions. (See HTML manual) 

                         # Enter here the directory name containing all 
			 # user code other than main program
			 # Note the users Makefile must exist in this 
			 # directory to compile users routines (see example). 
USER_DIR = rfi_subs
                         # Enter here name of user's main routine
			 # Note that the main program name is
			 # assumed to be `USER_MAIN.F' 
USER_MAIN=rfi_na

USER_MAIN_SERIAL=$(BIN)$(USER_MAIN)-serial$(EXE)
USER_MAIN_MPI=$(BIN)$(USER_MAIN)-mpi$(EXE)

TARGETS = $(USER_MAIN_SERIAL) $(USER_MAIN_MPI)

rfi_plot.all: utl.all $(USER_DIR).all

$(USER_MAIN_SERIAL): $(USER_MAIN).F utl.all $(USER_DIR).all NA_src.all
	$(FC) $(FFLAGS) $(INCLUDES) $< -l$(USER_DIR) \
	$(LIB)na-serial.o $(LIB)utils.o $(LIBS) -o $@

$(USER_MAIN_MPI): $(USER_MAIN).F utl.all $(USER_DIR).all NA_src.all
	- $(MFC) $(FFLAGS) $(INCLUDES) $(MPI) $< -l$(USER_DIR) \
	$(LIB)na-mpi.o $(LIB)utils.o $(LIBS) -o $@

# remove user object files and libraries

cleanuser: rfi_plot.clean $(USER_DIR).clean
	$(CLEAN) $(TARGETS) $(OBJ)

#---- end user specific make ----Do not edit below-------------------------

SUBS = utl.all $(USER_DIR).all rfi_plot.all NA_src.all

all: $(TARGETS) $(SUBS)

clean: cleanuser NA_src.clean utl.clean
	cd ../bin && $(CLEAN) *.dSYM
#	cd ../data && \
#        $(CLEAN) \
#	  na.nad \
#	  na.sum \
#	  sobol.coeff \
#	  splot/*.ps \
#	  demo_results/na.nad_demo* \
#	  demo_results/model.opt \
#	  rfi_plot/*.ps \
#	  rfi_files/NA_ORF/rec_func_demo \
#	  rfi_files/NA_SRF/rec_func_demo \
#	  demo_results/readnad \
#	  demo_results/rfi2nad && \
#	cp na.in_examples/na.in_9_2 na.in && \
#	cp splot/cmds/splot.cmd6 splot/splot.cmd

