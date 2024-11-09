      subroutine cfopen(lunit,ncol,id,ir,ig,ib) bind(c, name="cfopen")
      use iso_c_binding, only : c_int
c     implicit none
      integer(c_int) ncol, lunit, id(255),ir(255),ig(255),ib(255)

      character*256   string

  5   read(lunit,fmt='(a72)')string
      if(string(1:1).eq.'#')go to 5
      read(string,*)ncol
      do 10 i=1,ncol
  15    read(lunit,fmt='(a72)')string
        if(string(1:1).eq.'#')go to 15
        read(string,*)id(i),ir(i),ig(i),ib(i)
  10  continue

      return
      end

      subroutine logo_NA(x,y,s) bind(c, name="logo_na")
      use iso_c_binding, only : c_float
c     implicit none
      real(c_float) x,y,s

c     A dummy routine for xpak

      return
      end
