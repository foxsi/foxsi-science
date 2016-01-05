FUNCTION	TIME_CUT, DATA, T0, T1, GOOD=GOOD, YEAR=YEAR, energy=energy, stop=stop

	; This function takes in FOXSI level 2 data and returns a clipped version
	; corresponding only to the specified timerange.  T0 and T1 should be in anytim
	; seconds.  /GOOD returns only the data with no error flags.
	
	default, year, 2014
	
	case year of
		2012:	restore, 'data_2012/flight2012-parameters.sav'
		2014:	restore, 'data_2014/flight2014-parameters.sav'
		else: begin
			print, 'Year can only be 2012 or 2014.'
			return, -1
		end
	endcase

	if keyword_set(good) then data_mod = data[ where(data.error_flag eq 0) ] $
		else data_mod = data
	
	; Allow for the possibility that the user has input times in seconds-of-day or in 
	; seconds-since-launch.
	if t0 lt t_launch then t0_mod = t0 + t_launch else t0_mod = t0
	if t1 lt t_launch then t1_mod = t1 + t_launch else t1_mod = t1
		
	data_mod = data_mod[ where( data_mod.wsmr_time ge t0_mod and data_mod.wsmr_time lt t1_mod ) ]
	
	if keyword_set( energy ) then $
		data_mod = data_mod[ where( data_mod.hit_energy[1] ge energy[0] and data_mod.hit_energy[1] lt energy[1] ) ]

	if keyword_set( STOP ) then stop

	return, data_mod
	
END
	
	