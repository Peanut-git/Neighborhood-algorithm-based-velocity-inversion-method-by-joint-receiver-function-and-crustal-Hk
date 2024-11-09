      subroutine PLOTS(LPL)
      COMMON/P00000/LPLOT,A,B,C,D,ASP,THET
      common/p00001/ xorig,yorig,ipage
      COMMON/L00000/PSCA,xo,yo
C
      A=1.0
      B=0.0
      C=1.0
      D=0.0
      asp = 0.6666
      LPLOT=LPL
      xorig=0.
      yorig=0.
C
c     Postcript initialisation
      write(LPLOT,'("%!")')
      write(LPLOT,'("%%Page:1")')
        ipage=1
      write(LPLOT,*) 'initmatrix'
      write(LPLOT,*) '/pM {stroke newpath moveto} def'
      write(LPLOT,*) '/pL {lineto} def'
      write(LPLOT,*) '/rM {rmoveto} def'
      write(LPLOT,*) '/rL {rlineto} def'
      write(LPLOT,*) '/AR {stroke newpath',
     -               ' 0 360 arc closepath stroke} def'
      write(LPLOT,*) '/cAR {stroke newpath',
     -               ' 0 360 arc closepath fill} def'
      write(lplot,*) '/gBOX {stroke newpath moveto'
      write(lplot,*) '    dx 0 rlineto 0  dy rlineto'
      write(lplot,*) '    dx neg 0 rlineto 0 dy neg rlineto'
      write(lplot,*) '    closepath'
      write(lplot,*) '    hue setgray'
      write(lplot,*) '    fill} def' 
      write(lplot,*) '/cBOX {stroke newpath moveto'
      write(lplot,*) '    dx 0 rlineto 0  dy rlineto'
      write(lplot,*) '    dx neg 0 rlineto 0 dy neg rlineto'
      write(lplot,*) '    closepath'
      write(lplot,*) '    hue 1. 1. sethsbcolor'
      write(lplot,*) '    fill} def' 
      write(LPLOT,*) '/PLUS {stroke newpath moveto'
      write(LPLOT,*) '   -0.5 0 rlineto 1 0 rlineto'
      write(LPLOT,*) '   -0.5 -0.5 rmoveto 0 1 rlineto} def'
      write(LPLOT,*) '/SQR {stroke newpath moveto'
      write(LPLOT,*) '   -4 -4 rmoveto 0 8 rlineto 8 0 rlineto'
      write(LPLOT,*) '0 -8 rlineto -8 0 rlineto closepath fill} def'
      write(LPLOT,*) '/TRI {stroke newpath moveto'
      write(LPLOT,*) '   -4 -4 rmoveto 4 8 rlineto'
      write(LPLOT,*) '4 -8 rlineto -8 0 rlineto closepath fill} def'
      write(LPLOT,*) '1 setlinejoin'
      write(LPLOT,*) '/pR {/Palatino-Roman findfont '
      write(LPLOT,*) ' exch scalefont setfont} def'
      write(LPLOT,*) '/pI {/Palatino-Italic findfont '
      write(LPLOT,*) ' exch scalefont setfont} def'
      write(LPLOT,*) '/pB {/Palatino-Bold findfont '
      write(LPLOT,*) ' exch scalefont setfont} def'
      write(LPLOT,*) '/pBI {/Palatino-BoldItalic findfont '
      write(LPLOT,*) ' exch scalefont setfont} def'
      write(LPLOT,*) '/hV {/Helvetica-Bold findfont '
      write(LPLOT,*) ' exch scalefont setfont} def'
      write(LPLOT,*) 'newpath '
      write(LPLOT,*) '0.8 setlinewidth'
c
        PSCA = 72.0/2.54
      END
