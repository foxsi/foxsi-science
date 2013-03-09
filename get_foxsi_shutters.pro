FUNCTION get_foxsi_shutters, ENERGY_ARR = energy_arr, PLOT = plot, $
	MYLAR_UM = mylar_um, BE_UM = be_um, AL_UM = al_um, KAPTON_UM = kapton_um, $
	DATA_DIR = data_dir, NONSTD = nonstd

;PURPOSE: Get the FOXSI shutter absorption as a function of energy. 
;			Defining material thicknesses are always added to the 
;			optical path.
;
;	Note from Lindsay:  Running this with default parameters (no inputs for shutters) 
;			just gives you the FOXSI optical path, which is also useful.
;
;KEYWORD: MYLAR_UM - set the thickness of mylar
;         BE_UM - set the thickness of Be
;		  KAPTON_UM - set the thickness of kapton in microns
;		  MYLAR_UM - set the thickness of mylar in microns
;		  ENERGY_ARR - set the energy axis
;		  PLOT - create a plot for the screen
;		  NONSTD - set the optical path material to zero
;
;WRITTEN: Steven Christe (25-Mar-09)
; Updated with nominal flight blanketing defaults, LG March 2013

default, data_dir, './'

; These defaults are the nominal blanket material thicknesses in microns, according to Paul.
; They should be rechecked once payload is entirely disassembled.
default, mylar_um, 82.55
default, al_um, 2.6
default, kapton_um, 203.2
default, be_um, 0.0
default, th_um, [0.0, 0.0, 0.0, 0.0]

; old defaults for previous blanketing scenarios
; default, th_um, [82.6, 0.0, 2.9, 178.0]        

; default, th_um, [140, 0.0, 4.8, 203.0]		
; default, th_um, [95.5, 0.0, 3.2, 203.0]	
; proposed redo
;default, th_um, [140, 0.0, 4.8, 101.5]		
; proposed redo
default, th_um, [95.5, 0.0, 3.2, 101.5]		
; proposed redo
default, mylar_um, 0.0

;template = ascii_template(data_dir + "mylar_atten_len.dat")
;restore, data_dir + "atten_len_template.dat", /verbose
;result = read_ascii(data_dir + "mylar_atten_len.txt", template =template)
;save, result, filename = "mylar_atten_len.dat"

IF keyword_set(NONSTD) THEN th_um = [0.0,0.0,0.0,0.0]

material = ['mylar','Be', 'Al', 'Kapton']
add_um = [mylar_um, be_um, al_um, kapton_um]

total_th_um = th_um + add_um

f = data_dir + ["mylar_atten_len.dat","be_atten_len.dat", "al_atten_len.dat", "kapton_atten_len.dat"]

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
