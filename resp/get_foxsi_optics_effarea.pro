FUNCTION get_foxsi_optics_effarea, ENERGY_ARR = energy_arr, MODULE_NUMBER = module_number, $
    OFFAXIS_ANGLE = offaxis_angle, PLOT = plot, _EXTRA = _extra, INT_FACTOR = int_factor

;PURPOSE: Get the FOXSI optics effective area in cm^2 as a function of energy
;           and off-axis angle.
;
;KEYWORD:   MODULE_NUMBER - the module number (0 through 6).  Detector convention is used.
;			PLOT - plot to the current device
;			OFFAXIS_ANGLE - off-axis angle. if array then [pan, tilt] in arcmin
;           ORIG_DATA - return the original data structure
;
;WRITTEN: Steven Christe (21-Jan-15)
;	modified:	LG	2015 Feb	Switched X0->D6 and X6->D0
;   

COMMON foxsi, t0, data, data_dir, calibration_data_path, data_file, name, sparcs, flight_data, $
    optic_effarea

default, offaxis_angle, [0.0, 0.0]
default, module_number, 1
; this factor controls how the data is integrated to decrease the error bars
default, int_factor, 4     

CASE module_number of
    0: effective_area = optic_effarea.module0
    1: effective_area = optic_effarea.module1
    2: effective_area = optic_effarea.module2
    3: effective_area = optic_effarea.module3
    4: effective_area = optic_effarea.module4
    5: effective_area = optic_effarea.module5
    6: effective_area = optic_effarea.module6
ENDCASE

angles = effective_area.angles
nangles = n_elements(angles)
nenergies = n_elements(effective_area.energy)

IF n_elements(offaxis_angle) EQ 1 THEN angle = 1/sqrt(2) * [offaxis_angle, offaxis_angle] $
    ELSE angle = offaxis_angle		

energies = effective_area.energy
IF int_factor NE 1 THEN BEGIN
    nenergies = floor(nenergies / int_factor) * int_factor
    ndim = nenergies / int_factor

    ;chop the size of the energy bins to accomodate int_factor
    interpol_pan = effective_area.pan[*, 0:nenergies-1]
    interpol_tilt = effective_area.tilt[*, 0:nenergies-1]
    interpol_pan_err = effective_area.pan_error[*, 0:nenergies-1]
    interpol_tilt_err = effective_area.tilt_error[*, 0:nenergies-1]

    ;now rebin which averages the entries
    energies = rebin(energies[0:nenergies-1], ndim)

    interpol_pan = rebin(interpol_pan, nangles, ndim)
    interpol_tilt = rebin(interpol_tilt, nangles, ndim)
    ; now rebin the errors
    interpol_pan_err = fltarr(nangles, ndim)
    interpol_tilt_err = fltarr(nangles, ndim)
    FOR angle_index = 0, nangles-1 DO BEGIN
        FOR i = 0, ndim-2 DO BEGIN
            interpol_pan_err[i] = sqrt(total(effective_area.pan_error[angle_index, (i*int_factor):(i+1)*int_factor]^2))/float(int_factor)
            interpol_tilt_err[i] = sqrt(total(effective_area.tilt_error[angle_index, (i*int_factor):(i+1)*int_factor]^2))/float(int_factor)
        ENDFOR
    ENDFOR
    nenergies = ndim
ENDIF ELSE BEGIN
    interpol_pan = effective_area.pan
    interpol_tilt = effective_area.pan
    interpol_pan_err = effective_area.pan_error
    interpol_tilt_err = effective_area.tilt_error
    energies = effective_area.energy
ENDELSE

IF keyword_set(energy_arr) THEN BEGIN
    ; interpolate data on new energies    
    FOR i = 0, nangles-1 DO BEGIN
            interpol_pan[i, *] = interpol(interpol_pan[i, *], energies, energy_arr)
            interpol_pan_error[i, *] = interpol(interpol_pan_err[i, *], energies, energy_arr)
            interpol_tilt[i, *] = interpol(interpol_tilt[i, *], energies, energy_arr)
            interpol_tilt_error[i, *] = interpol(interpol_tilt_err[i, *], energies, energy_arr)
    ENDFOR
ENDIF ELSE energy_arr = energies

rnorm = sqrt(angle[0] ^ 2 + angle[1] ^ 2)
IF rnorm EQ 0 THEN BEGIN 
    rnorm = 1
    phi = !PI/4
    sign = [1, 1]
ENDIF ELSE BEGIN
    phi = atan(abs(angle[1]), abs(angle[0]))
    sign = (abs(angle)+1) / abs(abs(angle)+1)
ENDELSE

pan = fltarr(nenergies)
tilt = fltarr(nenergies)
pan_err = fltarr(nenergies)
tilt_err = fltarr(nenergies)

; now interpolate into the correct angle
FOR i = 0, n_elements(energy_arr)-1 DO BEGIN
    pan[i] = interpol(interpol_pan[*, i], angles, sign[0] * rnorm)
    tilt[i] = interpol(interpol_tilt[*, i], angles, sign[1] * rnorm)
    pan_err[i] = interpol(interpol_pan_err[*, i], angles, sign[0] * rnorm)
    tilt_err[i] = interpol(interpol_tilt_err[*, i], angles, sign[1] * rnorm)
ENDFOR

; now interpolate between pan and tilt
r = pan + (tilt - pan) / !pi/2. * phi

; this is definitely wrong!
err = pan_err + (tilt_err - pan_err) / !pi/2. * phi

; something is wrong with the errors :(

IF keyword_set(PLOT) THEN BEGIN
	plot, energy_arr, reform(r), psym = -4, $
		xtitle = "Energy [keV]", ytitle = "Effective Area [cm!U2!N]", $
		charsize = 1.5, /xstyle, xrange = [min(energy_arr), max(energy_arr)], $
		_EXTRA = _EXTRA, /nodata
	oplot, energy_arr, reform(r), psym = -4
	oploterr, energy_arr, reform(r), reform(err), psym = -4
	ssw_legend, 'pan, tilt = [' + num2str(angle[0]) + ',' + num2str(angle[1]) + ']'
ENDIF

data = effective_area
result = create_struct("energy_keV", energy_arr, "eff_area_cm2", reform(r), "eff_area_cm2_error", reform(err))

RETURN, result

END