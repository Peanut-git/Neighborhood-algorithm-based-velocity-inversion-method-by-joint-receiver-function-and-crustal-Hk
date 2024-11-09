C---------------------------------------------------------------bk-
      subroutine DASHLN(LDASH)
C
C     defines  the style for line drawing
C      ldash < 0   -  reset to solid line
C         or > 6
C
C      ldash = 0   -  solid line
C            = 1   -  dots
C            = 2   -  half dash
C            = 3   -  long dash
C            = 4   -  chain dotted
C            = 5   -  long and short
C            = 6   -  long and two short
C
      COMMON/P00000/LPLOT,A,B,C,D,ASP,THET
      COMMON/L00000/PSCA,xo,yo
C
        integer*4 ldash
        write(LPLOT,*) ' stroke'
        if(ldash.lt.0)  write(LPLOT,*) ' [] 0 setdash'
        if(ldash.gt.6)  write(LPLOT,*) ' [] 0 setdash'
c
        if(ldash.eq.0) write(LPLOT,*) ' [] 0 setdash'
        if(ldash.eq.1) write(LPLOT,*) ' [2 8] 0 setdash'
        if(ldash.eq.2) write(LPLOT,*) ' [4 4] 0 setdash'
        if(ldash.eq.3) write(LPLOT,*) ' [8 8] 0 setdash'
        if(ldash.eq.4) write(LPLOT,*) ' [6 2 2 2] 0 setdash'
        if(ldash.eq.5) write(LPLOT,*) ' [8 4 4 4] 0 setdash'
        if(ldash.eq.6) write(LPLOT,*) ' [6 4 4 4 4 4] 0 setdash'
        xv=psca*xo
        yv=psca*yo
        write(LPLOT,fmt='(2f9.3,a)') xv,yv,' pM'
C
        return
        end
