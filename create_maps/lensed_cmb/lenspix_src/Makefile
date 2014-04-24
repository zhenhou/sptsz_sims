#now using v11+ intel ifort

#Intel. Note heap-arrays needs v10+ of compiler, and avoids Seg Faults for large arrays
F90C     = mpif90
#F90C    = ifort

healpix = /global/homes/h/hou/Projects/CMBtools/Healpix_2.20a
LAPACKL = -mkl -lmpi -lhealpix
INCLUDE = /usr/common/usg/intel/13.0.028/composer_xe_2013.1.117/mkl/include

#Had problems with -O3 using ifort 11.1 and 12; use -fast if cluster is homogeneous
#add -DHEALPIXI4B if using older healpix and get errors about arguments not matching
FFLAGS = -O3 -ip -fpp -error-limit 5 -DMPIPIX -DMPI -heap-arrays -traceback

ifndef CFITSIO
cfitsio = /global/homes/h/hou/Projects/CMBtools/cfitsio/lib
else
cfitsio = $(CFITSIO)
endif

#cosmos seems to have only openmp healpix installed
ifneq ($(COSMOHOST),)
F90C    = ifort
FFLAGS += -openmp
LINKFLAGS = -openmp
endif

F90FLAGS = $(FFLAGS) -I$(INCLUDE) -I$(healpix)/include -L$(cfitsio) -L$(healpix)/lib $(LAPACKL) -lcfitsio

OBJFILES= toms760.o inifile.o utils.o spin_alm_tools.o \
   HealpixObj.o HealpixVis.o SimLens.o

PROJECT = simlens
default: $(PROJECT)
all: $(PROJECT)

spin_alm_tools.o:  utils.o toms760.o
HealpixObj.o: spin_alm_tools.o
HealpixVis.o: HealpixObj.o
SimLens.o: HealpixVis.o inifile.o

.f.o:
	f77 $(F90FLAGS) -c $<

%.o: %.f90
	$(F90C) $(F90FLAGS) -c $*.f90

%.o: %.F90
	$(F90C) $(F90FLAGS) -c $*.F90


simlens: $(OBJFILES) 	
	$(F90C) -o $(PROJECT) $(OBJFILES) $(F90FLAGS) $(LINKFLAGS)

clean:
	rm -f *.o* *.e* *.mod *.d *.pc *.obj core* *.il $(PROJECT)
