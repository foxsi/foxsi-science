;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FUNCTION FOXSI_IMAGE_DET, DATA, ERANGE = ERANGE, TRANGE = TRANGE, $
                          XYCOR = XYCOR, THR_N = THR_N, STOP = STOP
;
; written Jan 2014 by Linz
;        
; This routine computes a 2D intensity array for a single detector, in detector coords.
; Works from Level 1 data (NOT level 2).  Useful for calibration purposes.
; No binning choices; works in raw strip coordinates instead.
;
; Inputs:
;	DATA	FOXSI Level 1 data structure
;	ERANGE	Energy range to include in image (in keV)
;	TRANGE	Time range to include in image (in seconds *from launch*)
;	XYCOR	Correct for detector and payload offsets.
;			These values are hardcoded and were obtained by
;			comparing the flare centroid with RHESSI's.
;	THR_N	Threshold to use for n-side data.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;  	if not keyword_set(erange) then erange=[4.,15.]      ; energy range in keV
  	if not keyword_set(trange) then trange=[108.3,498.3] ; time range in sec (from launch)
  	if not keyword_set(thr_n) then thr_n =3.0    ; desired n-side energy threshold

  	tlaunch=long(64500.)	; time of launch in seconds-of-day
  
  	; Here are Ishikawa's offsets used if XYCOR is set:
;  	xerr=[55.4700,    81.490,   96.360,  87.8900,  48.2700,   49.550,   63.450]
;  	yerr=[-135.977, -131.124, -130.241, -92.7310, -95.3080, -120.276, -106.360]

	; throw out any potentially bad events
	data = data[ where( data.error_flag eq 0 ) ]

;	native_bin = 7.735*( cos(rotation) + sin(rotation) )
	
  	istart=long(0)
  	i_times = where( data.wsmr_time ge (trange[0]+tlaunch) and data.wsmr_time le (trange[1]+tlaunch) )
	if i_times[0] eq -1 then begin
		print, 'No events in time range.'
		return, -1
	endif
	istart = i_times[0]
	iend = i_times[n_elements(i_times)-1]
  	img = fltarr( 128, 128 )

;  	xyerr = fltarr(2)
;  	if keyword_set(xycor) then xyerr = [xerr[detector], yerr[detector]]

  	for i=istart, iend-1 do begin

	; Note: values are pinned to a pixel corner in data structure.
	; Change this to the pixel center.
;    err = get_payload_coords([64,64],detector) - xyerr
    position = data[i].hit_xy_det
    xpix = (long(position))[0]
    ypix = (long(position))[1]
    img[xpix, ypix] += 1
          
;    if xpix ge 0 and xpix lt size_nat[0] and ypix ge 0 and ypix lt size_nat[1] and $
;    	; data[i].error_flag eq 0 and $
;    	data[i].hit_energy[1] ge erange[0] and $
;        data[i].hit_energy[1] le erange[1] and data[i].hit_energy[0] gt thr_n then begin
;        img_nat(xpix, ypix)+=1.
;    endif

  endfor
  
  ; Rebin image into the desired bin size and dimensions.
;  img = frebin( img_nat, size[0], size[1], /total )

if keyword_set(stop) then stop

  ;wdef,600,600
  ;image_cont, alog(img+1)
  ;print, 'max count = ',max(img)
  ;print, 'max count rate = ', max(img)/(trange[1]-trange[0])
  ;return, img/(trange[1]-trange[0])

return, reverse( img, 2 )

END
