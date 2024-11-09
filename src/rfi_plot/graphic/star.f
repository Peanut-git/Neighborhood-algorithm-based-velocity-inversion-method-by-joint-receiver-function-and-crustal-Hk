      subroutine star(x,y)
      common/P00000/lplot,a,b,c,d
      common/p00001/ xorig,yorig,ipage
      common/L00000/psca,xo,yo
      write(lplot,*) '/STAR {stroke newpath moveto'
      write(lplot,*) '   0 8.0 rmoveto 4.8 -14.4 rlineto'
      write(lplot,*) '   -12.4 8.8 rlineto 15.2 0 rlineto'
      write(lplot,*) '   -12.4 -8.8 rlineto 4.8 14.4 rlineto'
      write(lplot,*) 'closepath fill} def'
      xp=psca*x+xorig
      yp=psca*y+yorig
      write(lplot,'(2f9.3,a)') xp,yp,' STAR'
      return
      end
