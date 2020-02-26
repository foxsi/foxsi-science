;+
; FOXSI_LEVEL0_TO_LEVEL1
;
; This function reads in a Level 0 FOXSI data file (*.sav) and processes it
; into Level 1 FOXSI data.  The function was originally written for use with the 
; data from the first flight on 2012 Nov 2, but also works with other data,
; for example FOXSI-2 flight data and calibration data.  More documentation 
; is available in the FOXSI data description document.
;
; Inputs:	FILENAME	File to process.  
;					 	Must be a FOXSI SAV file with Level 0 data structure.
;			  			Default is 2012 flight data file.
;
; Keywords:	
;			DETECTOR	Detector number (0-6).  Each detector data
;			   			must be processed individually.  Default D0
;			GROUND		Indicates this is calibration, not flight data.
;                       YEAR		Year of the flight. Default is 2014.
;			CDTE      	Set to 1 for CdTe detectors. Default is 0.
;
; Example:
; 	To process level 0 data into Level 1 IDL structures and save them:
;
;	filename = 'data_2012/foxsi_level0_data.sav'
;	data_lvl1_D0 = foxsi_level0_to_level1( filename, det=0 )
;	data_lvl1_D1 = foxsi_level0_to_level1( filename, det=1 )
;	data_lvl1_D2 = foxsi_level0_to_level1( filename, det=2 )
;	data_lvl1_D3 = foxsi_level0_to_level1( filename, det=3 )
;	data_lvl1_D4 = foxsi_level0_to_level1( filename, det=4 )
;	data_lvl1_D5 = foxsi_level0_to_level1( filename, det=5 )
;	data_lvl1_D6 = foxsi_level0_to_level1( filename, det=6 )
;	save, data_lvl1_D0, data_lvl1_D1, data_lvl1_D2, data_lvl1_D3, $
;		data_lvl1_D4, data_lvl1_D5, data_lvl1_d6, $
;		file = 'data_2014/foxsi_level1_data.sav'
;
; History:	
;     2019-Dec-5  Sophie included altitude calculation for FOXSI-2
;     2019-Oct-15 Sophie fixed altitude calculation and included it for the FOXSI-3 data
;     2019-Feb-05 Sophie fixed a problem in the xy_det for FOXSI-2 CdTe
;     2018-Dec-06 Sophie add a variable t_launch to have different values for different flights when used
;     2018-Nov-28 Sophie Use CdTe and year keywords to differentiate detector coordinates
;                           for different detectors (Si, FOXSI2 CdTe, FOXSI3 CdTe)
;                        Also differentiate the payload coordinates calculation with
;                           a Y reflexion applied to the Si detector coordinates just before
;                           calling get_payload_coords.pro
;                        Add CdTe keyword when calling get_payload_coords.pro
;     2018-Nov-27 Sophie Added hit_asic and hit_strip in the LEVEL1 structure
;			2015-Mar-03	Linz	Added CdTe keyword for different error flag determination.
;			2015-Feb-02	Linz	Added keyword YEAR
;			2014-Dec	Linz	Updated to work with 2014 data --
;								Eliminated events with HV ne 200V.
;			2013-Dec	Linz	Added fix to make it work with calibration data.	
;			2013-Feb-12	Linz	Created routine
;-

FUNCTION	FOXSI_LEVEL0_TO_LEVEL1, FILENAME, DETECTOR = DETECTOR, STOP = STOP, $
			GROUND = GROUND, YEAR = YEAR, CDTE = CDTE

	default, year, 2014
	default, cdte, 0
	if not keyword_set(filename) then filename = 'data_2014/foxsi_level0_data.sav'

  case year of
    2012: t_launch = 64500
    2014: t_launch = 69060
    2018: t_launch = 62460
  endcase

	restore, filename, /v
	if detector eq 0 then data0 = data_lvl0_D0
	if detector eq 1 then data0 = data_lvl0_D1
	if detector eq 2 then data0 = data_lvl0_D2
	if detector eq 3 then data0 = data_lvl0_D3
	if detector eq 4 then data0 = data_lvl0_D4
	if detector eq 5 then data0 = data_lvl0_D5
	if detector eq 6 then data0 = data_lvl0_D6
	if detector gt 6 then begin
		print, 'Detector number out of range.'
		return, -1
	endif

	nEvts = n_elements(data0)

  	; prepare the data structure and make an array with one element for each frame.
  	print, '  Creating data structure.'
  	data_struct = {foxsi_level1, 	$
		frame_counter:ulong(0),	$	; formatter frame counter value, 32 bits
        wsmr_time:double(0.),  	$	; WSMR ground station time, to milliseconds
		frame_time:ulong64(0), 	$	; formatter frame time, 64 bits
		det_num:uint(0),	$	; same for all frames; from input keyword
		trigger_time:uint(0), 	$	; raw trigger time value, 16 bits
		livetime:double(0),	$	; Livetime in microsec since previous event
		hit_asic:intarr(2)-1,   $ ; which ASIC is likely hit, [p,n]
		hit_strip:uintarr(2),   $ ; strip with highest ADC value, [p,n]
		hit_adc:uintarr(2), 	$	; highest ADC value, [n,p], no CM subtraction
		hit_cm:uintarr(2), 	$	; common mode for hit ASIC (also applicable for associated)
		hit_adc_sub:intarr(2), $	; highest ADC value, [n,p], CM subtracted.
		hit_xy_det:uintarr(2),	$	; hit position in detector coordinates [pixels]
		hit_xy_pay:fltarr(2),	$	; coarse hit position in payload coordinates [arcsec]
		assoc_adc:uintarr(3,3,2),$	; "associated" ADC values, including hit.
		assoc_xy:uintarr(3,3,2), $	; "associated" locations, in detector coordinates [pixels]
		unrel_adc:uintarr(3,3,2),$	; "unrelated" ADC values (from the other ASIC)
		unrel_xy:uintarr(3,3,2), $	; "unrelated" locations, in detector coordinates [pixels]
		unrel_cm:uintarr(2), 	$	; common mode for "unrelated" ASIC
		channel_mask:ulon64arr(4), $	; channel mask for each ASIC, 1 bit per strip
		HV:uint(0),		$	; detector bias voltage value [volts]
		temperature:double(0),	$	; thermistor value [deg C] if temperature exists for this det.
		inflight:uint(0),	$	; '1' if frame occurred post-launch (for flight data only!)
		altitude:float(0),	$	; altitude data, interpolated betw 0.5 sec cadence
		error_flag:uint(0)	$	; '1' if obvious error is noticed in that frame's data
                }
    	data_struct = replicate(data_struct, nEvts)

	; fill in values that are identical to Level 0.
	data_struct.frame_counter = data0.frame_counter
	data_struct.wsmr_time     = data0.wsmr_time
	data_struct.frame_time    = data0.frame_time
	data_struct.det_num       = data0.det_num
	data_struct.trigger_time  = data0.trigger_time
	data_struct.inflight      = data0.inflight
	data_struct.channel_mask  = data0.channel_mask
	data_struct.hit_asic      = data0.hit_asic
	data_struct.hit_strip     = data0.hit_strip
	data_struct.hit_adc	  = data0.hit_adc
	
	; if CHAN MASK is all zero, it's a USB file and don't worry about livetime.
	if max(data0.channel_mask) ne 0 then begin
		; Calculate livetime, which is time before trigger for this frame only.
		; (i.e. this doesn't include livetime due to empty frames.)
		print, '  Calculating livetime…'
		t_word = 2000./256	; transmit time per word (~8 us)
		nHskp = 23		; 23 words in the housekeeping header
		setup_time = (nHskp + (detector+1)*33) * t_word
		i_evt = where(data_struct.trigger_time gt 0)
	;	data_struct[i_evt].livetime = (data_struct[i_evt].trigger_time - data_struct[i_evt].frame_time mod 2^16)*0.1 - 2000 - setup_time
		data_struct[i_evt].livetime = (data_struct[i_evt].trigger_time - data_struct[i_evt].frame_time mod double(2)^16)*0.1 + 2000 - setup_time
		; if livetime<0 then counter has rolled over.  Add 16 bits.
		i=where(data_struct.livetime lt 0)
		data_struct[i].livetime = data_struct[i].livetime + 2.^16*0.1
	endif
	
	;;
	; Calculate hit, associated, and unrelated parameters (ADC, CM, and position)
	;;

	; Identifying hits, associated values, and unrelated values...

  ; identify in different cases in nside (ASIC 0 and 1) are on y axis (value=1) or x axis (value=0)
  ; and what are the shift to associate XY detector coordinates
	  nside = 1
	  pside = 0
	  strip_shift = [127,63]

  
	; Identify events where the highest n-side ADC value was on ASIC 0
	; --------------------
	i0 = where(data0.hit_asic[0] eq 0)
	data_struct[i0].hit_cm[0] = data0[i0].common_mode[0]
	data_struct[i0].unrel_cm[0] = data0[i0].common_mode[1]

	data_struct[i0].assoc_adc[*,0,0] = reform(data0[i0].adc[0,*] )
	data_struct[i0].assoc_adc[*,1,0] = reform(data0[i0].adc[0,*] )
	data_struct[i0].assoc_adc[*,2,0] = reform(data0[i0].adc[0,*] )

	data_struct[i0].unrel_adc[*,0,0] = reform(data0[i0].adc[1,*] )
	data_struct[i0].unrel_adc[*,1,0] = reform(data0[i0].adc[1,*] )
	data_struct[i0].unrel_adc[*,2,0] = reform(data0[i0].adc[1,*] )

	data_struct[i0].assoc_xy[*,0,nside] = strip_shift[0] - reform(data0[i0].strips[0,*] )
	data_struct[i0].assoc_xy[*,1,nside] = strip_shift[0] - reform(data0[i0].strips[0,*] )
	data_struct[i0].assoc_xy[*,2,nside] = strip_shift[0] - reform(data0[i0].strips[0,*] )

	data_struct[i0].unrel_xy[*,0,nside] = strip_shift[1] - reform(data0[i0].strips[1,*] )
	data_struct[i0].unrel_xy[*,1,nside] = strip_shift[1] - reform(data0[i0].strips[1,*] )
	data_struct[i0].unrel_xy[*,2,nside] = strip_shift[1] - reform(data0[i0].strips[1,*] )
	; ---------------------

	; Identify events where the highest n-side ADC value was on ASIC 1
	; ---------------------
	i1 = where(data0.hit_asic[0] eq 1)
	data_struct[i1].hit_cm[0] = data0[i1].common_mode[1]
	data_struct[i1].unrel_cm[0] = data0[i1].common_mode[0]

	data_struct[i1].assoc_adc[*,0,0] = reform(data0[i1].adc[1,*] )
	data_struct[i1].assoc_adc[*,1,0] = reform(data0[i1].adc[1,*] )
	data_struct[i1].assoc_adc[*,2,0] = reform(data0[i1].adc[1,*] )

	data_struct[i1].unrel_adc[*,0,0] = reform(data0[i1].adc[0,*] )
	data_struct[i1].unrel_adc[*,1,0] = reform(data0[i1].adc[0,*] )
	data_struct[i1].unrel_adc[*,2,0] = reform(data0[i1].adc[0,*] )

	data_struct[i1].assoc_xy[*,0,nside] = strip_shift[1] - reform(data0[i1].strips[1,*] )
	data_struct[i1].assoc_xy[*,1,nside] = strip_shift[1] - reform(data0[i1].strips[1,*] )
	data_struct[i1].assoc_xy[*,2,nside] = strip_shift[1] - reform(data0[i1].strips[1,*] )

	data_struct[i1].unrel_xy[*,0,nside] = strip_shift[0] - reform(data0[i1].strips[0,*] )
	data_struct[i1].unrel_xy[*,1,nside] = strip_shift[0] - reform(data0[i1].strips[0,*] )
	data_struct[i1].unrel_xy[*,2,nside] = strip_shift[0] - reform(data0[i1].strips[0,*] )
	; ---------------------

	; Identify events where the highest p-side ADC value was on ASIC 2
	; ---------------------
	i2 = where(data0.hit_asic[1] eq 2)
	if i2[0] ne -1 then begin
	data_struct[i2].hit_cm[1] = data0[i2].common_mode[2]
	data_struct[i2].unrel_cm[1] = data0[i2].common_mode[3]

	data_struct[i2].assoc_adc[0,*,1] = data0[i2].adc[2,*]
	data_struct[i2].assoc_adc[1,*,1] = data0[i2].adc[2,*]
	data_struct[i2].assoc_adc[2,*,1] = data0[i2].adc[2,*]

	data_struct[i2].unrel_adc[0,*,1] = data0[i2].adc[3,*]
	data_struct[i2].unrel_adc[1,*,1] = data0[i2].adc[3,*]
	data_struct[i2].unrel_adc[2,*,1] = data0[i2].adc[3,*]

	data_struct[i2].assoc_xy[0,*,pside] = strip_shift[1] - data0[i2].strips[2,*]
	data_struct[i2].assoc_xy[1,*,pside] = strip_shift[1] - data0[i2].strips[2,*]
	data_struct[i2].assoc_xy[2,*,pside] = strip_shift[1] - data0[i2].strips[2,*]

	data_struct[i2].unrel_xy[0,*,pside] = strip_shift[0] - data0[i2].strips[3,*]
	data_struct[i2].unrel_xy[1,*,pside] = strip_shift[0] - data0[i2].strips[3,*]
	data_struct[i2].unrel_xy[2,*,pside] = strip_shift[0] - data0[i2].strips[3,*]
	
	endif
	; ---------------------

	; Identify events where the highest p-side ADC value was on ASIC 3
	i3 = where(data0.hit_asic[1] eq 3)
	; ---------------------
	data_struct[i3].hit_cm[1] = data0[i3].common_mode[3]
	data_struct[i3].unrel_cm[1] = data0[i3].common_mode[2]

	data_struct[i3].assoc_adc[0,*,1] = data0[i3].adc[3,*]
	data_struct[i3].assoc_adc[1,*,1] = data0[i3].adc[3,*]
	data_struct[i3].assoc_adc[2,*,1] = data0[i3].adc[3,*]

	data_struct[i3].unrel_adc[0,*,1] = data0[i3].adc[2,*]
	data_struct[i3].unrel_adc[1,*,1] = data0[i3].adc[2,*]
	data_struct[i3].unrel_adc[2,*,1] = data0[i3].adc[2,*]

	data_struct[i3].assoc_xy[0,*,pside] = strip_shift[0] - data0[i3].strips[3,*]
	data_struct[i3].assoc_xy[1,*,pside] = strip_shift[0] - data0[i3].strips[3,*]
	data_struct[i3].assoc_xy[2,*,pside] = strip_shift[0] - data0[i3].strips[3,*]

	data_struct[i3].unrel_xy[0,*,pside] = strip_shift[1] - data0[i3].strips[2,*]
	data_struct[i3].unrel_xy[1,*,pside] = strip_shift[1] - data0[i3].strips[2,*]
	data_struct[i3].unrel_xy[2,*,pside] = strip_shift[1] - data0[i3].strips[2,*]
	; ---------------------

	; Subtract common mode for hit
	data_struct.hit_adc_sub = fix(data_struct.hit_adc) - fix(data_struct.hit_cm)

	; Determine hit position
  ; First, in detector pixel coords. ; distinct calculation for Si and CdTe
  IF cdte eq 0 THEN BEGIN
    ; this is the way it has been done for FOXSI 1 and 2 Si detectors
    data_struct[i0].hit_xy_det[1] = 127 - data0[i0].hit_strip[0]
    data_struct[i1].hit_xy_det[1] = 63 - data0[i1].hit_strip[0]
    if i2[0] ne -1 then data_struct[i2].hit_xy_det[0] = 63 - data0[i2].hit_strip[1]
    data_struct[i3].hit_xy_det[0] = 127 - data0[i3].hit_strip[1]
    ; note that using this, we need a reflexion in y axis to have the correct coordinates, 
    ; but historically in the FOXSI software this is done at a later stage, so 
    ; we keep the calculation in that state for Si detector to make sure this procedure
    ; is compatible with previous data set and codes
  ENDIF ELSE BEGIN
    IF year EQ 2014 THEN BEGIN
      ; this is the way it should be done for FOXSI2 Cdte, implemented on Nov 28 2018
      data_struct[i0].hit_xy_det[0] = 63 - data0[i0].hit_strip[0] 
      data_struct[i1].hit_xy_det[0] = 127 - data0[i1].hit_strip[0]  
      data_struct[i2].hit_xy_det[1] = 127 - data0[i2].hit_strip[1]
      data_struct[i3].hit_xy_det[1] = 63 - data0[i3].hit_strip[1]
    ENDIF
    IF year EQ 2018 THEN BEGIN
      ; this is the way it should be done for FOXSI3 Cdte, implemented on Nov 28 2018
      data_struct[i0].hit_xy_det[1] = 127 - data0[i0].hit_strip[0]
      data_struct[i1].hit_xy_det[1] = 63 - data0[i1].hit_strip[0]
      data_struct[i2].hit_xy_det[0] = 63 - data0[i2].hit_strip[1]
      data_struct[i3].hit_xy_det[0] = 127 - data0[i3].hit_strip[1]
    ENDIF
  ENDELSE

  ; Change hit position to payload coordinates: makes the distinction between Si and Cdte in the call to get_payload_coords
    xy_det = data_struct.hit_xy_det
    data_struct.hit_xy_pay = get_payload_coords( xy_det, detector, cdte=cdte )

	; Record position (detector pix coords only) for associated and unrelated pixels.
;	data_struct.assoc_adc[0,*,0] = assoc_adc[*,0,*]


	; Interpret HV value
	data_struct.HV = ishft(data0.HV, -4)/8

	; If detector is 0, 2, or 5 then temperature values remain zero.
	; Otherwise, convert to actual temperature.
	if detector eq 1 or detector eq 3 or detector eq 4 or detector eq 6 then begin
		; This conversion is copied from McBride's GSE code.
		temp = 10000./((4095./data0.temperature) -1.);
		data_struct.temperature = 1./(0.00102522746225986 $
			+ 0.000239789531411299*alog(temp) $
			+ 1.53998393755544E-07*(alog(temp))^3) $
			- 273.
	endif

	; Altitude
	; For level 1, interpolate linearly between each 0.5 sec measurement.
	; Get altitude data from text file
	if not keyword_set(ground) then begin ; 
		IF year EQ 2012 THEN data_alt=read_ascii('data_2012/36255.txt')
		IF year EQ 2014 THEN data_alt=read_ascii('data_2014/foxsi2_altitude.txt')
		IF year EQ 2018 THEN data_alt=read_ascii('data_2018/altitude.txt')
		time_alt = data_alt.field01[1,*] + t_launch	; adjust altitude clock for time of launch.
		altitude = data_alt.field01[9,*]

		; altitude data cadence is 2 Hz; formatter data cadence is 500 Hz
		; interpolate the post-flight values.
		FOR i=0, n_elements(data_struct)-1 do begin
			alt_interp = interpol(altitude,time_alt,data_struct[i].wsmr_time)
			data_struct[i].altitude = alt_interp
		endfor
	endif

	; Last step: check for obvious errors and flag these.
	; Errors include:
	; Bit 0: Any CM value > 1023
	; Bit 1: All zero ADC data from one side (either n or p)
	;		A few reasons why this could happen (common mode shifts below zero, incomplete R/O, etc)
	;		First look shows that we throw out little to no useful data by eliminating these.
	; Bit 2: p-side CM is 0 (can't use value for spectroscopy)
	; Bit 3: Detector voltage possibly not settled (applies for ~40 sec after HV=200 and at end)
	; Bit 4: CM > highest ADC for that ASIC
	;		This mostly duplicates bit 0 error.
	; Bit 5: Signal location is within 3 strips from detector edge.
	; Bit 6: Livetime value out of range ([1,1714] us)
	print, "  Checking data and flagging abnormalities."
	
	; if CHAN MASK is all zero, it's a USB file and errors are already removed.
	if max(data0.channel_mask) ne 0 then begin
		check = where(data0.common_mode[0] gt 1023 or data0.common_mode[1] gt 1023 or $
				  	  data0.common_mode[2] gt 1023 or data0.common_mode[3] gt 1023)
		data_struct[check].error_flag = data_struct[check].error_flag + 1

		check = where(data0.hit_asic[0] eq -1 or data0.hit_asic[1] eq -1)
		data_struct[check].error_flag = data_struct[check].error_flag + 2

		check = where(data_struct.hit_cm[1] eq 0)
		data_struct[check].error_flag = data_struct[check].error_flag + 4
	
		if keyword_set(ground) then begin
			check = where(data_struct.hv ne 200)
		endif else begin
			check = where(data_struct.hv ne 200 or data_struct.wsmr_time lt t_launch+90 )  
		endelse
		data_struct[check].error_flag = data_struct[check].error_flag + 8
	
	
		check = where(data_struct.hit_cm[0] gt data_struct.hit_adc[0] or $
					  data_struct.hit_cm[1] gt data_struct.hit_adc[1])
		data_struct[check].error_flag = data_struct[check].error_flag + 16
	
		; different geometry for CdTe detectors. Now that we changed the way the detector coordinates are calculated for CdTe this should be apply also to CDTE detectors
		if not keyword_set( CDTE ) then begin
			check = where(data_struct.hit_xy_det[0] lt 3 or data_struct.hit_xy_det[0] gt 124 or $
					  	data_struct.hit_xy_det[1] lt 3 or data_struct.hit_xy_det[1] gt 124)
			data_struct[check].error_flag = data_struct[check].error_flag + 32
		endif
	
		check = where(data_struct.livetime gt 2000. or data_struct.livetime lt 1.)
		data_struct[check].error_flag = data_struct[check].error_flag + 64

	endif
	
	; Added as of 2nd flight: only pass through data at 200V, to trim the higher-order
	; data files.
	
	if year ge 2014 then data_struct = data_struct[ where( data_struct.hv eq 200 ) ]
	
	if keyword_set(stop) then stop

	print, "  Done!"

	return, data_struct

END

