FUNCTION FOXSI_LIVE_CORRECT, FOXSI_COUNTS, TIME, STOP=STOP

	; scales a simulated spectrum by the estimated livetimes for the given count rates.
	;
	; FOXSI_COUNTS is an input structure with tags energy_kev, counts, and count_error
	; TIME is the time interval (in seconds) over which the counts are measured. (important for getting count RATES)
	; output is the same with the count rates and errors scaled appropriately.

	energy = foxsi_counts.energy_kev
	counts = foxsi_counts.counts/time
	error = foxsi_counts.count_error

	n = n_elements(counts)
	;deadtime = dblarr(n)	; empty array to hold avg deadtime array
	new_counts = fltarr(n)	; empty array for new count rate array
	frame_dt = 0.002*6./7.;-0.0008	; frame time is 2 ms.  subtract 1/7 time for frame R/O and 800 us for ASIC R/O.
	rate_tot = total(counts[where(counts gt 0)])

	;for i=0, n-1 do begin
	
	deadtime = frame_dt - 1./rate_tot + 1./rate_tot*exp((-1)*rate_tot*frame_dt)

	;endfor

	livetime = frame_dt - deadtime

	new_counts = counts*livetime/0.002

	new_foxsi_counts = foxsi_counts
	new_foxsi_counts.counts = new_counts*time
	new_foxsi_counts.count_error = sqrt(new_counts*time)

	if keyword_set(stop) then stop

	return, new_foxsi_counts

END