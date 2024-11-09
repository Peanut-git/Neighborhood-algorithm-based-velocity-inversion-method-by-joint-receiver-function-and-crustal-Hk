      interface
      subroutine italic(theta) bind(c, name="italic")
        use iso_c_binding, only : c_float
        implicit none
        real(kind=c_float) theta
      end subroutine italic
      end interface

      interface
      subroutine hplots(ion, iro, lpl, ils) bind(c, name="hplots")
        use iso_c_binding, only : c_int
        implicit none
        integer(kind=c_int) ion, iro, lpl, ils
      end subroutine hplots
      end interface

      interface
      subroutine scale(xmin, xmax, px1, px2, ymin, ymax, py1, py2)
     & bind(c, name="scale")
        use iso_c_binding, only : c_float
        implicit none
        real(kind=c_float) xmin, xmax, px1, px2, ymin, ymax, py1, py2
      end subroutine scale
      end interface

      interface
      subroutine plot(x, y, i) bind(c, name="plot")
        use iso_c_binding, only : c_int, c_float
        implicit none
        real(kind=c_float) x, y
        integer(kind=c_int) i
      end subroutine plot
      end interface

      interface
      subroutine plotu(x, y, i) bind(c, name="plotu")
        use iso_c_binding, only : c_int, c_float
        implicit none
        real(kind=c_float) x, y
        integer(kind=c_int) i
      end subroutine plotu
      end interface

      interface
      subroutine dashln(ldash, lpat) bind(c, name="dashln")
        use iso_c_binding, only : c_int
        implicit none
        integer(kind=c_int) ldash, lpat
      end subroutine dashln
      end interface

      interface
      subroutine symbol(x, y, size, iword, angl, nchar)
     & bind(c, name="symbol")
        use iso_c_binding, only : c_char, c_int, c_float
        implicit none
        real(kind=c_float) x, y, size
        character(kind=c_char) iword(*)
        real(kind=c_float) angl
        integer(kind=c_int) nchar
      end subroutine symbol
      end interface

      interface
      subroutine symbu(x, y, size, iword, angl, nchar)
     & bind(c, name="symbu")
        use iso_c_binding, only : c_char, c_int, c_float
        implicit none
        real(kind=c_float) x, y, size
        character(kind=c_char) iword(*)
        real(kind=c_float) angl
        integer(kind=c_int) nchar
      end subroutine symbu
      end interface

      interface
      subroutine number(x, y, size, rn, angl, nsf)
     & bind(c, name="number")
        use iso_c_binding, only : c_char, c_int, c_float
        implicit none
        real(kind=c_float) x, y, size, rn, angl
        integer(kind=c_int) nsf
      end subroutine number
      end interface

      interface
      subroutine csymbl(x, y, ip, size, it) bind(c, name="csymbl")
        use iso_c_binding, only : c_char, c_int, c_float
        implicit none
        real(kind=c_float) x, y
        integer(kind=c_int) ip
        real(kind=c_float) size
        integer(kind=c_int) it
      end subroutine csymbl
      end interface

      interface
      subroutine pcirclef(x, y, size) bind(c, name="pcirclef")
        use iso_c_binding, only : c_float
        implicit none
        real(kind=c_float) x, y, size
      end subroutine pcirclef
      end interface

      interface
      subroutine circle(radius, nsides) bind(c, name="circle")
        use iso_c_binding, only : c_int, c_float
        implicit none
        real(kind=c_float) radius
        integer(kind=c_int) nsides
      end subroutine circle
      end interface

      interface
      subroutine CreateColourMap() bind(c, name="CreateColourMap")
        implicit none
      end subroutine CreateColourMap
      end interface

      interface
      subroutine pen(ipen, ithk) bind(c, name="pen")
        use iso_c_binding, only : c_int
        implicit none
        integer(kind=c_int) ipen, ithk
      end subroutine pen
      end interface

      interface
      subroutine fillpoly(xf, yf, nf) bind(c, name="fillpoly")
        use iso_c_binding, only : c_int, c_float
        implicit none
        real(kind=c_float) xf(*), yf(*)
        integer(kind=c_int) nf
      end subroutine fillpoly
      end interface

      interface
      subroutine origin(x, y, iorig) bind(c, name="origin")
        use iso_c_binding, only : c_int, c_float
        implicit none
        real(kind=c_float) x, y
        integer(kind=c_int) iorig
      end subroutine origin
      end interface

      interface
      subroutine where(x, y, rfact) bind(c, name="where")
        use iso_c_binding, only : c_float
        implicit none
        real(kind=c_float) x, y, rfact
      end subroutine where
      end interface

      interface
      subroutine factor(fact) bind(c, name="factor")
        use iso_c_binding, only : c_float
        implicit none
        real(kind=c_float) fact
      end subroutine factor
      end interface

      interface
      subroutine shadrt(xi, yi) bind(c, name="shadrt")
        use iso_c_binding, only : c_float
        implicit none
        real(kind=c_float) xi, yi
      end subroutine shadrt
      end interface

      interface
      subroutine edgert(xi, yi) bind(c, name="edgert")
        use iso_c_binding, only : c_float
        implicit none
        real(kind=c_float) xi, yi
      end subroutine edgert
      end interface

      interface
      subroutine dispnm(dspnm, nchr) bind(c, name="dispnm")
        use iso_c_binding, only : c_char, c_int
        implicit none
        character(kind=c_char) dspnm(*)
        integer(kind=c_int) nchr
      end subroutine dispnm
      end interface

      interface
      subroutine ldcolrnew(lunit) bind(c, name="ldcolrnew")
        use iso_c_binding, only : c_int
        implicit none
        integer(kind=c_int) lunit
      end subroutine ldcolrnew
      end interface

      interface
      subroutine ldcolr(lunit) bind(c, name="ldcolr")
        use iso_c_binding, only : c_int
        implicit none
        integer(kind=c_int) lunit
      end subroutine ldcolr
      end interface

      interface
      subroutine pimag4(xori, yori, xxl, yyl, nsxx, nsyy, arr,
     & nth11, nth22, sth11, sth22) bind(c, name="pimag4")
        use iso_c_binding, only : c_int, c_float
        implicit none
        real(kind=c_float) xori, yori, xxl, yyl
        integer(kind=c_int) nsxx, nsyy
        real(kind=c_float) arr(*)
        integer(kind=c_int) nth11, nth22
        real(kind=c_float) sth11, sth22
      end subroutine pimag4
      end interface

      interface
      subroutine picol (xori, yori, xxl, yyl, nsxx, nsyy, arr,
     & nth11, nth22, sth11, sth22, imap) bind(c, name="picol")
        use iso_c_binding, only : c_int, c_float
        implicit none
        real(kind=c_float) xori, yori, xxl, yyl
        integer(kind=c_int) nsxx, nsyy
        real(kind=c_float) arr(*)
        integer(kind=c_int) nth11, nth22
        real(kind=c_float) sth11, sth22
        integer(kind=c_int) imap
      end subroutine picol
      end interface

      interface
      subroutine pimag8(xori, yori, xxl, yyl, nsxx, nsyy, arr,
     & nth11, nth22, sth11, sth22) bind(c, name="pimag8")
        use iso_c_binding, only : c_int, c_float
        implicit none
        real(kind=c_float) xori, yori, xxl, yyl
        integer(kind=c_int) nsxx, nsyy
        real(kind=c_float) arr(*)
        integer(kind=c_int) nth11, nth22
        real(kind=c_float) sth11, sth22
      end subroutine pimag8
      end interface

      interface
      function i2max(n1, n2) bind(c, name="i2max")
        use iso_c_binding, only : c_int
        implicit none
        integer(kind=c_int) i2max, n1, n2
      end function i2max
      end interface

      interface
      function i2min(n1, n2) bind(c, name="i2min")
        use iso_c_binding, only : c_int
        implicit none
        integer(kind=c_int) i2min, n1, n2
      end function i2min
      end interface

      interface
      subroutine xname(fnme, nlen) bind(c, name="xname")
        use iso_c_binding, only : c_char, c_int
        implicit none
        character(kind=c_char) fnme(*)
        integer(kind=c_int) nlen
      end subroutine xname
      end interface

      interface
      subroutine plottype(n) bind(c, name="plottype")
        use iso_c_binding, only : c_int
        implicit none
        integer(kind=c_int) n
      end subroutine plottype
      end interface
