FUNCTION foxsi_error_flags, data, trange

;
; PURPOSE: 	Determine where and how often error flags occur in a flight 
; 		data structure during a give time interval.
;
; INPUT:
;	DATA: 	level 1 or 2 data structure
;       TRANGE: time range to consider (seconds from launch)
;
; OUTPUT:
;	Structure containing the number of triggered events, number of good events,
;	number of times each error flag occurs, and index for each error flag (showing
;	where error flags occur in data structure).
;
; NOTES:
;	ERROR FLAGS:
;	Bit 0:  Any CM value > 1023
;	Bit 1:  All zero ADC data from one side (either n or p)
;	Bit 2:  p-side CM is 0 (can't use value for spectroscopy)
;	Bit 3:  Detector voltage possibly not settled (applies for ~40 sec after HV 
;		ramp finishes and at end, when HV ramp down starts)
;	Bit 4:  CM > highest ADC for that ASIC. (This mostly duplicates bit 0 error.)
;	Bit 5:  Signal location is within 3 strips from detector edge.
;	Bit 6:  Livetime value out of range ([1,2000] us)
;
;	The error flags are stored in both the level 1 and level 2 data, so either 
;	can be used.
;	
; EXAMPLE:
;	foxsi, 2014
;	error = foxsi_error_flags(data_lvl2_d6,[t4_start,t4_end]) 
;
; HISTORY:	
;	Apr 2020	Created by Julie Vievering
;		 

COMMON FOXSI_PARAM

trange = trange+tlaunch

; consider data in selected time range
i = where((data.wsmr_time gt trange[0]) and (data.wsmr_time lt trange[1]))
n_events = n_elements(data[i])	;number of events in time range 

; consider good data in time range
i2 = where((data.wsmr_time gt trange[0]) and (data.wsmr_time lt trange[1]) and (data.error_flag eq 0))
n_good = n_elements(data[i2])	;number of good events in time range

; create array to store number of times that each error flag occurs
flags = intarr(7)

; Determine where in the data array each error flag occurs and record how many times.
; The index for the occurrence of each error is stored in a list called "index". 
for k=0,6 do begin
	if k eq 0 then begin
		index = list(where((data.wsmr_time gt trange[0]) and (data.wsmr_time lt trange[1]) and (data.error_flag.bitget(k) eq 1),/null))
	endif else begin
		index.add, where((data.wsmr_time gt trange[0]) and (data.wsmr_time lt trange[1]) and (data.error_flag.bitget(k) eq 1),/null)
	endelse
	flags[k] = n_elements(index[k])
endfor

; Print information about good events and error flags
print, 'Number of events', n_events
print, 'Good events', n_good
for k=0,6 do begin
	print, 'Bit '+strtrim(k,2)+' errors', flags[k]
endfor

events = create_struct('events',n_events,'good_events', n_good, 'flags', flags,'index',index)

return, events 

end
