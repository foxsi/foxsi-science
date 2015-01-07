;+
; NAME:
; 
;	EXPO_FIT
;	
; PURPOSE:
; 
; 	Fit y=f(x) where:
; 	F(x) = a0*exp(-abs(x-a1)/a2)+a3
;	a0 = height of exp, a1 = center of peak, a2 = 1/e width,
; 	Estimate the parameters a0,a1,a2,a3 and then call curvefit.
; 	
; CALLING SEQUENCE:
; 
;	YFIT = EXPO_FIT(X,Y,A)
;	
; INPUTS:
; 
;	X - independent variable, must be a vector.
;	
;       Y - dependent variable, must have the same number of points ;
;           as x.
;		
; OUTPUTS:
; 
;	YFIT - fitted function.
;	
; OPTIONAL OUTPUT PARAMETERS:
; 
;       A - Fit coefficients. a four element vector as described
;           above.
;
; MODIFICATION HISTORY:
; 
;	Adapted from GAUSSFIT
;	
;	D. L. Windt, Bell Laboratories, March, 1990
;	windt@bell-labs.com
;-
;

pro	exponential,x,a,f,pder
f = a(0)*exp(-abs(x-a(1))/a(2))+a(3)
if n_params(0) le 3 then return ;need partial?
pder = fltarr(n_elements(x),4)  ;yes, make array.
pder(0,0) = (f-a(3))/a(0)
pder(0,1) = (f-a(3))/a(2)*(2*(x lt a(1))-1)
pder(0,2) = 1./a(2)/a(2)*abs(x-a(1))*(f-a(3))
pder(*,3) = 1.
return
end

function expo_fit,x,y,a
on_error,2		
cm=check_math(0.,1.)		; Don't print math error messages.
n = n_elements(y)		;# of points.
c=poly_fit(x,y,1,yf)		; Do a straight line fit.
yd=y-yf
ymax=max(yd) & xmax=x(!c) & imax=!c ;x,y and subscript of extrema
ymin=min(yd) & xmin=x(!c) & imin=!c

if abs(ymax) gt abs(ymin) then i0=imax else i0=imin ;emiss or absorp?
i0 = i0 > 1 < (n-2)		;never take edges
dy=yd(i0)			;diff between extreme and mean
del = dy/exp(1.)		;1/e value
i=0
while ((i0+i+1) lt n) and $	;guess at 1/2 width.
  ((i0-i) gt 0) and $
  (abs(yd(i0+i)) gt abs(del)) and $
  (abs(yd(i0-i)) gt abs(del)) do i=i+1
a = [yd(i0), x(i0), abs(x(i0)-x(i0+i)),c(0)] ;estimates
!c=0				;reset cursor for plotting
return,curvefit(x,y,replicate(1.,n),a,sigmaa,funct='exponential') 
end