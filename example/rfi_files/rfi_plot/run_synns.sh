#!/bin/bash
#
#       script to run synns_run 
#
cd ..

for ga in `seq 1.0 0.5 5.0`
do
echo "Gaussian: $ga"

synrf_noise <<END
model_ref      		/* Input model */
$ga 0.0001			/* Gaussian const. & Water level */
35.00				/* Incident angle */
5.0					/* Time shift */
25.0 876			/* Sampling freq. & points */
0.25 210165			/* S/N ratio & random number */
rfs.$ga   		/* Output receiver function */
END

done