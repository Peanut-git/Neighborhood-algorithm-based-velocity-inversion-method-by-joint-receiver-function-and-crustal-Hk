        subroutine fcellg(x,y,dx,dy,col)
c************************************************************
c       To paint cells.
c       Coded by T. Shibutani (RCEP, DPRI, Kyoto Univ.)
c       Ver. 1.00 (1993-05-09)
c************************************************************
c
        COMMON/P00000/LPLOT,A,B,C,D,ASP,THET
        common/p00001/ xorig,yorig,ipage
        COMMON/L00000/PSCA,xo,yo
C
        ddx=psca*dx
        ddy=psca*dy
        x1=psca*x-ddx/2.+xorig
        y1=psca*y-ddy/2.+yorig
c
        write(lplot,'("/hue ",f9.3," def")') col
        write(lplot,'(2f9.3," gBOX")') x1,y1
c
        return
        end
