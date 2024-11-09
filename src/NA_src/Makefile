
DIR=../../
include $(DIR)config.mk

NA_SERIAL = $(LIB)na-serial.o
NA_MPI = $(LIB)na-mpi.o
UTILS = $(LIB)utils.o

TARGETS = $(UTILS) $(NA_SERIAL) $(NA_MPI)

all: $(TARGETS)

clean:
	$(CLEAN) $(TARGETS) $(OBJ)

$(NA_SERIAL): na.F
	$(FC) $(FFLAGS) $(INCLUDES) $^ -c -o $@

$(NA_MPI): na.F
	- $(MFC) $(FFLAGS) $(INCLUDES) $(MPI) -DNA_MPI $^ -c -o $@
