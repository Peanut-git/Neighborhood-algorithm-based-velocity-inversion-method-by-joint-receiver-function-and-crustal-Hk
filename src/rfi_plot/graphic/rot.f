c
       subroutine rot(x,y,xx,yy,angl)
       pi=3.14159
       a=angl/180.0*pi
       xx=x*cos(a)-y*sin(a)
       yy=x*sin(a)+y*cos(a)
       return
       end
