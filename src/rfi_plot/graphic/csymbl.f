C----------------------------------------------------------------------
      subroutine CSYMBL(X,Y,IP,SIZE,INT)
C
C      writes a centered symbol at location (X,Y). The symbol is
C      is selected from the list below by INT for 1<INT<10
C      and is circle,triangle,square,pentagon,hexagon,heptagon,
C      octagon for 11<INT<17
C
      COMMON/P00000/LPLOT,A,B,C,D,ASP,THET
      COMMON/L00000/PSCA,xo,yo
c
      CHARACTER*1 ISYM
c
      DIMENSION ISYM(10)
      DIMENSION ICIR(10)
      DATA ISYM/'O','X','*','+','#','$','@','8','H','Z'/
      DATA ICIR/20,3,4,5,6,7,8,9,10,11/
      IF(INT.GE.11)GO TO 20
C
C    select character size
C
      call plot(x,y,ip)
      call symbol(x-0.5*size,y-0.5*size,size,isym(int),0.0,1)
      return
c
C     move pen to symbol location, symbol is written after move
C
   20 CALL PLOT(X,Y,IP)
      CALL CIRCLE(SIZE*0.75,ICIR(INT-10))
      RETURN
C
       END
