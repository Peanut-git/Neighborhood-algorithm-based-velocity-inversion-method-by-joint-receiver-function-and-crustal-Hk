      subroutine PENW(pw)
c
      COMMON/P00000/LPLOT,A,B,C,D,ASP,THET
      COMMON/L00000/PSCA,xo,yo
c
      if (pw.le.0.) then
        pww=0.8
      else
        pww=psca*pw
      end if
      write(LPLOT,'(a,f7.2,a)') 'stroke',pww,' setlinewidth'
c
      end
