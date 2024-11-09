cc -*- Mode: Fortran; compile-command: "make plot_model"; -*-
c--------------------------------------------------------------------------
c
        program plot_model
c
c       Malcolm's variant of T. Shibutani's program ga_vs_model_gray_test
c       to plot only selected models.
c
c       coded by T. Shibutani
c                18/05/95
c                01/09/95
c                05/09/95
c                21/11/95
c
c--------------------------------------------------------------------------

        include 'plot_model.inc'
c
        real*4          thickness(maxlayer,maxtotalpop),
     &                  velocity_1(maxlayer,maxtotalpop),
     &                  velocity_2(maxlayer,maxtotalpop),
     &                  vpvs_ratio(maxlayer,maxtotalpop),
     &                  misfitval(maxtotalpop),
     &                  speed(maxsublayer,maxtotalpop),
     &                  vpvs(maxsublayer,maxtotalpop),
     &                  d(0:maxsublayer,maxtotalpop),
     &                  speed_mean(maxdgrid),
     &                  speed_sd(maxdgrid),
     &                  vpvs_mean(maxdgrid),
     &                  vpvs_sd(maxdgrid),
     &                  true_thickness(maxlayer),
     &                  true_velocity_1(maxlayer),
     &                  true_velocity_2(maxlayer),
     &                  true_vpvs_ratio(maxlayer)
c
        integer         kosu1(maxdgrid,maxvgrid),
     &                  kosu2(maxdgrid,maxvgrid),
     &                  index(maxtotalpop),
     &                  nsublayer(maxtotalpop)
c
        character*80    mname,
     &                  kname,
     &                  psname,
     &                  str,
     &                  string,
     &                  title
c
        character       stc*4
        character       dir*2
        character       yesno*1

        logical         plotbestmodel,
     &                  plotallmodels,
     &                  plotavemodel,
     &                  plottruemodel,
     &                  colour,
     &                  boundaries

        real*4          mfitmin
c
c                                               Read directory type
c                                               GA or NA,
c
        read(5,fmt='(a2)')dir
c
c                                               Read plot mode

c                                               Do we plot all models ?
        read(5,fmt='(a1)')yesno
        plotallmodels = .false.
        if(yesno.eq.'y'.or.yesno.eq.'Y')then
           plotallmodels = .true.
        end if

c                                               Do we plot average model ?
        read(5,fmt='(a1)')yesno
        plotavemodel = .false.
        if(yesno.eq.'y'.or.yesno.eq.'Y')then
           plotavemodel = .true.
        end if
        if(.not.plotallmodels)plotavemodel = .false.

c                                               Do we plot best model ?
        read(5,fmt='(a1)')yesno
        plotbestmodel = .false.
        if(yesno.eq.'y'.or.yesno.eq.'Y')then
           plotbestmodel = .true.
        end if

c                                               Do we plot true model ?
        read(5,fmt='(a1)')yesno
        plottruemodel = .false.
        if(yesno.eq.'y'.or.yesno.eq.'Y')then
           plottruemodel = .true.
        end if

c                                               Use colour ?
        read(5,fmt='(a1)')yesno
        colour = .false.
        if(yesno.eq.'y'.or.yesno.eq.'Y')then
           colour = .true.
        end if
c                                               Read name of file 
c                                               containing true model
        read(5,'(a)') str

        if(plottruemodel)then
        lw=lofw(str)
        write(mname,'(a2,"_MDL/",a,a1)') dir,str(1:lw),char(0)

c
c                                               
c                                               Open true model file
c                                               (INPUT)
        open(10,file=mname,status='unknown')
        write(6,*)
        write(6,*) 'NOW OPEN FILE: ',mname(1:lw+7)

        end if
c
        read(5,'(a)') str
        lw=lofw(str)
        write(mname,'(a2,"_MDL/",a,a1)') dir,str(1:lw),char(0)
c                                               
c                                               Open model parameterization file
c                                               (INPUT)
        open(11,file=mname,status='unknown')
        write(6,*)
        write(6,*) 'NOW OPEN FILE: ',mname(1:lw+7)
c
        read(5,'(a)') str
        lw=lofw(str)
        write(mname,'(a2,"_MDL/",a,a1)') dir,str(1:lw),char(0)

c                                               Open file containing 
c                                               Inversion models
c                                               (INPUT)
        open(12,file=mname,status='unknown')
        write(6,*)
        write(6,*) 'NOW OPEN FILE: ',mname(1:lw+7)
        write(6,*)

c                                               Read the number of samples,
c                                               and the number of iterations
        read(12,*) npop1 
        read(12,*) npop2 
        read(12,*) nit
        ntot = npop2*(nit)+npop1
        if(ntot.gt.maxtotalpop)then
          write(*,*)
          write(*,*)' Error too many models to plot' 
          write(*,*)
          write(*,*)' Number of models in input file   = ',ntot
          write(*,*)' Maximum number of models allowed = ',maxtotalpop
          write(*,*)
          write(*,*)' Remedy : recompile program plot_models'
          write(*,*)'          with array parameter maxtotalpop'
          write(*,*)'          increased'
          write(*,*)
          stop
        end if

        write(6,*) '* NUMBER OF ITERATIONS    =',nit
        write(6,*) '* SAMPLES IN INITIAL POOL =',npop1
        write(6,*) '* SAMPLES PER ITERATION   =',npop2
c                                               
c
c                                               Station Code
        stc=str(1:4)
c
        read(5,'(a)') str
        lw=lofw(str)
        write(mname,'(a2,"_MDL/",a,"_mean",a1)') dir,str(1:lw),char(0)
c                                               
c                                               Open file for writing mean model
c                                               (OUTPUT)
        open(21,file=mname,status='unknown')
c
c                                               Open PS-file : unit=8
c                                               (OUTPUT)
c
        write(psname,'(a,".ps",a1)') str(1:lw),char(0)
        open(8,file=psname,status='unknown')
        call plots(8)
        call plot(5.,22.,-3)
c                                               Read parameters specifying
c                                               ranges of diagram
        read(5,*) dmin,dmax,ddiv,dreso,yl
        read(5,*) smin,smax,sdiv,sreso,xl
        read(5,*) rmin,rmax,rdiv,rl
        write(6,*)
        write(6,*) 'MINIMUM OF DEPTH =',dmin
        write(6,*) 'MAXIMUM OF DEPTH =',dmax
        write(6,*) 'LABEL INT. OF DEPTH =',ddiv
        write(6,*) 'RESOLUTION FOR DEPTH =',dreso
        write(6,*) 'MINIMUM OF VELOCITY =',smin
        write(6,*) 'MAXIMUM OF VELOCITY =',smax
        write(6,*) 'LABEL INT. OF VELOCITY =',sdiv
        write(6,*) 'RESOLUTION FOR VELOCITY =',sreso
c
c                                               Depth(y)-axis
        dfac=(dmax-dmin)/yl
        nd=int((dmax-dmin)/dreso)+1
c                                               Velocity(x)-axis
        sfac=(smax-smin)/xl
        nv=int((smax-smin)/sreso)+1
c                                               Vp/Vs ratio
        rfac=(rmax-rmin)/rl
c
        open(25,file='text',status='old',err=200)
        read(25,fmt='(a72)')title
        close(25)
 200    continue
        lt=lofw(title)
        write(kname,'("MODEL: ",a)') title(1:lt)
        call symbol(3.,1.5,0.42,kname,0.,20)
c
c                                               Best k-models to be selected
c                                               
        read(5,*) kbest
        if(kbest.gt.ntot)kbest = ntot

        if(plottruemodel)then
c
c                                               Read in true model
        read(10,*) nlayer_true
        do i=1,nlayer_true
          read(10,'(3x,4f7.2)') 
     &      true_thickness(i),true_velocity_1(i),true_velocity_2(i),
     &      true_vpvs_ratio(i)
        end do

        end if
c
c                                               Read in number of layers
c                                               from parameterisation file
        read(11,*) nlayer
c                                               Reset counter
        do id=1,maxdgrid
          do iv=1,maxvgrid
            kosu1(id,iv)=0
            kosu2(id,iv)=0
          end do
        end do
c                                               Read in a figure label
c                                               (if file exists)
c
c       open(25,file='text',status='old',err=100)
c       read(25,fmt='(a72)')string
c       close(25)
c       call typstr(xs,ys,sizl,string,0.,72)
c100    continue

        if(plotallmodels)then

        write(6,*)
        write(6,*) '* No. of best models =',kbest
        write(6,*)
        write(6,*) '*** Now reading all models ***'
c
        itp=0
        mfitmin = 100000000.
        npop = npop1
c
        do it=0,nit
c                                               Read the models
c
          read(12,'(a)') str
c
          do ip=1,npop
c
            itp=itp+1
c
            read(12,'(30x,f10.5)') misfitval(itp)
            if(misfitval(itp).le.mfitmin)then
               mfitmin = misfitval(itp)
               modmin = itp
            end if
c
            do i=1,nlayer
               read(12,'(8x,4f10.3)') thickness(i,itp),
     &            velocity_1(i,itp), velocity_2(i,itp), 
     &            vpvs_ratio(i,itp)
            end do
c
          end do
          npop = npop2
c
        end do
c
        ntotalpop=itp
c                                               write lowest 
c                                               misfit on plot

        write(string,fmt='("Misfit = ",f6.3)')mfitmin
        call symbol(10.0,3.5,0.42,string,0.,15)

        end if

        if(plotallmodels)then
c
c                                               Sort the array misfitval 
c                                               to ascending order
        write(6,*)
        write(6,*) '* Now sorting all models...'
        call indexx(ntotalpop,misfitval,index)
c
c                                               Transform all models
c                                               GA -> QLAYER
        write(6,*)
        write(6,*) '* Now transform all models: GA -> QLAYER'
        call model_transform(
     &          nlayer, thickness, velocity_1, velocity_2, vpvs_ratio, 
     &          ntotalpop, speed, vpvs, d, nsublayer, dmax )
c
c                                               Count models in cell
c       write(6,*)
c       write(6,*) '* Now count models ...'
        call count_model(
     &          nsublayer, speed, d, ntotalpop, index, kbest,
     &          kosu1, kosu2, dmin, dreso, nd, smin, sreso )
c
c                                               Draw models
        write(6,*)
        write(6,*) '* Now draw models ...'

        if(colour)then

        call color_model(
     &          kosu1, kosu2, dmin, ddiv, dreso, nd,
     &          smin, sdiv, sreso, nv, dfac, sfac )

        else

        call gray_model(
     &          kosu1, kosu2, dmin, ddiv, dreso, nd, 
     &          smin, sdiv, sreso, nv, dfac, sfac )

        end if

        boundaries = .true.
        if(boundaries)then

c                                               Draw upper most and lower most
c                                               bounds sampled in population
        call draw_sample_bounds(
     &          nsublayer, ntotalpop, 
     &          d, dmin, dmax, ddiv, dreso, dfac, nd, 
     &          speed, smin, sdiv, sfac,
     &          rmin, rdiv, rfac)

        end if
c
c                                               Draw true model
        if(plottruemodel)then

        write(*,fmt='(/" Plotting true model"/)')
        ipen_true = 1
        if(colour)ipen_true = 3
c       if(.not.colour) call penw(0.03)

        call draw_true_model(
     &          nlayer_true,true_thickness, true_velocity_1, 
     &          true_velocity_2, true_vpvs_ratio, 
     &          dmin, dmax, ddiv, dfac, smin, sdiv, sfac, 
     &          rmin, rdiv, rfac, ipen_true, colour)

        end if
c
c
c                                               Draw best and mean model
        if(plotavemodel.or.plotbestmodel)then

        write(6,*)
        write(6,*) '* Now draw the best (averaged) model ...'
        call draw_best_model(
     &          nsublayer, ntotalpop, index, ntotalpop, misfitval, 
     &          d, dmin, dmax, ddiv, dreso, dfac, nd, 
     &          speed, smin, sdiv, sfac, speed_mean, speed_sd, 
     &          vpvs, rmin, rdiv, rfac, vpvs_mean, vpvs_sd,  
     &          plotbestmodel, plotavemodel, colour, dir)
        write(6,*)
        write(6,*) '* Finished drawing best (averaged) model ...'
        write(6,*)
        write(6,*)' Created Postscript plot file : ',psname(1:lw+3)
        write(6,*)
c
c
c                                               Output mean model
        write(21,'(a4)') stc
        write(21,'(i5)') nd
        do i=1,nd
          write(21,'(4g15.6)') speed_mean(i), speed_sd(i),
     &                         vpvs_mean(i), vpvs_sd(i)
        end do

        end if
        close(21)

        end if
c                                               Frame of figure
        call penw(0.05)
        call newpen(1)
        call dashln(0)
        call plot(0.,yl,3)
        call plot(0.,0.,2)
        call plot(xl,0.,2)
        call plot(xl,yl,2)
c       call newpen(3)
        call plot(0.,yl,3)
        call plot(xl,yl,2)
c       call newpen(1)
c
c                                               y-axis(depth)
        ticlen1=0.2
        ticlen2=0.4
c
        ntic=(dmax-dmin)/ddiv
        do i=0,ntic
          dep=dmin+float(i)*ddiv
          y=(dep-dmin)/dfac
          if (i.gt.0 .and. i.lt.ntic) then
             call plot(0.,y,3)
             call plot(ticlen2,y,2)
             call plot(xl,y,3)
             call plot(xl-ticlen2,y,2)
          end if
          write(str,'(f4.1)') dep
          call symbol(-1.2,y-0.1,0.35,str,0.,4)
          if (i.lt.ntic) then
             do j=1,4
               dep=dep+ddiv/5.
               y=(dep-dmin)/dfac
               call plot(0.,y,3)
               call plot(ticlen1,y,2)
               call plot(xl,y,3)
               call plot(xl-ticlen1,y,2)
             end do
          end if
        end do
        call symbol(-2.,-7.,0.42,'DEPTH (km)',-90.,10)
c
c                                                       x-axis(speed)
        ntic=(smax-smin)/sdiv
        do i=0,ntic
          spe=smin+float(i)*sdiv
          x=(spe-smin)/sfac
          if (i.gt.0 .and. i.lt.ntic) then
             call plot(x,0.,3)
             call plot(x,-ticlen2,2)
          end if
          write(str,'(f4.1)') spe
          call symbol(x-0.4,0.1,0.35,str,0.,4)
          if (i.lt.ntic) then
             do j=1,4
               spe=spe+sdiv/5.
               x=(spe-smin)/sfac
               call plot(x,0.,3)
               call plot(x,-ticlen1,2)
             end do
          end if
        end do
        call symbol(3.5,0.7,0.42,'S VELOCITY (km/s)',0.,17)
c
c                                                       x-axis(Vp/Vs)
        if(colour)then

c       call newpen(3)
        ntic=(rmax-rmin)/rdiv
        do i=0,ntic
          rat=rmin+float(i)*rdiv
          x=(rat-rmin)/rfac
          if (i.gt.0 .and. i.lt.ntic) then
             call plot(x,yl,3)
             call plot(x,yl+ticlen2,2)
          end if
          write(str,'(f3.1)') rat
          call symbol(x-0.34,yl-0.5,0.35,str,0.,3)
          if (i.lt.ntic) then
             do j=1,4
               rat=rat+rdiv/5.
               x=(rat-rmin)/rfac
               call plot(x,yl,3)
               call plot(x,yl+ticlen1,2)
             end do
          end if
        end do
        call symbol(4.5,yl-1.2,0.42,'Vp/Vs RATIO',0.,11)

        end if
c
c                                                       Close files
        call plote(8)
        close(11)
c
        stop
c
        end
c
        subroutine model_transform(
     &          nlayer, thickness, velocity_1, velocity_2, vpvs_ratio, 
     &          ntotalpop, speed, vpvs, d, nsublayer, dmax )
c

        include 'plot_model.inc'

        real*4          thickness(maxlayer,maxtotalpop),
     &                  velocity_1(maxlayer,maxtotalpop),
     &                  velocity_2(maxlayer,maxtotalpop),
     &                  vpvs_ratio(maxlayer,maxtotalpop),
     &                  speed(maxsublayer,maxtotalpop),
     &                  vpvs(maxsublayer,maxtotalpop),
     &                  d(0:maxsublayer,maxtotalpop)
c
        integer         nsublayer(maxtotalpop)
c
c                                                  Loop on all models
        do imod=1,ntotalpop
c
c                                                  GA_model -> QLAYER model
          k=0
          d(0,imod)=0.
          do i=1,nlayer
            thick=thickness(i,imod)
            if (thick.gt.0.0) then
               v1=velocity_1(i,imod)
               v2=velocity_2(i,imod)
               gr=(v2-v1)/thick
               nsub=int(thick/2.)+1
               dh=thick/float(nsub)
               do j=1,nsub
                 k=k+1
                 d(k,imod)=d(k-1,imod)+dh
                 vpvs(k,imod)=vpvs_ratio(i,imod)
                 speed(k,imod)=v1+gr*dh*float(j-1)
               end do
            end if
          end do
c
c       *** semi-infinite layer ***
c
          k=k+1
          if (d(k-1,imod).le.dmax) then
             d(k,imod)=dmax
          else
             d(k,imod)=d(k-1,imod)
          end if
          speed(k,imod)=speed(k-1,imod)
          vpvs(k,imod)=vpvs(k-1,imod)
c
          nsublayer(imod)=k
c
        end do
c
        return
        end
c
        subroutine count_model(
     &          nsublayer, speed, d, ntotalpop, index, kbest, 
     &          kosu1, kosu2, dmin, dreso, nd, smin, sreso )
c
        include 'plot_model.inc'

        real*4          speed(maxsublayer,maxtotalpop),
     &                  d(0:maxsublayer,maxtotalpop)
c
        integer         kosu1(maxdgrid,maxvgrid),
     &                  kosu2(maxdgrid,maxvgrid),
     &                  index(maxtotalpop),
     &                  nsublayer(maxtotalpop)
c
c
c                                               Count models
        do imod=1,ntotalpop
c
          jmod=index(imod)
c
          do k=1,nsublayer(jmod)
c                                               Count vertical lines
            id1=int((d(k-1,jmod)-dmin)/dreso)+1
            if (id1.gt.nd) go to 10
            id2=int((d(k,jmod)-dmin)/dreso)+1
            if (id2.gt.nd) id2=nd
            iv=int((speed(k,jmod)-smin)/sreso)+1
            do id=id1,id2
              if (imod.le.kbest) kosu1(id,iv)=kosu1(id,iv)+1
              kosu2(id,iv)=kosu2(id,iv)+1
            end do
   10       continue
c                                               Count horizontal lines
            if (k.ge.2) then
               iv1=int((speed(k-1,jmod)-smin)/sreso)+1
               iv2=int((speed(k,jmod)-smin)/sreso)+1
               id=int((d(k-1,jmod)-dmin)/dreso)+1
               if (id.gt.nd) go to 20
               if (iv1.lt.iv2) then
                  do iv=iv1+1,iv2-1
                    if (imod.le.kbest) kosu1(id,iv)=kosu1(id,iv)+1
                    kosu2(id,iv)=kosu2(id,iv)+1
                  end do
               else if (iv1.gt.iv2) then
                  do iv=iv2+1,iv1-1
                    if (imod.le.kbest) kosu1(id,iv)=kosu1(id,iv)+1
                    kosu2(id,iv)=kosu2(id,iv)+1
                  end do
               else
                  if (imod.le.kbest) kosu1(id,iv)=kosu1(id,iv)-1
                  kosu2(id,iv)=kosu2(id,iv)-1
               end if
            end if
c
          end do
   20     continue
c
        end do
c
        return
        end
c
        subroutine gray_model(
     &          kosu1, kosu2, dmin, ddiv, dreso, nd, 
     &          smin, sdiv, sreso, nv, dfac, sfac )
c
        parameter       (maxvgrid=500,
     &                   maxdgrid=700
     &                  )
c
        integer kosu1(maxdgrid,maxvgrid),
     &          kosu2(maxdgrid,maxvgrid)
c
        character str*80
c
c                                               Maximum of kosu1
        ksmax=0.
        do id=1,nd
          do iv=1,nv
            ksmax=max0(ksmax,kosu1(id,iv))
          end do
        end do
c
        write(6,*) '  ** ksmax=',ksmax
c
c                                               Draw color diagram
        alogmax=alog10(float(ksmax))
        logmax=int(alogmax+0.5)
        alogmax=float(logmax)
        write(6,*) '  ** alogmax=',alogmax
c
        ksmin=10
        ksmin=1
        alogmin=alog10(float(ksmin))
c
        ddx=sreso/sfac
        ddy=-dreso/dfac
        call cellsize(ddx,ddy)
c
        do id=1,nd
          dep=dmin+float(id-1)*dreso
          yy=(dep-dmin)/dfac
          do iv=1,nv
            spe=smin+float(iv-1)*sreso
            xx=(spe-smin)/sfac
            if (kosu1(id,iv).ge.1) then
               alogkosu=alog10(float(kosu1(id,iv)))
            else
               alogkosu=-1.
            end if
            if (alogkosu.ge.alogmax) then
               gray=0.3
               gray=0.05
               call fcellg(xx,yy,ddx,ddy,gray)
            else if (alogkosu.ge.alogmin) then
               gray=-0.5*(alogkosu-alogmin)/(alogmax-alogmin)+0.8
               gray=-0.85*(alogkosu-alogmin)/(alogmax-alogmin)+0.9 
               call fcellg(xx,yy,ddx,ddy,gray)
c              write(100,*)alogmin,alogmax,alogkosu,gray
            else if (alogkosu.ge.0.) then
               gray=0.8
               gray=0.9
               call fcellg(xx,yy,ddx,ddy,gray)
            else if (kosu2(id,iv).ge.1) then
c              gray=0.85
c              call fcellg(xx,yy,ddx,ddy,gray)
c              col=0.10
c              call fcell(xx,yy,ddx,ddy,col)
            end if

          end do
        end do
c
c                                               Draw color-scale bar
c
        ddx=0.1
        ddy=0.5
        call cellsize(ddx,ddy)
c
        xbar0=3.5
        barlen=4.5
        nbarcell=int(barlen/ddx)+1
        bfac=alogmax/barlen
        by=-17.0
        do i=1,nbarcell
          alogkosu=ddx*float(i-1)*bfac
          bx=xbar0+float(i-1)*ddx
          if (alogkosu.ge.alogmin) then
             gray=-0.5*(alogkosu-alogmin)/(alogmax-alogmin)+0.8
             call fcellg(bx,by,ddx,ddy,gray)
          else
             gray=0.8
             call fcellg(bx,by,ddx,ddy,gray)
          end if
        end do
c
        call newpen(1)
        call penw(0.03)
c        xbar1=xbar0+ddx*0.5
        call plot(xbar0,by-ddy*0.5,3)
        call plot(xbar0+barlen,by-ddy*0.5,2)
        call plot(xbar0+barlen,by+ddy*0.5,2)
        call plot(xbar0,by+ddy*0.5,2)
        call plot(xbar0,by-ddy*0.5,2)
c
        call symbol(xbar0+0.5,by+1.5,0.28,'NO. OF MODELS',0.,13)
        call symbol(xbar0+0.3,by+1.0,0.28,'OF THE BEST 1000',0.,16)
        delx=barlen/float(logmax)
        call penw(0.03)
        do i=0,logmax
          xx=xbar0+float(i)*delx
          write(str,'(i4)') 10**i
          call symbol(xx-0.5,by+0.5,0.28,str,0.,4)
          call plot(xx,by+0.25,3)
          call plot(xx,by+0.45,2)
        end do
c
        return
        end
c
c                                       Changed by MS 28/7/97
c                                       to calculate and plot 
c                                       vpvs_best rather than vpvs_mean
c
        subroutine draw_best_model(
     &          nsublayer, ntotalpop, index, kbest, misfitval, 
     &          d, dmin, dmax, ddiv, dreso, dfac, nd, 
     &          speed, smin, sdiv, sfac, speed_mean, speed_sd, 
     &          vpvs, rmin, rdiv, rfac, vpvs_mean, vpvs_sd ,
     &          plotbestmodel, plotavemodel, colour, dir)
c
        include 'plot_model.inc'

        real*4          speed(maxsublayer,maxtotalpop),
     &                  vpvs(maxsublayer,maxtotalpop),
     &                  d(0:maxsublayer,maxtotalpop),
     &                  misfitval(maxtotalpop),
     &                  vel(maxtotalpop),
     &                  vps(maxtotalpop),
     &                  wt(maxtotalpop),
     &                  speed_best(maxdgrid),
     &                  speed_mean(maxdgrid),
     &                  speed_sd(maxdgrid),
     &                  vpvs_best(maxdgrid),
     &                  vpvs_mean(maxdgrid),
     &                  vpvs_sd(maxdgrid)
c
        integer         index(maxtotalpop),
     &                  nsublayer(maxtotalpop)

        logical         plotbestmodel, plotavemodel, colour

        character       dir*2
c
c                                               The best velocity model
        do id=1,nd
c
          depth=dmin+(id-1)*dreso
c
          ssum=0.
          rsum=0.
          wsum=0.
          do imod=1,kbest
c
            jmod=index(imod)
c
            do i=1,nsublayer(jmod)
              if (depth.ge.d(i-1,jmod) .and. depth.lt.d(i,jmod)) then 
                 idep=i
                 go to 10
              end if
            end do
   10       continue
c
            if (imod.eq.1) speed_best(id)=speed(idep,jmod)
            if (imod.eq.1) vpvs_best(id)=vpvs(idep,jmod)
c
            wt(imod)=1./misfitval(jmod)
            wsum=wsum+wt(imod)
            vel(imod)=speed(idep,jmod)
            ssum=ssum+vel(imod)*wt(imod)
            vps(imod)=vpvs(idep,jmod)
            rsum=rsum+vps(imod)*wt(imod)
c
          end do
c
          speed_mean(id)=ssum/wsum
          vpvs_mean(id)=rsum/wsum
c
          ssum=0.
          rsum=0.
          wsum=0.
          do imod=1,kbest
            wsum=wsum+wt(imod)**2
            ssum=ssum+(wt(imod)*(vel(imod)-speed_mean(id)))**2
            rsum=rsum+(wt(imod)*(vps(imod)-vpvs_mean(id)))**2
          end do
c
          speed_sd(id)=sqrt(ssum/wsum)
          vpvs_sd(id)=sqrt(rsum/wsum)
c
        end do
c
        pw=0.05
        ipen=10
        ipen=1
        if(colour)ipen = 2
        ldash=0
c                                               draw best vpvs model

        if(plotbestmodel.and.colour) call draw_model(
     &          pw, ipen, ldash, nd, dreso, vpvs_best, 
     &          dmin, ddiv, rmin, rdiv, dfac, rfac )
c
c                                               draw mean vpvs model
c       if(plotavemodel) call draw_model(
c     &         pw, ipen, ldash, nd, dreso, vpvs_mean, 
c     &         dmin, ddiv, rmin, rdiv, dfac, rfac )
c
        ipen=1
        ipen=8
        if(colour)ipen = 2
        ldash=0
c                                               draw best velocity model
        if(plotbestmodel) then
          if(dir.eq.'GA')then
             pw=0.10
             ipen=1
             call draw_model(
     &            pw, ipen, ldash, nd, dreso, speed_best, 
     &            dmin, ddiv, smin, sdiv, dfac, sfac )
             pw=0.05
             ipen=8
             call draw_model(
     &            pw, ipen, ldash, nd, dreso, speed_best, 
     &            dmin, ddiv, smin, sdiv, dfac, sfac )
          else
             call draw_model(
     &            pw, ipen, ldash, nd, dreso, speed_best, 
     &            dmin, ddiv, smin, sdiv, dfac, sfac )
          end if
        end if
c
        ipen=8
        ldash=0
c                                               draw mean velocity model
        if(plotavemodel) call draw_model(
     &          pw, ipen, ldash, nd, dreso, speed_mean, 
     &          dmin, ddiv, smin, sdiv, dfac, sfac )
c
        return
        end
c
        subroutine draw_true_model(
     &          nlayer,thickness, velocity_1, 
     &          velocity_2, vpvs_ratio, 
     &          dmin, dmax, ddiv, dfac, 
     &          smin, sdiv, sfac, 
     &          rmin, rdiv, rfac,
     &          ipen_in, colour )
c
        parameter ( maxlayer = 15, 
     &              maxsublayer = 100 )
c
        real*4 thickness(maxlayer),
     &         velocity_1(maxlayer),
     &         velocity_2(maxlayer),
     &         vpvs_ratio(maxlayer),
     &         speed(maxsublayer),
     &         vpvs(maxsublayer),
     &         d(0:maxsublayer)

        logical colour
c                                                  GA_model -> QLAYER model
        k=0
        d(0)=0.
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
               d(k)=d(k-1)+dh
               speed(k)=v1+gr*dh*float(j-1)
               vpvs(k)=vpvs_ratio(i)
             end do
          end if
        end do
c
c       *** semi-infinite layer ***
c
        k=k+1
        if (d(k-1).le.dmax) then
           d(k)=dmax
        else
           d(k)=d(k-1)
        end if
        speed(k)=speed(k-1)
        vpvs(k)=vpvs(k-1)
c
        nsublayer=k
c
        pw=0.05
        ipen=10
        ipen=3
        ipen = ipen_in
        ldash=2
        ldash=0
        if(colour)call draw_model_2(
     &          pw, ipen, ldash, nsublayer, vpvs, d, 
     &          dmin, ddiv, rmin, rdiv, dfac, rfac )
c
        pw=0.05
        ipen=0
        ipen=3
        ldash=4
        ldash=0
        ipen = ipen_in
        call draw_model_2(
     &          pw, ipen, ldash, nsublayer, speed, d, 
     &          dmin, ddiv, smin, sdiv, dfac, sfac )
c
        return
        end
c
        subroutine draw_model(
     &          pw, ipen, ldash, nd, dreso, velocity, 
     &          dmin, ddiv, vmin, vdiv, dfac, vfac )
c
        parameter       (maxdgrid=700) 
c
        real*4          velocity(maxdgrid)
c
c
        call penw(pw)
        call newpen(ipen)
        call dashln(ldash)
c
c                                                 Draw best model
        depth=dmin
        y=(depth-dmin)/dfac
        x=(velocity(1)-vmin)/vfac
        call plot(x,y,3)
c
        do i=2,nd
          depth=dmin+float(i-1)*dreso
          y=(depth-dmin)/dfac
          call plot(x,y,2)
          x=(velocity(i)-vmin)/vfac
          call plot(x,y,2)
        end do
c
        return
        end
c
        subroutine draw_model_2(
     &          pw, ipen, ldash, nsublayer, velocity, d, 
     &          dmin, ddiv, vmin, vdiv, dfac, vfac )
c
        parameter       (maxsublayer=100) 
c
        real*4          velocity(maxsublayer),
     &                  d(0:maxsublayer)
c
c
        call penw(pw)
        call newpen(ipen)
        call dashln(ldash)
c
c                                                 Draw best model
        depth=dmin
        y=(depth-dmin)/dfac
        x=(velocity(1)-vmin)/vfac
        call plot(x,y,3)
c
        do i=1,nsublayer-1
          y=(d(i)-dmin)/dfac
          call plot(x,y,2)
          x=(velocity(i+1)-vmin)/vfac
          call plot(x,y,2)
        end do
c
        y=(d(nsublayer)-dmin)/dfac
        call plot(x,y,2)
c
        return
        end
c
        subroutine color_model(
     &          kosu1, kosu2, dmin, ddiv, dreso, nd, 
     &          smin, sdiv, sreso, nv, dfac, sfac )
c
        parameter       (maxvgrid=500,
     &                   maxdgrid=700
     &                  )
c
        integer kosu1(maxdgrid,maxvgrid),
     &          kosu2(maxdgrid,maxvgrid)
c
        character str*80
c
c                                               Maximum of kosu1
        ksmax=kosu1(1,1)
        do id=1,nd
          do iv=1,nv
            ksmax=max0(ksmax,kosu1(id,iv))
          end do
        end do
c
        write(6,*) '  ** ksmax=',ksmax
c
c                                               Draw color diagram
        alogmax=alog10(float(ksmax))
        logmax=int(alogmax+0.5)
        alogmax=float(logmax)
c       write(6,*) '  ** alogmax=',alogmax
c
        ksmin=10
        ksmin=1
        alogmin=alog10(float(ksmin))
c       write(6,*) '  ** alogmin=',alogmin
c
        ddx=sreso/sfac
        ddy=-dreso/dfac
        call cellsize(ddx,ddy)
c
        do id=1,nd
          dep=dmin+float(id-1)*dreso
          yy=(dep-dmin)/dfac
          do iv=1,nv
            spe=smin+float(iv-1)*sreso
            xx=(spe-smin)/sfac
            if (kosu1(id,iv).ge.1) then
               alogkosu=alog10(float(kosu1(id,iv)))
            else
               alogkosu=-1.
            end if
            if (alogkosu.ge.alogmax) then
               col=0.333
               call fcell(xx,yy,ddx,ddy,col)
            else if (alogkosu.ge.alogmin) then
               col=0.166*(alogkosu-alogmin)/(alogmax-alogmin)+0.167
               call fcell(xx,yy,ddx,ddy,col)
            else if (alogkosu.ge.0.) then
               col=0.167
               call fcell(xx,yy,ddx,ddy,col)
            else if (kosu2(id,iv).ge.1) then
               gray=0.90
               gray=0.75
               call fcellg(xx,yy,ddx,ddy,gray)
            end if

          end do
        end do
c
c                                               Draw color-scale bar
c
        ddx=0.1
        ddy=0.5
        call cellsize(ddx,ddy)
c
        xbar0=3.5
        barlen=4.5
        nbarcell=int(barlen/ddx)+1
        bfac=alogmax/barlen
        by=-17.0
        do i=1,nbarcell
          alogkosu=ddx*float(i-1)*bfac
          bx=xbar0+float(i-1)*ddx
          if (alogkosu.ge.alogmin) then
             col=0.166*(alogkosu-alogmin)/(alogmax-alogmin)+0.167
             call fcell(bx,by,ddx,ddy,col)
          else
             col=0.167
             call fcell(bx,by,ddx,ddy,col)
          end if
        end do
c
        call newpen(1)
        call penw(0.03)
c        xbar1=xbar0+ddx*0.5
        call plot(xbar0,by-ddy*0.5,3)
        call plot(xbar0+barlen,by-ddy*0.5,2)
        call plot(xbar0+barlen,by+ddy*0.5,2)
        call plot(xbar0,by+ddy*0.5,2)
        call plot(xbar0,by-ddy*0.5,2)
c
        call symbol(xbar0+0.5,by+1.5,0.28,'NO. OF MODELS',0.,13)
        call symbol(xbar0+0.3,by+1.0,0.28,'OF THE BEST 1000',0.,16)
        delx=barlen/float(logmax)
        call penw(0.03)
        do i=0,logmax
          xx=xbar0+float(i)*delx
          write(str,'(i4)') 10**i
          call symbol(xx-0.5,by+0.5,0.28,str,0.,4)
          call plot(xx,by+0.25,3)
          call plot(xx,by+0.45,2)
        end do
c
        return
        end
c
c                                       find and draw maximum and minimum
c                                       bounds on each model.
        subroutine draw_sample_bounds(
     &          nsublayer, ntotalpop, 
     &          d, dmin, dmax, ddiv, dreso, dfac, nd, 
     &          speed, smin, sdiv, sfac,
     &          rmin, rdiv, rfac)
c
        include 'plot_model.inc'

        real*4          speed(maxsublayer,maxtotalpop),
     &                  d(0:maxsublayer,maxtotalpop),
     &                  speedmin(maxdgrid),
     &                  speedmax(maxdgrid)
c
        integer         nsublayer(maxtotalpop)

        COMMON/P00000/LPLOT,A,B,C,D2,ASP,THET

        write(lplot,fmt='("% start draw_sample_model")')

c       write(*,*)' nd = ',nd
c
c                                               The best velocity model
        do id=1,nd
c
          depth=dmin+(id-1)*dreso
c
          speedmax(id) = -1000.
          speedmin(id) = 1000.
          do jmod=1,ntotalpop
c
c           jmod=index(imod)
c
            do i=1,nsublayer(jmod)
              if (depth.ge.d(i-1,jmod) .and. depth.lt.d(i,jmod)) then 
                 idep=i
                 go to 10
              end if
            end do
   10       continue
c
            speedmax(id)= max(speedmax(id),speed(idep,jmod))
            speedmin(id)= min(speedmin(id),speed(idep,jmod))
c
          end do
c         write(*,*)id,' min ',speedmin(id)
c         write(*,*)id,' max ',speedmax(id)
c
        end do
c
        pw=0.03
        ipen=10
        ipen=1
        ldash=0
c                                               draw min bound 
        call draw_model(
     &          pw, ipen, ldash, nd, dreso, speedmin, 
     &          dmin, ddiv, smin, sdiv, dfac, sfac )
c
        ipen=1
        ldash=0
c                                               draw max bound 
        call draw_model(
     &          pw, ipen, ldash, nd, dreso, speedmax, 
     &          dmin, ddiv, smin, sdiv, dfac, sfac )
c
        return
        end
