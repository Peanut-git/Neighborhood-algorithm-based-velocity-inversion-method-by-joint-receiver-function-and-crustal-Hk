
      subroutine ARC(x,y,RADIUS,ang1,ang2)
      COMMON/P00000/LPLOT,A,B,C,D,ASP,THET
      common/p00001/ xorig,yorig,ipage
      COMMON/L00000/PSCA,xo,yo
      xp=PSCA*x+xorig
      yp=PSCA*y+yorig
      rp=PSCA*radius
      write(LPLOT,'(5f9.3,a)') xp,yp,rp,ang1,ang2,' arc'
      end
