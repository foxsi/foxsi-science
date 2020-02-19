FUNCTION get_foxsi_effarea, ENERGY_ARR = energy_arr, MODULE_NUMBER = module_number, $
	PLOT = plot, NODET = nodet, NOSHUT = noshut, BE_UM = be_um, DET_THICK = det_thick, $
	TYPE = type, YEAR = YEAR, NOPATH = nopath, LET_FILE = let_file, $
	DATA_DIR = data_dir, OFFAXIS_ANGLE = offaxis_angle, USE_THEORETICAL = use_theoretical, $
	QUIET = QUIET, _EXTRA = _extra

;PURPOSE: Get the FOXSI effective area 
;
; Note:  this needs modification to get the right "nominal" blanketing for FOXSI-1.
;
;KEYWORD: PER_MODULE - get the area for each module
;			NODET - do not include loss of area due to detector efficiency
;			DET_THICK - set the detector thickness (DEFAULT = 500 um)
;			NOSHUT - do not include a (Be) shutter  (KEYWORD CURRENTLY DISABLED!!!)
;			NOPATH - do not include material in optical path
;			PLOT - plot to the current device
;			BE_UM - set the thickness of a Be shutter
;			TYPE - element of the detector (e.g. cdte, DEFAULT is Si)
;			YEAR - year of the flight. Default is 2014. Other options are 2012 and 2018
;			OFFAXIS_ANGLE:	off-axis angle.  If nonzero, off-axis response routine is called.
;			USE_THEORETICAL:	Use the theoretical values for EA instead of the measured ones.
;					This is what we did for much of the FOXSI-1 analysis, before we had the updated
;					calibration data for FOXSI-2.
;			MODULE_NUMBER - the module number (0 through 6).  if not set, EA for the entire
;					set of optics (all 7) is returned.
;					Detector convention is used for the numbering.
;
;WRITTEN: Steven Christe (20-Mar-09)
;UPDATED: Steven Christe (3-Nov-09)
;UPDATED: Steven Christe (12-Jan-10)
; Updated: LG, 2013-Mar-03
; Updated: LG, 2015 feb to get the optics area from get_foxsi_optics_effarea instead.
;					Also changed keyword to FOXSI-1 instead of FOXSI-2.  Now FOXSI-2 is the default.
; Updated, SM, 2019/12/04 Replaced the FOXSI1 keyword by a YEAR keyword
;				updated the way to call get_foxsi_optics_effarea
;				included options for FOXSI-3
;				added correcting factor for collimator


default, type, 'si'
default, data_dir, 'calibration_data/'
default, offaxis_angle, 0.0
default, year, 2014
;default, let_file, 'efficiency_averaged.sav'

; define optic numbers for each flight, each module (detector) position

foxsi1_optic_modules = [6,1,2,3,4,5,0]
foxsi2_optic_modules = [6,1,2,3,4,5,0]
foxsi3_optic_modules = [8,5,4,1,0,2,7]

collimator_ratio = 0.673

IF NOT keyword_set(DET_THICK) THEN det_thick = 500.0
IF NOT keyword_set(BE_UM) THEN be_um = 0.0

; IF keyword_set(PER_MODULE) THEN num_modules = 1.0 ELSE num_modules = 7.0

if keyword_set(USE_THEORETICAL) then begin

	IF year Eq 2018 THEN print, 'No theoretical value for FOXSI-3. Returns FOXSI-2 theoretical values.'
	restore,  GETENV('FOXSIPKG') + '/' + data_dir + "eff_area_permodules2.dat"
	eff_area = eff_area_permod.eff_area2
	energy = eff_area_permod.energy
	IF year EQ 2012 THEN eff_area = eff_area_permod.eff_area
	if not exist(MODULE_NUMBER) then eff_area = eff_area*7
	if offaxis_angle gt 0 then begin
		offaxis_area = get_foxsi_offaxis_resp( energy_arr=energy_arr, offaxis_angle=offaxis_angle )
		eff_area = eff_area*offaxis_area.factor
	endif

endif else begin

	if exist( module_number ) then begin
		IF year EQ 2012 THEN optic_module = foxsi1_optic_modules[module_number]
		IF year EQ 2014 THEN optic_module = foxsi2_optic_modules[module_number]
		IF year EQ 2018 THEN optic_module = foxsi3_optic_modules[module_number]

		; placeholder for the two new modules on FOXSI-3 - the data is not yet available. 
		IF year EQ 2018 AND (module_number EQ 0 OR module_number EQ 6) THEN optic_module=0

		area = get_foxsi_optics_effarea( energy_arr=energy_arr, module_number=optic_module, $
								offaxis_angle=offaxis_angle, data_dir=data_dir, plot=plot, _extra=_extra )
		energy = area.energy_kev
		eff_area = area.eff_area_cm2
		; take care of 10-shell modules that were 7-shells on FOXSI-1 --> replacing by average over 7-shell modules
		if YEAR EQ 2012 and (module_number eq 6 or module_number eq 2) then $
				eff_area = average_5_optics( energy_arr=energy_arr, offaxis_angle=offaxis_angle, data_dir=data_dir )
		; take care of new 10-shell modules in FOXSI-3: average FOXSI-2 10-shell modules
		if YEAR EQ 2018 and (module_number eq 6 or module_number eq 0) then $
				eff_area = AVERAGE_2_10SHELL_OPTICS( energy_arr=energy_arr, offaxis_angle=offaxis_angle, data_dir=data_dir )
		; take care of collimators on FOXSI-3
		if YEAR EQ 2018 AND (module_number EQ 1 OR module_number EQ 2) then $
			eff_area = eff_area*collimator_ratio
	endif else begin
		IF year EQ 2012 THEN BEGIN
			; sum all optics modules of FOXSI-1. FOR THE 2 7-SHELL modules which became 10-shells in FOXSI-2,
			; need to average the eff area of the other 7 shell data
			optics = foxsi1_optic_modules
			FOR i=0,6 DO BEGIN
				IF (i NE 2) AND (i NE 6) THEN BEGIN
					area = get_foxsi_optics_effarea( energy_arr=energy_arr, module_number=optics[i], $
								offaxis_angle=offaxis_angle, data_dir=data_dir )
					if i eq 0 then energy = area.energy_kev
					if i eq 0 then eff_area = area.eff_area_cm2
					if i gt 0 then eff_area += area.eff_area_cm2
				ENDIF
				; add the effective area for modules 2 and 6
				ten_shell_effarea = average_5_optics( energy_arr=energy_arr, offaxis_angle=offaxis_angle, data_dir=data_dir )
				eff_area += 2*ten_shell_effarea
			ENDFOR
		ENDIF
		IF year EQ 2014 THEN BEGIN 
			optics = foxsi2_optic_modules
			; sum all optics modules of FOXSI-2
			for i=0, 6 do begin
				area = get_foxsi_optics_effarea( energy_arr=energy_arr, module_number=optics[i], $
								offaxis_angle=offaxis_angle, data_dir=data_dir )
				if i eq 0 then energy = area.energy_kev
				if i eq 0 then eff_area = area.eff_area_cm2
				if i gt 0 then eff_area += area.eff_area_cm2
			endfor
		ENDIF
		IF year EQ 2018 THEN BEGIN
			optics = foxsi3_optic_modules
			; sum all optics modules of FOXSI-3. FOR THE 2 new 10-SHELL modules,
			; need to average the eff area of the FOXSI-2 10-shell data
			FOR i=0,6 DO BEGIN
				; exclude the two new 10-shell modules
				IF (i NE 0) AND (i NE 6) THEN BEGIN
					area = get_foxsi_optics_effarea( energy_arr=energy_arr, module_number=optics[i], $
								offaxis_angle=offaxis_angle, data_dir=data_dir )
					; take care of collimator
					IF (i EQ 1 or i EQ 2) THEN area.eff_area_cm2 = area.eff_area_cm2*collimator_ratio
					if i eq 1 then energy = area.energy_kev
					if i eq 1 then eff_area = area.eff_area_cm2
					if i gt 1 then eff_area += area.eff_area_cm2
				ENDIF
				; add an approximation for the 2 new 10-shell modules
				new_10_shell_effarea = AVERAGE_2_10SHELL_OPTICS( energy_arr=energy_arr, offaxis_angle=offaxis_angle, data_dir=data_dir )
				eff_area += 2*new_10_shell_effarea
			ENDFOR
		ENDIF
		
	endelse

endelse


IF keyword_set(energy_arr) THEN BEGIN 
    eff_area_orig = interpol(eff_area, energy, energy_arr)
    eff_area = eff_area_orig
ENDIF ELSE BEGIN 
	energy_arr = energy
	eff_area_orig = eff_area
ENDELSE

;
; Detector efficiency, including low-energy cutoff curve
;

; take care of the fact that we do not have the efficiency curve for phoenix
IF year EQ 2018 and module_number EQ 1 THEN BEGIN
  nodet = 1
  PRINT, 'No data on PHOENIX detector. Returning effective area without detector efficiency.'
endif

IF NOT keyword_set(nodet) THEN BEGIN

	if not keyword_set( LET_FILE ) then begin
		if not keyword_set(module_number) then begin
			print, 'No low-energy threshold file specified, using FOXSI-1 average.'
			let_file = 'efficiency_averaged.sav'
		endif else begin
			if year EQ 2012 then begin
				; 2012 flight
				case module_number of
					0:  let_file = 'efficiency_det108_avg.sav'
					1:  let_file = 'efficiency_det109_avg.sav'
					2:  let_file = 'efficiency_det102_avg.sav'
					3:  let_file = 'efficiency_det103_avg.sav'
					4:  let_file = 'efficiency_det104_avg.sav'
					5:  let_file = 'efficiency_det105_avg.sav'
					6:  let_file = 'efficiency_det106_avg.sav'
				endcase
			endif
			if year EQ 2014 then begin
				; 2014 flight
				if (module_number eq 2 or module_number eq 3) then $
					print, 'Warning: efficiency curve for CdTe dets not done yet!'
				case module_number of
					0:  let_file = 'efficiency_det108_avg.sav'
					1:  let_file = 'efficiency_det101_avg.sav'
					2:  let_file = 'efficiency_averaged.sav'
					3:  let_file = 'efficiency_averaged.sav'
					4:  let_file = 'efficiency_det104_avg.sav'
					5:  let_file = 'efficiency_det105_avg.sav'
					6:  let_file = 'efficiency_det102_avg.sav'
				endcase
			endif
			if year EQ 2018 then begin
				if module_number eq 1 then print, 'Warning: no HXR data for detector 1 in 2018!'
				if (module_number eq 5 or module_number eq 3) then $
					print, 'Warning: efficiency curve for CdTe dets not done yet!'
				; 2018 flight
				case module_number of
					0:  let_file = 'efficiency_det105_avg.sav'
					2:  let_file = 'efficiency_det106_avg.sav'
					3:  let_file = 'efficiency_averaged.sav'
					4:  let_file = 'efficiency_det102_avg.sav'
					5:  let_file = 'efficiency_averaged.sav'
					6:  let_file = 'efficiency_det101_avg.sav'
				endcase
			endif
		endelse
	endif
			
    det_eff = get_foxsi_deteff(energy_arr = energy_arr, _EXTRA = _EXTRA, $
    		  det_thick = det_thick, type = type, data_dir = data_dir, let_file = let_file)
    eff_area = eff_area*det_eff.det_eff

ENDIF

;
; Blanketing transmission
;

;add in the various materials already in the optical path
IF NOT keyword_set(nopath) THEN BEGIN
	optical_path = get_foxsi_shutters(energy_arr = energy_arr, data_dir = data_dir, _EXTRA = _EXTRA)    
	eff_area = eff_area*optical_path.shut_eff
ENDIF

;IF NOT keyword_set(noshut) THEN BEGIN
;    shut_eff = get_foxsi_shutters(energy_arr = energy_arr, be_um = be_um, /nonstd, data_dir = data_dir, _EXTRA = _EXTRA)    
;    eff_area = eff_area*shut_eff.shut_eff
;ENDIF


IF keyword_set(PLOT) THEN BEGIN

	plot, energy_arr, eff_area_orig, psym = -4, $
		xtitle = "Energy [keV]", ytitle = "Effective Area [cm!U2!N]", charsize = 1.5, /xstyle, xrange = [min(energy_arr), max(energy_arr)], _EXTRA = _EXTRA, /nodata
		
	;xyouts, 0.6, 0.85, 'Optics', /normal, charsize = 1.5
	
	txt = ['Optics', '+Optical Path']
	oplot, energy_arr, eff_area_orig, psym = -4, color = 7
	oplot, energy_arr, eff_area, psym = -4, color = 6
    ssw_legend, txt, textcolor = [7,6], /right
    
    ;xyouts, 0.6, 0.8, num2str(det_thick, length = 5) +  " " + textoidl("\mum") + " Si detector", charsize = 1.5, color = 6, /normal
        
    ;IF NOT keyword_set(NOPATH) THEN xyouts, 0.7, 0.85, 'Optical path', /normal, color = 6, charsize = 1.5
    ;IF (NOT keyword_set(NOSHUT) AND (be_um NE 0.0)) THEN $
    ;      xyouts, 0.6, 0.70, num2str(be_um, length = 5) + " " + textoidl("\mum") + ' Be', charsize = 1.5, color = 6, /normal
ENDIF

res = create_struct("energy_keV", energy_arr, "eff_area_cm2", eff_area)

RETURN, res

END
