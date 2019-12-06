FUNCTION get_foxsi_shutters, ENERGY_ARR = energy_arr, PLOT = plot, $
	MYLAR_UM = mylar_um, BE_UM = be_um, AL_UM = al_um, KAPTON_UM = kapton_um, $
	DATA_DIR = data_dir, NONSTD = nonstd

;PURPOSE: Get the FOXSI shutter/blanketing absorption as a function of energy. 
;			
;	Note from Lindsay:  Running this with default parameters (no inputs for shutters) 
;			just gives you the FOXSI optical path, which is also useful.
;
;KEYWORD: 	
;	MYLAR_UM - set the thickness of mylar (default for FOXSI-2)
;       BE_UM - set the thickness of Be (default, 0.0)
;	KAPTON_UM - set the thickness of kapton in microns (default for FOXSI-2)
;	AL_UM - set the thickness of Al in microns (default for FOXSI-2)
;	ENERGY_ARR - set the energy axis
;	PLOT - create a plot for the screen
;	NONSTD - set the optical path material to zero
;
; FOXSI-1 Values:
;	mylar - 139.7 um
;	al - 4.8 um
; 	kapton - 203.2 um
;
; FOXSI-2 Values:
;	mylar - 76.2 um
;	al - 2.5 um
;	kapton - 50.8 um
;
; FOXSI-3 Values:
;	mylar - 76.2 um
;	al - 2.4 um
;	kapton - 0.0 um
;
;
;WRITTEN: Steven Christe (25-Mar-09)
; Updated with nominal flight blanketing defaults, LG March 2013
; Updated with values for FOXSI-3, JV January 2019

default, data_dir, './'

default, be_um, 0.0

; FOXSI-2 defaults:
default, mylar_um, 76.2
default, al_um, 2.5
default, kapton_um, 50.8

material = ['mylar','Be', 'Al', 'Kapton']
total_th_um = [mylar_um, be_um, al_um, kapton_um]

IF keyword_set(NONSTD) THEN total_th_um = [0.0,0.0,0.0,0.0]

f = GETENV('FOXSIPKG')+'/'+data_dir + ["mylar_atten_len.dat","be_atten_len.dat", "al_atten_len.dat", "kapton_atten_len.dat"]

FOR i = 0, n_elements(f)-1 DO BEGIN

    restore, f[i]

    IF keyword_set(energy_arr) THEN BEGIN 
        atten_len_um = interpol(result.atten_len_um, result.energy_eV/1000.0, energy_arr)
    ENDIF ELSE BEGIN
        energy_arr = result.energy_eV/1000.0
        atten_len_um =  result.atten_len_um
    ENDELSE

    IF i EQ 0.0 THEN shut_eff = exp(-total_th_um[i]/atten_len_um) ELSE shut_eff = exp(-total_th_um[i]/atten_len_um)*shut_eff

	; if values get too small
	;
	index = where(shut_eff LE 1d-30, count)
	IF ((count NE 0) AND (min(index) NE 0)) THEN BEGIN
		tmp = findgen(min(index))
		shut_eff[tmp] = 0.0
	ENDIF

ENDFOR

IF keyword_set(PLOT) THEN BEGIN
    plot, energy_arr, shut_eff, xtitle = 'Energy [keV]', ytitle = 'Transmission', $
          /nodata, yrange = [0.0, 1.0], charsize = 1.5
    oplot, energy_arr, shut_eff, psym = -4, color = 6
    
    text = strarr(4)
    FOR i = 0, 4-1 DO IF add_um[i] EQ 0.0 THEN text[i] = material[i] + ' ' + num2str(th_um[i], length = 5) + ' ' + textoidl("\mum") ELSE text[i] = material[i] + ' ' + num2str(th_um[i], length = 5) + '+' + num2str(add_um[i], length = 5) + ' ' + textoidl("\mum")
   
   	legend, text, /left
   
ENDIF

result = create_struct("energy_keV", energy_arr, "shut_eff", shut_eff)

RETURN, result

END
