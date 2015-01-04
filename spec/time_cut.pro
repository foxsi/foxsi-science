FUNCTION	TIME_CUT, DATA, T0, T1, GOOD=GOOD

	; This function takes in FOXSI level 2 data and returns a clipped version
	; corresponding only to the specified timerange.  T0 and T1 should be in anytim
	; seconds.  /GOOD returns only the data with no error flags.
	
	if keyword_set(good) then data_mod = data[ where(data.error_flag eq 0) ] $
		else data_mod = data
		
	i = where( data_mod.wsmr_time ge t0 and data_mod.wsmr_time lt t1 )
	
	return, data_mod[i]
	
END
	
	