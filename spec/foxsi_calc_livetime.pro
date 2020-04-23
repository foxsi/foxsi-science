FUNCTION foxsi_calc_livetime, data, trange

;
; PURPOSE:
; 	Calculate the total livetime for given time interval during a FOXSI flight.
;
; INPUT:
;	DATA: 	level 1 data structure (can also use level 2 data if updated to 
;		include livetime)
;	TRANGE: time range to consider (seconds from launch)
;
; OUTPUT:
;	total livetime in seconds
;
; NOTES:
;	For empty frames (no trigger), about 1/7 of the frame is dead time
;	(see Lindsay's dissertation for additional details). This is used to approximate 
;	the livetime for an empty frame when calculating the total livetime. 
;
;	The function for producing level 2 data (foxsi_level1_to_level2.pro) was changed 
;	in Dec 2019 to carry over livetime from level 1 to level 2 data. If the level 2 
;	data on your computer has not yet been updated to include the livetime, either 
;	make these updates or use the level 1 data.   
;
; EXAMPLE:
;	foxsi, 2014
;	restore,'foxsi_level1_data.sav' 	; provide personal path to this file 
;	ltime = foxsi_calc_livetime(data_lvl1_d6, [t4_start, t4_end])
;
; HISTORY:
;	Apr 2020	Created by Julie Vievering 
;

COMMON FOXSI_PARAM

trange = trange+tlaunch

; consider data in selected time interval
i = where((data.wsmr_time gt trange[0]) and (data.wsmr_time lt trange[1]))

; consider good data in selected time interval
i2 = where((data.wsmr_time gt trange[0]) and (data.wsmr_time lt trange[1]) and (data.error_flag eq 0))

nframes_tot = max(data[i].frame_counter) - min(data[i].frame_counter) + 1	;total number of frames in time interval
nframes_dat = n_elements(data[i])	; number of frames with a trigger in time interval
nframes_good = n_elements(data[i2])	; number of good frames with a trigger in time interval
nframes_empty = nframes_tot - nframes_dat	;frames without a trigger

good_evt_frac = float(nframes_good) / nframes_dat

; Give error message if using a data file that does not include the livetime.
if total(data[i2].livetime) eq 0. then begin
	print, 'ERROR: All livetimes are equal to zero. Please use level 1 data or update level 2 data.'
	return, !NULL
endif

; Calculate the total livetime (in microseconds) in the time interval.
; In this calculation, the livetime for bad frames and the preceding empty frames is set to zero. 
livetime_us = total(data[i2].livetime) + (good_evt_frac*nframes_empty*(6./7)*2000.)

;Convert livetime to seconds
livetime = livetime_us*1.e-6

return, livetime

end
