c-------------------------------------------------------------------------
c
c       Subroutine display_model - writes out the model contained in 
c                                  array rmodel and misfit value to 
c                                  the file assigned to logical 
c                                  unit lu
c
c       Note: Calls no other routines
c
c------------------------------------------------------------------------
c
        subroutine display_model(
     &          lu, imod, rmodel, moddim, misfitval )
c
        include 'rfi_param.inc'
c
c
        real*4          rmodel(maxmoddim)
c
        real*4          misfitval
c
c                                               Write out model `rmodel'
c
        write(lu,801) imod, misfitval
c
        nlayer=moddim/4
        do j=1,nlayer
          j2=nlayer+j
          j3=2*nlayer+j
          j4=3*nlayer+j
          write(lu,811) j, rmodel(j), rmodel(j2), 
     &                  rmodel(j3), rmodel(j4)
        end do
c
  801   format( '  model:',i5,',   misfit value:',f10.5 )
  811   format( 5x,i3,4f10.3 )
c
        return
        end
