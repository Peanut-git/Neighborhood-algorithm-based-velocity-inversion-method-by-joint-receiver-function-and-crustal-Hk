      subroutine scale(sc)
c     Coded by T. Shibutani on Oct 15, 1991.
c
      COMMON/P00000/LPLOT,A,B,C,D,ASP,THET
      common/p00001/ xorig,yorig,ipage
      COMMON/L00000/PSCA,xo,yo
c
      write(lplot,fmt='(2f9.3,a)') sc,sc,' scale'
c
      return
      end
