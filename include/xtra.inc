      interface
      subroutine typset(xa, ya) bind(c, name="typset")
        use iso_c_binding, only : c_float
        implicit none
        real(kind=c_float) xa, ya
      end subroutine typset
      end interface

      interface
      subroutine zpick(ifnm, iall, istati) bind(c, name="zpick")
        use iso_c_binding, only : c_int
        implicit none
        integer(kind=c_int) ifnm, iall, istati
      end subroutine zpick
      end interface

      interface
      subroutine typstr(x, y, size, iword, angl, nchar)
     & bind(c, name="typstr")
        use iso_c_binding, only : c_char, c_int, c_float
        implicit none
        real(kind=c_float) x, y, size
        character(kind=c_char) iword(*)
        real(kind=c_float) angl
        integer(kind=c_int) nchar
      end subroutine typstr
      end interface

      interface
      subroutine typnum(x, y, size1, fnum1, angle, ndec1)
     & bind(c, name="typnum")
        use iso_c_binding, only : c_int, c_float
        implicit none
        real(kind=c_float) x, y, size1, fnum1, angle
        integer(kind=c_int) ndec1
      end subroutine typnum
      end interface

      interface
      subroutine symnum(x, y, size, rn, angl, nsf)
     & bind(c, name="symnum")
        use iso_c_binding, only : c_int, c_float
        implicit none
        real(kind=c_float) x, y, size, rn, angl
        integer(kind=c_int) nsf
      end subroutine symnum
      end interface
