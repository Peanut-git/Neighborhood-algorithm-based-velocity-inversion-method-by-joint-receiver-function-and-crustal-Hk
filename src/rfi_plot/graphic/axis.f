       subroutine axis(x,y,iword,nchar,xl,angl,x0,dx0,keta)
       character iword*80
       dx=1.
       nc=iabs(nchar)
       id=1
       if (nchar.lt.0) id=-1
       call plot (x,y,-3)
       yl=0.0
       call rot(xl,yl,xx,yy,angl)
       call plot(xx,yy,3)
       call plot(0.,0.,2)
       do 1 z=0.0,xl,dx
       xval=x0+z/dx*dx0
       call rot(z,yl,xx,yy,angl)
       call plot(xx,yy,3)
       call rot(z,0.1*id,xx,yy,angl)
       call plot(xx,yy,2)
       call rot(z-0.2,0.4*id,xx,yy,angl)
       call number(xx,yy,0.25,xval,angl,keta)
 1     continue
       u=xl/2.0-0.1*nc
       call rot(u,0.8*id,xx,yy,angl)
       call symbol(xx,yy,0.3,iword,angl,nc)
       call plot(-x,-y,-3)
       return
       end
