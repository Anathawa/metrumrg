\name{compute.cwres}
\alias{compute.cwres}
\alias{ind.cwres}
\alias{read.cwres.data}
\alias{nm.data-class}
\alias{is.cwres.readable.file}
\title{Compute the Conditional Weighted Residuals}
\description{
  This function computes the conditional weighted residuals (CWRES) from a NONMEM
  run.  CWRES are an extension of the weighted residuals (WRES), but
  are calculated based on the first-order with conditional estimation (FOCE)
  method of linearizing a pharmacometric model (WRES are calculated
  based on the first-order (FO) method). The function requires a NONMEM table file
  and an extra output file that must be explicitly asked for when
  running NONMEM. See details below.
}
\usage{
compute.cwres(run.number,
              tab.prefix="cwtab",
              sim.suffix="",
              est.tab.suffix=".est",
              deriv.tab.suffix=".deriv",
              old.file.convention=FALSE,
              id="ALL",
              printToOutfile=TRUE,
              onlyNonZero=TRUE,
              ...)

}

\arguments{
  \item{run.number}{The run number of the NONMEM from which the CWRES
    are to be calculated.}
  \item{tab.prefix}{The prefix to two NONMEM file containing the
    needed values for the computation of the CWRES, described in the
    details section.}
  \item{sim.suffix}{The suffix ,before the ".", of the NONMEM file containing the
    needed values for the computation of the CWRES, described in the
    details section. For example, the table files might be named
    \code{cwtab1sim.est} and \code{cwtab1sim.deriv}, in which case
    \code{sim.suffix="sim"}.}
  \item{est.tab.suffix}{The suffix, after the ".", of the NONMEM file
    containing the estimated parameter values needed for the CWRES calculation.}
  \item{deriv.tab.suffix}{The suffix, after the ".", of the NONMEM file
    containing the derivatives of the model with respect to the random
    parameters needed for the CWRES calculation.}
  \item{old.file.convention}{For backwards compatibility.  Use this if
    you are using the previous file convention for CWRES (table files
    named cwtab1, cwtab1.50, cwtab1.51, ... , cwtab.58 for example).}
  \item{id}{Can be either "ALL" or a number matching an ID label in the
    \code{datasetname}.}
    \item{printToOutfile}{Logical (\code{TRUE}/\code{FALSE}) indicating whether the
    CWRES values calculated should be appended to a copy of the
    \code{datasetname}.  Only works if \code{id}="ALL".  If chosen the
    resulting output file will be \code{datasetname}.cwres.}
  \item{onlyNonZero}{Logical (\code{TRUE}/\code{FALSE}) indicating if the return value
    (the CWRES values) of \code{compute.cwres} should include the zero
    values associated with non-measurement lines in a NONMEM data file.}
  \item{tab.suffix}{The suffix to the  NONMEM table file containing the
    derivative of the model with respect to the etas and epsilons,
    described in the details section.}
  \item{\dots}{Other arguments passed to basic functions in code.}
}
\details{
  \code{compute.cwres}This function is the computational 'brains' of
    the CWRES computation.  The function simply reads in the following two files:
    
    \preformatted{
      paste(tab.prefix,run.number,sim.suffix,est.tab.suffix,sep="")
      paste(tab.prefix,run.number,sim.suffix,deriv.tab.suffix,sep="")
   }
    
    Which might be for example:
    
    \preformatted{
      cwtab1.est
      cwtab1.deriv
   }
    
    and (depending on the input values to the function) returns the CWRES
    in vector form as well as creating a new table file named:

    \preformatted{
      paste(tab.prefix,run.number,sim.suffix,sep="")
   }
    
    Which might be for example:
    
    \preformatted{
      cwtab1
   }
     
  
 }
\section{Setting up the NONMEM model file}{In order for this function to 
  calculate the CWRES, NONMEM must be run while requesting certain
  tables and files to be created.  How these
  files are created differs depending on if you are using $PRED or ADVAN 
  as well as the version of NONMEM you are using.  These procedures are
  known to work for NONMEM VI but may be different for NONMEM V.  We
  have attempted to indicate where NONMEM V may be different, but this
  has not been extensively tested!
 
  There are five main insertions needed in your NONMEM control file:
 
 \enumerate{
   \item{1. $ABB COMRES=X.}{

     Insert this line directly after your $DATA line.
     The value of X is the number of ETA() terms plus the number of EPS()
     terms in your model.  For example for a model with three ETA() terms
     and two EPS() terms the code would look like this:
    
     \preformatted{
       $DATA temp.csv IGNORE=@
       $ABB COMRES=5
       $INPUT ID TIME DV MDV AMT EVID
       $SUB ADVAN2 TRANS2
    } % preformatted
  } % item
     
   \item{2. Verbatim code.}{

     \itemize{
       \item{A. Using ADVAN.}{
	 
	 If you are using ADVAN routines in your
	 model, then Verbatim code should be inserted directly after
	 the $ERROR section of your model file.  The length of the code
	 depends again on the number of ETA() terms and EPS() terms in your
	 model.  For each ETA(y) in your model there is a corresponding
	 term G(y,1) that you must assign to a COM() variable.  For each EPS(y) in
	 your model, there is a corresponding HH(y,1) term that you must
	 assign to a COM() variable.
	 
	 For example for a model using ADVAN routines with three ETA() terms
	 and two EPS() terms the code would look like this:
	 \preformatted{
	   "LAST %"
	   "  COM(1)=G(1,1) %"
	   "  COM(2)=G(2,1) %"
	   "  COM(3)=G(3,1) %"
	   "  COM(4)=HH(1,1) %"
	   "  COM(5)=HH(2,1) %"
	} % preformatted       
         
      } % item
        
       \item{B. Using PRED.}{

	 If you are using $PRED, the verbatim
	 code should be  inserted directly
	 after the $PRED section of your model file.  For each ETA(y) in
	 your model there is a corresponding 
	 term G(y,1) that you must assign to a COM() variable.  For each EPS(y) in
	 your model, there is a corresponding H(y,1) term that you must
	 assign to a COM() variable. The code would look like this for
	 three ETA() terms and two EPS() terms:
      
         \preformatted{
	   "LAST %"
	   "  COM(1)=G(1,1) %"
	   "  COM(2)=G(2,1) %"
	   "  COM(3)=G(3,1) %"
	   "  COM(4)=H(1,1) %"
	   "  COM(5)=H(2,1) %"
        } % preformatted
      } % item
       
       
    } % itemize
      
  } % item (verbatim)
    
   \item{3. INFN routine.}{
     
     \itemize{
       \item{A. Using ADVAN with NONMEM VIb.}{

	 If you are using ADVAN
	 routines in your
	 model, then an $INFN section should be placed directly after the
	 $PK section using the following code.  In this example we are
	 assuming that the model file is named something like
	 '1.ctl'.  NOTE: Files 51, 53, 55
	 and 57 are not used in the CWRES calculation and can be removed
	 from the NONMEM model file if problems arise due to failure of the
	 $COV step in a NONMEM run.
	 \preformatted{
	   $INFN
	   IF (ICALL.EQ.3) THEN
	     OPEN(50,FILE='cwtab1.est')
	     WRITE(50,*) 'ETAS'
	     DO WHILE(DATA)                                                       
               IF (NEWIND.LE.1) WRITE (50,*) ETA                                    
	     ENDDO                                                                
	     WRITE(50,*) 'THETAS'
	     WRITE(50,*) THETA
	     WRITE(50,*) 'OMEGAS'
	     WRITE(50,*) OMEGA(BLOCK)
	     WRITE(50,*) 'SIGMAS'
	     WRITE(50,*) SIGMA(BLOCK)
	   ENDIF
	} % preformatted       
        
      } % item
        
       \item{B. Using ADVAN with NONMEM V.}{

	 If you are using ADVAN
	 routines in your
	 model, then you need to use an  INFN subroutine.
	 If we call the INFN subroutine 'myinfn.for' then the $SUBS
	 line of your model file should include the INFN option.  That
	 is, if we are using ADVAN2 and TRANS2 in our model file then
	 the $SUBS line would look like:
	 
	 \preformatted{
	   $SUB ADVAN2 TRANS2 INFN=myinfn.for
	} % preformatted
	 
	 The 'myinfn.for' routine for 4 thetas, 3 etas and 1 epsilon
	 is shown below.  If your model has different numbers of
	 thetas, etas and epsilons then the values of 
	 NTH, NETA, and NEPS, should be changed respectively.  These
	 vales are found  in the DATA statement of the subroutine.
     Please note that the 4th and 5th lines of
	 code should be one line with the '...' removed from each line,
	 reading:  \code{COMMON /ROCM6/
	   THETAF(40),OMEGAF(30,30),SIGMAF(30,30)}.  NOTE: Files 51, 53, 55
	 and 57 are not used in the CWRES calculation and can be removed
	 from the subroutine if problems arise due to failure of the
	 $COV step in a NONMEM run.
	 
	 \preformatted{
      SUBROUTINE INFN(ICALL,THETA,DATREC,INDXS,NEWIND)
      DIMENSION THETA(*),DATREC(*),INDXS(*)
      DOUBLE PRECISION THETA
      COMMON /ROCM6/ ...
      ... THETAF(40),OMEGAF(30,30),SIGMAF(30,30)
      COMMON /ROCM7/ SETH(40),SEOM(30,30),SESIG(30,30)
      COMMON /ROCM8/ OBJECT
      COMMON /ROCM9/ IERE,IERC
      DOUBLE PRECISION THETAF, OMEGAF, SIGMAF
      DOUBLE PRECISION OBJECT
      REAL SETH,SEOM,SESIG
      DOUBLE PRECISION ETA(10)
      INTEGER J,I
      INTEGER IERE,IERC
      INTEGER MODE
      INTEGER NTH,NETA,NEPS
      DATA NTH,NETA,NEPS/4,3,1/
      IF (ICALL.EQ.0) THEN
C     open files here, if necessary
      	 OPEN(50,FILE='cwtab1.est')
      ENDIF
      IF (ICALL.EQ.3) THEN
         MODE=0
         CALL PASS(MODE)
         MODE=1
	 WRITE(50,*) 'ETAS'
20       CALL PASS(MODE)
         IF (MODE.EQ.0) GO TO 30
         IF (NEWIND.NE.2) THEN
            CALL GETETA(ETA)
            WRITE (50,97) (ETA(I),I=1,NETA)
         ENDIF
         GO TO 20
30       CONTINUE
         WRITE (50,*) 'THETAS'
         WRITE (50,99) (THETAF(J),J=1,NTH)
	 WRITE(50,*) 'OMEGAS'
         DO 7000 I=1,NETA
7000       WRITE (50,99) (OMEGAF(I,J),J=1,NETA)
	 WRITE(50,*) 'SIGMAS'
         DO 7999 I=1,NEPS
7999       WRITE (50,99) (SIGMAF(I,J),J=1,NEPS)
      ENDIF
99    FORMAT (20E15.7)
98    FORMAT (2I8)
97    FORMAT (10E15.7)
      RETURN
      END

        } % preformatted
      
      } % item
       
       \item{C. Using $PRED with NONMEM VIb.}{

	 If you are using $PRED,
	 then an the following code should be placed at the end of the
	 $PRED section of the model file (together with the verbatim
	 code).  NOTE: Files 51, 53, 55
	 and 57 are not used in the CWRES calculation and can be removed
	 from the NONMEM model file if problems arise due to failure of the
	 $COV step in a NONMEM run.
	 
	 \preformatted{
	   IF (ICALL.EQ.3) THEN
	     OPEN(50,FILE='cwtab1.est')
	     WRITE(50,*) 'ETAS'
	     DO WHILE(DATA)                                                       
               IF (NEWIND.LE.1) WRITE (50,*) ETA                                    
	     ENDDO                                                                
	     WRITE(50,*) 'THETAS'
	     WRITE(50,*) THETA
	     WRITE(50,*) 'OMEGAS'
	     WRITE(50,*) OMEGA(BLOCK)
	     WRITE(50,*) 'SIGMAS'
	     WRITE(50,*) SIGMA(BLOCK)
	   ENDIF
	} % preformatted
	 
      } % item
      
       \item{D. Using $PRED with NONMEM V.}{

	 If you are using $PRED with
	 NONMEM V,
	 then you need to add verbatim code immediately after the $PRED
	 command.  In this example we assume 4 thetas, 3 etas and 1
	 epsilon.   If your model has different numbers of
	 thetas, etas and epsilons then the values of 
	 NTH, NETA, and NEPS, should be changed respectively.  These
	 vales are found  in the DATA statement below.   Please note  that
	 the 3rd and 4th lines of
	 code should be one line with the '...' removed from each line.   NOTE: Files 51, 53, 55
	 and 57 are not used in the CWRES calculation and can be removed
	 from the NONMEM model file if problems arise due to failure of the
	 $COV step in a NONMEM run.
	 
	 \preformatted{
	   $PRED
	   "FIRST  %"
	   "      COMMON /ROCM6/ ...
	   ...THETAF(40),OMEGAF(30,30),SIGMAF(30,30) %"
	   "      COMMON /ROCM7/ SETH(40),SEOM(30,30),SESIG(30,30) %"
	   "      COMMON /ROCM8/ OBJECT %"
	   "      DOUBLE PRECISION THETAF, OMEGAF, SIGMAF %"
	   "      DOUBLE PRECISION OBJECT %"
	   "      REAL SETH,SEOM,SESIG %"
	   "      INTEGER J,I %"
	   "      INTEGER MODE %"
	   "      INTEGER NTH,NETA,NEPS %" 
	   "      DATA NTH,NETA,NEPS/4,3,1/ %"
	} % preformatted
      
	 After this verbatim code you add all of the abbreviated code
	 needed for the $PRED routine in your model file.  After the
	 abbreviated code more verbatim code is needed.  This verbatim
	 code should be added before the verbatim code discussed above
	 under point 2. 
	       
	 \preformatted{
	   "      IF (ICALL.EQ.0) THEN %"
	   "C     open files here, if necessary %"
	   "         OPEN(50,FILE='cwtab1.est') %"
	   "      ENDIF %"
	   "      IF (ICALL.EQ.3) THEN %"
	   "         MODE=0 %"
	   "         CALL PASS(MODE) %"
	   "         MODE=1 %"
	   " 	  WRITE(50,*) 'ETAS' %"
	   " 20      CALL PASS(MODE) %"
	   "         IF (MODE.EQ.0) GO TO 30 %"
	   "         IF (NEWIND.NE.2) THEN %"
	   "            CALL GETETA(ETA) %"
	   "            WRITE (50,97) (ETA(I),I=1,NETA) %"
	   "         ENDIF %"
	   "         GO TO 20 %"
	   " 30      CONTINUE %"
	   "         WRITE (50,*) 'THETAS' %"
	   "         WRITE (50,99) (THETAF(J),J=1,NTH) %"
	   "         WRITE (50,*) 'OMEGAS' %"
	   "         DO 7000 I=1,NETA %"
	   " 7000       WRITE (50,99) (OMEGAF(I,J),J=1,NETA) %"
	   "         WRITE (50,*) 'SIGMAS' %"
	   "         DO 7999 I=1,NEPS %"
	   " 7999       WRITE (50,99) (SIGMAF(I,J),J=1,NEPS) %"
	   "      ENDIF %"
	   " 99   FORMAT (20E15.7) %"
	   " 98   FORMAT (2I8) %"
	   " 97   FORMAT (10E15.7) %"
	} % preformatted
      
      } % item
    
    } % itemize
  } % item (infn)

   \item{4. cwtab*.deriv table file.}{

     A special table file needs to be
     created to  print out the values
     contained in the \code{COMRES} variables.  In addition the
     \code{ID, IPRED, MDV, DV, PRED and RES} data items
     are needed for the computation of the CWRES.  The following code
     should be added to the NONMEM model file.  In this example we
     continue to assume that we are using a model with three ETA() terms
     and two EPS() terms, extra terms should be added for new ETA() and
     EPS() terms in the model file. 
     
     \preformatted{
       $TABLE ID COM(1)=G11 COM(2)=G21 COM(3)=G31
       COM(4)=H11 COM(5)=H21 
       IPRED MDV NOPRINT ONEHEADER FILE=cwtab1.deriv
    } % preformatted
     
  } % item (cwtab)
    
   \item{5. $ESTIMATION.}{

     To compute the CWRES, the NONMEM model file must use (at least) the
     FO method with the \code{POSTHOC} step.  If the FO method is used
     and the  \code{POSTHOC} step is not included then the CWRES values
     will be equivalent to the WRES.  The CWRES calculations are based
     on the FOCE approximation, and consequently give an idea of the
     ability of the FOCE method to fit the model to the data. If you
     are using another method of parameter estimation (e.g. FOCE with
     interaction), the CWRES will not be calculated based on the same
     model linearization procedure.
  } % item (est)
   
}  % Enumerate


} % Section


\value{
  \item{compute.cwres}{   Returns a vector containing the values of the
    CWRES.}
}
\references{
  Hooker A, Staatz CE, Karlsson MO. \emph{Conditional weighted residuals, an
    improved model diagnostic for the FO/FOCE methods}. PAGE 15 (2006)
  Abstr 1001 [\url{http://www.page-meeting.org/?abstract=1001}].
}
\author{Andrew Hooker}
\seealso{
	\itemize{
		\item \code{\link{compute.cwres}}
	}
}
\keyword{manip}
