#ifndef _XPAK_H
#define _XPAK_H

/* Program macros and parameter constants */

#ifndef ABS
#define ABS(x) (((x) < 0) ? -(x) : (x))
#endif

#ifndef UNUSED
#define UNUSED(x) x __attribute__ ((unused))
#endif

#define PIXELS    230
#define MAXDOT    500

/* Fortran Common Block equivalents (defined in xpakw.c) */

typedef struct {int lplot,irot,il34; float a,b,c,d,asp,theta;} p00000_t __attribute__((packed));
typedef struct {int xorig,yorig;} p00001_t __attribute__((packed));
typedef struct {float a1,a2,b1,b2,c1,c2,d1,d2;} p00002_t __attribute__((packed));
typedef struct {float psca; int ixo, iyo, iox, ioy;} a00000_t __attribute__((packed));

extern p00000_t p00000_;
extern p00001_t p00001_;
extern p00002_t p00002_;
extern a00000_t a00000_;

/* External variables (defined in xpakw.c) */

extern Display        *mydisplay;
extern Window         mywindow;
extern GC             mygc;
extern Pixmap         mypixmap;
extern XSizeHints     myhint;
extern Colormap       cmap;
extern XColor         color[];
extern unsigned long  pixels[];
extern unsigned long  plane_masks;
extern int            ncol;
extern unsigned int   ncolors;
extern XEvent         myevent;
extern KeySym         mykey;
extern Cursor         mycursor;
extern int            myscreen;
extern unsigned int   depth, pixheight, pixwidth;
extern int            mylinestyle;
extern int            mylinewidth;

extern void italic(float *theta);
extern void hplots(int *ion, int *iro, int *lpl, int *ils);
extern void scale(float *xmin, float *xmax, float *px1, float *px2,
  float *ymin, float *ymax, float *py1, float *py2);
extern void plot(float *x, float *y, int *i);
extern void plotu(float *x, float *y, int *i);
extern void dashln(int *ldash, int *lpat);
extern void symbol(float *x, float *y, float *size, char *iword,
  float *angl, int *nchar);
extern void symbu(float *x, float *y, float *size, char *iword,
  float *angl, int *nchar);
extern void number(float *x, float *y, float *size, float *rn,
  float *angl, int *nsf);
extern void csymbl(float *x, float *y, int *ip, float *size, int *it);
extern void pcirclef(float *x, float *y, float *size);
extern void circle(float *radius, int *nsides);
extern void CreateColourMap(void);
extern void pen(int *ipen, int *ithk);
extern void fillpoly(float *xf, float *yf, int *nf);
extern void origin(float *x, float *y, int *iorig);
extern void where(float *x, float *y, float *rfact);
extern void factor(float *fact);
extern void shadrt(float *xi, float *yi);
extern void edgert(float *xi, float *yi);
extern void dispnm(char *dspnm,int *nchr);
extern void ldcolrnew(int *lunit);
extern void ldcolr(int *lunit);
extern void pimag4(float *xori, float *yori, float *xxl, float *yyl,
  int *nsxx, int *nsyy, float *arr, int *nth11, int *nth22,
  float *sth11, float *sth22);
extern void picol (float *xori, float *yori, float *xxl, float *yyl,
  int *nsxx, int *nsyy, float *arr, int *nth11, int *nth22,
  float *sth11, float *sth22, int *imap);
extern void pimag8(float *xori, float *yori, float *xxl, float *yyl,
  int *nsxx, int *nsyy, float *arr, int *nth11, int *nth22,
  float *sth11, float *sth22);
extern int i2max(int n1, int n2);
extern int i2min(int n1, int n2);
extern void xname(char *fnme, int *nlen);
extern void plottype(int *n);

#endif /* _XPAK_H */
