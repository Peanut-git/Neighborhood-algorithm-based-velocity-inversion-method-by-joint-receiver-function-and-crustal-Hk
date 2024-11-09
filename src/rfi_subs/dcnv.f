
c****************************************
c
      subroutine dcnv(fs,to,a,c,vv,hh)
c
c     deconvolution by spectral division
c       ch()*cv~()*gau()/fai()
c         fai()=max(cv()*cv~(),c*max(cv()*cv~()))
c         gau()=exp(-(pi*f/a)**2)
c           cv()  : spectrum of deconvolved part
c           ch()  : spectrum from which cv() is deconvolved
c           fai() : denominator whose deep troughs are filled
c                   with water
c             c   : water level parameter
c           gau() : Gaussian high-cut filter
c             a   : width parameter
c
c     coded by T. Shibutani
c              RCEP, DPRI, Kyoto Univ.,
c              shibutan@rcep.dpri.kyoto-u.ac.jp
c
c     dcnv1.30 : released on 20/09/95
c
c*****************************************
c
      parameter ( n=2048, n2=n/2+1 )
c
      real  vv(n), hh(n,3)
      real  xx(n), data(2*n)
      real  fai(n2), gau(n2)
      complex  cv(n), ch(n), yi, co
c
c     *** parameters setting ***
c
      yi=(0.0,1.0)
      pi=3.141592654
c
      df=fs/float(n)
c
c     *** deconvolved part : vertical comp. ***
c
      do i=1,n
        data(2*i-1)=vv(i)
        data(2*i)=0.
      end do
c
c     *** call fft in NR ***
c
      call four1(data,n,1)
c
      do i=1,n2
        cv(i)=cmplx(data(2*i-1),data(2*i))
      end do
c
c     *** water level ***
c
      vmax=0.
      do i=1,n2
        xx(i)=cabs(cv(i)*conjg(cv(i)))
        vmax=amax1(vmax,xx(i))
      end do
      do i=1,n2
        fai(i)=amax1(xx(i),c*vmax)
      end do
c
c     *** gaussian high-cut filter ***
c
      do i=1,n2
        fr=df*float(i-1)
        gau(i)=exp(-(pi*fr/a)**2)
      end do
c
c     *** deconvolution process ***
c
      do j=1,3
c
        do i=1,n
          data(2*i-1)=hh(i,j)
          data(2*i)=0.
        end do
c
c       *** call fft in NR ***
c
        call four1(data,n,1)
c
        do i=1,n2
          ch(i)=cmplx(data(2*i-1),data(2*i))

        end do
c
c       *** spectral division & folding back at Nyquist ***
c
        do i=1,n2
          co=-2.*pi*yi*df*float(i-1)*to
          ch(i)=ch(i)*conjg(cv(i))*gau(i)*cexp(co)/fai(i)
          if (i.ge.2) ch(n-i+2)=conjg(ch(i))
        end do
c
c       *** transform back into time domain ***
c
        do i=1,n
          data(2*i-1)=real(ch(i))
          data(2*i)=aimag(ch(i))
        end do
c
c       *** call inverse fft in NR ***
c
        call four1(data,n,-1)
c
        do i=1,n
          hh(i,j)=data(2*i-1)/n
        end do
c
      end do
c
      return
      end
