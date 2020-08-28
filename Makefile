# FORTRAN compiler
FC = mpif90
# FC = gfortran
# compile flags
FCFLAGS = -g -c -fdefault-real-8 -fbacktrace -fno-align-commons -fbounds-check -I${PETSC_DIR}/include
# link flags
FLFLAGS = -I${PETSC_DIR}/include

LDFLAGS = -lpetsc -L$(PETSC_DIR)/lib -lm

# source files and objects
SRCS = $(patsubst %.F90, %.o, $(wildcard *.F90))
# program name
PROGRAM = fvweno

all: $(PROGRAM)
run: $(PROGRAM)
	mpirun -np 4 ./fvweno

$(PROGRAM): $(SRCS)
	$(FC) $(FLFLAGS) -o $@ $^ $(LDFLAGS)
initialcond.o: constants.o
%.o: %.F90
	$(FC) $(FCFLAGS) -o $@ $<
clean:
	rm -f $(PROGRAM) *.o *.mod
