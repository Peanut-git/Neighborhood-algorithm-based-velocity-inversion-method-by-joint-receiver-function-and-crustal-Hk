#!/bin/bash

rm na.sum na.nad rfi_files/NA_ORF/rec_func rfi_files/NA_SUM/plot_summary NA_MDL/density_plot_mean
rm rfi_files/*.ps rfi_files/*.pdf *.pdf
rm *.txt

Start=`date +%s`

mpirun -np 9 ../bin/rfi_na-mpi | tee log.txt
# /cluster/share/apps/openmpi-4.1.4/bin/mpirun -np 9 ../bin/rfi_na-mpi | tee log.txt

cd rfi_files/rfi_plot

bash run_plot_rf-p.sh
bash run_plot_model.sh

cd ..

TSec=$[ `date +%s` - $Start ]
TTime=`echo "scale=2;$TSec/60"|bc`
echo "--> End, Spend Time: $TTime mins"