      subroutine plot(x, y, ipen)
      real x, y
      integer ipen      
c
      common/p00001/ xorig,yorig,ipage
      COMMON/L00000/PSCA,xo,yo
c
      if(ipen.lt.0) then
         call origin(x,y,1)
         iqen=-ipen
         call xplot(0.,0.,iqen)
      else 
         iqen=ipen
         call xplot(x,y,iqen)
      endif
      return
      end
