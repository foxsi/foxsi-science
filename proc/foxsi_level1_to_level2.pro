FUNCTION	FOXSI_LEVEL1_TO_LEVEL2, FILE_DATA0, FILE_DATA1, DETECTOR = DETECTOR, $
			CALIB_FILE = CALIB_FILE, GROUND = GROUND, YEAR = YEAR, CDTE = CDTE, STOP = STOP

;+
; This function reads in Level 0 and Level 1 FOXSI data files (*.sav) and processes
; into Level 2 FOXSI data.  The function was originally written for use with the 
; data from the first flight on 2012 Nov 2, but also works with other data,
; for example FOXSI-2 flight data and calibration data.  More documentation 
; is available in the FOXSI data description document.
;
; Inputs:	
;		FILE_DATA0	Level 0 data file.
;		FILE_DATA1	Level 1 data file.
;
; Keywords:	
;		DETECTOR	Detector number (0-6).  Each detector data
;			   		must be processed individually.  Default D0
;		CALIB_FILE	Calibration file to use. Must be the correct detector!
;		GROUND		Indicates this is calibration, not flight data.
;		YEAR			Specify 2012 or 2014.  Default 2014
;		CDTE      Set to 1 for CdTe detectors. Default is 0
;
; Example:
; 	To process level 1 data into Level 2 IDL structures and save them:
;
;	file0 = 'data_2012/foxsi_level0_data.sav'
;	file1 = 'data_2012/foxsi_level1_data.sav'
;	cal0 = 'calibration_data/peaks_det108.sav'
;	cal1 = 'calibration_data/peaks_det109.sav'
;	cal2 = 'calibration_data/peaks_det102.sav'
;	cal3 = 'calibration_data/peaks_det103.sav'
;	cal4 = 'calibration_data/peaks_det104.sav'
;	cal5 = 'calibration_data/peaks_det105.sav'
;	cal6 = 'calibration_data/peaks_det106.sav'
;	data_lvl2_D0 = foxsi_level1_to_level2( file0, file1, det=0, calib=cal0 )
;	data_lvl2_D1 = foxsi_level1_to_level2( file0, file1, det=1, calib=cal1 )
;	data_lvl2_D2 = foxsi_level1_to_level2( file0, file1, det=2, calib=cal2 )
;	data_lvl2_D3 = foxsi_level1_to_level2( file0, file1, det=3, calib=cal3 )
;	data_lvl2_D4 = foxsi_level1_to_level2( file0, file1, det=4, calib=cal4 )
;	data_lvl2_D5 = foxsi_level1_to_level2( file0, file1, det=5, calib=cal5 )
;	data_lvl2_D6 = foxsi_level1_to_level2( file0, file1, det=6, calib=cal6 )
;	save, data_lvl2_D0, data_lvl2_D1, data_lvl2_D2, data_lvl2_D3, $
;		data_lvl2_D4, data_lvl2_D5, data_lvl2_d6, $
;		file = 'data_2012/foxsi_level2_data.sav'
;
; History:	
;     2019-Feb-05 Sophie Added a xy_offset variable for each flight, needed to calculate the correct solar coordinates
;     2018-Dec-06 Sophie Added Date_creation and Calib_filename fields in the level 2 structure
;                        Added case of year=2018 to define t_launch and liss_dir
;     2018-Nov-28 Sophie Added y axis flip for Si data to calculate payload coordinates for associated events
;                        Added CDTE keyword
;                        Added CDTE keyword in call to get_payload_coords
;     2018-Nov-27 Sophie Added hit_asic and hit_strip in the LEVEL1 structure
;			2015-Feb-2	Linz	Added keyword YEAR
;			2014-Dec	Linz	Adjustments to work with 2014 data, specifically
;								allowing for lvl0 and lvl1 data lengths to be
;								different, as lvl1 now only includes HV=200V data.
;			2013-Dec	Linz	Added fix to make it work with calibration data.
;			2013-Mar-08	Linz	Created routine
;-

	default, year, 2014
	default, cdte, 0
	
	if not keyword_set(calib_file) then begin
		print, 'No calibration file given.'
		return, -1
	endif

	restore, file_data0, /v
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

	restore, file_data1, /v
	if detector eq 0 then data1 = data_lvl1_D0
	if detector eq 1 then data1 = data_lvl1_D1
	if detector eq 2 then data1 = data_lvl1_D2
	if detector eq 3 then data1 = data_lvl1_D3
	if detector eq 4 then data1 = data_lvl1_D4
	if detector eq 5 then data1 = data_lvl1_D5
	if detector eq 6 then data1 = data_lvl1_D6

	nEvts = n_elements(data1)
	
  	; prepare the data structure and make an array with one element for each frame.
  	print, '  Creating data structure.'
  	data_struct = {foxsi_level2, 	$
		frame_counter:ulong(0),	$	; formatter frame counter value, 32 bits
        wsmr_time:double(0.),  	$	; WSMR ground station time, to milliseconds
		frame_time:ulong64(0), 	$	; formatter frame time, 64 bits
		det_num:uint(0),		$	; same for all frames; from input keyword
		trigger_time:uint(0), 	$	; raw trigger time value, 16 bits
		livetime:double(0),		$	; Livetime in microsec since previous event
		hit_asic:intarr(2)-1,   $ ; which ASIC is likely hit, [p,n]
		hit_strip:uintarr(2),   $ ; strip with highest ADC value, [p,n]
		hit_energy:fltarr(2), 	$	; Energy value for hit strip, [n,p]
		hit_xy_det:fltarr(2),		$	; Hit position in detector coordinates [strips]
		hit_xy_pay:fltarr(2),		$	; Hit position in payload coordinates [arcsec]
		hit_xy_solar:fltarr(2),		$	; Hit position in heliographic coordinates [arcsec]
		assoc_energy:fltarr(3,3,2),$	; "associated" energies, including hit.
		assoc_xy_pay:fltarr(3,3,2), $	; "associated" locations, in payload coordinates [pixels]
		assoc_xy_solar:fltarr(3,3,2), $	; "associated" locations, in solar coordinates [pixels]
		HV:uint(0),				$	; detector bias voltage value [volts]
		temperature:double(0),	$	; thermistor value [deg C] if temperature exists for this det.
		inflight:uint(0),		$	; '1' if frame occurred post-launch (for flight data only!)
		altitude:float(0),		$	; altitude data, interpolated betw 0.5 sec cadence
		pitch:float(0),			$	; SPARCS pitch
		yaw:float(0),			$	; SPARCS yaw
		error_flag:uint(0),		$	; '1' if obvious error is noticed in that frame's data
		date_creation:string(0),   $ ; Date and time of level2 structure creation, from OS (local time)
		calib_filename:string(0)    $ ; name of the calibration file used to calculate the level2 data
    }
    	data_struct = replicate(data_struct, nEvts)

	if keyword_set(stop) then stop

	if year ge 2014 then begin
		; Because data0 and data1 have different sizes, restrict data0 events to those
		; with HV=200V. (As of 2014.)
		tempHV = ishft(data0.HV, -4)/8
		data0 = data0[ where( tempHV eq 200 ) ]
		if n_elements(data0) ne nEvts then begin
			print, 'Level 0 and level 1 data structures do not match.'
			return, -1
		endif
	endif

	; Fill in values that are identical to previous versions.
	data_struct.frame_counter = data1.frame_counter
	data_struct.wsmr_time     = data1.wsmr_time
	data_struct.frame_time    = data1.frame_time
	data_struct.det_num       = data1.det_num
	data_struct.hv			  = data1.hv
	data_struct.temperature	  = data1.temperature
	data_struct.trigger_time  = data1.trigger_time
	data_struct.livetime      = data1.livetime
	data_struct.inflight      = data1.inflight
	data_struct.altitude	  = data1.altitude
	data_struct.error_flag	  = data1.error_flag
	data_struct.hit_asic      = data1.hit_asic
	data_struct.hit_strip     = data1.hit_strip
	data_struct.hit_xy_det 	  = data1.hit_xy_det
	
	;;;; WHAT DO YOU WANT TO DO ABOUT LIVETIME??? ;;;;
	
	;
	; Do the energy conversion.	
	;
	
	; These variables shouldn't need to vary, so hardcode them.
	binwidth = 0.1
	nbins = 1000
	
	if file_exist(calib_file) eq 1 then restore, calib_file else begin
		print, 'Peaks file not found.'
		return, -1
	endelse

	cmn = data1.hit_cm + randomu(seed,[2,nEvts]) - 0.5

    for evt = long(0), nEvts-1 do begin
        
        if keyword_set(ground) then begin
    		if data1[evt].hv ne 200 then continue
    	endif ;else begin
	    ;    if data1[evt].inflight ne 1 then continue
    	;endelse
        
        if (evt mod 1000) eq 0 then print, 'Calibrating event  ', evt, ' / ', nEvts

		; First, process the "single-pixel hit" separately:

        for side = 0, 1 do begin
					chan = data0[evt].hit_strip[side]
					asic = data0[evt].hit_asic[side]
					if asic eq -1 then continue
					adc  = data0[evt].hit_adc[side]
        	
        	; new method using quadratic
					fit = poly_fit( peaks[*,chan,asic,1], peaks[*,chan,asic,0], 2 )
					y_array = findgen(1000)/1000.*100.
					x_array = fit[0] + fit[1]*y_array + fit[2]*y_array^2
        	data_struct[evt].hit_energy[side] = interpol( y_array, x_array, adc - cmn[side,evt] )

					; old method using splines.
					; data_struct[evt].hit_energy[side] = $
					;			spline( peaks[*,chan,asic,0],peaks[*,chan,asic,1],adc - cmn[side,evt] )
        		
        	        		
		endfor

		; Then repeat for all the "associated" values.
		; One of these is redundant since the hit value was already converted.		       

        for side = 0, 1 do begin
			asic = data0[evt].hit_asic[side]
			if asic eq -1 then continue
        	for strip = 0, 2 do begin
				chan = data0[evt].strips[asic,strip]
				adc  = data0[evt].adc[asic,strip]
        	
        ; new method using quadratic
				fit = poly_fit( peaks[*,chan,asic,1], peaks[*,chan,asic,0], 2 )
				y_array = findgen(1000)/1000.*100.
				x_array = fit[0] + fit[1]*y_array + fit[2]*y_array^2
        energy = interpol( y_array, x_array, adc - cmn[side,evt] )

					; old method using splines.
					; energy = $
					;			spline( peaks[*,chan,asic,0],peaks[*,chan,asic,1],adc - cmn[side,evt] )
        		

					if side eq 0 then begin
					data_struct[evt].assoc_energy[strip,0,0] = energy
					data_struct[evt].assoc_energy[strip,1,0] = energy
					data_struct[evt].assoc_energy[strip,2,0] = energy
				endif else begin
					data_struct[evt].assoc_energy[0,strip,1] = energy
					data_struct[evt].assoc_energy[1,strip,1] = energy
					data_struct[evt].assoc_energy[2,strip,1] = energy
				endelse				
			endfor
		endfor
		
		;if data_struct[evt].error_flag eq 0 then stop

    endfor

	; Transform all positions to payload coords.
	; For some reason this was done only for the primary hit in Lvl1 data
	; (not for the associated values)
	data_struct.hit_xy_pay = data1.hit_xy_pay
	for i=0, 2 do begin
		for j=0, 2 do begin
		  IF cdte eq 0 THEN BEGIN
		   ; for silicon, we have to invert the y axis
		    assoc_xy_temp = reform(data1.assoc_xy[i,j,*,*])
		    assoc_xy_temp[*,1] = 127 - assoc_xy_temp[*,1]
		  ENDIF ELSE BEGIN
		    assoc_xy_temp = reform(data1.assoc_xy[i,j,*,*])
      ENDELSE
			temp = get_payload_coords( assoc_xy_temp, detector, cdte=cdte )
			data_struct.assoc_xy_pay[i,j,*,*] = reform( temp, [1,1,2,n_elements(data1)] )
		endfor
	endfor
	
	; Get SPARCS pointing data and put in solar coords.
	if not keyword_set(ground) then begin
	
    IF year EQ 2018 THEN BEGIN
      liss_dir = 'data_2018/'
      t_launch = 62460
      xy_offset = [0.,0.] ; this is not the final value, to be checked 
      roll_angle_deg = fltarr(n_elements(data_struct))*0. ; this is not the final value, to be checked
      roll_center = fltarr(n_elements(data_struct),2)*0.  ; this is not the final value, to be checked
    ENDIF
    IF year EQ 2014 THEN BEGIN
      liss_dir = 'data_2014/'
      t_launch = 69060
      xy_offset = [360.,-180.]
      roll_angle_deg = fltarr(n_elements(data_struct))*0. 
      roll_center = fltarr(n_elements(data_struct),2)*0.  
    ENDIF
    IF year EQ 2012 THEN BEGIN
      liss_dir = 'data_2012/'
      t_launch = 64500
      xy_offset = [0.,0.]
      roll_angle_deg = fltarr(n_elements(data_struct))*0. 
      roll_center = fltarr(n_elements(data_struct),2)*0.  
    ENDIF
    
    roll_angle_rad = roll_angle_deg*!pi/180.
	
	  pitch_struct = read_ascii( liss_dir+'LISS_pitch.txt' )
		pitch_time = pitch_struct.field1[0,*]
		pitch = pitch_struct.field1[1,*]

		yaw_struct = read_ascii( liss_dir+'LISS_yaw.txt' )
		yaw_time = yaw_struct.field1[0,*]
		yaw = yaw_struct.field1[1,*]
		
		for i=long(0), nEvts-1 do begin
			if data_struct[i].inflight eq 0 then continue
			if i mod 100 eq 0 then print, 'i=', i
			j = where(pitch_time gt 0)	; skip the NaN values
			evt = closest( pitch_time[j] + t_launch, data_struct[i].wsmr_time )
			data_struct[i].pitch = pitch[j[evt]]
			j = where(yaw_time gt 0)	; skip the NaN values
			evt = closest( yaw_time[j] + t_launch, data_struct[i].wsmr_time )
			data_struct[i].yaw = yaw[j[evt]]
		endfor
		
		; Combine pitch and yaw with hit position.
		; Don't forget yaw has sign reversed.
		x_solar_before_roll = data_struct.hit_xy_pay[0] + data_struct.pitch + xy_offset[0]
		y_solar_before_roll =  data_struct.hit_xy_pay[1] - data_struct.yaw + xy_offset[1]
		
		; calculate polar coordinates in respect to roll center
		r = sqrt((x_solar_before_roll-roll_center[0])^2 + (y_solar_before_roll-roll_center[1])^2)
		alpha = atan((y_solar_before_roll-roll_center[1]), (x_solar_before_roll-roll_center[0]))

		; apply roll correction
		data_struct.hit_xy_solar[0] = roll_center[*,0] + cos(roll_angle_rad)*r*cos(alpha) + sin(roll_angle_rad)*r*sin(alpha)
		data_struct.hit_xy_solar[1] = roll_center[*,1] + cos(roll_angle_rad)*r*sin(alpha) - sin(roll_angle_rad)*r*cos(alpha)

	endif else begin
		data_struct.hit_xy_solar[0] = data_struct.hit_xy_pay[0]
		data_struct.hit_xy_solar[1] = data_struct.hit_xy_pay[1]
	endelse	
	
	; read the time and assign to the structure
  data_struct.date_creation[0] = systim()
  
  ; record the calibration filename in the structure
  strcalib = strsplit(calib_file, '/\', /extract)
  data_struct.calib_filename[0] = strcalib[n_elements(strcalib)-1]

	if keyword_set(stop) then stop
		
	print, "  Done!"

	return, data_struct

END

