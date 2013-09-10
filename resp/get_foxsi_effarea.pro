FUNCTION get_foxsi_effarea, ENERGY_ARR = energy_arr, PER_MODULE = per_module, $
	PLOT = plot, NODET = nodet, NOSHUT = noshut, BE_UM = be_um, DET_THICK = det_thick, $
	TYPE = type, FOXSI2 = FOXSI2, NOPATH = nopath, LET_FILE = let_file, $
	DATA_DIR = data_dir, OFFAXIS_ANGLE = offaxis_angle, _EXTRA = _extra

;PURPOSE: Get the FOXSI effective area 
;
;KEYWORD: PER_MODULE - get the area for each module
;			NODET - do not include loss of area due to detector efficiency
;			DET_THICK - set the detector thickness (DEFAULT = 500 um)
;			NOSHUT - do not include a (Be) shutter
;			NOPATH - do not include material in optical path
;			PLOT - plot to the current device
;			BE_UM - set the thickness of a Be shutter
;			TYPE - element of the detector (e.g. cdte, DEFAULT is Si)
;			FOXSI2 - get the effective area for the updated FOXSI2 (3 extra inner shells)
;			OFFAXIS_ANGLE:	off-axis angle.  If nonzero, off-axis response routine is called.
;
;WRITTEN: Steven Christe (20-Mar-09)
;UPDATED: Steven Christe (3-Nov-09)
;UPDATED: Steven Christe (12-Jan-10)
; Updated: LG, 2013-Mar-03

default, type, 'si'
default, data_dir, 'detector_data/'
default, offaxis_angle, 0.0
default, let_file, 'efficiency_averaged.sav'

;my_linecolors

;restore, data_dir + "eff_area_permodules.dat"
restore, data_dir + "eff_area_permodules2.dat"

IF keyword_set(PER_MODULE) THEN num_modules = 1.0 ELSE num_modules = 7.0

IF NOT keyword_set(DET_THICK) THEN det_thick = 500.0
IF NOT keyword_set(BE_UM) THEN be_um = 0.0

result = eff_area_permod
eff_area = eff_area_permod.eff_area
IF keyword_set(FOXSI2) THEN eff_area = eff_area_permod.eff_area2

energy = eff_area_permod.energy

IF keyword_set(energy_arr) THEN BEGIN 
    eff_area_orig = interpol(eff_area, energy, energy_arr)
    eff_area = eff_area_orig
ENDIF ELSE BEGIN 
	energy_arr = energy
	eff_area_orig = eff_area
ENDELSE

IF NOT keyword_set(nodet) THEN BEGIN
    det_eff = get_foxsi_deteff(energy_arr = energy_arr, _EXTRA = _EXTRA, $
    		  det_thick = det_thick, type = type, data_dir = data_dir, let_file = let_file)
    eff_area = eff_area*det_eff.det_eff
ENDIF

;add in the various materials already in the optical path
IF NOT keyword_set(nopath) THEN BEGIN
	optical_path = get_foxsi_shutters(energy_arr = energy_arr, data_dir = data_dir, _EXTRA = _EXTRA)    
	eff_area = eff_area*optical_path.shut_eff
ENDIF

IF NOT keyword_set(noshut) THEN BEGIN
    shut_eff = get_foxsi_shutters(energy_arr = energy_arr, be_um = be_um, /nonstd, data_dir = data_dir, _EXTRA = _EXTRA)    
    eff_area = eff_area*shut_eff.shut_eff
ENDIF

IF NOT keyword_set(PER_MODULES) THEN eff_area = num_modules * eff_area
;load the measured effective area
;restore, foxsi_effarea.dat
;effarea = replicate(1, 

if offaxis_angle gt 0 then begin
	offaxis_area = get_foxsi_offaxis_resp( energy_arr=energy_arr, offaxis_angle=offaxis_angle )
	eff_area = eff_area*offaxis_area.factor
endif

IF keyword_set(PLOT) THEN BEGIN

	plot, energy_arr, num_modules*eff_area_orig, psym = -4, $
		xtitle = "Energy [keV]", ytitle = "Effective Area [cm!U2!N]", charsize = 1.5, /xstyle, xrange = [min(energy_arr), max(energy_arr)], _EXTRA = _EXTRA, /nodata
		
	;xyouts, 0.6, 0.85, 'Optics', /normal, charsize = 1.5
	
	txt = ['Optics', '+Optical Path']
	oplot, energy_arr, num_modules*eff_area_orig, psym = -4, color = 7
	oplot, energy_arr, eff_area, psym = -4, color = 6
    legend, txt, textcolor = [7,6], /right
    
    ;xyouts, 0.6, 0.8, num2str(det_thick, length = 5) +  " " + textoidl("\mum") + " Si detector", charsize = 1.5, color = 6, /normal
        
    ;IF NOT keyword_set(NOPATH) THEN xyouts, 0.7, 0.85, 'Optical path', /normal, color = 6, charsize = 1.5
    ;IF (NOT keyword_set(NOSHUT) AND (be_um NE 0.0)) THEN $
    ;      xyouts, 0.6, 0.70, num2str(be_um, length = 5) + " " + textoidl("\mum") + ' Be', charsize = 1.5, color = 6, /normal
ENDIF

res = create_struct("energy_keV", energy_arr, "eff_area_cm2", eff_area)

RETURN, res

END
