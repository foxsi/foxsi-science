FUNCTION	foxsi_lc, data, dt=dt, stop=stop, good=good, energy=energy, year=year, $
					start_time=start_time, end_time=end_time
					
;	Produces a FOXSI lightcurve given a FOXSI level2 data structure.
;	
; INPUTS:
;
;	DATA:		FOXSI level 2 data structure
;	DT:		time bin size (in seconds), default is 10 sec
;	GOOD:		Only return events with error_flag eq 0
;	ENERGY:		Restrict to energy range defined by this 2-element array, default is [4.,15.] keV
;	YEAR:		2012 or 2014, default is 2014
;	START_TIME:	start of time interval (in seconds-since-launch) 
;	END_TIME:	end of time interval (in seconds-since-launch)
;
; History:
;		Created routine sometime in 2014!  LG
;		Jan 2015  Updated for FOXSI-2 flight.
;		March 12 2015	LG	Added START_TIME and END_TIME keywords so that array sizes can be controlled.
;
; Example:
;
	
	default, dt, 10		; default time step is 10 sec
	default, energy, [4.,15.]
	default, year, 2014

	; perform cuts.
	data_mod = data
	if keyword_set(good) then data_mod = data_mod[ where( data_mod.error_flag eq 0 ) ]
	if keyword_set(energy) then $
		data_mod = data_mod[ where( data_mod.hit_energy[1] ge energy[0] and $
									data_mod.hit_energy[1] lt energy[1] ) ]
	
	nEvts = n_elements(data_mod)
	
	if year eq 2014 then restore,'data_2014/flight2014-parameters.sav' $
			else restore, 'data_2012/flight2012-parameters.sav'
	
	; determine time range
	times = data_mod.wsmr_time
	t1 = times[0]
	t2 = times[nEvts-1]
	
	; If start and end times are set, use those instead.
	if keyword_set( start_time ) then t1 = start_time + t_launch
	if keyword_set( end_time )   then t2 = end_time   + t_launch	
	
	nInt = fix( (t2 - t1) / dt )
	if nInt eq 0 then begin
		nInt = 1
		dt = t2-t1
	endif
	
	;time_array = times[0] + dt*findgen(nInt+1)
	time_array = t1 + dt*findgen(nInt+1)
	lc = fltarr( nInt )

	for i=0, nInt-1 do begin
		j = where( data_mod.wsmr_time ge time_array[i] and $
				   data_mod.wsmr_time lt time_array[i+1] )
		if j[0] gt -1 then lc[i] = n_elements(j)	
	endfor
	
	time_mean = get_edges(time_array,/mean)
	
	CASE year OF
		2012: date = '2012-nov-02'
		2014: date = '2014-dec-11'
	ENDCASE
	curve=create_struct('time',anytim(date)+time_mean[0],'persec', double(lc[0])/dt)
	curve = replicate(curve, nInt)
	curve.time = anytim(date)+time_mean
	curve.persec = float(lc)/dt
	
	if keyword_set(stop) then stop
	
	return, curve

END
