FUNCTION get_foxsi_deteff, ENERGY_ARR = energy_arr, DET_THICK = det_thick, PLOT = plot, $
	type = type, NO_LET = no_let, DATA_DIR = data_dir, LET_FILE = let_file

; PURPOSE: Get the FOXSI Detector efficiency
;
; KEYWORD: 
;	ENERGY_ARR:	energy array (keV)
;	DET_THICK:	set the detector thickness in units of microns
; 	LET_FILE:	file containing low-energy-threshold efficiency
;	PLOT:		creates a plot of detector efficiency vs. energy
;	TYPE: 		detector type ('si', 'czt', or 'cdte')
;	DATA_DIR:	directory where efficiency files located
;	NOT_LET:	set keyword to exclude LET trigger efficiency 	
;
; WRITTEN: Steven Christe (23-Mar-09)
; UPDATED L.G. Sept. 2012
; UPDATED J.V. July 2018 : include absorption by Pt and Au layers for CdTe efficiency

default, data_dir, 'calibration_data/'
default, let_file, 'efficiency_averaged.sav'
default, type, 'si'

if not keyword_set(no_let) and not keyword_set(let_file) then begin
	print, 'No low-energy threshold file defined.'
	return, -1
endif ;else print, 'Using low-energy threshold file ', let_file

IF NOT keyword_set(det_thick) THEN det_thick_um = 500 ELSE det_thick_um = det_thick

IF (type ne 'si') and (type ne 'cdte') and (type ne 'czt') then begin
        print, 'ERROR: Detector type not allowed! Please choose si, cdte, or czt.'
        return, -1
ENDIF

IF ((NOT keyword_set(TYPE)) OR (TYPE EQ 'si')) THEN BEGIN

    restore, GETENV('FOXSIPKG')+'/'+data_dir + "si_atten_len.dat" 
    atten_len_um = result.atten_len_um
    energy_keV = result.energy_ev/1000.0
ENDIF ELSE BEGIN

    IF TYPE EQ 'czt' THEN BEGIN 
        ;det thick in file is 1000 um
        restore, GETENV('FOXSIPKG')+'/'+data_dir + "czt_xray_data.dat"
        energy_keV = result.energy_keV
        atten_len_um = 1/(result.atten_len_photo_cm)*10000
    ENDIF

    IF TYPE EQ 'cdte' THEN BEGIN 

	;attenuation length for CdTe
        restore, GETENV('FOXSIPKG')+'/'+data_dir + "cdte_atten_len.dat"
        energy_keV = result.energy_eV/1000.
        atten_len_um = result.atten_len_um

;        restore, '$FOXSIPKG'+'/'+data_dir + "cdte_xray_data.dat"       ;alternate file for absorption info
;        energy_keV = result.energy_keV
;        atten_len_um = 1/(result.atten_len_photo_cm)*10000

	;attenuation length for Au electrodes
	restore, GETENV('FOXSIPKG')+'/'+data_dir + "au_atten_len.dat"
	energy_keV_au = data.energy_ev/1000. 
	atten_len_um_au = data.atten_len_um
	au_thick_um = 0.1 

	;attenuation length for Pt electrodes
	restore, GETENV('FOXSIPKG')+'/'+data_dir + "pt_atten_len.dat"
	energy_keV_pt = data.energy_ev/1000.
	atten_len_um_pt = data.atten_len_um
	pt_thick_um = .05

	IF (keyword_set(energy_arr) AND NOT keyword_set(SUM)) THEN BEGIN
    		atten_len_um_au = interpol(atten_len_um_au, energy_keV_au, energy_arr)
		atten_len_um_pt = interpol(atten_len_um_pt, energy_keV_pt, energy_arr)
	ENDIF ELSE energy_arr = energy_keV 
    ENDIF

ENDELSE

hsi_linecolors

IF (keyword_set(energy_arr) AND NOT keyword_set(SUM)) THEN BEGIN 
    atten_len_um = interpol(atten_len_um, energy_keV, energy_arr)
ENDIF ELSE energy_arr = energy_keV

;If considering a CdTe detector, include effects of aborption by Pt & Au electrodes
if type eq 'cdte' then begin
	elec = ((5./6)*exp(-au_thick_um/atten_len_um_au)*exp(-pt_thick_um/atten_len_um_pt))+(1./6)
	det_eff = (1 - exp(-det_thick_um/atten_len_um))*elec 
endif else begin
	det_eff = 1 - exp(-det_thick_um/atten_len_um)
endelse

;; added by lindsay

if not keyword_set(no_let) then begin
	
	restore, GETENV('FOXSIPKG')+'/'+data_dir + let_file
	if is_struct(efficiency) then begin
		let = interpol(efficiency.efficiency, efficiency.energy_keV, energy_arr)

	endif else let = interpol(efficiency, findgen(100)/10., energy_arr)
	det_eff = det_eff*let

endif

IF keyword_set(PLOT) THEN BEGIN
    plot, energy_arr, det_eff, xtitle = 'Energy [keV]', ytitle = 'Detector Efficiency', $
          /nodata, yrange = [0.0, 1.0], charsize = 1.5
    oplot, energy_arr, det_eff, psym = -4, color = 6
    legend, ['thickness = ' + num2str(det_thick_um, length = 5) + ' ' + textoidl('\mum')], psym = 4, /right
ENDIF

result = create_struct("energy_keV", energy_arr, "det_eff", det_eff)

RETURN, result

END
