
      subroutine xSYMBOL(X,Y,SIZE,IWORD,ANGL,NCHAR, ifont)
C
C     writes a Hollerith string on the plot--plotter unit
C     ifont = 1(Palatino Roman), 2(Bold), 3(Italic), 4(BoldItalic)
C
      COMMON/P00000/LPLOT,A,B,C,D,ASP,THET
      COMMON/L00000/PSCA,xo,yo
      CHARACTER*80 IWORD
      CHARACTER*80 CWORD
      nch = nchar
      IF(NCHAR.GT.80)NCH=80
C
C     select character orientation
C
      ab=0.0
c      if(irot.ne.0) ab=90.0
C
C     select character size
C
   40 SZ=ABS(SIZE)*PSCA*1.5
      do 50 k=1,80
        cword(k:k) = iword(k:k)
   50 continue
      do 51 k=nch+1,80
        cword(k:k) = ' '
   51 continue
C
C      move pen to symbol location
C
      IP=3
      IF(SIZE.LT.0.0)IP=-3
      CALL PLOT(X,Y,IP)
      ang=angl+ab
      write(LPLOT,fmt='(f9.3,a)') ang,' rotate'
C
c     write character string
C
        if(ifont .eq. 1) then
                write(LPLOT,fmt='(f9.3,x,a)') sz,' pR'
        else if(ifont .eq. 2) then
                write(LPLOT,fmt='(f9.3,x,a)') sz,' pB'
        else if(ifont .eq. 3) then
                write(LPLOT,fmt='(f9.3,x,a)') sz,' pI'
        else if(ifont .eq. 4) then
                write(LPLOT,fmt='(f9.3,x,a)') sz,' pBI'
        else
                write(LPLOT,fmt='(f9.3,x,a)') sz,' hV'
        endif
      write(LPLOT,fmt='(x,a,a,a,/,a)') '(',cword,')',' show'
C
C     reset character orientation if necessary
C
      bng = -ang 
      write(LPLOT,fmt='(f9.3,a)') bng,' rotate'
10    RETURN
      END
