FUNCTION get_foxsi_optics_effarea, ENERGY_ARR = energy_arr, MODULE_NUMBER = module_number, $
	OFFAXIS_ANGLE = offaxis_angle, DATA_DIR = data_dir, PLOT = plot, _EXTRA = _extra, YEAR = year

;PURPOSE:   Get the FOXSI optics effective area in cm^2 as a function of energy
;           and off-axis angle.
;
;KEYWORD:   MODULE_NUMBER - the module number (0 through 8).  Optic number is used, this is DIFFERENT FROM THE DETECTOR NUMBER.
;			      PLOT - plot to the current device
;			      OFFAXIS_ANGLE - off-axis angle. if array then [pan, tilt] in arcmin
;			      YEAR - year of the FOXSI launch. It can be: 2012, 2014 or 2018. If not set, COMMON DATE will be used instead.
;
;WRITTEN: Steven Christe (21-Jan-15)
;	modified:	LG	2015 Feb	Switched X0->D6 and X6->D0
;	modified:	SM	2019 Dec	Switched to optic module numbers instead of detector position
; modified: MB  2020 Jan  Differenciate among the three foxsi flights using the DATE keyword.
;               2020 Feb  Add a YEAR keyword that can be used when the user don't want to load all FOXSI COMMON variables.

default, data_dir, 'calibration_data/'
default, offaxis_angle, [0.0, 0.0]
default, module_number, 0

IF n_elements(offaxis_angle) EQ 1 THEN angle = 1/sqrt(2) * [offaxis_angle, offaxis_angle] $
ELSE angle = offaxis_angle

IF KEYWORD_SET(YEAR) THEN BEGIN
  IF ((YEAR EQ 2012) OR (YEAR EQ 2014) OR (YEAR EQ 2018)) THEN BEGIN
    ; foxsi1 :
    IF (YEAR EQ 2012) THEN BEGIN
      IF (WHERE(MODULE_NUMBER EQ [0,1,2,3,4,5,6]) NE -1) THEN BEGIN
        files =  GETENV('FOXSIPKG') + '/' + data_dir + 'FOXSI2_' + ['Module_X-' + num2str(MODULE_NUMBER) + '_EA_pan.txt', $
                 'Module_X-' + num2str(MODULE_NUMBER) + '_EA_tilt.txt'] ; for foxsi1 we used the same EA files as for foxsi2.
      ENDIF ELSE PRINT, 'Invalid Module_number for FOXSI1. Chose one of 0,1,2,3,4,5 or 6.'
    ENDIF
    ; foxsi2 :
    IF YEAR EQ 2014 THEN BEGIN
      IF (WHERE(MODULE_NUMBER EQ [0,1,2,3,4,5,6]) NE -1) THEN BEGIN
        files =  GETENV('FOXSIPKG') + '/' + data_dir + 'FOXSI2_' + ['Module_X-' + num2str(MODULE_NUMBER) + '_EA_pan.txt', $
                 'Module_X-' + num2str(MODULE_NUMBER) + '_EA_tilt.txt']
      ENDIF ELSE PRINT, 'Invalid Module_number for FOXSI2. Chose one of 0,1,2,3,4,5 or 6.'
    ENDIF
    ; foxsi3 :
    IF YEAR EQ 2018 THEN BEGIN
      IF (WHERE(MODULE_NUMBER EQ [0,1,2,4,5]) NE -1) THEN BEGIN
        files =  GETENV('FOXSIPKG') + '/' + data_dir + 'FOXSI2_' + ['Module_X-' + num2str(MODULE_NUMBER) + '_EA_pan.txt', $
                 'Module_X-' + num2str(MODULE_NUMBER) + '_EA_tilt.txt']
      ENDIF ELSE BEGIN
        IF (WHERE(MODULE_NUMBER EQ [7,8]) NE -1) THEN BEGIN
          files =  GETENV('FOXSIPKG') + '/' + data_dir + 'FOXSI3_' + ['Module_X-' + num2str(MODULE_NUMBER) + '_EA_pan.txt', $
                   'Module_X-' + num2str(MODULE_NUMBER) + '_EA_tilt.txt']
        ENDIF ELSE PRINT, 'Invalid Module_number for FOXSI3. Chose one of 0,1,2,4,5,7 or 8.'
      ENDELSE
    ENDIF
  ENDIF ELSE BEGIN
    PRINT, 'YEAR has an illegal value.'
  ENDELSE
ENDIF ELSE BEGIN
  ; If YEAR is not set then COMMON DATE will be used to know wich FOXSI flight the user is working with. 
  IF FOXSI_PARAM EQ !NULL THEN BEGIN
    print,'Please initialize the FOXSI common parameter or provide the year of the flight via the YEAR keyword'
    return, -1
  ENDIF
  COMMON FOXSI_PARAM ; allows access to the FOXSI COMMON variables.
  default, datefoxsi1, anytim('2012-nov-02') ; FOXSI1 Launch Date
  default, datefoxsi2, anytim('2014-dec-11') ; FOXSI2 Launch Date
  default, datefoxsi3, anytim('2018-sep-7')  ; FOXSI3 Launch Date  
  IF ((DATE EQ datefoxsi1) OR (DATE EQ datefoxsi2) OR (DATE EQ datefoxsi3)) THEN BEGIN
    ; foxsi1 :
    IF (DATE EQ datefoxsi1) THEN BEGIN
      IF (WHERE(MODULE_NUMBER EQ [0,1,2,3,4,5,6]) NE -1) THEN BEGIN
        files =  GETENV('FOXSIPKG') + '/' + data_dir + 'FOXSI2_' + ['Module_X-' + num2str(MODULE_NUMBER) + '_EA_pan.txt', $
                 'Module_X-' + num2str(MODULE_NUMBER) + '_EA_tilt.txt'] ; for foxsi1 we used the same EA files as for foxsi2.
      ENDIF ELSE PRINT, 'Invalid Module_number for FOXSI1. Chose one of 0,1,2,3,4,5 or 6.'
    ENDIF
    ; foxsi2 :
    IF DATE EQ datefoxsi2 THEN BEGIN
      IF (WHERE(MODULE_NUMBER EQ [0,1,2,3,4,5,6]) NE -1) THEN BEGIN
        files =  GETENV('FOXSIPKG') + '/' + data_dir + 'FOXSI2_' + ['Module_X-' + num2str(MODULE_NUMBER) + '_EA_pan.txt', $
                 'Module_X-' + num2str(MODULE_NUMBER) + '_EA_tilt.txt']
      ENDIF ELSE PRINT, 'Invalid Module_number for FOXSI2. Chose one of 0,1,2,3,4,5 or 6.'
    ENDIF
    ; foxsi3 :
    IF DATE EQ datefoxsi3 THEN BEGIN
      IF (WHERE(MODULE_NUMBER EQ [0,1,2,4,5]) NE -1) THEN BEGIN
        files =  GETENV('FOXSIPKG') + '/' + data_dir + 'FOXSI2_' + ['Module_X-' + num2str(MODULE_NUMBER) + '_EA_pan.txt', $
                 'Module_X-' + num2str(MODULE_NUMBER) + '_EA_tilt.txt']
      ENDIF ELSE BEGIN
        IF (WHERE(MODULE_NUMBER EQ [7,8]) NE -1) THEN BEGIN
          files =  GETENV('FOXSIPKG') + '/' + data_dir + 'FOXSI3_' + ['Module_X-' + num2str(MODULE_NUMBER) + '_EA_pan.txt', $
                   'Module_X-' + num2str(MODULE_NUMBER) + '_EA_tilt.txt']
        ENDIF ELSE PRINT, 'Invalid Module_number for FOXSI3. Chose one of 0,1,2,4,5,7 or 8.'
      ENDELSE
    ENDIF
  ENDIF ELSE BEGIN
    PRINT, 'You MUST either set the YEAR variable or load FOXSI, YEAR to make this routine work.'
  ENDELSE
ENDELSE

; Switch X0->D6 and X6->D0 - we do not need this now that we follow the optic number convention
;if MODULE_NUMBER eq 0 then MODULE = 6 else if MODULE_NUMBER eq 6 then MODULE = 0 $
;		else MODULE = MODULE_NUMBER

energy = [4.5,  5.5,  6.5,  7.5,  8.5,  9.5, 11. , 13. , 15. , 17. , 19. , 22.5, 27.5]; all effarea use same energy bins
angles = READ_ASCII(files[0], DATA_START=3, NUM_RECORDS=1, DELIMITER=","); angles provided by the data files themselves

FOR i = 0, n_elements(files)-1 DO BEGIN
    ; the following code fills all effare into the data array variable
    IF i EQ 0 THEN data = fltarr(2, n_elements(angles.field01), n_elements(energy))
    FOR j = 0, n_elements(energy)-1 DO BEGIN
      dummy = READ_ASCII(files[i], DATA_START=4+j, NUM_RECORDS=1, DELIMITER=",");dummy var needed to pass field01
      data[i, *, j] = dummy.field01
    ENDFOR
ENDFOR

IF keyword_set(energy_arr) THEN BEGIN
    interpol_data = fltarr(2, n_elements(data[0, *, 0]), n_elements(energy_arr))
    ; interpolate data on new energies    
    FOR j = 0, 2 - 1 DO BEGIN
        FOR i = 0, n_elements(angles.field01)-1 DO BEGIN
            eff_area = data[j, i, *]
            interpol_data[j, i, *] = interpol(eff_area, energy, energy_arr)
        ENDFOR
    ENDFOR
ENDIF ELSE BEGIN 
    interpol_data = data
    energy_arr = energy
ENDELSE

rnorm = sqrt(angle[0] ^ 2 + angle[1] ^ 2)
IF rnorm EQ 0 THEN phi = 0 ELSE phi = atan(abs(angle[1] / angle[0]) )

; now interpolate to the requested off-axis angle
eff_area = fltarr(2, n_elements(energy_arr))


FOR j = 0, 2 - 1 DO FOR i = 0, n_elements(energy_arr)-1 DO BEGIN
    eff_area[j, i] = interpol(interpol_data[j, *, i], angles.field01, rnorm)
ENDFOR

; now interpolate between pan and tilt
m = (eff_area[1, *] - eff_area[0, *]) / !pi/2. 
result = eff_area[0, *] + m * phi
eff_area = result

IF keyword_set(PLOT) THEN BEGIN
	plot, energy_arr, reform(eff_area), psym = -4, $
		xtitle = "Energy [keV]", ytitle = "Effective Area [cm!U2!N]", charsize = 1.5, /xstyle, xrange = [min(energy_arr), max(energy_arr)], _EXTRA = _EXTRA, /nodata
	oplot, energy_arr, reform(eff_area), psym = -4
	ssw_legend, 'pan, tilt = [' + num2str(angle[0]) + ',' + num2str(angle[1]) + ']'
ENDIF

result = create_struct("energy_keV", energy_arr, "eff_area_cm2", eff_area)

RETURN, result

END
