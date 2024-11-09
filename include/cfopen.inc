      interface
      subroutine cfopen(lunit,ncol,id,ir,ig,ib) bind(c, name="cfopen")
        use iso_c_binding, only : c_int
        implicit none
        integer(kind=c_int) ncol, lunit, id(255),ir(255),ig(255),ib(255)
      end subroutine cfopen
      end interface

      interface
      subroutine logo_NA(x,y,s) bind(c, name="logo_na")
        use iso_c_binding, only : c_float
        implicit none
        real(kind=c_float) x,y,s
      end subroutine logo_NA
      end interface
