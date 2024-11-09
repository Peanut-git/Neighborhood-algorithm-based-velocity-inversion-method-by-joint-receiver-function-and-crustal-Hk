/* 
	function write_srf_() : writes SRF in SAC format
	
				T. Shibutani
				November 1999
*/

#include <stdio.h>
#include <string.h>
#include "sac.h"

writesrf_(
	fname, ndata, 
	data, 
	t_begin,  
	const_a, const_c, 
	delt
	)

int *ndata;
float *t_begin; 
float *const_a, *const_c;
float *delt; 
float data[]; 
char fname[]; 

{
	struct sac_header sp; 
	FILE *fp; 
	
	if ((fp=fopen(fname,"wb"))==NULL) {
		fprintf(stderr, "Error opening file %s\n", fname); 
	}
/* Initialize header */
	sp=sac_null;
	
/* write header & data*/
	
	sp.leven=TRUE;
	sp.iftype=ITIME;
	sp.npts=*ndata;
	sp.b=*t_begin;
	sp.delta=*delt;
	sp.user0=*const_a;
	sp.user1=*const_c;

	fwrite(&sp, sizeof(struct sac_header), 1, fp);
	fwrite(data, sp.npts*sizeof(float), 1, fp);

}	/* end of function */

