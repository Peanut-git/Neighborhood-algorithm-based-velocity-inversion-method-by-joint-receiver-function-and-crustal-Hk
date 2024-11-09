/* 
	function write_data_() : writes ORF & SRF in SAC format
	
				T. Shibutani
				November 1999
*/

#include <stdio.h>
#include <string.h>
#include "sac.h"

writedata_(
	fname, ndata, 
	o_data, p_data, 
	t_begin,  
	const_a, const_c, layeridx, 
    pstime, pppstime, ppsstime,
    hdata, kdata,
    misfitval, delt
	)

int *ndata;
float *t_begin; 
float *const_a, *const_c, *layeridx, *pstime, *pppstime, *ppsstime;
float *hdata, *kdata, *misfitval, *delt; 
float o_data[], p_data[]; 
char fname[]; 

{
	struct sac_header sp; 
	FILE *fp;
	int lw; 
	char kname1[40], kname2[40], sub[40]; 

/* Initialize header */
	sp=sac_null;
	
/* write header */
	sp.leven=TRUE;
	sp.iftype=ITIME;
	sp.npts=*ndata;
	sp.b=*t_begin;
	sp.delta=*delt;
	sp.user0=*const_a;
	sp.user1=*const_c;
	sp.user5=*misfitval;
	sp.t0=*layeridx;
	sp.t1=*pstime;
	sp.t2=*pppstime;
	sp.t3=*ppsstime;
	sp.t4=*hdata;
	sp.t5=*kdata;

/* open and write ORF */
	lw=strlen(fname); 
	substr(fname, 14, lw, sub); 
	sprintf(kname1, "rfi_files/NA_ORF/%s", sub);
	if ((fp=fopen(kname1,"wb"))==NULL) {
		fprintf(stderr, "Error opening file %s\n", kname1); 
	}
	fwrite(&sp, sizeof(struct sac_header), 1, fp);
	fwrite(o_data, sp.npts*sizeof(float), 1, fp);
	fclose(fp);

/* open and write SRF */
	sprintf(kname2, "rfi_files/NA_SRF/%s", sub);
	if ((fp=fopen(kname2,"wb"))==NULL) {
		fprintf(stderr, "Error opening file %s\n", kname2); 
	}
	fwrite(&sp, sizeof(struct sac_header), 1, fp);
	fwrite(p_data, sp.npts*sizeof(float), 1, fp);
	fclose(fp);

}	/* end of function */


substr(str1, s1, s2, str2)

char str1[], str2[];
int s1, s2;

{
        int i, ii;

        ii=0;
        for (i=s1; i<s2; i++) {
                str2[ii++]=str1[i];
        }
        str2[ii]=0x00;
}
