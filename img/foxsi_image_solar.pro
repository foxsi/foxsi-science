;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FUNCTION FOXSI_IMAGE_SOLAR, DATA, DETECTOR, ERANGE = ERANGE, TRANGE = TRANGE, $
                          	CENTER = CENTER, PSIZE = PSIZE, SIZE = SIZE, $
                          	XYCOR = XYCOR, THR_N = THR_N
;
; written March 2013 by Ishikawa, modified by Lindsay
;        
; This routine computes a 2D intensity array for multiple detectors at a time.
;
; Inputs:
;	DATA	FOXSI Level 2 data structure
;	DETECTOR	Detector number
;	ERANGE	Energy range to include in image (in keV)
;	TRANGE	Time range to include in image (in seconds *from launch*)
;	CENTER	Center of image (arcseconds)
;	PSIZE	Image pixel size (arcseconds)
;	SIZE	Image size in pixels
;	XYCOR	Correct for detector and payload offsets.
;			These values are hardcoded and were obtained by
;			comparing the flare centroid with RHESSI's.
;	THR_N	Threshold to use for n-side data.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  	if not keyword_set(erange) then erange=[4.,15.]      ; energy range in keV
  	if not keyword_set(trange) then trange=[108.3,498.3] ; time range in sec (from launch)
  	if not keyword_set(center) then center=[0.0, 0.0]    ; img center position in arcsec
 	if not keyword_set(psize) then psize=7.735   ; img pixel size (arcseconds/imagepixel)
  	if not keyword_set(size) then size=[500,500] ; size in image pixel numbers
  	if not keyword_set(thr_n) then thr_n =3.0    ; desired n-side energy threshold

  	tlaunch=long(64500.)	; time of launch in seconds-of-day
  
  	; Here are Ishikawa's offsets used if XYCOR is set:
  	xerr=[55.4700,    81.490,   96.360,  87.8900,  48.2700,   49.550,   63.450]
  	yerr=[-135.977, -131.124, -130.241, -92.7310, -95.3080, -120.276, -106.360]

	; get rotation angle for this detector.
	case detector of
		0: rotation =  82.5
		1: rotation =  75.0
		2: rotation = -67.5
		3: rotation = -75.0
		4: rotation =  97.5
		5: rotation =  90.0
		6: rotation = -60.0
	else: begin
		print, 'Detector number out of range (0-6).'
		return, -1
	      end
	endcase
	
	if rotation lt 0 then rotation = rotation*(-1)
	while rotation gt 90 do rotation = rotation - 90.
	print, '  Detector ', detector, ', absolute value rotation angle = ', rotation
	rotation = rotation*!pi/180.
	; **NATIVE BIN SIZE**
	native_bin = 7.735*( cos(rotation) + sin(rotation) )
	print, '  Native image bin size: ', native_bin, ' arcsec'
	
	; number of native bins in output image
	size_nat = fix(size / (native_bin/psize))
	print, '  ', '  Native pixels in image: ', size_nat

  	istart=long(0)
  	istart=(where(data.wsmr_time ge trange[0]+tlaunch))[0]
  	iend=(where(data.wsmr_time gt trange[1]+tlaunch))[0]
  	img_nat = fltarr( size_nat[0], size_nat[1] )  ; image in native pixels
  	img = fltarr( size[0], size[1] )	; image in user-desired pixels

  	xyerr = fltarr(2)
  	if keyword_set(xycor) then xyerr = [xerr[detector], yerr[detector]]

	; first, make the image with native binning

  	for i=istart, iend-1 do begin

	; Note: values are pinned to a pixel corner in data structure.
	; Should change this to the pixel center.
    err = get_payload_coords([64,64],detector) - xyerr
    position = data[i].hit_xy_solar+err
    position = (position - center)/native_bin + size_nat/2.
    xpix = (long(position))[0]
    ypix = (long(position))[1]
          
    if xpix ge 0 and xpix lt size_nat[0] and ypix ge 0 and ypix lt size_nat[1] and $
    	data[i].error_flag eq 0 and data[i].hit_energy[1] ge erange[0] and $
        data[i].hit_energy[1] le erange[1] and data[i].hit_energy[0] gt thr_n then begin
        img_nat(xpix, ypix)+=1.
    endif

  endfor
  
  ; Rebin image into the desired bin size and dimensions.
  img = frebin( img_nat, size[0], size[1], /total )
;  img = congrid( img_nat, size[0], size[1], /center, /interp )
;  img = img*total(img_nat)/total(img)

  ;wdef,600,600
  ;image_cont, alog(img+1)
  ;print, 'max count = ',max(img)
  ;print, 'max count rate = ', max(img)/(trange[1]-trange[0])
  ;return, img/(trange[1]-trange[0])


return, img

END
