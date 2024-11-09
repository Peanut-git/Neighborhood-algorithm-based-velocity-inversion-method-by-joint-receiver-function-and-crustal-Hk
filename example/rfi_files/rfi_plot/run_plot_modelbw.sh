#!/bin/bash
#
#	script for plotting models
#

cd ..

# 使用splot的命令来绘制模型图

plot_model <<END
NA     				/* Directory type to look for files */
y				/* plot all models ? (y,n) */
n				/* plot average model ? (y,n) */
y				/* plot best model ? (y,n) */
n				/* plot true model ? (y,n) */
n				/* use colour ? (y,n) */
model_ref                       /* file containing reference model (input) */
rfi_param                       /* model parameterisation (input) */
rfi_models                      /* Inversion models  (input) */
density_plot                    /* output ps-file */
0.0 21.0 10.0 0.19444 -18.0	/* depth-axis */
0.0  5.25  1.0 0.01923  13.0	/* Vs-axis */
1.5  3.0  0.5          13.0	/* Vp/Vs-axis */
1000				/* Best models */
END

# 转换格式
mv density_plot.ps density_plotbw.ps
convert -density 200 density_plotbw.ps density_plotbw.pdf
echo "--> 转换输出的文件: rif_fils/density_plotbw.pdf"
