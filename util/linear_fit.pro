function linear, x, a
; LINEAR.pro
; Fits to a line y=a0*x+a1 for LMFIT.  It's dumb but I need to check
; LMFIT.
y = a[0]*x+a[1]

return, [[y], [x], [1.]]
end

function linear_fit, xin, yin, errors = errors, covar = covar, chi2 = chi2, $
                     _ref_extra = ex, fita = fita
;+
; NAME:
;   LINEAR_FIT
; PURPOSE:
;   Fits a line to X and Y data.
;
; CALLING SEQUENCE:
;   coeffs = LINEAR_FIT (X, Y [, errors=errors, covar=covar])
;
; INPUTS:
;   X, Y -- Vectors of X and Y data.
;
; KEYWORD PARAMETERS:
;   ERRORS -- Errors in the Y values.
;   COVAR -- Variable name into which the covariance matrix is stored.
; OUTPUTS:
;   COEFFS -- vector: [y-intercept, slope]
;
; MODIFICATION HISTORY:
;   Documented --
;       Sun Jun 3 14:14:15 2001, Erik Rosolowsky <eros@cosmic>
;
;-

  ind = where(xin eq xin and yin eq yin)
  x = xin[ind]
  y = yin[ind]

  if keyword_set(errors) then begin
    wt = 1/(errors^2) 
    bad_index = where(finite(wt) ne 1)
    if total(bad_index) gt -1 then wt[bad_index] = 0 
  endif else wt = replicate(1., n_elements(x)) ;

  if  n_elements(fita) eq 0 then fita = [1, 1]
  M = [[total(wt), total(x*wt)], $
       [total(x*wt), total(x^2*wt)]]
  covar = invert(M)
  coeffs = covar##transpose([total(y*wt), $
                             total(x*y*wt)])
  chi2 = total((y-coeffs[0]-coeffs[1]*x)^2*wt)/(n_elements(x)-2)
  
  coeffs = [coeffs[1], coeffs[0]]*fita
  fit = lmfit(x, y, coeffs, covar = covar, chisq = chi2, $
              measure_errors = errors, function_name = 'linear', $
              _extra = ex, fita = fita, /double)

  
  return, [coeffs[1], coeffs[0]]
end


