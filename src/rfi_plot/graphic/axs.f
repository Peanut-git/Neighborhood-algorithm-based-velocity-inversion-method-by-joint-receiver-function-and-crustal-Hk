      subroutine AXS(ID,XL,DX,X0,DX0,nsf)
* < x-axis (ID=0) or y-axis (ID.NE.0)
C     RAD=0.01745
      call penw(0.1)
      IF(ID.EQ.0) CALL PLOT(XL,0.,3)
      IF(iABS(ID).EQ.1) CALL PLOT(0.,-XL*ID,3)
      CALL PLOT(0.,0.,2)
      DO 1 X=0.,XL,DX
           XVAL=X0+X/DX*DX0
      IF(ID.EQ.0) THEN
            CALL PLOT(X,0.,3)
            CALL PLOT(X,0.5,2)
            CALL NUMBER(X-0.7,-0.8,0.5,XVAL,0.,nsf)
            if (x.lt.xl) then
              do i=1,4
                xt=x+dx/5.*i
                call plot(xt,0.,3)
                call plot(xt,0.3,2)
              end do
            end if
      ELSE
            CALL PLOT(0.,-X*ID,3)
            CALL PLOT(0.5,-X*ID,2)
            CALL NUMBER(-1.8,-(X+0.2)*ID,0.5,XVAL,0.,nsf)
            if (x.lt.xl) then
              do i=1,4
                xt=x+dx/5.*i
                call plot(0.,-xt*id,3)
                call plot(0.3,-xt*id,2)
              end do
            end if
      END IF
1     CONTINUE
      END
