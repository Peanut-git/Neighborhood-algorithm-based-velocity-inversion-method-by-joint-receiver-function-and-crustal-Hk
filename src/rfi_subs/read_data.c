/* 
	function read_data_() : reads ORF in SAC format
	
				T. Shibutani
				November 1999
*/

#include <stdio.h>
#include <string.h>
#include "sac.h"

#define NDMAX 1500

readdata_(
	fname, ndata, 
	o_data, 
	t_begin, t_end, t_shift, 
	const_a, const_c, layeridx, pstime, pppstime, ppsstime,
    hdata, kdata, fs
	)

int *ndata;
float *t_begin, *t_end, *t_shift; 
float *const_a, *const_c, *layeridx, *pstime, *pppstime, *ppsstime; 
float *hdata, *kdata, *fs; 
float o_data[]; 
char fname[]; 

{
	struct sac_header sp; 
	float dummy[NDMAX], tb, delt;
	int i, ii, nlen;
	int n_begin, n_end;
	FILE *fp; 

	if ((fp=fopen(fname,"rb"))==NULL) {
		fprintf(stderr, "Error opening file %s\n", fname); 
	}

/* read header */
	fread(&sp, sizeof(struct sac_header), 1, fp);
	
	nlen=sp.npts;
	tb=sp.b;
	delt=sp.delta;
	*fs=1.0/delt;
	*const_a=sp.user0;
	*const_c=sp.user1;
	*layeridx=sp.t0;
	*pstime=sp.t1;
	*pppstime=sp.t2;
	*ppsstime=sp.t3;
	*hdata=sp.t4;
	*kdata=sp.t5;

/* read data */
	fread(dummy, nlen*sizeof(float), 1, fp); 

	*t_shift=-*t_begin;
	n_begin=(*t_begin-tb)/delt;
	n_end=(*t_end-tb)/delt;
	*ndata=n_end-n_begin+1;
	
	ii=0;
	for (i=n_begin; i<=n_end; i++) {
		o_data[ii++]=dummy[i];
	}

}	/* end of function */
