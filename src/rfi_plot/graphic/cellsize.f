        subroutine cellsize(dx,dy)
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
c
        write(lplot,'("/dx ",f9.3," def")') ddx
        write(lplot,'("/dy ",f9.3," def")') ddy
c
        return
        end
