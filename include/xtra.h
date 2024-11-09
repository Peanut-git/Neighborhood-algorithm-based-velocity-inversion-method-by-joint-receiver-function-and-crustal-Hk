#ifndef _XTRA_H
#define _XTRA_H

#include "xpak.h"

extern void typset(float *xa, float *ya);
extern void zpick(int *ifnm, int *iall, int *istati);
extern void typstr(float *x,float *y, float *size, char *iword,
  float *angl, int *nchar);
extern void typnum(float *x, float *y, float *size1, float *fnum1,
  float *angle, int *ndec1);
extern void symnum(float *x, float *y, float *size, float *rn, float *angl,
  int *nsf);

#endif /* _XTRA_H */
