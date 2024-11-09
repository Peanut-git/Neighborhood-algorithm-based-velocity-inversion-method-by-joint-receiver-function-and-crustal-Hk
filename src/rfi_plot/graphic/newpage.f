      subroutine NEWPAGE(LPL)
C
      COMMON/P00000/LPLOT,A,B,C,D,ASP,THET
      common/p00001/ xorig,yorig,ipage
C
      A=1.0
      B=0.0
      C=1.0
      D=0.0
      asp = 0.6666
      LPLOT=LPL
      xorig=0.
      yorig=0.
      write(LPLOT,*) 'stroke'
      write(LPLOT,*) 'showpage'
      ipage=ipage+1
      write(LPLOT,*) '%%Page:',ipage
      write(LPLOT,*) '0.8 setlinewidth'
      write(LPLOT,*) '1 setlinejoin'
      end
