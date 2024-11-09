#!/bin/bash
#
#	plot_rf-p_run 
#

cd ..

plot_rf-p <<END
NA                                      /* Directory type to look for files */
rfi_param                               /* model parameterisation (input) */
plot_summary                            /* summary file name */
1                                       /* nwave */
rec_func                               /* input RF */
34.8497                                 /* incident angle */
1.0                                     /* weight */
-1 30.0                               /* time window */
END

# 转换文件
convert -density 200 plot_rf.ps ../plot_rf.pdf
echo "--> 转换输出的文件: plot_rf.pdf"

