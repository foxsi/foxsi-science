;
; First, some utility functions.
; Main procedure is below and is 'USB_data_to_level0'
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
; This function reads in a USB (ACTEL) CALIBRATION-style data file (*.dat) and processes 
; it into Level 0 FOXSI data.  The Level 0 FOXSI data structure is meant for use with
; flight data; this function allows the conversion of calibration into a form that can
; be analyzed with flight data software. More documentation of the data structure is 
; available in the FOXSI data description doc.
;
; Inputs:	
;		FILENAME	File to process.  Must be a USB CALIBRATION-style data file.
;
; Keywords:	
;		DETECTOR	Detector number (0-6).  Each detector data
;			   	must be processed individually.  Default D0
;
; Example:
; 	To process formatter data into Level 0 IDL structures and save them:
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
; History:	
;	
;	2013-May-09	Linz	Created routine
;-

FUNCTION	USB_DATA_TO_LEVEL0, FILENAME, DETECTOR=DETECTOR, STOP=STOP

	add_path, 'util/'
	
	; This starts from the data structure that has been produced by
	; read_data_struct_cal_c.  Result of that function should be stored in
	; file.  Read that file into this function.
	
	; input DETECTOR=# to tell the routine which detector it is.
	; (This info is not found in the data file.
	
	restore, filename
	nFrames = n_elements(data)

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
    data_struct.frame_counter = data.frame_counter[0]
    data_struct.frame_time = 0.
    data_struct.det_num = detector
    data_struct.trigger_time = data.time[0]
    data_struct.HV = ishft(200*8, 4)	; set HV to 200, in McB's encoded way.
    data_struct.inflight = 1
    data_struct.common_mode = data.cmn_median

	print, '  Filling in ADC values.'
	
	; temporary values
	hit_strip = intarr(4, nFrames)
	hit_adc = intarr(4, nFrames)

	for j=0L, nFrames-1 do begin
		for i=0, 3 do begin
			max = max(data[j].data[i,3:60], maxind)
			hit_strip[i,j] = maxind
			hit_adc[i,j] = max
			if maxind eq 0 then maxind++
			if maxind eq 63 then maxind--
			data_struct[j].adc[i,*] = data[j].data[i,maxind-1:maxind+1]
			data_struct[j].strips[i,*] = [maxind-1,maxind,maxind+1]
		endfor
	endfor
	
	; see which ASIC had the highest value on each side for each event.
	temp = where( hit_adc[0,*] gt hit_adc[1,*])
	if temp[0] ne -1 then data_struct[temp].hit_asic[0] = 0
	if temp[0] ne -1 then data_struct[temp].hit_strip[0] = reform(hit_strip[0,temp])
	if temp[0] ne -1 then data_struct[temp].hit_adc[0] = reform(hit_adc[0,temp])
	temp = where( hit_adc[1,*] ge hit_adc[0,*])
	if temp[0] ne -1 then data_struct[temp].hit_asic[0] = 1
	if temp[0] ne -1 then data_struct[temp].hit_strip[0] = reform(hit_strip[1,temp])
	if temp[0] ne -1 then data_struct[temp].hit_adc[0] = reform(hit_adc[1,temp])
	temp = where( hit_adc[2,*] gt hit_adc[3,*])
	if temp[0] ne -1 then data_struct[temp].hit_asic[1] = 2
	if temp[0] ne -1 then data_struct[temp].hit_strip[1] = reform(hit_strip[2,temp])
	if temp[0] ne -1 then data_struct[temp].hit_adc[1] = reform(hit_adc[2,temp])
	temp = where( hit_adc[3,*] ge hit_adc[2,*])
	if temp[0] ne -1 then data_struct[temp].hit_asic[1] = 3
	if temp[0] ne -1 then data_struct[temp].hit_strip[1] = reform(hit_strip[3,temp])
	if temp[0] ne -1 then data_struct[temp].hit_adc[1] = reform(hit_adc[3,temp])
	
	return, data_struct

END

