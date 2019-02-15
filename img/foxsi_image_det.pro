;+
;
; Purpose:
; 	This routine computes a 2D intensity array for a single detector, in detector coords.
; 	No binning choices; works in raw strip coordinates instead.
;
;
; Inputs:
;		DATA	FOXSI Level 2 data structure
; 
; Keywords:
;		ERANGE	Energy range to include in image (in keV).  Default [4,15]
;		TRANGE	Time range to include in image (in seconds *from launch*)
;				Default entire flight
;		THR_N	Threshold to use for n-side data.
;		YEAR	2012 or 2014 flight.  Default 2014.
;		CDTE Set to 1 if CdTe detector
;		KEEPALL	Keep all events, not just the "good" ones (i.e. those w/no error flags)
;		FLATFIELD		Apply flatfielding correction.
;
;
; Example:
; 	To make an image for D6 for the FOXSI-2 flight:
;
;	image6 = foxsi_image_det( data_lvl2_d6, year=2014 )
;	map6 = make_map( image6, dx=7.78, dy=7.78, xcen=xc, ycen=yc, $
;	time=time, id='D6' )
;
; History:	
;		2018 Oct 29 Sophie Added CdTe keyword and restrict the flip on Y axis to Silicon detectors
;		2015 Jul 23	Linz	Added flatfielding capability
;		2015 Jan 19	Linz	Drawing flight parameters from file instead of hardcoding.
;		2014 Dec	Linz	Updated to work for 2014 data too.
;		Updates throughout 2014 for FOXSI-1 data
;		2014 Jan	Linz	Wrote routine
;-

FUNCTION FOXSI_IMAGE_DET, DATA, ERANGE = ERANGE, TRANGE = TRANGE, $
                          THR_N = THR_N, KEEPALL = KEEPALL, cdte=cdte, $
                          YEAR=YEAR, flatfield=flatfield, STOP = STOP
    COMMON FOXSI_PARAM
	  default, erange, [4.,15.]
;  	if not keyword_set(trange) then trange=[108.3,498.3] ; time range in sec (from launch)
	  default, thr_n, 4.		; n-side keV threshold
  	default, year, 2014
  	default, trange, [0,500]
  	default, cdte, 0
  	
  	detector = data[0].det_num

	; throw out any potentially bad events
	if keyword_set( keepall ) then data2=data else data2 = data[ where( data.error_flag eq 0 ) ]

	; restrict ADC range
	data2 = data2[ where( data2.hit_energy[1] gt erange[0] and data2.hit_energy[1] lt erange[1]$
				 and data2.hit_energy[0] gt thr_n ) ]

	istart=long(0)
	i_times = where( data2.wsmr_time ge (trange[0]+tlaunch) and data2.wsmr_time le (trange[1]+tlaunch) )
  if i_times[0] eq -1 then begin
			print, 'No events in time range.'
			return, -1
	endif
	istart = i_times[0]
	iend = i_times[n_elements(i_times)-1]

  img = fltarr( 128, 128 )

  for i=istart, iend-1 do begin

	; Note: values are pinned to a pixel corner in data structure.
	; Change this to the pixel center.
;    err = get_payload_coords([64,64],detector) - xyerr
    position = data2[i].hit_xy_det
    xpix = (long(position))[0]
    ypix = (long(position))[1]
    img[xpix, ypix] += 1
          
  endfor
  
	if keyword_set(stop) then stop

	IF CDTE EQ 0 THEN img = reverse( img, 2 )
	
	; Apply flatfield correction
	if keyword_set( flatfield ) then begin
		case detector of
			0: det=detnum0
			1: det=detnum1
			2: det=detnum2
			3: det=detnum3
			4: det=detnum4
			5: det=detnum5
			6: det=detnum6
		endcase	

		restore, 'calibration_data/norm_D'+strtrim(det,2)+'_allASIC_allChan.sav
	
		x = [ reverse(chan2), reverse(chan3) ]
		y = [ reverse(chan1), reverse(chan0) ]
		img2 = img
		for i=0, 127 do img2[i,*]=img[i,*]/x[i]*1000
		for i=0, 127 do img2[*,i]=img[*,i]/y[i]*1000
		img2[ where(finite(img2) eq 0) ] = 0.
		img2 = img2*total(img)/total(img2)	; overall scaling to match original
		img = img2

	endif
	
	return, img

END
