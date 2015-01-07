FUNCTION	INVERSE_RESP, ENERGY, PER_MODULE = per_module, $
	PLOT = plot, NODET = nodet, NOSHUT = noshut, BE_UM = be_um, DET_THICK = det_thick, $
	TYPE = type, FOXSI2 = FOXSI2, NOPATH = nopath, LET_FILE = let_file, $
	DATA_DIR = data_dir, OFFAXIS_ANGLE = offaxis_angle, N_BLANKETS = N_BLANKETS, $
	OFFSET = OFFSET, _EXTRA = _extra

;	This routine takes in an energy array and performs the count-to-photon conversion 
;	using the inverse response.  No off-diagonal elements are included,
;	which is ok since the FOXSI response is almost completely diagonal.  Energy smearing
;	of the photon spectrum, however, is not properly accounted for here.  An iterative
;	procedure is necessary for that.
;
;	Returned structure contains the energy array and the inverse response (units cm-2)
;
;	Right now most of the inputs are not used, but reserved for future use.
;
;	History:  Born 7/13/2014 LG.

; input an energy array and count spectrum.
; get effective area using the usual function.
; throw in blanketing.
; compute inverse and return.

	default, data_dir, 'calibration_data/'
	default, offaxis_angle, 0
	default, n_blankets, 1
	default, foxsi2, 0
	default, let_file, 'efficiency_averaged.sav'
	default, per_module, 0

	en = energy

	area = get_foxsi_effarea( energy=en, data_dir=data_dir, let_file=let_file , $
							  offaxis_angle=offaxis, foxsi2=foxsi2, per=per )
	
	; Multiply that area by extra blanketing attenuation.
	; Since one set of blankets was already included in the previous call,
	; need to add in n-1 layers.
	if n_blankets gt 1 then begin
		atten = get_blanket_atten( energy=en, factor=n_blankets-1 )
		area.eff_area_cm2 = area.eff_area_cm2 * (offset + (1-offset)*atten.shut_eff)
	endif

	return, create_struct("energy_keV", en, "per_cm2", 1./area.eff_area_cm2)

END