
      subroutine xNUMBER(X,Y,SIZE,RN,ANGL,NSF, ifont)
C       modified on 90/10/20 by Kikuchi

      COMMON/P00000/LPLOT,A,B,C,D,ASP,THET
      COMMON/L00000/PSCA,xo,yo
      CHARACTER*8 IFORM
      CHARACTER*40 IWORD
      if(rn.eq.0.) then
        call xsymbol(x,y,size,'0',angl,1,ifont)
         return
      endif
        iorder=log10(abs(rn))+1.
         if(iorder.le.0) iorder=1
        if(nsf.lt.0) goto 20
        idl=iorder+nsf+2
      Write(IFORM,55) idl,NSF
   55 FORMAT('(f',i2,'.',I1,')')
      Write(IWORD,IFORM)RN
      GO TO 30

C    for integer format

   20  if(rn.lt.0.) iorder=iorder+1
       write(iform,56) iorder
   56  format('(i',i2,')')
       Write(IWORD,iform)IFIX(RN)
       idl=iorder

   30 CALL xSYMBOL(X,Y,SIZE,IWORD,ANGL,idl, ifont)
      END
