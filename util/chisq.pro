;******************************************************************************
;+
;*NAME:
;
;    CHISQ    (General IDL Library 01)  JUNE,1984
; 
;*CLASS: 
;
;    Statistics
;
;*CATEGORY
;  
;*PURPOSE:   
;
;    To evaluate reduced chi-squared for a fit to data.
; 
;*CALLING SEQUENCE: 
;
;    CHISQ,Y,WEIGHT,YFIT,NFREE,CHISQ
; 
;*PARAMETERS:
;
;    Y       (REQ) (I) (1) (F D)
;            Required input vector containing the measured data.
;
;    WEIGHT  (REQ) (I/O) (1) (F D)
;            Required input vector containing the data point weights:
;              for instrumental uncertainties use WEIGHT=1/sigmay^2,
;              for statistical uncertaintities use WEIGHT=1/Y,
;              if WEIGHT=1 then value returned = variance of fit,
;              see BEVINGTON for further information.
;
;    YFIT    (REQ) (I) (1) (F D)
;            Required input vector containing the calculated data based
;            on some model or least squares fitting.
;
;    NFREE   (REQ) (I) (0) (I L F D)
;            Required input scalar containing the number of degrees of 
;            freedom.  This is equal to:
;               number of data points - degree of polynomial - 1
;
;    CHISQ   (REQ) (O) (0) (F D)
;            Required ouput scalar giving the reduced chi-squared statistic.
;
;*EXAMPLES:
;
;    To compute the chi-squared statistic for observed data YDATA and
;    computed data YFIT, with uniform data weighting,
;
;       weight = 0 * ydata + 1.
;       chisq,ydata,weight,yfit,nfree,chisq
;
;    To compute the reduced chi-squared statistic for observed data Y and
;    computed data YF, where the weight = abs(1./y), Y has 100 points, YF
;    is a third degree polynomial [i.e., yf = a(0) + a(1) * x + a(2) * x^2 +
;    a(3) * x^3}:
;
;       chisq,y,abs(1./y),yf,n_elements(y)-3-1,chisq
;
;*SYSTEM VARIABLES USED:
;
;    none
;
;*INTERACTIVE INPUT:
;
;    none
;
;*SUBROUTINES CALLED:
;
;    PARCHECK
;    PCHECK
;
;*FILES USED:
;
;    none
;
;*SIDE EFFECTS:
;
;    If WEIGHT
;
;*PROCEDURE: 
;
;    The procedure computes total(weight(y-yfit)^2)/nfree
;                 (See Bevington [1969] p. 193-195 for weighting methods)
;   
;*NOTES:
;
;    If NFREE is < 0  or NPTS is < NFREE then CHISQ is set to 0
;    and an error message will appear.
;    Typing CHISQ without any parameters will display the procedure
;    call statement.
;
;	tested with IDL Version 2.1.0 (sunos sparc)  	19 Jun 91
;	tested with IDL Version 2.1.0 (ultrix mispel)	N/A
;	tested with IDL Version 2.1.0 (vms vax)      	21 Jun 91
; 
;*MODIFICATION HISTORY:
;
;    July,  1981  TBA  GSFC add weighting
;    June,  1984  NRE  GSFC change to 1/SIGMA^2 weighting, document
;    Jul  5 1984  RWT  GSFC correct error in using WEIGHT and modify
;                          documentation
;    Sep  9 1987  RWT  GSFC add procedure call listing 
;    Mar  8 1988  CAG  GSFC add VAX RDAF-style prolog.
;    Jun 21 1991  PJL  GSFC cleaned up; tested on SUN and VAX; updated prolog
;     6 May 94  PJL  added to prolog
;    11 May 94  PJL  print a warning if any of the weights are negative
;
;-
;******************************************************************************
 pro chisq,y,weight,yfit,nfree,chisq
;
 npar = n_params(0)
 if (npar eq 0) then begin
    print,'CHISQ,Y,WEIGHT,YFIT,NFREE,CHISQ'
    retall
 endif  ; npar
 parcheck,npar,5,'CHISQ'
 pcheck,y,1,010,0011
 pcheck,yfit,2,010,0011
 pcheck,nfree,3,100,0010
;
;  print a warning if any of the weights are negative
;
 temp = where(weight lt 0,count)
 if (count gt 0) then begin
    print,' '
    print,'WARNING:  ' + strtrim(count,2) + ' of the ' +   $
       strtrim(n_elements(weight),2) + ' weight values are negative.'
    print,'ACTION:  continuing'
    print,' '
 endif  ; count gt 0
;
 npts  = n_elements(y)
;
; if degrees of freedom positive, proceed
;
 if (nfree gt 0) and (npts gt nfree) then begin
    chisq = total(weight*(y-yfit)*(y-yfit)) / nfree
 endif else begin
    print,'Error detected in CHISQ.'
    print,'nfree = ',strtrim(nfree,2),'  npts = ',strtrim(npts,2)
    chisq = 0
 endelse  ; nfree
;
 return
 end  ; chisq