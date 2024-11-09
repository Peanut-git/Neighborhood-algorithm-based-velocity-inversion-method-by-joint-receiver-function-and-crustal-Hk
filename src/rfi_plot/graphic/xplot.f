
      subroutine xPLOT(X,Y,I)
C
C     Raises (I=3) or lowers (I=2) pen and moves to coordinates
C      (X,Y) if I>0 or to current position plus (X,Y) if I<0
C
      COMMON/P00000/LPLOT,A,B,C,D,ASP,THET                            
      common/p00001/ xorig,yorig,ipage
      COMMON/L00000/PSCA,xo,yo
      DATA IUP/1/
      II=IABS(I)
C
C     Rotate plot by 90 degrees if necessary
C
      XP=X
      YP=Y
      XV= PSCA*XP+xorig
      YV= PSCA*YP+yorig
C
C     plot
C
      if(I.eq.2)  write(LPLOT,fmt='(2f9.3,a)') xv,yv,' pL'
      if(I.eq.3)  write(LPLOT,fmt='(2f9.3,a)') xv,yv,' pM'
      if(I.eq.-2) write(LPLOT,fmt='(2f9.3,a)') xv,yv,' rL'
      if(I.eq.-3) write(LPLOT,fmt='(2f9.3,a)') xv,yv,' rM'
c 
c      if(I.gt.0) then
       xo = x   
       yo = y
c      endif
      RETURN
      END
