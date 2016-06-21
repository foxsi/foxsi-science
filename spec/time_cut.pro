FUNCTION	TIME_CUT, DATA, Ti, Tf, GOOD=GOOD, YEAR=YEAR, energy=energy, stop=stop

	; This function takes in FOXSI level 2 data and returns a clipped version
	; corresponding only to the specified timerange.  T0 and T1 should be in anytim
	; seconds.  /GOOD returns only the data with no error flags.
	
	COMMON FOXSI_PARAM
	if keyword_set(good) then data_mod = data[ where(data.error_flag eq 0) ] $
		else data_mod = data
	
	; Allow for the possibility that the user has input times in seconds-of-day or in 
	; seconds-since-launch.
	if ti lt t_launch then ti_mod = ti + t_launch else ti_mod = ti
	if tf lt t_launch then tf_mod = tf + t_launch else tf_mod = tf
		
	data_mod = data_mod[ where( data_mod.wsmr_time ge ti_mod and data_mod.wsmr_time lt tf_mod ) ]
	
	if keyword_set( energy ) then $
		data_mod = data_mod[ where( data_mod.hit_energy[1] ge energy[0] and data_mod.hit_energy[1] lt energy[1] ) ]

	if keyword_set( STOP ) then stop

	return, data_mod
	
END
	
	