c--------------------------------------------------------------------------
c
        program synrf_noise
c
c       coded by T. Shibutani
c                28/08/95
c                20/11/95
c
c       This program computes the radial component of 
c       a receiver function from a given multi-layered 
c       model (NA model). The synthetic waveform is 
c       output in the SAC format.
c
c       subroutines called
c         synth_rf.f
c         theo.f
c         qlayer.f
c         lofw.f
c         cft.f
c
c--------------------------------------------------------------------------

        include 'rfi_param.inc'
c
        real*4          thickness(maxlayer),
     &                  velocity_1(maxlayer),
     &                  velocity_2(maxlayer),
     &                  vpvs_ratio(maxlayer),
     &                  q_alpha(maxlayer),
     &                  q_beta(maxlayer),
     &                  wdata(maxdata)
c
        character*80    mname,
     &                  kname,
     &                  str
c
c                                               Read the name of input file
        read(5,'(a)') str
        lw=lofw(str)
        write(mname,'("NA_MDL/",a,a1)') str(1:lw),char(0)
        open(11,file=mname,status='old')
        write(6,*)
        write(6,*) 'NOW OPEN FILE: ',mname(1:lw+7)
c
c                                               Input parameter
        read(5,*) gauss_a, water_c
        read(5,*) angle
        read(5,*) time_shift
        read(5,*) fs, ndata
        delt=1./fs
        read(5,*) sn, iseed
        write(6,*) 
        write(6,*) '* gauss_a =',gauss_a
        write(6,*) '* water_c =',water_c
        write(6,*) '* incident_angle =',angle
        write(6,*) '* time_shift =',time_shift
        write(6,*) '* sampling freq. =',fs
        write(6,*) '* ndata =',ndata
        write(6,*) '* s/n =',sn
        write(6,*) '* iseed =',iseed
        adum=ran3rfi(iseed)
        beg = -time_shift
c       end = beg + (ndata-1)*delt
c
c                                               Read in number of layers
c                                               and NA velocity model
        read(11,*) nlayer
        do i=1,nlayer
c         read(11,'(3x,4f7.2,2f7.0)') 
          read(11,*)idum, 
     &            thickness(i), velocity_1(i), velocity_2(i),
     &            vpvs_ratio(i), q_alpha(i), q_beta(i)
        end do
c
c                                               Compute receiver function 
        write(6,*)
        write(6,*) '* Now compute receiver functions...'
        call synth_rf(
     &          thickness, velocity_1, velocity_2, angle, gauss_a, 
     &          water_c, time_shift, ndata, fs, vpvs_ratio, 
     &          q_alpha, q_beta, wdata, nlayer, sn )
c
c                                               Output to SAC files
        read(5,'(a)') str
        lw=lofw(str)
        write(kname,'("NA_SRF/",a,".syn",a1)') str(1:lw),char(0)
        write(6,*)
        write(6,*) 'NOW WRITE FILE: ',kname(1:lw+11)
        write(6,*)
        call writesrf(
     &          kname, ndata,
     &          wdata,
     &          beg, 
     &          gauss_a, water_c,
     &          delt )
c
        close(11)
c
        stop
        end
c
        subroutine synth_rf(
     &          thickness, velocity_1, velocity_2, angle, gauss_a, 
     &          water_c, time_shift, ndata, fs, vpvs_ratio, 
     &          q_alpha, q_beta, wdata, nlayer, sn )
c
        include 'rfi_param.inc'
c
        parameter     ( v60 = 8.043 )
        parameter     ( rad = 0.017453292 )
c
        real*4          thickness(maxlayer),
     &                  velocity_1(maxlayer),
     &                  velocity_2(maxlayer),
     &                  vpvs_ratio(maxlayer),
     &                  q_alpha(maxlayer),
     &                  q_beta(maxlayer),
     &                  beta(maxsublayer),
     &                  h(maxsublayer),
     &                  vpvs(maxsublayer),
     &                  qa(maxsublayer),
     &                  qb(maxsublayer),
     &                  wdata(maxdata)
c
c                                                  NA_model -> QLAYER model
        k=0
        do i=1,nlayer
          thick=thickness(i)
          if (thick.gt.0.0) then
             v1=velocity_1(i)
             v2=velocity_2(i)
             gr=(v2-v1)/thick
             nsub=int(thick/2.)+1
             dh=thick/float(nsub)
             do j=1,nsub
               k=k+1
               h(k)=dh
               beta(k)=v1+gr*dh*float(j-1)
               vpvs(k)=vpvs_ratio(i)
               qa(k)=q_alpha(i)
               qb(k)=q_beta(i)
             end do
          end if
        end do
c
c       *** semi-infinite layer ***
c
        k=k+1
        h(k)=0.
        beta(k)=beta(k-1)
        vpvs(k)=vpvs(k-1)
        qa(k)=qa(k-1)
        qb(k)=qb(k-1)
c
        nsublayer=k
c
c                                           Correction of incident angle
c
          ppara=sin(angle*rad)/v60
          din=asin(ppara*beta(nsublayer)*vpvs(nsublayer))/rad
c
c                                           Synthesize receiver function
        call theo_noise(
     &          nsublayer, beta, h, vpvs, qa, qb, fs, din, 
     &          gauss_a, water_c, time_shift, ndata, sn, wdata )
c
        return
        end
