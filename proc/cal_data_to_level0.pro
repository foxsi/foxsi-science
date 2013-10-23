;
; First, some utility functions.
; Main procedure is below and is 'formatter_data_to_level0'
;

;; Utility function, adapted from CMPRODUCT
function cmapply_product, x
  sz = size(x)
  n = sz(1)

  while n GT 1 do begin
      if (n mod 2) EQ 1 then x(0,*) = x(0,*) * x(n-1,*)
      n2 = floor(n/2)
      x = x(0:n2-1,*) * x(n2:n2*2-1,*)
      n = n2
  endwhile
  return, reform(x(0,*), /overwrite)
end

;; Utility function, used to collect collaped dimensions
pro cmapply_redim, newarr, dimapply, dimkeep, nkeep, totcol, totkeep
  sz = size(newarr)
  ;; First task: rearrange dimensions so that the dimensions
  ;; that are "kept" (ie, uncollapsed) are at the back
  dimkeep = where(histogram(dimapply,min=1,max=sz(0)) ne 1, nkeep)
  if nkeep EQ 0 then return

  newarr = transpose(temporary(newarr), [dimapply-1, dimkeep])
  ;; totcol is the total number of collapsed elements
  totcol = sz(dimapply(0))
  for i = 1, n_elements(dimapply)-1 do totcol = totcol * sz(dimapply(i))
  totkeep = sz(dimkeep(0)+1)
  for i = 1, n_elements(dimkeep)-1 do totkeep = totkeep * sz(dimkeep(i)+1)

  ;; this new array has two dimensions:
  ;;   * the first, all elements that will be collapsed
  ;;   * the second, all dimensions that will be preserved
  ;; (the ordering is so that all elements to be collapsed are
  ;;  adjacent in memory)
  newarr = reform(newarr, [totcol, totkeep], /overwrite)
end

;; Main function
function cmapply, op, array, dimapply, double=dbl, type=type, $
                  functargs=functargs, nocatch=nocatch

  if n_params() LT 2 then begin
      message, "USAGE: XX = CMAPPLY('OP',ARRAY,2)", /info
      message, '       where OP is +, *, AND, OR, MIN, MAX', /info
      return, -1L
  endif
  if NOT keyword_set(nocatch) then $
    on_error, 2 $
  else $
    on_error, 0

  version = double(!version.release)
;  version = 0
;  print, 'version = ',version

  ;; Parameter checking
  ;; 1) the dimensions of the array
  sz = size(array)
  if sz(0) EQ 0 then $
    message, 'ERROR: ARRAY must be an array!'

  ;; 2) The type of the array
  if sz(sz(0)+1) EQ 0 OR sz(sz(0)+1) EQ 7 OR sz(sz(0)+1) EQ 8 then $
    message, 'ERROR: Cannot apply to UNDEFINED, STRING, or STRUCTURE'
  if n_elements(type) EQ 0 then type = sz(sz(0)+1)

  ;; 3) The type of the operation
  szop = size(op)
  if szop(szop(0)+1) NE 7 then $
    message, 'ERROR: operation OP was not a string'

  ;; 4) The dimensions to apply (default is to apply to first dim)
  if n_params() EQ 2 then dimapply = 1
  dimapply = [ dimapply ]
  dimapply = dimapply(sort(dimapply))   ; Sort in ascending order
  napply = n_elements(dimapply)

  ;; 5) Use double precision if requested or if needed
  if n_elements(dbl) EQ 0 then begin
      dbl=0
      if type EQ 5 OR type EQ 9 then dbl=1
  endif

  newop = strupcase(op)
  newarr = array
  newarr = reform(newarr, sz(1:sz(0)), /overwrite)
  case 1 of

      ;; *** Addition
      (newop EQ '+'): begin
          for i = 0L, napply-1 do begin
              newarr = total(temporary(newarr), dimapply(i)-i, double=dbl)
          endfor
      end

      ;; *** Multiplication
      (newop EQ '*'): begin ;; Multiplication (by summation of logarithms)
          forward_function product

          cmapply_redim, newarr, dimapply, dimkeep, nkeep, totcol, totkeep
          if nkeep EQ 0 then begin
              newarr = reform(newarr, n_elements(newarr), 1, /overwrite)
              if version GT 5.55 then return, product(newarr)
              return, (cmapply_product(newarr))(0)
          endif

          if version GT 5.55 then begin
              result = product(newarr,1)
          endif else begin
              result = cmapply_product(newarr)
          endelse
          result = reform(result, sz(dimkeep+1), /overwrite)
          return, result
      end

      ;; *** LOGICAL AND or OR
      ((newop EQ 'AND') OR (newop EQ 'OR')): begin
          newarr = temporary(newarr) NE 0
          totelt = 1L
          for i = 0L, napply-1 do begin
              newarr = total(temporary(newarr), dimapply(i)-i)
              totelt = totelt * sz(dimapply(i))
          endfor
          if newop EQ 'AND' then return, (round(newarr) EQ totelt)
          if newop EQ 'OR'  then return, (round(newarr) NE 0)
      end

      ;; Operations requiring a little more attention over how to
      ;; iterate
      ((newop EQ 'MAX') OR (newop EQ 'MIN') OR (newop EQ 'MEDIAN')): begin
          cmapply_redim, newarr, dimapply, dimkeep, nkeep, totcol, totkeep
          if nkeep EQ 0 then begin
              if newop EQ 'MAX' then return, max(newarr)
              if newop EQ 'MIN' then return, min(newarr)
              if newop EQ 'MEDIAN' then return, median(newarr)
          endif

          ;; IDL 5.5 introduced the DIMENSION keyword to MAX() and MIN()
          if version GT 5.45 then begin
              extra = {dimension:1}
              if newop EQ 'MAX' then result = max(newarr, _EXTRA=extra)
              if newop EQ 'MIN' then result = min(newarr, _EXTRA=extra)
              if newop EQ 'MEDIAN' then result = median(newarr, _EXTRA=extra)
          endif else begin
              
              ;; Next task: create result array
              result = make_array(totkeep, type=type)
              
              ;; Now either iterate over the number of output elements, or
              ;; the number of collapsed elements, whichever is smaller.
              if (totcol LT totkeep) AND newop NE 'MEDIAN' then begin
                  ;; Iterate over the number of collapsed elements
                  result(0) = reform(newarr(0,*),totkeep,/overwrite)
                  case newop of 
                      'MAX': for i = 1L, totcol-1 do $
                        result(0) = result > newarr(i,*)
                      'MIN': for i = 1L, totcol-1 do $
                        result(0) = result < newarr(i,*)
                  endcase
              endif else begin
                  ;; Iterate over the number of output elements
                  case newop of 
                      'MAX': for i = 0L, totkeep-1 do result(i) = max(newarr(*,i))
                      'MIN': for i = 0L, totkeep-1 do result(i) = min(newarr(*,i))
                      'MEDIAN': for i = 0L, totkeep-1 do result(i) = median(newarr(*,i))
                  endcase
              endelse
          endelse

          result = reform(result, sz(dimkeep+1), /overwrite)
          return, result
      end

      ;; User function
      (strmid(newop,0,4) EQ 'USER'): begin
          functname = strmid(newop,5)
          if functname EQ '' then $
            message, 'ERROR: '+newop+' is not a valid operation'

          cmapply_redim, newarr, dimapply, dimkeep, nkeep, totcol, totkeep
          if nkeep EQ 0 then begin
              if n_elements(functargs) GT 0 then $
                return, call_function(functname, newarr, _EXTRA=functargs)
              return, call_function(functname, newarr)
          endif
          
          ;; Next task: create result array
          result = make_array(totkeep, type=type)
          
          ;; Iterate over the number of output elements
          if n_elements(functargs) GT 0 then begin
              for i = 0L, totkeep-1 do $
                result(i) = call_function(functname, newarr(*,i), _EXTRA=functargs)
          endif else begin
              for i = 0L, totkeep-1 do $
                result(i) = call_function(functname, newarr(*,i))
          endelse

          result = reform(result, sz(dimkeep+1), /overwrite)
          return, result
      end

              
  endcase

  newsz = size(newarr)
  if type EQ newsz(newsz(0)+1) then return, newarr

  ;; Cast the result into the desired type, if necessary
  castfns = ['UNDEF', 'BYTE', 'FIX', 'LONG', 'FLOAT', $
             'DOUBLE', 'COMPLEX', 'UNDEF', 'UNDEF', 'DCOMPLEX' ]
  if type GE 1 AND type LE 3 then $
    return, call_function(castfns(type), round(newarr)) $
  else $
    return, call_function(castfns(type), newarr)
end
  
;+
; This function reads in a FORMATTER CALIBRATION-style data file (*.dat) and processes 
; it into Level 0 FOXSI data.  The Level 0 FOXSI data structure is meant for use with
; flight data; this function allows the conversion of calibration into a form that can
; be analyzed with flight data software. More documentation of the data structure is 
; available in the FOXSI data description doc.
;
; Inputs:	FILENAME = File to process.  Must be a FORMATTER CALIBRATION-style data file.
;
; Keywords:	DETECTOR = Detector number (0-6).  Each detector data
;			   must be processed individually.  Default D0
;		STOP = stop before returning, for debugging
;
; To process formatter data into Level 0 IDL structures and save them:
;
;	filename = 'data_2012/data_121102_114631.dat'
; 	data_lvl0_D0 = formatter_data_to_level0( filename, det=0 )
; 	data_lvl0_D1 = formatter_data_to_level0( filename, det=1 )
; 	data_lvl0_D2 = formatter_data_to_level0( filename, det=2 )
; 	data_lvl0_D3 = formatter_data_to_level0( filename, det=3 )
; 	data_lvl0_D4 = formatter_data_to_level0( filename, det=4 )
; 	data_lvl0_D5 = formatter_data_to_level0( filename, det=5 )
; 	data_lvl0_D6 = formatter_data_to_level0( filename, det=6 )
;	save, data_lvl0_D0, data_lvl0_D1, data_lvl0_D2, data_lvl0_D3, $
;		data_lvl0_D4, data_lvl0_D5, data_lvl0_d6, $
;		file = 'data_2012/formatter_data.sav'
;
; History:	Version 1, 2013-May-09, Lindsay Glesener
;

FUNCTION	FORMATTER_DATA_TO_LEVEL0, FILENAME, DETECTOR=DETECTOR, STOP=STOP

	add_path, 'util/'

	frame_length = 256

	; Read in data file.
	openr, lun, filename, /get_lun
	frame = read_binary(lun, data_dims=-1, data_type=2)		; read in integers
	frame = uint(frame)  						; cast to unsigned
	nFrames = n_elements(frame)/frame_length
	frame = reform(frame,[frame_length,nFrames])		; reshape into a frame-by-frame array.
	close, lun							; no longer need the file.

	; The next section pulls the detector data into a structure and 
	; is a little similar to the earlier FOXSI calibration
	; processing codes (specifically formatter_packet_b.pro)

  	; prepare the data structure and make an array with one element for each frame.
  	print, '  Creating data structure.'
  	data_struct = {foxsi_level0, $
		frame_counter:ulong(0),	$	; formatter frame counter value, 32 bits
		wsmr_time:double(0),	$	;
		frame_time:ulong64(0), 	$	; formatter frame time, 64 bits
		det_num:uint(0),		$	; same for all frames; from input keyword
		trigger_time:uint(0), 	$	; raw trigger time value, 16 bits
		hit_asic:intarr(2)-1, 	$	; which ASIC is likely hit, [p,n]
		hit_strip:uintarr(2), 	$	; strip with highest ADC value, [p,n]
		hit_adc:uintarr(2), 	$	; highest ADC value, [p,n]
		strips:uintarr(4,3),	$	; 4x3 array of strips with recorded data
		adc:uintarr(4,3), 		$	; 4x3 array of recorded ADC values
		common_mode:uintarr(4), $	; CM value for each ASIC
		channel_mask:ulon64arr(4), $	; channel mask for each ASIC, 1 bit per strip
		HV:uint(0),		$	; detector bias voltage value, with status bits
		temperature:uint(0),	$	; raw A/D thermistor value if exists
		inflight:uint(0),	$	; '1' if frame occurred post-launch (for flight data only!)
		altitude:float(0),	$	;
		error_flag:uint(0)	$	; '1' if obvious error is noticed in that frame's data
                }
    	
    data_struct = replicate(data_struct, nFrames)

    print, '  Filling in header info.'
    data_struct.frame_counter = reform( ishft( ulong(frame[4,*]),16 ) + frame[5,*] )
    data_struct.frame_time = reform( ishft( ulong64(frame[1,*]),32 ) + ishft( ulong64(frame[2,*]),16 ) + frame[3,*] )
    data_struct.det_num = detector
    data_struct.trigger_time = reform( frame[23 + 33*detector, *] )
    
    ; HV data
    data_struct.HV = reform( frame[13,*] )


	; temporary arrays to grab data during loops
	adc_array = uintarr(4,3,nFrames)
	strip_array = uintarr(4,3,nFrames)

	print, '  Filling in ADC values.'
    	for i=0, 3 do begin
       		print, '    ASIC ', i
          	index = 28 + 33*detector + 8*i + [0,1,2]
          	strip = ishft(frame[index,*],-10)
		adc_array[i,*,*] = frame[index,*] - ishft(strip,10)
		strip_array[i,*,*] = strip
    	endfor

	data_struct.adc = adc_array
	data_struct.strips = strip_array

	asic = indgen(4)

    ; Grab the common mode
    data_struct.common_mode = frame[31 + 33*detector + 8*asic,*]

	; Grab the channel mask
    	data_struct.channel_mask = frame[27 + 33*detector + 8*asic,*]
    	data_struct.channel_mask = ishft( data_struct.channel_mask, 16) + frame[26 + 33*detector + 8*asic,*]
    	data_struct.channel_mask = ishft( data_struct.channel_mask, 16) + frame[25 + 33*detector + 8*asic,*]
    	data_struct.channel_mask = ishft( data_struct.channel_mask, 16) + frame[24 + 33*detector + 8*asic,*]

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
	
	; Compress data by getting rid of "zero" frames.  If a detector's trigger time
	; is 0, then the frame is empty for that detector.  However, to not lose any
	; data (even if it's bad), here frames are only thrown away if all data is 0
	; except ASIC 3 common mode.  (ASIC 3 common mode should usually be nonzero.)

	print, "  Deleting zero frames."

	; Find the max value of all 33 words per detector in the frame.
	; If max value is zero, then the frame is empty for this detector.
	max_frame = cmapply('max', frame[ 23+33*detector:54+33*detector, *], [1])
	data_struct_compressed = data_struct[ where( max_frame gt 0 ) ]

	; Last step: check for obvious errors and flag these.

	print, "  Checking data and flagging abnormalities."
	; Check for events where *any* common mode > 1023
	cm_max = cmapply('max', data_struct_compressed.common_mode, [1] )
	data_struct_compressed[ where( cm_max gt 1023 ) ].error_flag = 1

	if keyword_set(stop) then stop

	print, "  Done!"

	return, data_struct_compressed

END

