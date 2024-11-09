        subroutine frame(xl,dx,x0,dx0,yl,dy,y0,dy0,nsf)
c
        call penw(0.1)
c
c >> frame box
        call plot(1.,0.,3)
        call plot(0.,0.,2)
        call plot(0.,yl,2)
        call plot(xl,yl,2)
        call plot(xl,0.,2)
        call plot(0.,0.,2)
c >> x-axis
        s=sign(1.,yl)
        do x=0.,xl,dx
          xval=x0+x/dx*dx0
          CALL PLOT(X,0.,3)
          CALL PLOT(X,0.5*s,2)
          CALL NUMBER(X-0.7,-0.25-0.55*s,0.5,XVAL,0.,nsf)
          call plot(x,yl,3)
          call plot(x,yl-0.5*s,2)
          if (x.lt.xl) then
            do i=1,4
              xt=x+dx/5.*i
              call plot(xt,0.,3)
              call plot(xt,0.3*s,2)
              call plot(xt,yl,3)
              call plot(xt,yl-0.3*s,2)
            end do
          end if
        end do
c >> y-axis
        do y=0.,yl,dy
          yval=y0+y/dy*dy0
          CALL PLOT(0.,y,3)
          CALL PLOT(0.5,y,2)
          CALL NUMBER(-1.8,y-0.2,0.5,yVAL,0.,nsf)
          call plot(xl,y,3)
          call plot(xl-0.5,y,2)
          if (abs(y).lt.abs(yl)) then
            do i=1,4
              yt=y+dy/5.*i
              call plot(0.,yt,3)
              call plot(0.3,yt,2)
              call plot(xl,yt,3)
              call plot(xl-0.3,yt,2)
            end do
          end if
        end do
c
        return
        end
        
