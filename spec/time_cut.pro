FUNCTION	TIME_CUT, DATA, Ti, Tf, GOOD=GOOD, YEAR=YEAR, ENERGY=ENERGY, STOP=STOP

;	This function takes in FOXSI level 2 data and returns a clipped version
;	corresponding only to the specified timerange.
;
;	INPUTS:
;		DATA:		FOXSI level 2 data structure
;		T0:		start of time range (in seconds-of-day OR seconds-since launch) 
;		T1:		end of time range (in seconds-of-day OR seconds-since launch)
;		GOOD:		returns only the data with no error flags
;		YEAR:		2012 or 2014, default 2014
;		ENERGY:		Restrict to energy range defined by this 2-element array
	
	COMMON FOXSI_PARAM

	if keyword_set(good) then begin
		cut = where(data.error_flag eq 0)
		if cut[0] ne -1 then data_mod = data[ cut ] else return, -1
	endif else data_mod = data
=======
	if keyword_set(good) then data_mod = data[ where(data.error_flag eq 0) ] $
		else data_mod = data
	
	; Allow for the possibility that the user has input times in seconds-of-day or in 
	; seconds-since-launch.
	if ti lt t_launch then ti_mod = ti + t_launch else ti_mod = ti
	if tf lt t_launch then tf_mod = tf + t_launch else tf_mod = tf
	
	cut = where( data_mod.wsmr_time ge ti_mod and data_mod.wsmr_time lt tf_mod )
	if cut[0] ne -1 then data_mod = data_mod[ cut ] else return, -1
	
	if keyword_set( energy ) then begin
		cut = where( data_mod.hit_energy[1] ge energy[0] and data_mod.hit_energy[1] lt energy[1] )
		if cut[0] ne -1 then data_mod = data_mod[ cut ] else return, -1
	endif

	if keyword_set( STOP ) then stop

	return, data_mod
	
END
	
	
