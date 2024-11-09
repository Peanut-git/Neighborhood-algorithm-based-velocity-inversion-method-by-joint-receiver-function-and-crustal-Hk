c compile with make plot_rf-x or plot_rf-x; run with plot_rf-x_run script
c----------------------------------------------------------------------
c
c       Program to plot Receiver Functions read in in SAC format.
c
c                                               M. Sambridge
c                                               February 1997
c----------------------------------------------------------------------
c
        Program plot_rf

c
        parameter       (maxmodint = 9,
     &                   maxlenstr = 500,
     &                   maxpopsize = 100)

        include 'rfi_param.inc'

        include '../../na_param.inc'

c
        character*72    xstr,ystr,tstr,string
c
c                                               Set up all dimensions for 
c                                               arrays used by NA routines
c
        real*4          misfitval
c
c       real*8          rmodel(max_moddim)

        real*4          ranges(2,maxmoddim),
     &                  rangest(2,maxmoddim),
     &                  scales(maxmoddim+1)

        logical         verbose,
     &                  restart
c
c                                               Set dimensions for 
c                                               arrays used by narfi
c
c       real*8          amodel(maxmoddim,10)
c       real*4          omodel(maxmoddim)
c       real*4          cmodel(maxmoddim)
c
        real*4          observed_data(maxdata,maxwave),
     &                  predicted_data(maxdata,maxwave),
     &                  incident_angle(maxwave),
     &                  constant_a(maxwave),
     &                  constant_c(maxwave),
     &                  layeridx(maxwave),
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
     &                  time_shift(maxwave),
     &                  weight(maxwave),
     &                  time_begin(maxwave),
     &                  time_end(maxwave),
     &                  q_alpha(maxlayer),
     &                  q_beta(maxlayer)
c
        integer         ndata(maxwave)
c
        character*40    chars,
     &                  kname,
     &                  fname(maxwave)

        character*2     twochars

        logical         calcm
        logical         printm
        logical         GAdir
c                                               I/O common for NA routines
c
        common /NA_IO/verbose,lu_na,lu_out,lu_sum,lu_det,lu_sob
        common /NA_info/nxsave,ndsave,ndc,nerr,
     &                  cells,ttorder,ttaxis,tna


c
c               Set up logical units 
c                                               LU's for standard input and 
c                                               output
        lu_in  = 5
        lu_out = 6
c
c
c               Set up logical units for Neighbourhood Algorithm files
c 
c                                               LU for output of information
c                                               summarising NA performance. 
        lu_sum = 8
c
c               Set up logical units for rfi files
c
c                                               LU for input of velocity 
c                                               model
        lu_vel = 11
c                                               LU for output of model 
c                                               parameters
        lu_mod = 12

        read(lu_in,fmt='(a2)')twochars
        GAdir = .false.
        if(twochars.eq.'GA')GAdir = .true.
c
c                                               Open rfi files
c
        write(*,*)' Opening files...'
        read(lu_in,'(a)') chars
        lw=lofw(chars)
        if(GAdir)then
           write(kname,'("GA_MDL/",a,a1)') chars(1:lw),char(0)
        else
           write(kname,'("NA_MDL/",a,a1)') chars(1:lw),char(0)
        end if
        write(lu_out,*)
        write(lu_out,*) '* Now open ... ',kname(1:lw+7)
        open(lu_vel,file=kname,status='old')
c
c
c                                               Open summary file
c
        read(lu_in,'(a)') chars
        lw=lofw(chars)
        if(GAdir)then
           write(kname,'("GA_SUM/",a,a1)') chars(1:lw),char(0)
        else
           write(kname,'("NA_SUM/",a,a1)') chars(1:lw),char(0)
        end if
        write(lu_out,*)
        write(lu_out,*) '* Now open ... ',kname(1:lw+7)
        open(lu_sum, file=kname, status='unknown')
c
c                                               Read in velocity model 
c                                               and ranges of the parameters
        call read_vmodelNA
     &       (lu_vel, ranges, scales, moddim, q_alpha, q_beta ) 

        call NA_getrange
     &             (ranges,rangest,scales,moddim,naxis,x,restart)
c
c
c                                               Read in ORFs in SAC format
        read(lu_in,*) nwave
c
c                                               read in observed RF
        do iw=1,nwave
          read(lu_in,'(a)') chars
          lw=lofw(chars)
c         write(fname(iw),'("ORF/",a,a1)') chars(1:lw),char(0)
          if(GAdir)then
             write(fname,'("GA_ORF/",a,a1)') chars(1:lw),char(0)
          else
             write(fname,'("NA_ORF/",a,a1)') chars(1:lw),char(0)
          end if
          write(lu_out,*)
          write(lu_out,*) '* Read in data from ',fname(iw)(1:lw+7)
c
          read(lu_in,*) incident_angle(iw)
          read(lu_in,*) weight(iw)
          read(lu_in,*) time_begin(iw), time_end(iw)
          write(lu_out,*) '* Incident angle =',incident_angle(iw)
          write(lu_out,*) '* Weight =',weight(iw)
          write(lu_out,*) '* Time window =',time_begin(iw),
     &                          ' - ',time_end(iw)
          call readdata(
          call readdata(
     &          fname(iw), ndata(iw),
     &          observed_data(1,iw),
     &          time_begin(iw), time_end(iw), time_shift(iw),
     &          constant_a(iw), constant_c(iw), layeridx(iw),
     &          pstime(iw), pppstime(iw), ppsstime(iw),
     &          hdata(iw), kdata(iw), fs )
c         
         pstime(iw)=-12345.0
         pppstime(iw)=-12345.0
         ppsstime(iw)=-12345.0
         hdata(iw)=-12345.0
         kdata(iw)=-12345.0
c
        end do
c
c
c       write(100,*)' observed data'
c       write(100,*)ndata(1),
c    &              fs,constant_a(1),constant_c(1)
c       write(100,*)(observed_data(i,1),i=1,ndata(1))



c       if(pcalc)then
c                                               calculate predicted RF


c       else
c                                               read in predicted RF
        do iw=1,nwave
          if(GAdir)then
             write(fname,'("GA_SRF/",a,a1)') chars(1:lw),char(0)
          else
             write(fname,'("NA_SRF/",a,a1)') chars(1:lw),char(0)
          end if
          write(lu_out,*)
          write(lu_out,*) '* Read in data from ',fname(iw)(1:lw+7)

          write(lu_out,*) '* Incident angle =',incident_angle(iw)
          write(lu_out,*) '* Weight =',weight(iw)
          write(lu_out,*) '* Time window =',time_begin(iw),
     &                          ' - ',time_end(iw)

          call readdata(
     &          fname(iw), ndata(iw),
     &          predicted_data(1,iw),
     &          time_begin(iw), time_end(iw), time_shift(iw),
     &          constant_a(iw), constant_c(iw), layeridx(iw),
     &          pstime(iw), pppstime(iw), ppsstime(iw),
     &          hdata(iw), kdata(iw), fs )
c         
         pstime(iw)=-12345.0
         pppstime(iw)=-12345.0
         ppsstime(iw)=-12345.0
         hdata(iw)=-12345.0
         kdata(iw)=-12345.0
c
        end do


c       end if

        write(*,*)' finished read_data'
c
c                                               Calculate misfit between
c                                               observed and predicted
c                                               receiver functions
        calcm = .true.
        printm = .true.
        if(calcm)then
c
c
           call calcmisfit(
     &          predicted_data, observed_data, ndata,
     &          weight, pstime, pppstime, ppsstime,
     &          pstimesyn, pppstimesyn, ppsstimesyn,
     &          hdata, hdatasyn, kdata, kdatasyn,
     &          nwave, misfitval )

           write(*,*)' misfit : ',misfitval
        end if
c
c                                               write out
c
c       write(100,*)' predicted data'
c       write(100,*)ndata(1),
c    &              fs,constant_a(1),constant_c(1)
c       write(100,*)(predicted_data(i,1),i=1,ndata(1))
c
c                                               find range in amplitude
        amp_max = observed_data(1,1)
        amp_min = observed_data(1,1)
        do i=1,ndata(1)
           amp_max = max(amp_max,observed_data(i,1))
           amp_min = min(amp_min,observed_data(i,1))
        end do
        write(*,*)' amp_max ',amp_max
        write(*,*)' amp_min ',amp_min
c
c                               Call hplots to initialize plotting
c
        open(30,file='plot_rf.ps',status='unknown')

        iro = -1
        iro = 0

         call xname ('plot-rf',7)
c                                       A3
c       call hplots(1,iro,30,1)
c                                       A4
        call hplots(1,iro,30,0)
c
c ---------------------------- Start plotting -------------------------
c
c       Read in colour table (if required)
c
        open(20,file='PS_utl/pal.in',status='unknown')
        call ldcolr(20)
c
c       Read input command and data files
c
        call typset(0.0,0.0)
c       call zpick(3,0,0)
        call zpick(0,0,0)
c
        call pen(1,0)
c                                               read frame parameters
c                                               in from file
        open(25,file='PS_utl/frame.in',status='old')
        read(25,*)
        read(25,*)
        read(25,*)
        read(25,*)x0
        read(25,*)y0
        read(25,*)xasl
        read(25,*)yasl
        read(25,*)xticl
        read(25,*)yticl
        read(25,*)nxdec
        read(25,*)nydec
        read(25,*)nxsub
        read(25,*)nysub
        read(25,*)fx0
        read(25,*)fy0
        read(25,*)dfx
        read(25,*)dfy
        read(25,*)sizl
        read(25,*)sizt
        read(25,*)ipen1
        read(25,*)ipen2
        read(25,*)ipen3
        read(25,fmt='(a24)')xstr
        read(25,fmt='(a24)')ystr
        read(25,fmt='(a50)')tstr
        close(25)

        if(fx0.eq.-999.0)fx0  = time_begin(1)
        if(fy0.eq.-999.0)fy0  = amp_min - 0.05*(amp_max - amp_min)
        if(dfx.eq.-999.0)dfx = (time_end(1) - time_begin(1))*xticl/xasl
        if(dfy.eq.-999.0)dfy = (amp_max - amp_min)*1.1*yticl/yasl

        xmin = x0
        ymin = y0
        xmax = x0+xasl
        ymax = y0+yasl
c
c                                               draw frame
c
        call framer(x0,y0,xasl,yasl,
     &             fx0,xticl,dfx,nxsub,nxdec,
     &             fy0,yticl,dfy,nysub,nydec,
     &             xstr,ystr,tstr,sizl,sizt,ipen1,ipen2,ipen3)
c
c                                               plot observed receiver function
        ipenl = 2
        ipenl = 2
        ipenl = 27
        ldash = 1
c       call dashln(ldash,0)
        delt = 1./fs
        call pen(ipenl,0)
        iup = 3
        xval = time_begin(1) 
        yval = observed_data(1,1)
        xcm = x0 + (xval -fx0)*xticl/dfx
        ycm = y0 + (yval -fy0)*yticl/dfy
        if(xcm.ge.xmin.and.xcm.le.xmax.and.
     &     ycm.ge.ymin.and.ycm.le.ymax)then
           call plot(xcm,ycm,iup)
           iup=2
        end if
        do i=2,ndata(1)
           xval = time_begin(1) + (i-1)*delt
           yval = observed_data(i,1)
           xcm = x0 + (xval -fx0)*xticl/dfx 
           ycm = y0 + (yval -fy0)*yticl/dfy 
           if(xcm.ge.xmin.and.xcm.le.xmax.and.
     &        ycm.ge.ymin.and.ycm.le.ymax)then
              call plot(xcm,ycm,iup)
c             write(101,*)xcm,ycm
              iup=2
           end if
        end do
        call dashln(-1,0)
c                                       plot predicted receiver function
        call pen(4,0)
        call pen(1,0)
        iup = 3
        xval = time_begin(1) 
        yval = predicted_data(1,1)
        xcm = x0 + (xval -fx0)*xticl/dfx
        ycm = y0 + (yval -fy0)*yticl/dfy
        if(xcm.ge.xmin.and.xcm.le.xmax.and.
     &     ycm.ge.ymin.and.ycm.le.ymax)then
           call plot(xcm,ycm,iup)
           iup=2
        end if
        do i=2,ndata(1)
           xval = time_begin(1) + (i-1)*delt
           yval = predicted_data(i,1)
           xcm = x0 + (xval -fx0)*xticl/dfx 
           ycm = y0 + (yval -fy0)*yticl/dfy 
           if(xcm.ge.xmin.and.xcm.le.xmax.and.
     &        ycm.ge.ymin.and.ycm.le.ymax)then
              call plot(xcm,ycm,iup)
c             write(101,*)xcm,ycm
              iup=2
           end if
        end do

        if(calcm.or.printm)then
           call pen(1,0)
           xs = x0 + xasl*0.7
           ys = y0 + yasl*0.80
           write(string,fmt='("Misfit = ",f5.3)')misfitval
           write(*,*)' string'
           write(*,fmt='(a72)')string
           call typstr(xs,ys,sizl,string,0.,72)
           open(25,file='text',status='old',err=100)
           read(25,fmt='(a72)')string
           xs = x0 + xasl*0.7
           ys = y0 + yasl*0.70
           call typstr(xs,ys,sizl,string,0.,72)
           close(25)
 100       continue
        end if
c
c ---------------------------- Stop plotting -------------------------
c
c       Call hplots to terminate plotting
c
        call hplots (0,0,0,0)

        write(*,*)
        write(*,*)' Created plot file plot_rf.ps'
        write(*,*)
c
        stop                                                       
        end
c
C===================================================================
C
      SUBROUTINE framer
     &           (X0,Y0,XASL,YASL,FX0,XTICL,DFX,NXSUB,NXDEC,FY0,
     &            YTICL,DFY,NYSUB,NYDEC,xstr,ystr,tstr,sizl,sizt,
     &            ipen1,ipen2,ipen3)
C
c
C     This subroutine draws a frame
C     Parameters:
C     X0,Y0 = coordinates of lower left corner (cm)
C     XASL,YASL length of x- and y-axis (cm)
C     FX0,FY0 = functional values at lower left corner
C     XTICL,YTICL = distance (cm) between large tics
C     DFX,DFY = step in function values between two large tics
C     NXSUB,NYSUB = number of subdivisions with small tics between any two
C                   large tics
C     NXDEC,NYDEC = number of decimals in large tic labels (set -1 for integer)
C     ITX(18),ITY(18)= text for x and y axis respectively (centered at char 18
C     ITT(18)= title text (max 72 char, start at ITT(1), unlike ITX,ITY)
C     sizl = labelsize in cm
C     sizt = textletter size in cm
C     ipen1 frame-box pen     
C     ipen2 tics and symbols pen                       
C     ipen3 text pen
c
c
C
      character*72 xstr,ystr,tstr
c     DATA CM/2.54/
C
C
C  Formerly convert to inches
      st=sizt
      sl=sizl
      X0I=X0
      Y0I=Y0
      xlow=x0i
      ylow=y0i
      XASLI=XASL
      YASLI=YASL
      xup=x0i+xasli
      yup=y0i+yasli
C
      call Pen(ipen1,0)
C     Move to lower left corner and draw frame
      X=X0I
      Y=Y0I
      call Plot(X,Y,3)
      call Plot(x,yup,2)
      call Plot(xup,yup,2)
      call Plot(xup,y,2)
      call Plot(x,y,2)
c
C
C     Compute subdivision parameters
      NX=XASL/XTICL+1.01
      NY=YASL/YTICL+1.01
      NXSUB=MAX0(1,NXSUB)
      NYSUB=MAX0(1,NYSUB)
      DX=XTICL/real(NXSUB)
      DY=YTICL/real(NYSUB)
c
c     Reorigin in function values relative to (fx,fy)=(0,0)
      if(fx0.lt.0.and.dfx.gt.0) rox=(ifix(fx0/dfx)-1)*dfx
      if(fx0.ge.0.and.dfx.gt.0) rox=(ifix(fx0/dfx)  )*dfx
      if(fx0.lt.0.and.dfx.lt.0) rox=(ifix(fx0/dfx)  )*dfx
      if(fx0.ge.0.and.dfx.lt.0) rox=(ifix(fx0/dfx)-1)*dfx
*                                            
      if(fy0.lt.0.and.dfy.gt.0) roy=(ifix(fy0/dfy)-1)*dfy
      if(fy0.ge.0.and.dfy.gt.0) roy=(ifix(fy0/dfy)  )*dfy
      if(fy0.lt.0.and.dfy.lt.0) roy=(ifix(fy0/dfy)  )*dfy
      if(fy0.ge.0.and.dfy.lt.0) roy=(ifix(fy0/dfy)-1)*dfy
*                                            
      x0i=x0i-xticl/dfx *(fx0-rox)
      y0i=y0i-yticl/dfy *(fy0-roy)
c                  
      x=x0i
      y=ylow
      F=rox
      call Plot(xlow,ylow,3)
C
*
      call Pen(ipen2,0)
*
C     Plot tics and numbers lower x-axis
      DO 20 I=1,NX+1
      DO 10 J=1,NXSUB
      X=X+DX
      if(x.lt.xlow) goto 10
      if(x.gt.xup)  goto 21
      call Plot(X,Y,3)
      call Plot(X,Y+.25,2)
      call Plot(X,Y,3)
   10 CONTINUE
      F=F+DFX
      call Plot(x,y,3)
      call Plot(X,Y+.50,2)
      nxd=nxdec
      call nfig(f,nxd,nf)
      call typnum(X-sl*nf/3.,Y-.25-sl,0.8*sl,F,0.,NXD)
      call Plot(X,Y,3)
   20 CONTINUE
   21 continue
      call numc(xstr,nct)
      call Pen(ipen3,0)
      xback = nct*0.5*sl
      call typstr(Xlow+.5*XASLI-xback,Ylow-2.5*sl-.6,sl,xstr,0.,72)
      call Pen(ipen2,0)
C
      X=Xlow
      Y=Y0I
      call Plot(Xlow,ylow,3)
      F=roy
C
C     Plot left y-axis
      DO 40 I=1,NY+1
      DO 30 J=1,NYSUB
      Y=Y+DY
      if(y.lt.ylow) goto 30
      if(y.gt.yup)  goto 41
      call Plot(X,Y,3)
      call Plot(X+.25,Y,2)
      call Plot(X,Y,3)
   30 CONTINUE
      F=F+DFY
      call Plot(x,y,3)
      call Plot(X+.40,Y,2)
      nyd=nydec
      call nfig(f,nyd,nf)
      call typnum(X-sl*nf/1.5-.35,Y-sl*0.25,0.8*sl,F,0.,NYD)
c     call typnum(X-.35,Y-sl*nf/3.,0.8*sl,F,90.,NYD)
      call Plot(X,Y,3)
   40 CONTINUE
   41 continue
      call numc(ystr,nct)
      call Pen(ipen3,0)
      zback = nct*0.5*sl
      call typstr(Xlow-sl-1.95,Ylow+.5*YASLI-zback,sl,ystr,90.,72)
      call Pen(ipen2,0)
C
C     Move to upper left corner
      X=X0I
      Y=Yup
      call Plot(Xlow,ylow,3)
C                                                 
C     Plot top x-axis
      DO 60 I=1,NX+1
      DO 50 J=1,NXSUB
      X=X+DX
      if(x.lt.xlow) goto 50
      if(x.gt.xup)  goto 61
      call Plot(X,Y,3)
      call Plot(X,Y-.25,2)
      call Plot(X,Y,3)
   50 CONTINUE
      call Plot(X,Y-.40,2)
      call Plot(X,Y,3)
   60 CONTINUE
   61 continue
C
C
C     Plot right y-axis
      X=Xup
      Y=Y0I
      call Plot(xlow,ylow,3)
      DO 80 I=1,NY+1
      DO 70 J=1,NYSUB
      Y=Y+DY
      if(y.lt.ylow) goto 70
      if(y.gt.yup)  goto 81
      call Plot(X,Y,3)
      call Plot(X-.25,Y,2)
      call Plot(X,Y,3)
   70 CONTINUE
      call Plot(X-.40,Y,2)
      call Plot(X,Y,3)
   80 CONTINUE
   81 continue
C
C     title text
      call Pen(ipen3,0)
      call Plot(xup,yup,3)
      X=Xlow
c     call numc(tstr,nct)
      call Plot(X,Yup+1.00,3)
      call typstr(X,Yup+1.00,st,tstr,0.,72)
      call Pen(1,0)
      RETURN
      END
      subroutine nfig(f,ndec,nf)
      if(abs(f).lt.0.00001) then
            x=0
      else
            x=alog10(abs(f))
            if(abs(f-1).lt.0.0001) x=0
      endif
      if(x.ge.0) then
            nf=x+2+ndec
      else
            ng=abs(x)+2
            nf=max0(ng,ndec+2)
      endif
      if(f.lt.0) nf=nf+1
c  plotpak use
c     ndec= nf*10+ndec
      return
      end
      subroutine numc(c,nc)
      character*(*) c
      m=len(c)
      nc=m+1
10      nc=nc-1
      if(c(nc:nc).eq.' '.and.nc.gt.1) goto 10
      return
      end
c
c ----------------------------------------------------------------------------
c
c       NA_getrange - performs minor initialization tasks for NA algorithm.
c
c       Calls no other routines.
c
c                                               M. Sambridge, Oct. 1996
c
c ----------------------------------------------------------------------------
c
        Subroutine NA_getrange
     &             (range,ranget,scales,nd,naxis,x,restart)
c
        real            range(2,nd)
        real            ranget(2,nd)
        real            scales(*)
        real            x(nd)

        logical         verbose
        logical         restart
c
        common /NA_IO/verbose,lu_in,lu_out,lu_sum,lu_det,lu_sob
        common /NA_init/idnext,ic

c
c                                               set logical switch for 
c                                               first call to NA_sample 
c                                               (ensures distance list is
c                                                initialized)
        restart = .true.
c
c                                               set initial parameter
c                                               for NA walk
c       idnext = 1
        ic = 1

c                                               Normalize parameter ranges
c                                               by a-priori model co-variances
c
        if(scales(1).eq.0.0)then
c                                               First option:
c                                               No transform 
c                                               (All a priori model 
c                                                co-variances are 
c                                                equal to unity)
           do i=1,nd
              ranget(1,i) = range(1,i)
              ranget(2,i) = range(2,i)
           end do

        else if(scales(1).eq.-1.0)then
c                                               Second option:
c                                               Use parameter range as
c                                               a priori model co-variances 
           do i=1,nd
              ranget(1,i) = 0.0
              ranget(2,i) = 1.0
           end do

        else
c                                               Third option:
c                                               Use scales array as
c                                               a priori model co-variances 
           do i=1,nd
              if(scales(i+1).eq.0)then
                 write(*,200)i,scales(i+1)
                 stop
              end if
              ranget(1,i)  = range(1,i)/scales(i+1)
              ranget(2,i)  = range(2,i)/scales(i+1)
           end do

        end if
c                                               write out information
c                                               on parameter space
c                                               to summary file
        if(lu_sum.gt.5)then
           
        write(lu_sum,300)
        write(lu_sum,fmt='("Parameter space details:"/)')
        write(lu_sum,*)' Number of dimensions           : ',nd
        write(lu_sum,*)' '
        write(lu_sum,*)' Parameter ranges'
        write(lu_sum,*)'   Number   Minimum     Maximum   ',
     &                    ' A-prior cov Scaled min  Scaled max'
c
        do i=1,nd
           if(scales(1).eq.0.0)then
              sf = 1.0 
           else if(scales(1).eq.-1.0)then
              sf = range(2,i)-range(1,i)  
           else
              SF = scales(i+1)
           end if
           write(lu_sum,100)i,range(1,i),range(2,i),sf,
     &                      ranget(1,i),ranget(2,i)
        end do
        write(lu_sum,300)

        end if

 100    format(3x,i4,2x,5(f11.4,1x))
 200    format(/' Error in subroutine NA_initialize '//,
     &          ' Input a priori model co-variance is equal to zero',
     &          ' for parameter ',i4/
     &          ' This is not valid'//
     &          ' Remedy - check and adjust input',
     &          ' a priori co-variances'/)
 300    format(/72("-")/)

        return
        end
c
c ----------------------------------------------------------------------------
c
c       NA_transform - transforms model back to input units (if necessary)
c
c       Calls no other routines.
c
c                                               M. Sambridge, Oct. 1996
c
c ----------------------------------------------------------------------------
c
        Subroutine NA_transformf
     &             (na_model,nd,range,scales,rmodel)
c
        real*8          rmodel(*)
        real            na_model(*)
        real            scales(*)
        real            range(2,*)
c
        if(scales(1).eq.0.0)then

           do i=1,nd
              na_model(i) = sngl(rmodel(i))
           end do

        else if(scales(1).eq.-1.0)then

           do i=1,nd
              na_model(i) = 
     &        (rmodel(i)-range(1,i))/(range(2,i)-range(1,i))
           end do

        else 

           do i=1,nd
              na_model(i) = (rmodel(i)-range(1,i))/scales(i+1)
           end do

        end if
c
        return
        end
