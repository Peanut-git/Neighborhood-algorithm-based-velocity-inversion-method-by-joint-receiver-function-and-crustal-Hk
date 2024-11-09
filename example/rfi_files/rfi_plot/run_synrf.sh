#!/bin/bash
#
#	script to run synrf_run 
#
cd ..
# for ga in `seq 1.0 0.5 5.0`
# do
# echo "Gaussian: $ga"

synrf <<END
model_ref2      		/* Input model */
2.0 0.001			/* Gaussian const. & Water level */
35.219				/* Incident angle */
2.0					/* Time shift */
25.0 876			/* Sampling freq. & points */
rec_func   		/* Output receiver function */
END

# done
