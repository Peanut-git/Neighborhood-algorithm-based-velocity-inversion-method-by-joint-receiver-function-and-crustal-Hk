
      subroutine SYMBOL(X,Y,SIZE,IWORD,ANGL,NCHAR)
      COMMON/P00000/LPLOT,A,B,C,D,ASP,THET
      COMMON/L00000/PSCA,xo,yo
      CHARACTER*80 IWORD
       call xsymbol(x,y,size,iword,angl,nchar,5)
      end
