FUNCTION	foxsi_lc, data, dt=dt, stop=stop, good=good, energy=energy, year=year

	;	produces a FOXSI lightcurve given a FOXSI level2 data structure.
	;	DT is the time interval.  Constant for entire curve.
	
	; sample call:
	; get_target_data, 4, d0,d1,d2,d3,d4,d5,d6, /good 
	
	default, dt, 10		; default time step is 10 sec
	default, energy, [4.,15.]

	; perform cuts.
	data_mod = data
	if keyword_set(good) then data_mod = data_mod[ where( data_mod.error_flag eq 0 ) ]
	if keyword_set(energy) then $
		data_mod = data_mod[ where( data_mod.hit_energy[1] gt energy[0] and $
									data_mod.hit_energy[1] lt energy[1] ) ]
	
	nEvts = n_elements(data_mod)
	
	; determine time range
	times = data_mod.wsmr_time
	t1 = times[0]
	t2 = times[nEvts-1]
	
	nInt = fix( (t2 - t1) / dt )
	if nInt eq 0 then begin
		nInt = 1
		dt = t2-t1
	endif
	
	time_array = times[0] + dt*findgen(nInt+1)
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