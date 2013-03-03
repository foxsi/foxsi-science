FUNCTION get_foxsi_deteff, ENERGY_ARR = energy_arr, DET_THICK = det_thick, PLOT = plot, type = type, NO_LET = no_let

;PURPOSE: Get the FOXSI Detector efficiency (Si)
;
;KEYWORD: DET_THICK - set the detector thickness in units of microns.
;
;WRITTEN: Steven Christe (23-Mar-09)
; UPDATED L.G. Sept. 2012

;data_dir = "~/idlsave/foxsi/"
data_dir = "./"
default, type, 'si'

IF NOT keyword_set(det_thick) THEN det_thick_um = 500 ELSE det_thick_um = det_thick

IF ((NOT keyword_set(TYPE)) OR (TYPE EQ 'si')) THEN BEGIN

    restore, data_dir + "si_atten_len.dat" 
    atten_len_um = result.atten_len_um
    energy_keV = result.energy_ev/1000.0
ENDIF ELSE BEGIN

    IF TYPE EQ 'czt' THEN BEGIN 
        ;det thick in file is 1000 um
        restore, data_dir + "czt_xray_data.dat"
        energy_keV = result.energy_keV
        atten_len_um = 1/(result.atten_len_photo_cm)*10000
    ENDIF

    IF TYPE EQ 'cdte' THEN BEGIN 
        restore, data_dir + "cdte_xray_data.dat"
        energy_keV = result.energy_keV
        atten_len_um = 1/(result.atten_len_photo_cm)*10000
    ENDIF

ENDELSE

hsi_linecolors

IF (keyword_set(energy_arr) AND NOT keyword_set(SUM)) THEN BEGIN 
    atten_len_um = interpol(atten_len_um, energy_keV, energy_arr)
ENDIF ELSE energy_arr = energy_keV

det_eff = 1 - exp(-det_thick_um/atten_len_um)


;; added by lindsay

if not keyword_set(no_let) then begin
	
	restore, 'LET_efficiency_flight_detectors_averaged.sav'
	
	let = interpol(efficiency.efficiency, efficiency.energy_keV, energy_arr)
	
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
