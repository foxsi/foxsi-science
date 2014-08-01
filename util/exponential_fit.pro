function exponential, x, a
; EXPONENTIAL.PRO
; y=a0*exp(a1*x)+a2 function in format for LMFIT
  y = a[0]*exp(a[1]*x);+a[2]
  return, [[y], [exp(a[1]*x)], [a[0]*x*exp(a[1]*x)]];, [1.0]]
end

function exponential_fit, x, y, guess = guess, $
                          sigma = sigma, errors = errors
;+
; NAME:
;   EXPONENTIAL_FIT
; PURPOSE:
;   Fit an exponential to the data of the form y=a*exp(b*x).  It's
;   just a wrapper for LMFIT, as always.
;
; CALLING SEQUENCE:
;   fit=exponential_fit(x, y[, errors=errors, guess=guess,
;   sigma=sigma])
;
; INPUTS:
;   X, Y -- X and Y values to be fit.
;
; KEYWORD PARAMETERS:
;   GUESS -- vector containing the guess values [a,b] in y=a*exp(b*x)
;   SIGMA -- Named variable to contain the errors in the fit parameters.
;   ERRORS -- error in the y_values
; 
; REQUIRES:
;  EXPONENTIAL.pro -- See FITFCNS
;
; OUTPUTS:
;   COEFFS -- Coefficients of the powerlaw fit in vector form [a,b];
;
; MODIFICATION HISTORY:
;       Documented.
;       Wed Nov 21 11:49:45 2001, Erik Rosolowsky <eros@cosmic>
;-



  if not keyword_set(guess) then begin
    goodind = where(y gt 0)
    coeffs = linear_fit(x[goodind], alog(y[goodind]))
    guess = [exp(coeffs[0]), coeffs[1]]
  endif
  a = guess
  for i = 0, 3 do begin
    fit = lmfit(x, y, a, $
                measure_errors = errors, /double, sigma = sigma, $
                function_name = 'exponential', conv = conv)
    if conv eq 1 then break
  endfor

  return, a
end
