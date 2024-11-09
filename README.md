This work is based on this project.

http://iearth.edu.au/codes/NA/NA_sampler.php

Thanks for their excellent work!



If you have any questions about the copyright of the source code for this project, please raise an issue and let me konw.



### Install

Download all the files.

```bash
sudo apt install gcc gfortran openmpi-bin
sudo apt install imagemagick

# checkout this configuration in the config.mk
CC=gcc
FC=gfortran
MFC=mpifort

# make sure you are in the correct folder
make all

# all the program will be stored in the bin folder, then add it into the PATH
```

### Usage

The observed receiver function in `SAC` format is stored in `example/rfi_files/ORF/recfunc`.

The predicted receiver function in 'SAC' format is stored in `example/rfi_files/NA_SRF/recfunc`.

Modify 5 parameters in the sac header of observed receiver function.
- `t0`, i-th layer represents the Moho. If you set up 6 layers, this number is 5.
- `t1`, the arrival time of Pms.
- `t2`, the arrival time of PpPs.
- `t3`, the arrival time of PpSs/PsPs.
- `t4`, the H parameter.
- `t5`, the K parameter.

if the `t0` is `None`, this program will start in the classical NA-based invertion method.
If the `t0` is a number, this program will run in the NA-based joint inversion method.

The default crustal mean Vp for H-k scaning is 6.2 km/s.

Make sure you calculate the `incident angle ` correctly.

Modify these two lines in `src/rfi_subs/calcmisfit.f` to change the default weight. Then recompile this code and run.
```fortran
 90             misfitval=misfitval + log10(dh / 5.0 + 1.0)
 91             misfitval=misfitval + log10(dk / 0.1 + 1.0)
```



After the article is successfully published, more tutorials will be added.



### Synthesis Example

```bash
cd exmaple
# about 30 mins.
bash run.sh
# check the pdf named 'density_plot.pdf' and 'plot_rf.pdf'
```

There are three files corresponding to these methods:
- `recfunc-classical`, classical NA-based inversion
- `recfunc-joint-correct`, NA-based joint inversion method with correct parameters
- `recfunc-joint-wrong`, also NA-based joint inversion method but with wrong H-k parameters.

The file used is named as `recfunc`, default is the copy of  `recfunc-joint-correct`.




### References

*Geophysical Inversion with a Neighbourhood Algorithm -I. Searching a parameter space*, Sambridge, M., *Geophys. J. Int.*, **138** , 479-494, 1999. [doi:10.1046/j.1365-246X.1999.00876.x](http://dx.doi.org/10.1046/j.1365-246X.1999.00876.x)

Crustal architecture and thickening of the eastern Northern Himalayan belt: Insight
from a short-period dense nodal array. Li C.S., Xu X., Guo X.Y. et al., Geochemistry, Geophysics, Geosystems (Under review)

