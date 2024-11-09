c-------------------------------------------------------------------------
c
c       Subroutine calcmisfit - calculates a misfit value between 
c                               observed data and predicted data
c                               plus model roughness
c
c       Note: Calls no other routines
c
c------------------------------------------------------------------------
c
        subroutine calcmisfit(
     &          predicted_data, observed_data, ndata, 
     &          weight, pstime, pppstime, ppsstime,
     &          pstimesyn, pppstimesyn, ppsstimesyn,
     &          hdata, hdatasyn, kdata, kdatasyn,
     &          nwave, misfitval )
c
c
        include 'rfi_param.inc'
c
c
        real*4          predicted_data(maxdata,maxwave),
     &                  observed_data(maxdata,maxwave),
     &                  weight(maxwave),
     &                  pstime(maxwave),
     &                  pppstime(maxwave),
     &                  ppsstime(maxwave),
     &                  pstimesyn(maxwave),
     &                  pppstimesyn(maxwave),
     &                  ppsstimesyn(maxwave),
     &                  hdata(maxwave),
     &                  kdata(maxwave),
     &                  hdatasyn(maxwave),
     &                  kdatasyn(maxwave),
     &                  misfitval
c
        integer         ndata(maxwave)
c
c                                               misfit between observed and
c                                               predicted
        misfitval=0.0
c
        do iw=1,nwave
c
            tim1=0.0
            tim2=0.0
c
            call l2_score(
     &          predicted_data(:,iw), observed_data(:,iw), ndata(iw), 
     &          weight(iw), misfitval )
c
c           call time_score(
c     &          pstime(iw), pppstime(iw), ppsstime(iw),
c     &          pstimesyn(iw), pppstimesyn(iw), ppsstimesyn(iw),
c     &          weight(iw), misfitval)
c
            call hk_score(
     &          hdata(iw), hdatasyn(iw), kdata(iw), kdatasyn(iw),
     &          weight(iw), misfitval)
c
c
c            write(*,*), '失配值:',misfitval,
c     &                '观测H: ',hdata(iw),
c     &                '估计H: ',hdatasyn(iw),
c     &                '观测K: ',kdata(iw),
c     &                '估计K: ',kdatasyn(iw)
c     &                '观测Ps: ',pstime(iw),
c     &                '估计Ps: ',pstimesyn(iw),
c     &                '观测PpPs: ',pppstime(iw),
c     &                '估计PpPs: ',pppstimesyn(iw)
c
        end do
c
        return
        end
c
c
        subroutine hk_score(
     &          hdata, hdatasyn, kdata, kdatasyn,
     &          weight, misfitval)
c
        real*4  hdata, hdatasyn, kdata, kdatasyn,
     &          weight, misfitval
c       
        if((hdata.gt.0.0).and.(kdata.gt.0.0)) then
c
            dh=abs(hdata - hdatasyn)
            dk=abs(kdata - kdatasyn)
c
            misfitval=misfitval + log10(dh / 5.0 + 1.0)
            misfitval=misfitval + log10(dk / 0.1 + 1.0)
        end if
c
        return
        end
c
c
        subroutine time_score(
     &          pstime, pppstime, ppsstime, 
     &          pstimesyn, pppstimesyn, ppsstimesyn,
     &          weight, misfitval )
c
        real*4  pstime, pppstime, ppsstime,
     &          pstimesyn, pppstimesyn, ppsstimesyn,
     &          weight, misfitval
c
        tim=0.0
        tim1=0.0
        tim2=0.0
        tim3=0.0
c
        if(pstime.gt.0.0) then
            tim1=(pstime - pstimesyn) * weight
        end if
c
        if(pppstime.gt.0.0) then
            tim2=(pppstime - pppstimesyn) * weight
        end if
c
        if(ppsstime.gt.0.0) then
            tim3=(ppsstime - ppsstimesyn) * weight
        end if
c
        if((pstime.gt.0.0).and.(pppstime.gt.0.0)) then
            tim=abs(tim1) * 0.7 + abs(tim2) * 0.3
        else
            tim=abs(tim1) + abs(tim2)
        end if
c
c    loss function: log10
        misfitval=misfitval + log10(abs(tim) + 1.0) * 2.0
c    loss function: linear 
c       misfitval=misfitval + abs(tim) / 5.0
c    loss function: square
c       misfitval=misfitval + (abs(tim) / 5.0) ** 2.0
        
        return
        end
c
c     
        subroutine l2_score(
     &          predicted_data, observed_data, ndata, 
     &          weight, misfitval )
c
c
        include 'rfi_param.inc'
c
c
        real*4          predicted_data(maxdata),
     &                  observed_data(maxdata),
     &                  weight, misfitval
c
        integer         ndata
c                
        do i=1,ndata
c
            aval=(observed_data(i)-predicted_data(i))
     &                  * weight
            misfitval=misfitval+aval**2
c        
        end do
c
        return
        end
c
c
c
        subroutine corr_score(
     &          predicted_data, observed_data, ndata, 
     &          weight, misfitval )
c
c
        include 'rfi_param.inc'
c
c
        real*4          predicted_data(maxdata),
     &                  observed_data(maxdata),
     &                  weight, misfitval,
     &                  mean_a, mean_b, sum_a, sum_b, var_a, var_b, cov_ab, temp
c
        integer         ndata
c
        sum_a=0.0
        sum_b=0.0
c           
        do i=1,ndata
            sum_a=sum_a + observed_data(i)
            sum_b=sum_b + predicted_data(i)
        end do
c
        mean_a=sum_a / ndata
        mean_b=sum_b / ndata
c
        var_a=0.0
        var_b=0.0        
c
        do i=1,ndata
            var_a=var_a + (observed_data(i) - mean_a)**2
            var_b=var_b + (predicted_data(i) - mean_b)**2
        end do
c
        var_a=var_a / ndata
        var_a=var_a / ndata  
c
        cov_ab=0.0
        temp=0.0
c
        do i=1,ndata
            temp=(observed_data(i) - mean_a)
            cov_ab=cov_ab + (predicted_data(i) - mean_b) * temp
        end do
c
        misfitval=misfitval + 1.0 - cov_ab / ndata / sqrt(var_a * var_b)
c
c
        return
        end
