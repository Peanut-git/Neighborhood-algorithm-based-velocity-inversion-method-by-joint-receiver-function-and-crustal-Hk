#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <assert.h>
#include <unistd.h>

#include "utils.h"

void na_printline(int* nd, int* procnum, float* err, float* model)
{
	static char buf[8192];
	int j = 0;
	int i = 0;

	/*fprintf(stderr, "printline called by iproc %d (nd=%d)\n", *procnum, *nd);*/

	
	j = snprintf(buf, 8192, "NA_MSG_PREFIX %d ", *procnum);
	/*fprintf(stderr, "j is %d\n", j);*/
	while(i < *nd) {
		j += snprintf(&(buf[j]), 8192-j, "%f ", model[i++]);
		/*fprintf(stderr, "j is %d\n", j);*/
		if(j >= 8192) {
			fprintf(stderr, "BUFFER OVERFLOW IN PRINTLINE .... ABORTING\n");
			exit(1);
		}
	}

	j += snprintf(&(buf[j]), 8192-j, "%f \n", *err);
	/*fprintf(stderr, "after final write, j is %d\n", j);*/
	if(j >= 8192) {
		fprintf(stderr, "BUFFER OVERFLOW IN PRINTLINE (but only just).... ABORTING\n");
		exit(1);
	}
	

	fprintf(stdout, buf);
} /* na_printline */

/* print the message immediately to stderr (i.e. print 
 * and flush(), just in case stderr is buffered) */
void na_printnow(char* msg)
{
	fflush(stdout);
	fprintf(stderr, "%s\n", msg);
	fflush(stderr);
} /* na_printnow */

/* return elapsed wall time in seconds since start
 * of last epoch
 */
static struct timeval tp;
static int rtn;
void na_walltime(double* t)
{
	rtn=gettimeofday(&tp, NULL);
	assert(rtn == 0);
				 
	*t = tp.tv_sec+(1.e-6)*tp.tv_usec;
} /* na_walltime */

static char hn[1024];
void na_printhostname(int* iproc)
{
	gethostname(hn, 1024);
	fprintf(stdout, "I am proc %d on host %s\n", *iproc, hn);
} /* na_printhostname */
