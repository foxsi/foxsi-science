FUNCTION	INVERSE_RESP, ENERGY, $
	PLOT = plot, NODET = nodet, NOSHUT = noshut, BE_UM = be_um, DET_THICK = det_thick, $
	TYPE = type, NOPATH = nopath, LET_FILE = let_file, $
	DATA_DIR = data_dir, OFFAXIS_ANGLE = offaxis_angle, N_BLANKETS = N_BLANKETS, $
	OFFSET = OFFSET, MODULE = module, FOXSI1 = foxsi1, _EXTRA = _extra, $
	STOP = STOP

;	This routine takes in an energy array and performs the count-to-photon conversion 
;	using the inverse response.  No off-diagonal elements are included,
;	which is ok since the FOXSI response is almost completely diagonal.  Energy smearing
; (i.e. detector energy resolution)	of the photon spectrum is not properly accounted 
; for here.  An iterative	procedure would be necessary for that.
;
;	Returned structure contains the energy array and the inverse response (units cm-2)
;
;	Right now most of the inputs are not used, but reserved for future use.
;
;	History:  Born 7/13/2014 LG.
;						March 2015	LG	Added ability to make use of effarea's MODULE keyword.
;						4/22/2015  LG	Some cleaning

; input an energy array and count spectrum.
; get effective area using the usual function.
; throw in blanketing.
; compute inverse and return.

	default, data_dir, 'calibration_data/'
	default, offaxis_angle, 0.
	default, n_blankets, 1.
	;default, let_file, 'efficiency_averaged.sav'
	default, offset, 0.

	en = energy

	area = get_foxsi_effarea( energy=en, data_dir=data_dir, $
							  offaxis_angle=offaxis, module=module, foxsi1=foxsi1, _extra=_extra )
	
	; Multiply that area by extra blanketing attenuation.
	; Since one set of blankets was already included in the previous call,
	; need to add in n-1 layers.
	if n_blankets gt 1 then begin
		atten = get_blanket_atten( energy=en, factor=n_blankets-1 )
		area.eff_area_cm2 = area.eff_area_cm2 * (offset + (1-offset)*atten.shut_eff)
	endif
	
	if keyword_set(stop) then stop

	return, create_struct("energy_keV", en, "per_cm2", 1./area.eff_area_cm2)

END
