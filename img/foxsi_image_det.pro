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
;		KEEPALL	Keep all events, not just the "good" ones (i.e. those w/no error flags)
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
;		2014 Jan	Linz	Wrote routine
;		Updates throughout 2014 for FOXSI-1 data
;		2014 Dec	Linz	Updated to work for 2014 data too.
;		2015 Jan 19	Linz	Drawing flight parameters from file instead of hardcoding.
;-

FUNCTION FOXSI_IMAGE_DET, DATA, ERANGE = ERANGE, TRANGE = TRANGE, $
                          THR_N = THR_N, KEEPALL = KEEPALL, $
                          YEAR=YEAR, STOP = STOP



	default, erange, [4.,15.]
;  	if not keyword_set(trange) then trange=[108.3,498.3] ; time range in sec (from launch)
	default, thr_n, 4.		; n-side keV threshold
  	default, year, 2014
  	default, trange, [0,500]
  	default, year, 2014

	case year of
		2012:	restore, 'data_2012/flight2012-parameters.sav'
		2014:	restore, 'data_2014/flight2014-parameters.sav'
		else: begin
			print, 'Year can only be 2012 or 2014.'
			return, -1
		end
	endcase

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

    img = hist_2d(data2.hit_xy_det[0], data2.hit_xy_det[1], bin1=1, bin2=1, min1=0, min2=0, max1=127, max2=127)

    result = reverse(img, 2)
  
	if keyword_set(stop) then stop
	
RETURN, result

END