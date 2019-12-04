;+
; This function reads in a White Sands data file (*.log) and processes it
; into Level 0 FOXSI **housekeeping** data.  The function is intended for use with the 
; data file from the first flight on 2012 Nov 2, but should work for other
; WSMR data files too.  More documentation is available in the FOXSI
; data description doc.
;
; THIS FUNCTION IS FOR HOUSEKEEPING DATA! If detector data is desired,
; use wsmr_data_to_level0.pro
;
; Inputs:
;
; Keywords:	
;		FILENAME	File to process. Must be a WSMR .log file.
;		YEAR	Year of the flight. Options are: 2012, 2014, 2018
;
; Example:
;
; To process WSMR files into Level 0 housekeeping IDL structures and save them:
;
;	filename = 'data_2012/36.255_TM2_Flight_2012-11-02.log'
; 	hskp_data = wsmr_data_to_hskp_level0( filename )
;	save, hskp_data, file = 'data_2012/foxsi_level0_hskp_data.sav'
;
; History:	
;		2019-Oct-16	Sophie	Change Filename to a keyword, add year keyword, and selection of files for FOXSI2 and FOXSI3	
;		2013-Jan-28	Linz	Created routine
;-

FUNCTION	WSMR_DATA_TO_HSKP_LEVEL0, FILENAME=filename, YEAR=YEAR, STOP=STOP

	IF not keyword_set(filename) then begin
		case year of
   			2012: filename = 'data_2012/36.255_TM2_Flight_2012-11-02.log'
    			2014: filename = 'data_2014/36_295_Krucker_FLIGHT_HOT_TM2.log'
    			2018: filename = 'data_2018/36_325_Glesener_FLIGHT_HOT_TM2.log'
  		endcase
	ENDIF
	
	wsmr_frame_length = 259						; 256 words (our data) + 3 WSMR time words

	; Read in data file.
	openr, lun, filename, /get_lun
	frame = read_binary(lun, data_dims=-1, data_type=2)		; read in integers
	frame = uint(frame)  						; cast to unsigned
	nFrames = n_elements(frame)/259
	frame = reform(frame,[wsmr_frame_length,nFrames])		; reshape into a frame-by-frame array.
	close, lun							; no longer need the file.


  	; prepare a housekeeping data structure and make an array with one element for each frame.
  	print, '  Creating data structure.'
  	data_struct = {housekeeping, 	$
		frame_counter:ulong(0),	$	; formatter frame counter value, 32 bits
               	wsmr_time:double(0.),  	$	; WSMR ground station time, to milliseconds
		frame_time:ulong64(0), 	$	; formatter frame time, 64 bits
		HV:uint(0),		$	; detector bias voltage value, with status bits
		t_ref:uint(0),		$	; reference temperature, every 4th frame
		v_5pos:uint(0),		$	; +5V value, every 4th frame
		v_5neg:uint(0),		$	; -5V value, every 4th frame
		v_33:uint(0),		$	; 3.3V value, every 4th frame
		v_15:uint(0),		$	; 1.5V value, every 4th frame
		therm1:uint(0),		$	; raw A/D thermistor 1 value, every 4th frame
		therm2:uint(0),		$	; raw A/D thermistor 2 value, every 4th frame
		therm3:uint(0),		$	; raw A/D thermistor 3 value, every 4th frame
		therm4:uint(0),		$	; raw A/D thermistor 4 value, every 4th frame
		therm5:uint(0),		$	; raw A/D thermistor 5 value, every 4th frame
		therm6:uint(0),		$	; raw A/D thermistor 6 value, every 4th frame
		therm7:uint(0),		$	; raw A/D thermistor 7 value, every 4th frame
		therm8:uint(0),		$	; raw A/D thermistor 8 value, every 4th frame
		therm9:uint(0),		$	; raw A/D thermistor 9 value, every 4th frame
		therm10:uint(0),	$	; raw A/D thermistor 10 value, every 4th frame
		therm11:uint(0),	$	; raw A/D thermistor 11 value, every 4th frame
		cmd_count:uint(0),	$	; command counter
		command1:uint(0),	$	; last sent command (first part)
		command2:uint(0),	$	; last sent command (second part)
		formatr_status:uint(0),	$	; formatter status
		status0:uint(0),	$	; detector status (unused)
		status1:uint(0),	$	; detector status (unused)
		status2:uint(0),	$	; detector status (unused)
		status3:uint(0),	$	; detector status (unused)
		status4:uint(0),	$	; detector status (unused)
		status5:uint(0),	$	; detector status (unused)
		status6:uint(0),	$	; detector status (unused)
		inflight:uint(0),	$	; '1' if frame occurred post-launch (for flight data only!)
		altitude:float(0),	$	; altitude data
		error_flag:uint(0)	$	; '1' if obvious error is noticed in that frame's data
                }
    	data_struct = replicate(data_struct, nFrames)

    	print, '  Filling in data.'
    	data_struct.frame_counter = reform( ishft( ulong(frame[7,*]),16 ) + frame[8,*] )
    	data_struct.frame_time = reform( ishft( ulong64(frame[4,*]),32 ) + ishft( ulong64(frame[5,*]),16 ) + frame[6,*] )

    	; Decode WSMR time (seconds of day).
	; Note that including the MSB of the time (from the frame word 2) is not strictly necessary
	; since this value is zero for our entire flight.  However, it's done anyway for 
	; completeness.
	seconds = uint( reform( frame[1,*] + ishft(ishft(frame[2,*],-15),16) ) )
	mil = ishft(ishft(frame[2,*],6),-6)/double(1000.)
	data_struct.wsmr_time = double(seconds)+mil

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Get the thermistor and voltage information from the 4 HSKP words. ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	hskp0 = reform( frame[9,*] )
	hskp1 = reform( frame[13,*] )
	hskp2 = reform( frame[17,*] )
	hskp3 = reform( frame[21,*] )

	; See McBride's formatter packet description for an explanation of the decoding
	; of thermistors and voltages.
	tref =  hskp0[where(data_struct.frame_counter mod 4 eq 0)]
	v5pos = hskp1[where(data_struct.frame_counter mod 4 eq 0)]
	v5neg = hskp2[where(data_struct.frame_counter mod 4 eq 0)]
	v33 =   hskp3[where(data_struct.frame_counter mod 4 eq 0)]
	v15 =   hskp0[where(data_struct.frame_counter mod 4 eq 1)]

	therm1 = hskp1[where(data_struct.frame_counter mod 4 eq 1)]
	therm2 = hskp2[where(data_struct.frame_counter mod 4 eq 1)]
	therm3 = hskp3[where(data_struct.frame_counter mod 4 eq 1)]
	therm4 = hskp0[where(data_struct.frame_counter mod 4 eq 2)]
	therm5 = hskp1[where(data_struct.frame_counter mod 4 eq 2)]
	therm6 = hskp2[where(data_struct.frame_counter mod 4 eq 2)]
	therm7 = hskp3[where(data_struct.frame_counter mod 4 eq 2)]
	therm8 = hskp0[where(data_struct.frame_counter mod 4 eq 3)]	; disfunctional!
	therm9 = hskp1[where(data_struct.frame_counter mod 4 eq 3)]
	therm10 = hskp2[where(data_struct.frame_counter mod 4 eq 3)]  	; on focal plane
	therm11 = hskp3[where(data_struct.frame_counter mod 4 eq 3)]

	; Each value only shows up once every fourth frame.  Allow values to leak
	; into neighboring frames so that we have one value per frame.
	tref =  reform( transpose([ [tref],[tref],[tref],[tref] ]), 4*n_elements(tref) )
	v5pos = reform( transpose([ [v5pos],[v5pos],[v5pos],[v5pos] ]), 4*n_elements(v5pos) )
	v5neg = reform( transpose([ [v5neg],[v5neg],[v5neg],[v5neg] ]), 4*n_elements(v5neg) )
	v33 =   reform( transpose([ [v33],[v33],[v33],[v33] ]), 4*n_elements(v33) )
	v15 =   reform( transpose([ [v15],[v15],[v15],[v15] ]), 4*n_elements(v15) )

	temp1 =  reform( transpose([ [therm1],[therm1],[therm1],[therm1] ]), 4*n_elements(therm1) )
	temp2 =  reform( transpose([ [therm2],[therm2],[therm2],[therm2] ]), 4*n_elements(therm2) )
	temp3 =  reform( transpose([ [therm3],[therm3],[therm3],[therm3] ]), 4*n_elements(therm3) )
	temp4 =  reform( transpose([ [therm4],[therm4],[therm4],[therm4] ]), 4*n_elements(therm4) )
	temp5 =  reform( transpose([ [therm5],[therm5],[therm5],[therm5] ]), 4*n_elements(therm5) )
	temp6 =  reform( transpose([ [therm6],[therm6],[therm6],[therm6] ]), 4*n_elements(therm6) )
	temp7 =  reform( transpose([ [therm7],[therm7],[therm7],[therm7] ]), 4*n_elements(therm7) )
	temp8 =  reform( transpose([ [therm8],[therm8],[therm8],[therm8] ]), 4*n_elements(therm8) )
	temp9 =  reform( transpose([ [therm9],[therm9],[therm9],[therm9] ]), 4*n_elements(therm9) )
	temp10 = reform( transpose([ [therm10],[therm10],[therm10],[therm10] ]), 4*n_elements(therm10) )
	temp11 = reform( transpose([ [therm11],[therm11],[therm11],[therm11] ]), 4*n_elements(therm11) )

	; Series of frames at beginning where frame_counter is zero are also added in as zero values.
	; THIS MAY CAUSE PROBLEMS IF THERE ARE DROPOUTS MIDFLIGHT! (These are not well
	; accounted for in this code.
	; Note that values obtained from HSKP0 need values *removed* instead of added.
	i_nonzero = where(data_struct.frame_counter gt 0)
	tref =  tref[i_nonzero[0]*3:n_elements(tref)-1]
	v5pos = v5pos[i_nonzero[0]*3:n_elements(v5pos)-1]
	v5neg = v5neg[i_nonzero[0]*3:n_elements(v5neg)-1]
	v33 =   v33[i_nonzero[0]*3:n_elements(v33)-1]
	v15 =   [uintarr(i_nonzero[0]), v15]

	temp1 =  [uintarr(i_nonzero[0]), temp1]
	temp2 =  [uintarr(i_nonzero[0]), temp2]
	temp3 =  [uintarr(i_nonzero[0]), temp3]
	temp4 =  [uintarr(i_nonzero[0]), temp4]
	temp5 =  [uintarr(i_nonzero[0]), temp5]
	temp6 =  [uintarr(i_nonzero[0]), temp6]
	temp7 =  [uintarr(i_nonzero[0]), temp7]
	temp8 =  [uintarr(i_nonzero[0]), temp8]
	temp9 =  [uintarr(i_nonzero[0]), temp9]
	temp10 = [uintarr(i_nonzero[0]), temp10]
	temp11 = [uintarr(i_nonzero[0]), temp11]

	; Not all arrays will be the same size. Pad some empty values at the end.
	; In the next step, any excess will be trimmed.
	print, 'Check: hskp array lengths are:'
	print, n_elements(tref), n_elements(v5pos), n_elements(v5neg), n_elements(v33), n_elements(v15)
	print, n_elements(temp1), n_elements(temp2), n_elements(temp3), n_elements(temp4), n_elements(temp5)
	print, n_elements(temp6), n_elements(temp7), n_elements(temp8), n_elements(temp9), n_elements(temp10)
	print, n_elements(temp11)
	print, 'Number of frames is ', nFrames
	tref =  [tref,   uintarr(40)]
	v5pos = [v5pos,  uintarr(40)]
	v5neg = [v5neg,  uintarr(40)]
	v33 =   [v33,    uintarr(40)]
	v15 =   [v15,    uintarr(40)]
	temp1 =  [temp1,  uintarr(40)]
	temp2 =  [temp2,  uintarr(40)]
	temp3 =  [temp3,  uintarr(40)]
	temp4 =  [temp4,  uintarr(40)]
	temp5 =  [temp5,  uintarr(40)]
	temp6 =  [temp6,  uintarr(40)]
	temp7 =  [temp7,  uintarr(40)]
	temp8 =  [temp8,  uintarr(40)]
	temp9 =  [temp9,  uintarr(40)]
	temp10 = [temp10, uintarr(40)]
	temp11 = [temp11, uintarr(40)]

	; Finally, write the arrays to the data structure, trimming excess.
	data_struct.t_ref  = tref[0:nFrames-1]
	data_struct.v_5pos = v5pos[0:nFrames-1]
	data_struct.v_5neg = v5neg[0:nFrames-1]
	data_struct.v_33   = v33[0:nFrames-1]
	data_struct.v_15   = v15[0:nFrames-1]
	data_struct.therm1 = temp1[0:nFrames-1]
	data_struct.therm2 = temp2[0:nFrames-1]
	data_struct.therm3 = temp3[0:nFrames-1]
	data_struct.therm4 = temp4[0:nFrames-1]
	data_struct.therm5 = temp5[0:nFrames-1]
	data_struct.therm6 = temp6[0:nFrames-1]
	data_struct.therm7 = temp7[0:nFrames-1]
	data_struct.therm8 = temp8[0:nFrames-1]
	data_struct.therm9 = temp9[0:nFrames-1]
	data_struct.therm10 = temp10[0:nFrames-1]
	data_struct.therm11 = temp11[0:nFrames-1]

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; The other housekeeping words can simply be grabbed every frame. ;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	data_struct.cmd_count = reform( frame[10,*] )
	data_struct.command1 = reform( frame[11,*] )
	data_struct.command2 = reform( frame[12,*] )
	data_struct.formatr_status = reform( frame[13,*] )
	data_struct.status0 = reform( frame[18,*] )
	data_struct.status1 = reform( frame[19,*] )
	data_struct.status2 = reform( frame[20,*] )
	data_struct.status3 = reform( frame[22,*] )
	data_struct.status4 = reform( frame[23,*] )
	data_struct.status5 = reform( frame[24,*] )
	data_struct.status6 = reform( frame[25,*] )
	data_struct.HV = reform( frame[16,*] )
	
	; Major and minor frame lock (and # frame check) info.
	; This info is used by White Sands to identify if we are sync locked.
	; THIS INFO HAS BEEN REMOVED SINCE IT IS DETERMINED THAT EVERY FRAME
	; RECORDED AT WSMR REGISTERED PROPER MAJOR AND MINOR FRAME LOCKS.

	; Identify which events occurred after launch (17:55:00), or "in flight"
	; Do this only if the file is the flight data file.
	; Post-launch events will have a '1' in the 'inflight' tag.
	case year of
   			2012: flight_filename = '36.255_TM2_Flight_2012-11-02.log'
    			2014: flight_filename = '36_295_Krucker_FLIGHT_HOT_TM2.log'
    			2018: flight_filename = '36_325_Glesener_FLIGHT_HOT_TM2.log'
  	endcase
	case year of
   			2012: tlaunch = 64500
    			2014: tlaunch = 69060
    			2018: tlaunch = 62460
  	endcase
	if strmatch(filename,'*'+flight_filename) eq 1 then begin
		print, "  File is flight data.  Flagging post-launch events."
		data_struct[ where( data_struct.wsmr_time gt tlaunch ) ].inflight = 1
	endif else print, "FILE DOES NOT CONTAIN FLIGHT DATA!"

	; Check for obvious errors and flag these.
	; Errors include:
	;    -- Frame counter does not increase by 1.  This is mostly
	i=where(data_struct[1:-1].frame_counter - data_struct[0:-2].frame_counter ne 1)
	data_struct[i+1].error_flag = 1

	; Get altitude data from text file
	case year of
   			2012: altitude_file = 'data_2012/36255.txt'
    			2014: altitude_file = 'data_2014/foxsi2_altitude.txt'
    			2018: altitude_file = 'data_2018/altitude.txt'
  	endcase
	data_alt=read_ascii(altitude_file)
	time_alt = data_alt.field01[1,*]
	altitude = data_alt.field01[9,*] + tlaunch	; adjust altitude clock for time of launch.

	; altitude data cadence is 2 Hz; formatter data cadence is 500 Hz
	; So resize the altitude data by repeating values.
	; I don't like the way "interpol" interpolates this, and I think the 
	; "discrete" step nature is good so that you can see the real
	; resolution of the altitude data.
	
	i_flight = long(0)
	for i=long(0), nFrames-1 do begin
		if not data_struct[i].inflight then continue
		data_struct[i].altitude = altitude[i_flight/250]
		i_flight++;
	endfor

	if keyword_set(stop) then stop

	print, "  Done!"

	return, data_struct

END

