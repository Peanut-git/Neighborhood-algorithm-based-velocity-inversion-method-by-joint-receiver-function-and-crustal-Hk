c------------------------------------------------------------------------
c
c       Subroutine forward_modelling - calculates the array "predicted_
c                                      data" from the model "rmodel"
c
c       Note_1: Calls are made to : theo
c
c       Note_2: rmodel(1:nlayer): thickness
c               rmodel(nlayer+1:2*nlayer): velocity at upper interface
c               rmodel(2*nlayer+1:3*nlayer): velocity at lower interface
c               rmodel(3*nlayer+1:4*nlayer): Vp/Vs ratio
c
c-------------------------------------------------------------------------
c
        subroutine forward_modelling(
     &          rmodel, moddim, incident_angle, constant_a, 
     &          constant_c, layeridx, pstimesyn, pppstimesyn,
     &          ppsstimesyn, hdatasyn, kdatasyn,
     &          time_shift, ndata, nwave, fs,
     &          q_alpha, q_beta, predicted_data)
c
        include 'rfi_param.inc'
c
        parameter     ( v60 = 8.043 )
        parameter     ( rad = 0.017453292 )
c
        real*8          rmodel(maxmoddim)
c
        real*4          incident_angle(maxwave),
     &                  constant_a(maxwave),
     &                  constant_c(maxwave),
     &                  layeridx(maxwave),
     &                  pstimesyn(maxwave),
     &                  pppstimesyn(maxwave),
     &                  ppsstimesyn(maxwave),
     &                  hdatasyn(maxwave),
     &                  kdatasyn(maxwave),
     &                  time_shift(maxwave),
     &                  predicted_data(maxdata,maxwave),
     &                  q_alpha(maxlayer),
     &                  q_beta(maxlayer),
     &                  mdepth
c
        real*4          h(maxsublayer),
     &                  beta(maxsublayer),
     &                  vpvs(maxsublayer),
     &                  qa(maxsublayer),
     &                  qb(maxsublayer)
c
        integer         ndata(maxwave)
c
c------ construct a model for 'theo'
c
        nlayer=moddim/4
        depth=0.0
        mdepth=0.0
c
        mindex=int(layeridx(1))+1
c
        k=0
        do i=1,nlayer
          thick=rmodel(i)
          
          if (thick.gt.0.0) then
             v1=rmodel(nlayer+i)
             v2=rmodel(2*nlayer+i)
             gr=(v2-v1)/thick
             nsub=int(thick/2.)+1
             dh=thick/float(nsub)
             
             do j=1,nsub
                k=k+1
                h(k)=dh
                depth=depth+dh
                beta(k)=v1+gr*dh*real(j-1)
                vpvs(k)=rmodel(3*nlayer+i)
                qa(k)=q_alpha(i)
                qb(k)=q_beta(i)
                
                if(i.eq.mindex) then
                   if(mdepth.le.0.1) then
                        mdepth=depth-dh
                   end if
                end if               
               
             end do
          end if
        end do
c
c       *** semi-infinite layer ***
c
        k=k+1
        h(k)=0.0
        beta(k)=beta(k-1)
        vpvs(k)=vpvs(k-1)
        qa(k)=qa(k-1)
        qb(k)=qb(k-1)
c
        ntot=k
c
c       do i=1,ntot
c         write(6,'(i3,5f10.3)') i,h(i),beta(i),vpvs(i),qa(i),qb(i)
c       end do
c
c------ compute synthetic receiver functions
c
        do iw=1,nwave
c
c       *** correction of incident angle ***
c
          ppara=sin(incident_angle(iw)*rad)/v60
          din=asin(ppara*beta(ntot)*vpvs(ntot))/rad
c
          call theo(
     &          ntot, beta, h, vpvs, qa, qb, fs, din, 
     &          constant_a(iw), constant_c(iw), time_shift(iw), 
     &          ndata(iw), predicted_data(1,iw) )
c     
          call calculate_ps_arrival(
     &          ntot, beta, h, vpvs, ppara, mdepth,
     &          pstimesyn(iw), pppstimesyn(iw), ppsstimesyn(iw))
c
          call calculate_hk(
     &          ppara, mdepth, pstimesyn(iw), pppstimesyn(iw),
     &          ppsstimesyn(iw), hdatasyn(iw), kdatasyn(iw))   
c
c          write(*,*) 'Moho:',mdepth,
c     &          '估计Ps:',pstimesyn(iw),
c     &          '估计PpPs:',pppstimesyn(iw),
c     &          '估计PpSs:',ppsstimesyn(iw),
c     &          '估计H:',hdatasyn(iw),
c     &          '估计K:',kdatasyn(iw)
c
c          write(6,*) 'predicted_data(71:80)'
c          write(6,*) (predicted_data(i,iw),i=71,80)
c
        end do
c
        return
        end
c
c
c
        subroutine calculate_hk(
     &          ppara, mdepth, pstimesyn, pppstimesyn,
     &          ppsstimesyn, hdatasyn, kdatasyn)
c
        real*4  ppara, mdepth, pstimesyn, pppstimesyn,
     &          ppsstimesyn, hdatasyn, kdatasyn,
     &          H, K, Vp        
c
c       calculate h and k
c
c       default vp 
        Vp=6.2
c
        A=(pppstimesyn - pstimesyn) / ppsstimesyn
        K=sqrt((Vp*ppara)**2 - (Vp*ppara/A)**2 + 1/A**2)
        H=ppsstimesyn / (sqrt(1 / (Vp/K)**2 - ppara**2) * 2.0)
c
        hdatasyn=H
        kdatasyn=K
c        write(*,*) 'ppara',ppara,'H',H,'K',K1,'A',A
c
        return
        end
c
c
c
        subroutine calculate_ps_arrival(
     &          ntot, beta, h, vpvs, ppara, mdepth,
     &          pstimesyn, pppstimesyn, ppsstimesyn)
     
         real*4         h(maxsublayer),
     &                  beta(maxsublayer),
     &                  vpvs(maxsublayer),
     &                  ppara, mdepth, pstimesyn,
     &                  pppstimesyn, ppsstimesyn
     
        integer         ntot     
     
c
c       compute Ps arrival time
c      
        t1=0.0
        t2=0.0
        ta=0.0
        tb=0.0
        tc=0.0
        dep=0.0
        do i=1,ntot
            t1=h(i) * sqrt(1 / beta(i) ** 2 - ppara ** 2)
            t2=h(i) * sqrt(1 / (beta(i) * vpvs(i)) ** 2 - ppara ** 2)
c
c           Ps:(1,-1), PpPs:(1,1), PpSs:(2,0)
c
            ta=ta + t1 - t2
            tb=tb + t1 + t2
            tc=tc + t1 * 2.0
            dep=dep + h(i)
c
c            write(*,*) 'depth',dep,'thick',h(i),
c     &          'vs',beta(i),'k',vpvs(i),
c     &          'ray',ppara,dep,'ta:',ta,'tb',tb

            if(abs(dep-mdepth).le.0.001) then
                pstimesyn=ta
                pppstimesyn=tb
                ppsstimesyn=tc
                exit
            end if
          
        end do
        return
        end
