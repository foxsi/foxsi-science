;+
; This function reads in a White Sands data file (*.log) and processes it
; into Level 0 FOXSI data.  The function is intended for use with the 
; data file from the first flight on 2012 Nov 2, but should work for other
; WSMR data files too.  More documentation is available in the FOXSI
; data description doc.
;
; Inputs:	FILENAME	File to process.  Must be a WSMR .log file.
;
; Keywords:	DETECTOR	Detector number (0-6).  Each detector data
;						must be processed individually.  Default D0
;			YEAR		Specify 2012, 2014 or 2018. This is a temporary fix while we
;						wait for altitude data for FOXSI-2.
;
; To process flight data into Level 0 IDL structures and save them:
;
;	filename = 'data_2012/36.255_TM2_Flight_2012-11-02.log'
; 	data_lvl0_D0 = wsmr_data_to_level0( filename, det=0 )
; 	data_lvl0_D1 = wsmr_data_to_level0( filename, det=1 )
; 	data_lvl0_D2 = wsmr_data_to_level0( filename, det=2 )
; 	data_lvl0_D3 = wsmr_data_to_level0( filename, det=3 )
; 	data_lvl0_D4 = wsmr_data_to_level0( filename, det=4 )
; 	data_lvl0_D5 = wsmr_data_to_level0( filename, det=5 )
; 	data_lvl0_D6 = wsmr_data_to_level0( filename, det=6 )
;	save, data_lvl0_D0, data_lvl0_D1, data_lvl0_D2, data_lvl0_D3, $
;		data_lvl0_D4, data_lvl0_D5, data_lvl0_d6, $
;		file = 'data_2012/foxsi_level0_data.sav'
;
; History:	
;		2019-Oct-15	Sophie	Delete the default selection of filename. If we want a selection of the filename, 
;						we can change this input into a keyword and select the filename using the year keyword
;					Added file option for FOXSI-3
;		2015-feb-2	Linz	Changed default to 2014 flight, and fixed a bug in the wsmr_time tag
;											that was interpreting milliseconds incorrectly.
;		2015-Dec	Linz	Updated to work for 2014 data too.
;		2013-Feb-13	Linz	Fixed altitude glitch and shifted "inflight" flag to 70 seconds later.
;		2013-Feb-07	Linz	Updated structure name and added altitude data
;		2013-Jan-20	Linz	Created routine
;-

FUNCTION	WSMR_DATA_TO_LEVEL0, FILENAME, DETECTOR=DETECTOR, STOP=STOP, YEAR=YEAR

	add_path, 'util/'
	default, year, 2014

	case year of
    		2012: t_launch = 64500
    		2014: t_launch = 69060
    		2018: t_launch = 62460
  	endcase
	
	wsmr_frame_length = 259						; 256 words (our data) + 3 WSMR time words

	; Read in data file.
	openr, lun, filename, /get_lun
	frame = read_binary(lun, data_dims=-1, data_type=2)		; read in integers
	frame = uint(frame)  						; cast to unsigned
	nFrames = n_elements(frame)/259
	frame = reform(frame,[wsmr_frame_length,nFrames])		; reshape into a frame-by-frame array.
	close, lun							; no longer need the file.

	; The next section pulls the detector data into a structure and 
	; is a little similar to the earlier FOXSI calibration
	; processing codes (specifically formatter_packet_b.pro)

  	; prepare the data structure and make an array with one element for each frame.
  	print, '  Creating data structure.'
  	data_struct = {foxsi_level0, $
		frame_counter:ulong(0),	$	; formatter frame counter value, 32 bits
   		wsmr_time:double(0.),  	$	; WSMR ground station time, to milliseconds
		frame_time:ulong64(0), 	$	; formatter frame time, 64 bits
		det_num:uint(0),	$	; same for all frames; from input keyword
		trigger_time:uint(0), 	$	; raw trigger time value, 16 bits
		hit_asic:intarr(2)-1, 	$	; which ASIC is likely hit, [p,n]
		hit_strip:uintarr(2), 	$	; strip with highest ADC value, [p,n]
		hit_adc:uintarr(2), 	$	; highest ADC value, [p,n]
		strips:uintarr(4,3),	$	; 4x3 array of strips with recorded data
		adc:uintarr(4,3), 	$	; 4x3 array of recorded ADC values
		common_mode:uintarr(4), $	; CM value for each ASIC
		channel_mask:ulon64arr(4), $	; channel mask for each ASIC, 1 bit per strip
		HV:uint(0),		$	; detector bias voltage value, with status bits
		temperature:uint(0),	$	; raw A/D thermistor value if exists
		inflight:uint(0),	$	; '1' if frame occurred post-launch (for flight data only!)
		altitude:float(0),	$	; altitude data
		error_flag:uint(0)	$	; '1' if obvious error is noticed in that frame's data
                }
    	data_struct = replicate(data_struct, nFrames)

    	print, '  Filling in header info.'
    	data_struct.frame_counter = reform( ishft( ulong(frame[7,*]),16 ) + frame[8,*] )
    	data_struct.frame_time = reform( ishft( ulong64(frame[4,*]),32 ) + ishft( ulong64(frame[5,*]),16 ) + frame[6,*] )
    	data_struct.det_num = detector
    	data_struct.trigger_time = reform( frame[26 + 33*detector, *] )

    	; Decode WSMR time (seconds of day).
	; Note that including the MSB of the time (from the frame word 2) is not strictly necessary
	; since this value is zero for our entire flight.  However, it's done anyway for 
	; completeness.
	frame = ulong64(frame)
	seconds = reform( frame[1,*] + ishft(ishft(frame[2,*],-15),16) )
	mil = frame[2,*] mod 2^10
	mic = frame[3,*] mod 2^10
	data_struct.wsmr_time = double(seconds) + mil/1.d3 + mic/1.d6

	; temporary arrays to grab data during loops
	adc_array = uintarr(4,3,nFrames)
	strip_array = uintarr(4,3,nFrames)

	print, '  Filling in ADC values.'
    	for i=0, 3 do begin
       		print, '    ASIC ', i
          	index = 31 + 33*detector + 8*i + [0,1,2]
          	strip = ishft(frame[index,*],-10)
		adc_array[i,*,*] = frame[index,*] - ishft(strip,10)
		strip_array[i,*,*] = strip
    	endfor

	data_struct.adc = adc_array
	data_struct.strips = strip_array

	asic = indgen(4)

    	; Grab the common mode
    	data_struct.common_mode = frame[34 + 33*detector + 8*asic,*]

	; Grab the channel mask
    	data_struct.channel_mask = frame[30 + 33*detector + 8*asic,*]
    	data_struct.channel_mask = ishft( data_struct.channel_mask, 16) + frame[29 + 33*detector + 8*asic,*]
    	data_struct.channel_mask = ishft( data_struct.channel_mask, 16) + frame[28 + 33*detector + 8*asic,*]
    	data_struct.channel_mask = ishft( data_struct.channel_mask, 16) + frame[27 + 33*detector + 8*asic,*]


;;;	This section is not used since the common mode will not be used in this level analysis. 
;;;	Reserve it for later use.
;	; find "hit" asics and strips.  First subtract the common mode (only for calculation; CM is
;	; NOT subtracted in the stored data.
;	; construct a CM cube that can be subtracted from the ADC cube.
;	cm = transpose( [[[data_struct.common_mode]],[[data_struct.common_mode]],[[data_struct.common_mode]]], [0,2,1] )
;	sub = fix(data_struct.adc) - fix(cm)
;	;;;; THIS STEP REQUIRES CMAPPLY.PRO ;;;;
;	n_max = cmapply('max', sub[0:1,*,*], [1,2])
;	p_max = cmapply('max', sub[2:3,*,*], [1,2])

	;;;;;;
	; Identify the "hit" (i.e. max ADC value) on p-side and n-side.  
	; Save the ADC value, ASIC, and strip # for each side.
	;;;;;;

	print, "  Identifying hits."

	; Identify max for each ASIC in each frame.
	max0 = cmapply('max', data_struct.adc[0,*], [2])
	max1 = cmapply('max', data_struct.adc[1,*], [2])
	max2 = cmapply('max', data_struct.adc[2,*], [2])
	max3 = cmapply('max', data_struct.adc[3,*], [2])
	
	; Identify which ASIC had the global max on each side.
	; ASICs 0 and 2 automatically win any tie. (arbitrary)
	ind_0 = where( max0 ge max1 and max0 gt 0 )
	ind_1 = where( max1 gt max0 )
	ind_2 = where( max2 ge max3 and max2 gt 0)
	ind_3 = where( max3 gt max2 )
	
	; Identify the hit ASIC (if any!) for each frame.
	; Hit ASIC values were initialized to -1.  After this step, any entries still at -1 did not get a hit.
	data_struct[ind_0].hit_asic[0] = 0
	data_struct[ind_1].hit_asic[0] = 1
	data_struct[ind_2].hit_asic[1] = 2
	data_struct[ind_3].hit_asic[1] = 3

	; Fill in hit ADC values for p and n side.
	data_struct[ind_0].hit_adc[0] = max0[ind_0]
	data_struct[ind_1].hit_adc[0] = max1[ind_1]
	data_struct[ind_2].hit_adc[1] = max2[ind_2]
	data_struct[ind_3].hit_adc[1] = max3[ind_3]

	; Hit strip /should/ always be the middle one in the 3-strip data, so grab the middle strip#s
	data_struct[ind_0].hit_strip[0] = data_struct[ind_0].strips[0,1]
	data_struct[ind_1].hit_strip[0] = data_struct[ind_1].strips[1,1]
	data_struct[ind_2].hit_strip[1] = data_struct[ind_2].strips[2,1]
	data_struct[ind_3].hit_strip[1] = data_struct[ind_3].strips[3,1]

	; But account for the possibility that it's not!
	for i_asic=0, 3 do begin

		if i_asic gt 1 then n_p = 1 else n_p = 0	; 0 for n-side ASIC, 1 for p-side

		; replace with the first strip# where needed.
		glitch = where( data_struct.adc[i_asic,0] gt data_struct.adc[i_asic,1] and data_struct.hit_adc[n_p] eq i_asic )
		if glitch[0] gt -1 then data_struct[glitch].hit_strip[n_p] = data_struct[glitch].strips[i_asic,0]  	

		; replace with the last strip# where needed.
		glitch = where( data_struct.adc[i_asic,2] gt data_struct.adc[i_asic,1] and data_struct.hit_adc[n_p] eq i_asic )
		if glitch[0] gt -1 then data_struct[glitch].hit_strip[n_p] = data_struct[glitch].strips[i_asic,2]
	
		; If both the first and third strip are greater than the middle strip and are equal to each other, 
		; the third strip is arbitrarily designated the hit strip.
	
	endfor
	
	; extract housekeeping data
	print, "  Getting housekeeping data."
	data_struct.HV = reform( frame[16,*] )
	hskp0 = reform( frame[9,*] )
	hskp1 = reform( frame[13,*] )
	hskp2 = reform( frame[17,*] )
	hskp3 = reform( frame[21,*] )

	; See McBride's formatter packet description for an explanation of the decoding.
	therm6 = hskp2[where(data_struct.frame_counter mod 4 eq 2)]
	therm7 = hskp3[where(data_struct.frame_counter mod 4 eq 2)]
	;  therm8 = hskp0[where(data_struct.frame_counter mod 4 eq 3)]		; disfunctional! Not used.
	therm9 = hskp1[where(data_struct.frame_counter mod 4 eq 3)]
	;  therm10 = hskp2[where(data_struct.frame_counter mod 4 eq 3)]  	; on focal plane, not used here.
	therm11 = hskp3[where(data_struct.frame_counter mod 4 eq 3)]

	; Each temperature value only shows up once every fourth frame.  Allow values to leak
	; into neighboring frames so that we have one value per frame.
	; Series of frames at beginning where frame_counter is zero are also added in.
	; THIS MAY CAUSE PROBLEMS IF THERE ARE DROPOUTS MIDFRAME! (These are not well
	; accounted for in this code.
	i_nonzero = where(data_struct.frame_counter gt 0)
	temp6 = reform( transpose([ [therm6],[therm6],[therm6],[therm6] ]), 4*n_elements(therm6) )
	temp6 = [uint(i_nonzero[0]),temp6]
	i_diff = n_elements(data_struct) - n_elements(temp6)
	if i_diff gt 0 then temp6 = [temp6, uintarr(i_diff)]
	if i_diff lt 0 then temp6 = temp6[0:n_elements(data_struct)-1]
	temp7 = reform( transpose([ [therm7],[therm7],[therm7],[therm7] ]), 4*n_elements(therm7) )
	temp7 = [uint(i_nonzero[0]),temp7]
	i_diff = n_elements(data_struct) - n_elements(temp7)
	if i_diff gt 0 then temp7 = [temp7, uintarr(i_diff)]
	if i_diff lt 0 then temp7 = temp7[0:n_elements(data_struct)-1]
	temp9 = reform( transpose([ [therm9],[therm9],[therm9],[therm9] ]), 4*n_elements(therm9) )
	temp9 = [uint(i_nonzero[0]),temp9]
	i_diff = n_elements(data_struct) - n_elements(temp9)
	if i_diff gt 0 then temp9 = [temp9, uintarr(i_diff)]
	if i_diff lt 0 then temp9 = temp9[0:n_elements(data_struct)-1]
	temp11 = reform( transpose([ [therm11],[therm11],[therm11],[therm11] ]), 4*n_elements(therm11) )
	temp11 = [uint(i_nonzero[0]),temp11]
	i_diff = n_elements(data_struct) - n_elements(temp11)
	if i_diff gt 0 then temp11 = [temp11, uintarr(i_diff)]
	if i_diff lt 0 then temp11 = temp11[0:n_elements(data_struct)-1]

	; Pick out correct temperature:
	if detector eq 1 then data_struct.temperature = temp7
	if detector eq 3 then data_struct.temperature = temp9
	if detector eq 4 then data_struct.temperature = temp11
	if detector eq 6 then data_struct.temperature = temp6
	; If detector is 0, 2, or 5 then temperature values remain zero.

	; Identify which events occurred after HV upramp and before HV downramp, or "in flight"
	; Do this only if the file is the flight data file.
	; Post-ramp events will have a '1' in the 'inflight' tag.
	if strmatch(filename,'*36.255_TM2_Flight_2012-11-02.log') eq 1 $
		or strmatch(filename,'*36_295_Krucker_FLIGHT_HOT_TM2.log') eq 1 $
		or strmatch(filename,'*36_325_Glesener_FLIGHT_HOT_TM2.log') eq 1 $
	 	then begin
		print, "  File is flight data.  Flagging post-launch events."
		data_struct[ where( ishft(data_struct.hv,-4)/8 gt 190  ) ].inflight = 1
	endif else print, "FILE DOES NOT CONTAIN FLIGHT DATA!"

	if year eq 2012 then begin
		; Get altitude data from text file
		data_alt=read_ascii('data_2012/36255.txt')
		time_alt = data_alt.field01[1,*] + t_launch	; adjust altitude clock for time of launch.
		altitude = data_alt.field01[9,*]

		; altitude data cadence is 2 Hz; formatter data cadence is 500 Hz
		; So resize the altitude data by repeating values.
		; I don't like the way "interpol" interpolates this, and I think the 
		; "discrete" step nature is good so that you can see the real
		; resolution of the altitude data.
	
		i_flight = long(0)
		for i=long(0), nFrames-1 do begin
			if data_struct[i].wsmr_time lt 64500 then continue
			data_struct[i].altitude = altitude[i_flight/250]
			i_flight++;
		endfor
	endif

	; Compress data by getting rid of "zero" frames.  If a detector's trigger time
	; is 0, then the frame is empty for that detector.  However, to not lose any
	; data (even if it's bad), here frames are only thrown away if all data is 0
	; except ASIC 3 common mode.  (ASIC 3 common mode should usually be nonzero.)

	print, "  Deleting zero frames."

	; Find the max value of all 33 words per detector in the frame.
	; If max value is zero, then the frame is empty for this detector.
	max_frame = cmapply('max', frame[ 26+33*detector:57+33*detector, *], [1])
	data_struct_compressed = data_struct[ where( max_frame gt 0 ) ]

	; Last step: check for obvious errors and flag these.
	; Errors include:
	;    -- Common mode value greater than 1023

	print, "  Checking data and flagging abnormalities."
	; Check for events where *any* common mode > 1023
	cm_max = cmapply('max', data_struct_compressed.common_mode, [1] )
	data_struct_compressed[ where( cm_max gt 1023 ) ].error_flag = 1

	if keyword_set(stop) then stop

	print, "  Done!"

	return, data_struct_compressed

END

