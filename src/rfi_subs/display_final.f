c-------------------------------------------------------------------------
c
c       Subroutine display_final - writes out the final model contained in 
c                                  array rmodel to the file assigned to 
c                                  logical unit lu
c
c       Note: Calls no other routines
c
c------------------------------------------------------------------------
c
        subroutine display_final(
     &          lu, rmodel, moddim, misfitval,  
     &          q_alpha, q_beta )
c
        include 'rfi_param.inc'
c
c
        real*4          rmodel(maxmoddim)
c
        real*4          misfitval,
     &                  q_alpha(maxlayer),
     &                  q_beta(maxlayer)
c
c
c                                               Write out final model
c
        nlayer=moddim/4
        depth=0.0
        write(lu,801)
        do j=1,nlayer
          j2=nlayer+j
          j3=2*nlayer+j
          j4=3*nlayer+j
          depth=depth+rmodel(j)
          write(lu,811) 
     &          j, rmodel(j), depth, rmodel(j2), rmodel(j3), 
     &          rmodel(j4), q_alpha(j), q_beta(j)
        end do
c
  801   format(/'*** Final model ***' /
     &          3x,'layer #',3x,'thickness',7x,'Vs1',7x,'Vs2',
     &          5x,'Vp/Vs',3x,'Q_alpha',4x,'Q_beta' )
  811   format( i10,f12.6,'(',f12.6,')',3f12.6,2f10.0 )
c
        return
        end
