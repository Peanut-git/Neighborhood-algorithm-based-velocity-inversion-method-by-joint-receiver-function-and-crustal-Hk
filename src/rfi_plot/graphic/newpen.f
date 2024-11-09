C-------------------------------------------------------------bk-
      subroutine NEWPEN(IPEN)
C
C     allows user to change pen
C     to access colours
C
      COMMON/P00000/LPLOT,A,B,C,D,ASP,THET
      COMMON/L00000/PSCA,xo,yo
      write(LPLOT,*) ' stroke '
c
       if(IPEN.le.1) write(LPLOT,71) ' 0 setgray'
c red
       if(IPEN.eq.2)
     ^ write(LPLOT,71) ' 0. 1. 1. sethsbcolor'
c blue
       if(IPEN.eq.3)
     ^ write(LPLOT,71) ' 0.5 1. 1. sethsbcolor'
c green
       if(IPEN.eq.4)
     ^ write(LPLOT,71) ' 0.333 1. 1. sethsbcolor'
c yellow
       if(IPEN.eq.5)
     ^ write(LPLOT,71) ' 0.167 1. 1. sethsbcolor'
c violet
       if(IPEN.eq.6)
     ^ write(LPLOT,71) ' 0.666 1. 1. sethsbcolor'
c pink
       if(IPEN.eq.7)
     ^ write(LPLOT,71) ' 0.833 1. 1. sethsbcolor'
c white
       if(IPEN.eq.8)
     ^ write(LPLOT,71) ' 1 1 1 setrgbcolor'
c gray tones
       if(IPEN.gt.8) then
           gray = mod(IPEN,8)/8.
           write(LPLOT,72) gray
       endif
c
 71    format(a)
 72    format(1x,f7.4,' setgray ')
       RETURN
       END
