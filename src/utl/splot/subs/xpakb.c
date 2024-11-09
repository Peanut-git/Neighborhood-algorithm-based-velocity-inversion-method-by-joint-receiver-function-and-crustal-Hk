/* X include files */

#include <assert.h>
#include <errno.h>
#include <time.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/cursorfont.h>
#include <X11/X.h>
#include <X11/keysym.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <string.h>
#include <sys/file.h>
#include <sys/stat.h>
#include <utmp.h>

#include "cfopen.h"
#include "xpak.h"
#include "xtra.h"

/* Fortran Common Block equivalents definitions */

p00000_t p00000_;
p00001_t p00001_;
p00002_t p00002_;
a00000_t a00000_;

/* Global variables */

Display          *mydisplay;
Window	 	 mywindow;
GC               mygc, backgroundgc;
Pixmap           mypixmap;
XSizeHints       myhint;
Font             font1,font2,font3,font4,font5;
Colormap         cmap;
XColor           color[PIXELS];
XColor           colorgrey[PIXELS];
unsigned long    pixels[PIXELS];
unsigned long    plane_masks;
int              ncol;
short            xdot[MAXDOT+1][PIXELS],ydot[MAXDOT+1][PIXELS];
unsigned int     ncolors;
XEvent           myevent;
KeySym           mykey;
Cursor           mycursor;
int              myscreen;
unsigned int     depth, pixheight, pixwidth;
int              mylinestyle;
int              mylinewidth;
char             mywindowname[256];

static char      dash1[]={3,3};
static char      dash2[]={6,3};
static char      dash3[]={9,3};
static char      dash4[]={9,3,3,3};
static char      dash5[]={9,3,6,3};
static char      dash6[]={9,3,6,3,6,3};

static int       red[] =   {0,255,  0,255, 63, 31,255,255,
                            191,255,159,255,255,159,159,159,
                             15, 31, 47, 63, 79, 95,111,127,
                            143,159,175,191,207,223,239,255};
static int       green[] = {0,255,  0, 31, 63,225,255,159,
                            127,191, 63,159,159,159,255,159,
                             15, 31, 47, 63, 79, 95,111,127,
                            143,159,175,191,207,223,239,255};
static int       blue[] =  {0,255, 63, 31,255, 31, 31, 31,
                             63, 97,159,159,255,255,159,159,
                             15, 31, 47, 63, 79, 95,111,127,
                            143,159,175,191,207,223,239,255};

/* Subroutine Library */

void italic(UNUSED(float *theta))
{
  return;
} /* italic */

/* Hplots initializes the graphics process:
        if ils = 0 - a4 window
        if ils = 1 - a3 window
        if ils = 2 - a3 window
   and initializes handshaking characteristics (ion=1,2) or terminates
   plotting (ion=0). */

void hplots(int *ion, int *iro, int *lpl, int *ils)
{

  /* declarations */
  unsigned long    myforeground, mybackground;
  int              i;
  char             dspnm[40];
  int              done;
/*int              sync = 1; */
  XGCValues        gcvalues;
  struct timespec  t0, t1 = { 0l, 100000000lu };

  if (*ion == 0) goto finish;

  /* Initialize common block variables */

  p00000_.lplot = *lpl;
  p00000_.irot = *iro;
  p00000_.il34 = *ils;
  p00000_.a = 1.0;
  p00000_.b = 0.0;
  p00000_.c = 1.0;
  p00000_.d = 0.0;
  p00000_.asp = 0.66666;

  p00001_.xorig = 0;
  p00001_.yorig = 0;
  ncol = 0;

  /* Establish the current environment */

  i =40;
  dispnm(dspnm,&i);

  /* Fix bug with opening a window */
  /* on an x-terminal */
  /* mydisplay=XOpenDisplay(dspnm); */

  mydisplay=XOpenDisplay(NULL);
  assert(mydisplay != NULL);

  myscreen=DefaultScreen(mydisplay);
  mybackground=XBlackPixel(mydisplay,myscreen);
  myforeground=XWhitePixel(mydisplay,myscreen);
  mylinewidth = 1;
  depth=XDefaultDepth(mydisplay,myscreen);
  /*mylinestyle=LineSolid;
  XSetLineAttributes (mydisplay,mygc,mylinewidth,mylinestyle,
                        CapButt,JoinBevel);*/
  
  /*XSynchronize(mydisplay,sync);*/

  /* Load fonts */
  /*maxnames = 1000;
  strcpy(pattern,"*");
  list = XListFonts(mydisplay,pattern,maxnames,&count);
  for (i = 0; i < count; i++) printf("%s, %d\n", list[i],i);*/
  /*font1=XLoadFont(mydisplay,"6x10");
  font2=XLoadFont(mydisplay,"6x10");
  font3=XLoadFont(mydisplay,"6x13");
  font4=XLoadFont(mydisplay,"6x13");
  font5=XLoadFont(mydisplay,"9x15");*/
  font1=XLoadFont(mydisplay,"lucidasans-10");
  font2=XLoadFont(mydisplay,"lucidasans-12");
  font3=XLoadFont(mydisplay,"lucidasans-14");
  font4=XLoadFont(mydisplay,"lucidasans-18");
  font5=XLoadFont(mydisplay,"lucidasans-24");

  /* Perform appropriate scaling */


  if (*ils==0) {
    a00000_.psca = 32.0;
    myhint.width = (int) (a00000_.psca * 27.2);
    myhint.height = (int) (a00000_.psca * 19.1);}
  else {
    a00000_.psca = 25.0;
    myhint.width = (int) (a00000_.psca * 40.1);
    myhint.height = (int) (a00000_.psca * 27.4);}

  myhint.x = (1024 - myhint.width) / 2;
  myhint.y = (800 - myhint.height) / 2;

  a00000_.ixo = 0;
  a00000_.iyo = myhint.height;
  a00000_.iox = 0;
  a00000_.ioy = 0;

  myhint.flags=PPosition|PSize;

  /* Create colour map */

  CreateColourMap();

  /* Create window and set default properties */
  mywindow=XCreateSimpleWindow (mydisplay, DefaultRootWindow (mydisplay),
                                myhint.x,myhint.y,myhint.width,myhint.height,
                                2,color[3].pixel,mybackground);

  XSetStandardProperties(mydisplay,mywindow,mywindowname,mywindowname, \
    None,0,0,&myhint);

  mycursor=XCreateFontCursor(mydisplay,XC_center_ptr);
  XDefineCursor(mydisplay,mywindow,mycursor);

  depth = XDefaultDepth(mydisplay,myscreen);
  pixheight = (unsigned) myhint.height;
  pixwidth = (unsigned) myhint.width;
  mypixmap=XCreatePixmap(mydisplay,mywindow,
                         pixwidth,pixheight,depth);

  memset(&gcvalues,0,sizeof(gcvalues));

  mygc=XCreateGC(mydisplay,mypixmap,0,&gcvalues);
  XSetBackground(mydisplay,mygc,mybackground);
  XSetForeground(mydisplay,mygc,myforeground);

  gcvalues.foreground = mybackground;
  gcvalues.fill_style = FillSolid;
  backgroundgc=XCreateGC(mydisplay,mypixmap,GCForeground|GCFillStyle,&gcvalues);
  XFillRectangle(mydisplay,mypixmap,backgroundgc,0,0,pixwidth,pixheight);

  /* input event selection */
  XSelectInput(mydisplay,mywindow, \
    ButtonPressMask|KeyPressMask|ExposureMask);

  /* Map the window to the screen */
  XMapRaised(mydisplay,mywindow);

  return;

  finish:

  /* Copy window to pixmap after plotting */

  depth = XDefaultDepth(mydisplay,myscreen);
  pixheight = (unsigned) myhint.height;
  pixwidth = (unsigned) myhint.width;

  /* Send message to screen */

  printf ("Click on window to exit\n");
  fflush(stdout);

  /* Redraw window if obscured */

  done=0;
  while(done==0)
  {
  /* read the next event */
    XNextEvent(mydisplay,&myevent);
/*  printf("Event: %d\n", myevent.type);
    fflush(stdout); */
    switch(myevent.type)
    {
      /* repaint window on expose events */
      case Expose:
        if (myevent.xexpose.count==0)
          XCopyArea(mydisplay,mypixmap,mywindow,mygc,0,0, \
                    pixwidth,pixheight,0,0);
        break;

      /* process keyboard mapping changes */
      case MappingNotify:
        XRefreshKeyboardMapping(&myevent.xmapping);
        break;

      case ButtonPress:
        done=1;
        break;

      /* process keyboard input
      case KeyPress:
        i=XLookupString(&myevent,text,10,&mykey,0);
        if (i==1 && text[0]=='q') done=1;
        break;*/

      default:
        break;
      } /* switch(myevent.type) */
  } /* while (done==0) */
  /* termination */

  ncolors=PIXELS;
  if (ncol != 0)
     if (depth <9)
        XFreeColors (mydisplay,cmap,pixels,ncol,plane_masks);

  XFreeGC(mydisplay,backgroundgc);
  XFreeGC(mydisplay,mygc);

  XFreeColormap(mydisplay,cmap);

  XUnloadFont(mydisplay,font5);
  XUnloadFont(mydisplay,font4);
  XUnloadFont(mydisplay,font3);
  XUnloadFont(mydisplay,font2);
  XUnloadFont(mydisplay,font1);

  XFreePixmap(mydisplay,mypixmap);
  XDestroyWindow(mydisplay,mywindow);
  XCloseDisplay(mydisplay);
  exit(0);
} /* hplots */

/* Set up scale factors used to go between user and plotter coordinates */

void scale(float *xmin, float *xmax, float *px1, float *px2,
  float *ymin, float *ymax, float *py1, float *py2)
{
  p00000_.a = (*px2 - *px1) / (*xmax - *xmin);
  p00000_.b = *px1 - p00000_.a * (*xmin);
  p00000_.c = (*py2 - *py1) / (*ymax - *ymin);
  p00000_.d = *py1 - p00000_.c * (*ymin);

  p00002_.a1 = *xmin;
  p00002_.a2 = *xmax;
  p00002_.b1 = *px1;
  p00002_.b2 = *px2;
  p00002_.c1 = *ymin;
  p00002_.c2 = *ymax;
  p00002_.d1 = *py1;
  p00002_.d2 = *py2;
}  /* scale */

/* Raises (i=3) or lowers (i=2) pen and moves to coordinates (x,y)
   if i > 0 or to current position plus (x,y) if i < 0 */

void plot(float *x, float *y, int *i)
{
  float            xp, yp;
  short            ixv, iyv;

  xp = *x;
  yp = *y;

  if(p00000_.irot != 0){
    yp = *x;
    xp = -*y;
    if(p00000_.il34 == 0){
      if(*i > 0) xp = 27.2 - *y;}
    else if(p00000_.il34 == 1){
      if(*i > 0) xp = 40.1 - *y;}
  }
  ixv = (int) (xp *  a00000_.psca);
  iyv = (int) (yp *  a00000_.psca);

  if (*i < 0) {
    ixv = a00000_.iox + ixv;
    iyv = a00000_.ioy - iyv;}
  else {
    ixv = ixv + p00001_.xorig;
    iyv = a00000_.iyo - p00001_.yorig - iyv;}

  if(ABS(*i) == 2) {
    XDrawLine (mydisplay,mypixmap,mygc,
               a00000_.iox,a00000_.ioy,ixv,iyv);}

  /* Update the current position */

  a00000_.iox = ixv;
  a00000_.ioy = iyv;
} /* plot */

/* Scales user coordinates to plotter coordinates and plots as in plot */

void plotu(float *x, float *y, int *i)
{
  float            xp, yp;

  xp = *x * p00000_.a;
  yp = *y * p00000_.c;

  if(*i > 0) {
    xp = xp + p00000_.b;
    yp = yp + p00000_.d;}

  plot(&xp,&yp,i);
} /* plotu */

void dashln(int *ldash, UNUSED(int *lpat))
{
  if(*ldash < 0 || *ldash >= 12){
    mylinestyle=LineSolid;
    XSetLineAttributes (mydisplay,mygc,mylinewidth,mylinestyle,
                        CapButt,JoinBevel);}

  switch (*ldash){

    case (0):
      XSetDashes (mydisplay,mygc,3,dash1,2);
      mylinestyle=LineOnOffDash;
      XSetLineAttributes (mydisplay,mygc,mylinewidth,mylinestyle, \
                          CapButt,JoinBevel);
    break;
    case (1):

      XSetDashes (mydisplay,mygc,0,dash1,2);
      mylinestyle=LineOnOffDash;
      XSetLineAttributes (mydisplay,mygc,mylinewidth,mylinestyle, \
                          CapButt,JoinBevel);
    break;
    case (2):
      XSetDashes (mydisplay,mygc,0,dash2,2);
      mylinestyle=LineOnOffDash;
      XSetLineAttributes (mydisplay,mygc,mylinewidth,mylinestyle, \
                          CapNotLast,JoinBevel);
    break;
    case (3):
      XSetDashes (mydisplay,mygc,0,dash3,2);
      mylinestyle=LineOnOffDash;
      XSetLineAttributes (mydisplay,mygc,mylinewidth,mylinestyle, \
                          CapProjecting,JoinBevel);
    break;
    case (4):
      XSetDashes (mydisplay,mygc,0,dash4,4);
      mylinestyle=LineOnOffDash;
      XSetLineAttributes (mydisplay,mygc,mylinewidth,mylinestyle, \
                          CapProjecting,JoinBevel);
    break;
    case (5):
      XSetDashes (mydisplay,mygc,0,dash5,4);
      mylinestyle=LineOnOffDash;
      XSetLineAttributes (mydisplay,mygc,mylinewidth,mylinestyle, \
                          CapButt,JoinBevel);
    break;
    case (6):
      XSetDashes (mydisplay,mygc,0,dash6,6);
      mylinestyle=LineOnOffDash;
      XSetLineAttributes (mydisplay,mygc,mylinewidth,mylinestyle, \
                          CapButt,JoinBevel);
    break;
  }/* switch */
} /* dashln */

/* Writes a Hollerwith string on the plot (plotter units) */

void symbol(float *x, float *y, float *size, char *iword,
  UNUSED(float *angl), int *nchar)
{
  static           float xsiz;
  float            xp, yp;
  short            ixv, iyv;

  xp = *x;
  yp = *y;
  if(p00000_.irot != 0){
    yp = *x;
    xp = -*y;
    if(p00000_.il34 == 0){
      if(*size > 0) xp = 27.2 - *y;}
    else if(p00000_.il34 == 1){
      if(*size > 0) xp = 40.1 - *y;}}

  ixv = (int) (xp *  a00000_.psca);
  iyv = (int) (yp *  a00000_.psca);

  if (*size < 0.0) {
    ixv = a00000_.iox + ixv;
    iyv = a00000_.ioy - iyv;}
  else {
    ixv = p00001_.xorig + ixv;
    iyv = a00000_.iyo - p00001_.yorig - iyv;}

  if(ABS(*size) != xsiz){
    xsiz=ABS(*size);
    if(xsiz <=  0.25) XSetFont(mydisplay,mygc,font1);
    else if(xsiz <= 0.35) XSetFont(mydisplay,mygc,font2);
    else if(xsiz <= 0.45) XSetFont(mydisplay,mygc,font3);
    else if(xsiz <= 0.55) XSetFont(mydisplay,mygc,font4);
    else {
      XSetFont(mydisplay,mygc,font5);}}

  XDrawString(mydisplay,mypixmap,mygc, \
              ixv,iyv,iword,*nchar);
} /* symbol */

/* Writes a Hollerwith string on the plot (user units) */

void symbu(float *x, float *y, float *size, char *iword,
  UNUSED(float *angl), int *nchar)
{
  /* move pen to symbol location */
  static          float xsiz;
  float           xp, yp;
  short           ixv, iyv;

  xp = *x;
  yp = *y;
  if(p00000_.irot != 0){
    yp = *x;
    xp = -*y;
    if(p00000_.il34 == 0){
      if(*size > 0) xp = 27.2 - *y;}
    else if(p00000_.il34 == 1){
      if(*size > 0) xp = 40.1 - *y;}}

  xp = xp * p00000_.a;
  yp = yp * p00000_.c;

  if(*size > 0) {
    xp = xp + p00000_.b;
    yp = yp + p00000_.d;}

  ixv = (int) (xp *  a00000_.psca);
  iyv = (int) (yp *  a00000_.psca);

  if (*size < 0.0) {
    ixv = a00000_.iox + ixv;
    iyv = a00000_.ioy - iyv;}
  else {
    ixv = p00001_.xorig + ixv;
    iyv = a00000_.iyo - p00001_.yorig - iyv;}

  if(ABS(*size) != xsiz){
    xsiz=ABS(*size);
    if(xsiz <=  0.25) XSetFont(mydisplay,mygc,font1);
    else if(xsiz <= 0.35) XSetFont(mydisplay,mygc,font2);
    else if(xsiz <= 0.45) XSetFont(mydisplay,mygc,font3);
    else if(xsiz <= 0.55) XSetFont(mydisplay,mygc,font4);
    else XSetFont(mydisplay,mygc,font5);}

  XDrawString(mydisplay,mypixmap,mygc, \
              ixv,iyv,iword,*nchar);
} /* symbu */

/* Writes a number on the plot: if nsf=klm, format is fkl.m (FORTRAN),
                                if nsf = -lm, rn is fixed to an integer
                                   and format is ilm (FORTRAN) */

void number(float *x, float *y, float *size, float *rn,
  float *angl, int *nsf)
{
  int itot, idpl, ir;
  int *it;
  char iform[7];
  char iword[30];
  char *iptr;

  if(*nsf > 0) {
    itot = *nsf / 10;
    it = &itot;
    idpl = *nsf - (*nsf /10) * 10;
    sprintf(iform,"%%%d.%df",itot,idpl);
    sprintf(iword,iform,*rn);}
  else {
    ir = (int) *rn;
    it = nsf;
    sprintf(iword,"%d",ir);}

  iptr = &iword[0];

  symbol(x,y,size,iptr,angl,it);
} /* number */

void csymbl(float *x, float *y, int *ip, float *size, int *it)
{
  float radius, xp, yp;
  float angl;
  int il;

  static char isym[] = "ox*+#$@8hz";
  static int icir[] = { 0,3,4,5,6,7,8,9,10,11,
                       100,103,104,105,106,107,108,109,110,111};

  plotu(x,y,ip);
  angl = 0.0;
  if(*it <= 10) {
    xp = *x - *size / 2.0;
    yp = *y - *size / 2.0;
    il = 1;
    symbu(&xp,&yp,size,&isym[*it-1],&angl,&il);}
   else {
     radius = *size * 0.75;
     circle(&radius, &icir[*it-11]);}
} /* csymbl */

void pcirclef(float *x, float *y, float *size)
{
  int *ip = NULL, *it = NULL;
  *ip = 3;
  *it = 21;
  csymbl(x,y,ip,size,it);
} /* pcirclef */

void circle(float *radius, int *nsides)
{
  XPoint *points = NULL;
  float sta, ang, rpa;
  int i, n, icx, icy, ixv, iyv;
  int shape, mode;
  Bool fflag;

  fflag = False;
  n = *nsides;
  if (*nsides >= 100) {
    fflag = True;
    n = *nsides-100;}
  if(n == 0) n = 72;

  if (fflag == True) {points = (XPoint *) malloc(n * sizeof(XPoint));}
  icx = a00000_.iox;
  icy = a00000_.ioy;
  sta = 0.0;
  ang = 6.283185308 / ((float) n);
  rpa = *radius * a00000_.psca;
  ixv = (int) rpa + icx;
  iyv = icy;
  a00000_.iox = ixv;
  a00000_.ioy = iyv;
  for (i = 0; i < n; i = i+1){
    sta = sta + ang;
    if (fflag == False){
      ixv = (int)(rpa * cos(sta)) + icx;
      iyv = (int)(rpa * sin(sta)) + icy;
      XDrawLine (mydisplay,mypixmap,mygc, \
               a00000_.iox,a00000_.ioy,ixv,iyv);
      a00000_.iox = ixv;
      a00000_.ioy = iyv;}
    else if (fflag == True){
      ixv = (int)(rpa * cos(sta)) + icx;
      iyv = (int)(rpa * sin(sta)) + icy;
      points[i].x = ixv;
      points[i].y = iyv;}
  }

  if (fflag == True) {
    shape = Complex;
    mode = CoordModeOrigin;
    XFillPolygon(mydisplay,mypixmap,mygc,points,n,shape,mode);
    free(points);}

  a00000_.iox = icx;
  a00000_.ioy = icy;
} /* circle */

void CreateColourMap(void)
{
/*Bool contig = False;
  unsigned int nplanes = 0;*/
  int i;

  cmap=XDefaultColormap(mydisplay,myscreen);

  for (i = 0;i < 32; i++)
    {
    color[i].red  =  red[i] * 256;
    color[i].green=  green[i] * 256;
    color[i].blue =  blue[i] * 256;
    color[i].pixel=  pixels[i];
    XAllocColor(mydisplay,cmap,&color[i]);
    }
}  /* CreateColourMap */

void pen(int *ipen, int *ithk)
{
  unsigned long valuemask;
  XGCValues values;

  valuemask = GCForeground;
  values.foreground = color[*ipen].pixel;
  if(*ithk != 0) mylinewidth = *ithk;
/*
  if(*ithk == -1) mylinewidth = 0.5;
  if(*ithk == -2) mylinewidth = 0.35;
  if(*ithk == -3) mylinewidth = 0.25;
*/
    XSetLineAttributes (mydisplay,mygc,mylinewidth,mylinestyle, \
                       CapButt,JoinBevel);

  XChangeGC(mydisplay,mygc,valuemask,&values);
} /* pen */

void fillpoly(float *xf, float *yf, int *nf)
{
  XPoint *points;
  int ixv, iyv;
  int i, shape, mode;

  points = (XPoint *) malloc(*nf * sizeof(XPoint));

  for(i = 0; i < *nf; i++){
    ixv = (int)(a00000_.psca * *(xf+i)) + p00001_.xorig;
    iyv = a00000_.iyo - (int)(a00000_.psca * *(yf+i)) - p00001_.yorig;
    points[i].x = ixv;
    points[i].y = iyv;}

  shape = Complex;
  mode = CoordModeOrigin;

  XFillPolygon(mydisplay,mypixmap,mygc,points,*nf,shape,mode);

  free(points);
} /* fillpoly */

void origin(float *x, float *y, int *iorig)
{
  if(*iorig == 0){
    p00001_.xorig = a00000_.psca * (int) *x;
    p00001_.yorig = a00000_.psca * (int) *y;}
  else if(*iorig > 0){
    p00001_.xorig = p00001_.xorig + a00000_.psca * (int) *x;
    p00001_.yorig = p00001_.yorig + a00000_.psca * (int) *y;}
  else if(*iorig < 0){
    if(a00000_.psca == 0){
      printf("ORIGIN error: zero scale\n");}
    else{
      *x = p00001_.xorig / a00000_.psca;
      *y = p00001_.yorig / a00000_.psca;}}
} /* origin */

/* Check this */

void where(float *x, float *y, float *rfact)
{
  float r;

  r = 1.0;
  rfact = &r;
  *x = (float) a00000_.iox * a00000_.psca;
  *y = (float) a00000_.ioy * a00000_.psca;
  factor(rfact);
} /* where */

void factor(float *fact)
{
  static int first = 0;
  static float factl = 1.0;
  float osca = 0.0;

  if(first == 1){
    osca = a00000_.psca;
    first = 1;}
  if(*fact > 0){
    a00000_.psca = osca * *fact;
    factl = *fact;}
  else{
    *fact = factl;}
}  /* factor */

void shadrt(float *xi, float *yi)
{
  unsigned int dx,dy;

  dx =  (int) a00000_.psca * *xi;
  dy =  (int) a00000_.psca * *yi;

  XFillRectangle(mydisplay,mypixmap,mygc,a00000_.iox, \
                 a00000_.ioy-dy,dx,dy);
} /* shadrt */

void edgert(float *xi, float *yi)
{
  unsigned int dx,dy;

  dx =  (int) a00000_.psca * *xi;
  dy =  (int) a00000_.psca * *yi;

  XDrawRectangle(mydisplay,mypixmap,mygc,a00000_.iox, \
                 a00000_.ioy-dy,dx,dy);
} /* edgert */

/* Routine to find the display name on which client is working*/

void dispnm(char *dspnm, int *nchr)
{
#if 0
  int m,j,k;
  struct utmp ut;

  m = sizeof ut;
  k = ttyslot();				/* Get offset of my user's entry in utmp */
  j = open("/etc/utmp", O_RDONLY,0);		/* Open utmp and */
  lseek(j,k*m,L_SET); 			/*    seek to the appropriate entry. */
  read(j,&ut,sizeof ut);			/* Read the entry. */
  close(j);

  if (strlen(ut.ut_line) == 0)		/* If no remote host, use the local one */
        gethostname(dspnm,*nchr);
  else
        strcpy(dspnm,ut.ut_line);
#endif
  const char *p=getenv("DISPLAY");
  if (p != NULL)
    strncpy(dspnm, p, *nchr);
  else
    strncpy(dspnm,":0", *nchr);

  return;
} /* dispnm */

void ldcolr(int *lunit)
{
  Bool contig;
  unsigned int nplanes;
  Status result;
  int lu;
  int id[PIXELS],ir[PIXELS],ig[PIXELS],ib[PIXELS];
  int i;

  contig=False;
  nplanes=0;

  lu = *lunit;

  /* printf ("Into ldcolr \n");  */

  cmap=XDefaultColormap(mydisplay,myscreen);

  /*printf ("Out of defcm \n");*/

  cfopen(&lu, &ncol, id, ir, ig, ib);
  /* printf ("%4d %4d %4d %4d %4d\n",ncol,*(id),*(ir),*(ig),*(ib)); */

  if (depth<9){
  result=XAllocColorCells (mydisplay,cmap,contig,
                           &plane_masks,nplanes,pixels,ncol+32);
  if (result==0) printf ("1 Error in allocating the color cells...\n");
  /*printf("ncol is, %3d \n",ncol);*/
  }

  for (i = 0;i < 32; i++)
    {
    color[i].red  =  red[i] * 256;
    color[i].green=  green[i] * 256;
    color[i].blue =  blue[i] * 256;
    color[i].flags=  DoRed | DoGreen | DoBlue;
    color[i].pixel=  pixels[i];
    if (depth<9) { XStoreColor(mydisplay,cmap,&color[i]); }
    else {color[i].pixel=0; XAllocColor (mydisplay,cmap, &color[i]);}
    }
  for (i = 0;i < ncol; i++)
    {
  /*  printf("%3d %3d %3d %3d\n",id[i],ir[i],ig[i],ib[i]);*/
    color[id[i]].red  =  ir[i] * 256;
    color[id[i]].green=  ig[i] * 256;
    color[id[i]].blue =  ib[i] * 256;
    color[id[i]].flags=  DoRed | DoGreen | DoBlue;
    color[id[i]].pixel=  pixels[i+32];
    if (depth<9) { XStoreColor (mydisplay,cmap,&color[id[i]]);}
    else {color[id[i]].pixel=0; XAllocColor (mydisplay,cmap, &color[id[i]]);}
    }

  /* XStoreColors (mydisplay,cmap,color,ncolors); */

  /*printf (" Xstorecolours \n");*/
} /* ldcolr */

/* POSTPAK pimag4 variables nth11,nth22 (ranging between 1 and 16) are
mapped into a 1,256 range and incorporated into a call to pimag8 (see
below)
*/

void pimag4(float *xori, float *yori, float *xxl, float *yyl,
  int *nsxx, int *nsyy, float *arr, int *nth11, int *nth22,
  float *sth11, float *sth22)
{
  int n1,n2;

  n1 = (*nth11 - 1) * 8 + 4;
  n2 = (*nth22 - 1) * 8 + 4;
  pimag8(xori,yori,xxl,yyl,nsxx,nsyy,arr,&n1,&n2,sth11,sth22);
} /* pimag4 */

/* Routine to simulate POSTPAK picol. Variables are defined
as follows:
      Passed variables:
        xori,yori - coordinates of bottom left corner of image.
        xxl,yyl - length of x and y sides (plotter units as above).
        nsxx,nsyy - no of individual colour cells along x and y borders.
        arr - the array containing the values to be contoured.
        nth11,nth22 - range of indices in POSTPAK grey shades (1:256).
        sth11,sth22 - corresponding array maximum and minimum values.
        imap - switch to colour outside bounds.

      Work variables:
        npx,npy - no of screen pixels along x and y borders.
        ixo,iyo - identification of plot origin pixels.
        ix,iy - identification of current pixel being considered. (0:npx-1)
        nx,ny - identification of cell in which current pixel belongs. (1:nsxx)

   N.B. The maximum number of permitted color indices in a colour map
        is PIXELS (i.e. colour indices in the range 0 --> PIXELS-1). If
	either nth11 or nth22 is greater than PIXELS-1 it is set equal
	to PIXELS-1.

	If either the pen range or the parameter range are swapped around
	then the colour mapping is reversed. All array values which fall
        beyond the parameter range (s1,s2) are mapped onto the end colours
        if imap = 0 and are not plotted if imap = 1.
*/

void picol(float *xori, float *yori, float *xxl, float *yyl,
  int *nsxx, int *nsyy, float *arr, int *nth11, int *nth22,
  float *sth11, float *sth22, int *imap)
{
  int           npx,npy;
  int           ix,iy,nx,ny;
  unsigned long valuemask;
  XGCValues     values;
  XPoint        points[MAXDOT+1];
  int           count[PIXELS];
  int           pix,ixo,iyo,i,k,ndiff,id;
  float         a1,sdiff;
  unsigned int nth1,nth2;
  int n1,n2;

  sdiff = *sth22 - *sth11;
  nth1 = *nth11;
  nth2 = *nth22;
  n1 = i2min(nth1,nth2);
  n2 = i2max(nth1,nth2);
  ndiff = nth2 - nth1;
  npx = (int) (*xxl *  a00000_.psca);
  npy = (int) (*yyl *  a00000_.psca);
  ixo = (int) (*xori * a00000_.psca) + p00001_.xorig;
  iyo = a00000_.iyo - p00001_.yorig - (int) (*yori * a00000_.psca);


  for (i = 0 ; i < PIXELS; i++) count[i]=0;

  for (iy = 0; iy < npy; iy++){
    ny = 1 + (int) ((float) (iy) * (float) (*nsyy) / (float) (npy));
    for (ix = 0; ix < npx; ix++ ){
      nx = 1 + (int) ((float) (ix) * (float) (*nsxx) / (float) (npx));
      id = nx + (ny - 1) * (*nsxx) - 1;
      a1 = *(arr+id);
      pix = (int) ((a1 - *sth11) * (float) (ndiff) / sdiff) + nth1;
      if (*imap > 0){
        if (pix <= n2){
        if (pix >= n1){
        xdot[count[pix]][pix] = ix + ixo;
        ydot[count[pix]][pix] = iyo - iy;
        count[pix]++;

  /* Colour in groups of individual pixels when the number of pixels with
  a given pixel value pix exceeds MAXDOT. Note that this is efficient when
  dealing with large arrays (arr).  */

        if (count[pix] == MAXDOT){
          for(k = 0; k <= MAXDOT; k++){
            points[k].x=xdot[k][pix];
            points[k].y=ydot[k][pix];
          }
          valuemask = GCForeground;
          values.foreground = color[pix].pixel;
          XChangeGC(mydisplay,mygc,valuemask,&values);
          XDrawPoints (mydisplay,mypixmap,mygc,points,MAXDOT,CoordModeOrigin);
          count[pix]=0;
        }
      }}}
      else {
        if (pix > n2) pix = n2;
        if (pix < n1) pix = n1;
        xdot[count[pix]][pix] = ix + ixo;
        ydot[count[pix]][pix] = iyo - iy;
        count[pix]++;

  /* Colour in groups of individual pixels when the number of pixels with
  a given pixel value pix exceeds MAXDOT. Note that this is efficient when
  dealing with large arrays (arr).  */

        if (count[pix] == MAXDOT){
          for(k = 0; k <= MAXDOT; k++){
            points[k].x=xdot[k][pix];
            points[k].y=ydot[k][pix];
          }
          valuemask = GCForeground;
          values.foreground = color[pix].pixel;
          XChangeGC(mydisplay,mygc,valuemask,&values);
          XDrawPoints (mydisplay,mypixmap,mygc,points,MAXDOT,CoordModeOrigin);
          count[pix]=0;
        }
      }
    }
  }

  /* Colour in remaining values of pix where count[pix] does not exceed MAXDOT.*/

  for(pix = n1; pix <= n2; pix++){
    if(count[pix] != 0){
      for(k=0; k <= count[pix]; k++){
        points[k].x=xdot[k][pix];
        points[k].y=ydot[k][pix];
      }
       valuemask = GCForeground;
       values.foreground = color[pix].pixel;
       XChangeGC(mydisplay,mygc,valuemask,&values);
       XDrawPoints(mydisplay,mypixmap,mygc,points,count[pix],CoordModeOrigin);
    }
  }
} /* picol */

/*
Routine to simulate Postscript library routine pimag8.
This is an obsolete routine and has been superseeded by picol which
does the same thing in colour.
Picol uses the current colour table for the pixels (a greyscale can
be achieved by reading in a greyscale using the routine ldcolr,
e.g. the one in /usr/server/plot/pak/Examples.

*/

/*    write out error message */

void pimag8(UNUSED(float *xori), UNUSED(float *yori),
  UNUSED(float *xxl), UNUSED(float *yyl),
  UNUSED(int *nsxx), UNUSED(int *nsyy),
  UNUSED(float *arr),
  UNUSED(int *nth11), UNUSED(int *nth22),
  UNUSED(float *sth11), UNUSED(float *sth22))
{
  printf("Error routine pimag8 is obsolete in the xpak library \n");
  printf("use subroutine picol with a greyscale colour table \n");
  printf("read in with routine ldcolr\n");
} /* pimag8 */

/* function to calculate the greater of two integers*/

int i2max(int n1, int n2)
{
  return (n1 > n2) ? n1 : n2;
} /* i2max */

/* function to calculate the lesser of two integers*/

int i2min(int n1, int n2)
{
  return (n1 < n2) ? n1 : n2;
} /* i2min */

/* to give a name to the window and icon.
   note: to have any effect it must be called before hplots*/

void xname(char *fnme, int *nlen)
{
  int     i;

  for ( i=0 ; i< *nlen ; i++) mywindowname[i]=fnme[i];
  mywindowname[ *nlen]='\0';
} /* xname */

/* Tells user if the X-pak or postscript library has been compiled */

void plottype(int *n)
{
  *n=2;
} /* plottype */
