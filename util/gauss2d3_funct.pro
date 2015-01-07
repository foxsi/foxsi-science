function gauss2, x, y, p, _EXTRA=extra

  u = ((x-p(0))/p(2))^2 + ((y-p(1))/p(2))^2
  mask = u LT 100
  f = p(3) * mask * exp(-0.5D * temporary(u) * mask)
  mask = 0

  return, f
end

FUNCTION gauss2d3_funct, x, y, params, gauss1=gauss1, gauss2=gauss2, gauss3=gauss3

; PURPOSE: A multi 2D (elliptical) gaussian fit function. All the gaussian 
;           share the same center and rotation angle.
;
;           F(x,y) = A0 + sum( A1i * EXP( -Ui / 2), i = 1 to 3)
;		        where: Ui = (yp / A2i) ^ 2 + (xp / A3i ) ^ 2
;		                xp = (x-A4) * cos(A6) - (y-A5) * sin(A6)
;		                yp = (x-A4) * sin(A6) + (y-A5) * cos(A6)
;
; PARAMETERS:
;          x - 2D x values
;          y - 2D y values
;          params - the parameters for the gaussians
;               PARAMS[0] - constant, A0
;               PARAMS[1] - X center, A4
;               PARAMS[2] - Y center, A5
;               PARAMS[3] - amplitude for gauss1, A11
;               PARAMS[4] - relative amplitude for gauss2, A12
;               PARAMS[5] - relative amplitude for gauss3, A13
;               PARAMS[6:11] - sigmaX, sigmaY for gauss1 to gauss3, A2(1-3), A3(1-3)
;               PARAMS[12] - angle, A6
;
; WRITTEN: Steven Christe (6-Jun-2014)
;
; REQUIREMENTS:
;           gauss2_funct.pro
;
params = float(params)

constant = params[0]
centerX = params[1]
centerY = params[2]
amplitude = params[3]
rel_amplitude1 = params[4]
rel_amplitude2 = params[5]
sig = params[6:11]
angle = params[12]

params1 = [0, amplitude - rel_amplitude1 - rel_amplitude2, sig[0:1], centerX, centerY, angle]
params2 = [0, amplitude*rel_amplitude1, sig[2:3], centerX, centerY, angle]
params3 = [0, amplitude*rel_amplitude2*rel_amplitude1, sig[4:5], centerX, centerY, angle]

print, params1
print, params2
print, params3

gauss1 = gauss2(x,y, params1)
gauss2 = gauss2(x,y, params2)
gauss3 = gauss2(x,y, params3)

stop

;gauss1 = gauss2_funct(x,y, params1)
;gauss2 = gauss2_funct(x,y, params2)
;gauss3 = gauss2_funct(x,y, params3)

RETURN, gauss1 + gauss2 + gauss3 + constant

END