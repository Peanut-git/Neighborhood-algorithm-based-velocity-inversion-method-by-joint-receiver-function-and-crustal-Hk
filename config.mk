
# NA configuration 2016-11-01
# 
# If necessary modify this file to suit your platform.
# Should run on any Posix compatible platform.

# Where downloaded include files are expected and where library files
# and executable binaries will be created. Should usually be left as is.

INCLUDE=$(DIR)include/
LIB=$(DIR)lib/
BIN=$(DIR)bin/
DATA=$(DIR)data/
OBJ=*.o *.mod *genmod.f90
EXE=

# C compiler. e.g. gcc g++ icc ipp cc CC (gnu/intel/sun)

CC=gcc

# Fortran compiler. e.g. gfortran g77 ifort f95 f90 f77 (gnu/intel/sun)

FC=gfortran

# MPI Fortran compiler. e.g. mpifort mpif90 mpif77 (openmpi)

MFC=mpifort

# Fortran compilation warnings
# gnu: -Wall -Wextra -Wpedantic -g3
# intel: -warn all -debug all -traceback
# sun: -xtransition -xvpara

FWARN=-Wall -Wextra -Wpedantic -g3

# C compilation warnings
# gnu: -Wall -Wextra -Wpedantic -g3
# intel: -w3 -debug all -traceback
# sun: -xtransition -xvpara

CWARN=-Wall -Wextra -Wpedantic -g3

# C/Fortran compiler optimization level
# gnu: -O2; intel: -O; sun: -xO3

OPT=-O2

# Platform/architecture endianness for rfi_plot.
# intel alpha vax: littleendian; sgi powerpc: bigendian

ENDIAN=littleendian

# Where to look for include files (-I) for both C and Fortran in addition
# to system defaults such as /usr/include.
# e.g. /usr/X11/include /opt/X11/include /usr/local/include /opt/local/include

INCLUDES=-I$(INCLUDE) -I/usr/X11/include

# Library files (-l) and where to find them (-L) for both C and Fortran.
# e.g. /usr/X11/lib /opt/X11/lib /usr/local/lib /opt/local/lib

LIBS=-L$(LIB) -L/usr/X11/lib -lm -lX11

# By default, NA uses some fortran90 features like
# dynamic memory allocation. If you prefer to use
# the static memory version compiled under F77
# change the following option. In this case the 
# file na_param.inc will be used at compile time 
# to set array sizes. 

FC_COMPAT=-DNA_FC_COMPATIBILITY=0# "0" for F90, "1" for F77

FFLAGS=$(OPT) $(FWARN) $(FC_COMPAT)# Fortran compiler options
CFLAGS=$(OPT) $(CWARN)# C compiler options

# Should be no need to modify definitions below

AR=ar# Archiver
CLEAN=rm -rf

.DEFAULT_GOAL=all
.SECONDARY:
.PHONY: clean %.clean all %.all
.SUFFIXES:
.SUFFIXES: .clean .all .mk .f .F .c .o .a

%.o: %.f
	$(FC) $(FFLAGS) $(INCLUDES) $^ -c -o $@

%.o: %.F
	$(FC) $(FFLAGS) $(INCLUDES) $^ -c -o $@

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) $^ -c -o $@

$(LIB)%.o: %.f
	$(FC) $(FFLAGS) $(INCLUDES) $^ -c -o $@

$(LIB)%.o: %.F
	$(FC) $(FFLAGS) $(INCLUDES) $^ -c -o $@

$(LIB)%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) $^ -c -o $@

%: %.o
	$(FC) $(FFLAGS) $^ $(LIBS) -o $@

$(BIN)%: %.o
	$(FC) $(FFLAGS) $^ $(LIBS) -o $@

%: %.f

%: %.F

%: %.c

all:

%.all:
	cd $* && make all

clean:

%.clean:
	cd $* && make clean

# End of file
