
      subroutine PLUS(x,y)
      COMMON/P00000/LPLOT,A,B,C,D,ASP,THET
      common/p00001/ xorig,yorig,ipage
      COMMON/L00000/PSCA,xo,yo
      xp=PSCA*x+xorig
      yp=PSCA*y+yorig
      write(LPLOT,'(2f9.3,a)') xp,yp,' PLUS'
      end
