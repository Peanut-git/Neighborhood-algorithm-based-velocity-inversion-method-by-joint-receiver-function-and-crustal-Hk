      interface
      subroutine na_printline(nd, procnum, err, model)
     & bind(c, name="na_printline")
        use iso_c_binding, only : c_int, c_float
        implicit none
        integer(kind=c_int) nd
        integer(kind=c_int) procnum
        real(kind=c_float) err
        real(kind=c_float) model(*)
      end subroutine na_printline
      end interface

      interface
      subroutine na_printnow(msg) bind(c, name="na_printnow")
        use iso_c_binding, only : c_char
        implicit none
        character(kind=c_char) msg(*)
      end subroutine na_printnow
      end interface

      interface
      subroutine na_walltime(t) bind(c, name="na_walltime")
        use iso_c_binding, only : c_double
        implicit none
        real(kind=c_double) t
      end subroutine na_walltime
      end interface

      interface
      subroutine na_printhostname(iproc)
     & bind(c, name="na_printhostname")
        use iso_c_binding, only : c_int
        implicit none
        integer(kind=c_int) iproc
      end subroutine na_printhostname
      end interface
