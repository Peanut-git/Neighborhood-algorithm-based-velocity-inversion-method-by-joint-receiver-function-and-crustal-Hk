C-----------------------------------------------------------gh--bk
       subroutine ORIGIN(x,y,iorig)
c
      common/p00001/ xorig,yorig,ipage
      common/l00000/psca,xo,yo
c
      if(iorig.eq.0) then
         xorig=x*psca
         yorig=y*psca
      else if(iorig.gt.0) then
         xorig=xorig+x*psca
         yorig=yorig+y*psca
      else if(iorig.lt.0) then
         if(psca.eq.0) stop 'ORIGIN error: zero scale'
         x=xorig/psca
         y=yorig/psca
      endif
      return
      end
