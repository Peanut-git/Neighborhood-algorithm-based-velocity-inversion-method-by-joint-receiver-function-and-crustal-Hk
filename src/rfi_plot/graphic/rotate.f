        subroutine rotate(ang)
c************************************************************
c       To rotate graphics.
c       Coded by T. Shibutani (RCEP, DPRI, Kyoto Univ.)
c       Ver. 1.00 (1993-05-09)
c************************************************************
c
        COMMON/P00000/LPLOT,A,B,C,D,ASP,THET
        common/p00001/ xorig,yorig,ipage
        COMMON/L00000/PSCA,xo,yo
c
        write(lplot,'(f9.3,a)') ang,' rotate'   
c
        return
        end
