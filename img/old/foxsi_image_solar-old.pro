;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FUNCTION FOXSI_IMAGE_SOLAR, DATA, DETECTOR, ERANGE = ERANGE, TRANGE = TRANGE, $
                          	CENTER = CENTER, PSIZE = PSIZE, SIZE = SIZE, $
                          	XYCOR = XYCOR, THR_N = THR_N
;
; written March 2013 by Ishikawa, modified by Lindsay
;        
; This routine computes a 2D intensity array for multiple detectors at a time.
; Requires foxsi_image_solar_int.pro
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  if not keyword_set(erange) then erange=[4.,15.]   ; energy range in keV
  if not keyword_set(trange) then trange=[108.3,498.3]   ; time range in seconds (from the launch)
  if not keyword_set(center) then center=[0.0, 0.0]   ; image center position in arcseconds
  if not keyword_set(psize) then psize=7.735   ; image pixel size (arcseconds/imagepixel)
  if not keyword_set(size) then size=[300,300]   ; size in image pixel numbers
  if not keyword_set(thr_n) then thr_n =3.0   ; threshold for n-side energy to include in the image


  tlaunch=long(64500.)	; time of launch in seconds-of-day
  
  ; Here are Ishikawa's offsets used if XYCOR is set:
  xerr=[55.4700,      81.4900,      96.3600,      87.8900,      48.2700,      49.5500,      63.4500]
  yerr=[-135.977,     -131.124,     -130.241,     -92.7310,     -95.3080,     -120.276,     -106.360]

  istart=long(0)
  istart=(where(data.wsmr_time ge trange[0]+tlaunch))[0]
  iend=(where(data.wsmr_time gt trange[1]+tlaunch))[0]
  img=fltarr(size[0], size[1])

  xyerr = fltarr(2)
  if keyword_set(xycor) then xyerr = [xerr[detector], yerr[detector]]

  for i=istart, iend-1 do begin

	; Note: we need to find a better way to bin data other than using the random
    ; smearing technique.  For now, values are pinned to a pixel corner.
    err = get_payload_coords([64,64],detector) - xyerr
;          err = get_payload_coords(randomu(seed, 2)+63.5,detector) - xyerr
    position = data[i].hit_xy_solar+err
    position = (position - center)/psize + size/2.
    xpix = (long(position))[0]
    ypix = (long(position))[1]
          
    if xpix ge 0 and xpix lt size[0] and ypix ge 0 and ypix lt size[1] and $
    	data[i].error_flag eq 0 and data[i].hit_energy[1] ge erange[0] and $
        data[i].hit_energy[1] le erange[1] and data[i].hit_energy[0] gt thr_n then begin
        img(xpix, ypix)+=1.
    endif

  endfor

  ;wdef,600,600
  ;image_cont, alog(img+1)
  ;print, 'max count = ',max(img)
  ;print, 'max count rate = ', max(img)/(trange[1]-trange[0])
  ;return, img/(trange[1]-trange[0])


return, img

END
