C-----------------------------------------------------------------
      subroutine CIRCLE(RADIUS,NSIDES)
C
C    draws circle centred at current pen location, with
C    circumference divided into NSIDES straight segments
C
      COMMON/P00000/LPLOT,A,B,C,D,ASP,THET
      COMMON/L00000/PSCA,xo,yo
C
      cx = xo
      cy = yo
      nsid = NSIDES
      if(nsid.EQ.0) nsid = 72
      rpa = radius
      ANG = 6.283185308/float(nsid)
      xv = rpa+cx
      yv = cy
      call plot(xv,yv,3)
      sta=0.0
      do 30 i=1,nsid
        sta = sta+ang
        xv = rpa*cos(sta)+cx
        yv = rpa*sin(sta)+cy
        call plot(xv,yv,2)
 30   continue
      xo = cx
      yo = cy
      RETURN
      END
