;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FUNCTION FOXSI_IMAGE_SOLAR, DATA_IN, DETECTOR, ERANGE = ERANGE, TRANGE = TRANGE, $
                                  CENTER = CENTER, PSIZE = PSIZE, SIZE = SIZE, $
                                  XYCOR = XYCOR, THR_N = THR_N, STOP = STOP, ROT=ROT, $
                                  KEEP_BAD = KEEP_BAD, YEAR = YEAR

; 2015 Feb 18			Adding functionality for FOXSI-2.
; 2014 March Linz	Reworking this to use foxsi_image_det as a starting point, to 
; 					avoid strange aliasing effects that showed up earlier.
;					RETURN VARIABLE IS NOW A PLOTMAP!!
; 2014 Feb	Linz	Added keywords ROT and KEEP_BAD
; written March 2013 by Ishikawa, modified by Lindsay
;        
; This routine computes a plotmap for a single detector.
;
; Inputs:
;        DATA_IN        FOXSI Level 2 data structure
;        DETECTOR        Detector number
;        ERANGE        Energy range to include in image (in keV)
;        TRANGE        Time range to include in image (in seconds *from launch*)
;        CENTER        Center of image (arcseconds)
;        PSIZE        Image pixel size (arcseconds)
;        SIZE        Image size in pixels
;        XYCOR        Correct for detector and payload offsets.
;                        These values are hardcoded and were obtained by
;                        comparing the flare centroid with RHESSI's.
;        THR_N        Threshold to use for n-side data.
;		 ROT		Detector rotation put in by hand.  If not set, detector-dependent
;					default is used.  (For normal analysis, do not use this keyword.)
;		 KEEP_BAD	Include events with a nonzero error flag.
;				YEAR			Year of flight; default 2014
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  COMMON FOXSI_PARAM
  default, erange, [4.,15.]      	; energy range in keV
  default, trange, [108.3,498.3] 	; time range in sec (from launch)
  default, trange, [0.,1200.] 	; time range in sec (from launch)
  default, center, [0.,0.]    	; img center position in arcsec
	default, psize,  7.735   		; img pixel size (arcseconds/imagepixel)
;    default, size,   [2000,2000] 	; size in image pixel numbers
  default, thr_n,   4.0    		; desired n-side energy threshold
			
;    ; Here are Ishikawa's offsets used if XYCOR is set:
;    xerr=[55.4700,    81.490,   96.360,  87.8900,  48.2700,   49.550,   63.450]
;    yerr=[-135.977, -131.124, -130.241, -92.7310, -95.3080, -120.276, -106.360]
	case detector of
			0: shift = shift0
			1: shift = shift1
			2: shift = shift2
			3: shift = shift3
			4: shift = shift4
			5: shift = shift5
			6: shift = shift6
	else: begin
			print, 'Detector number out of range (0-6).'
      return, -1
  end
  endcase
	
    data = data_in

    ; throw out any potentially bad events
    if not keyword_set(keep_bad) then data = data[ where( data.error_flag eq 0 ) ]
    
    data = data[ where( data.wsmr_time gt trange[0]+tlaunch and $
    	data.wsmr_time lt trange[1]+tlaunch ) ]

;    ; get rotation angle for this detector.
;    case detector of
;        0: rotation =  82.5
;        1: rotation =  75.0
;        2: rotation = -67.5
;        3: rotation = -75.0
;        4: rotation =  97.5
;        5: rotation =  90.0
;        6: rotation = -60.0
;    else: begin
;        print, 'Detector number out of range (0-6).'
;        return, -1
;    end
;    endcase
    
    ; If ROT is set, this will override the just-set rotation.
    if keyword_set(rot) then rotation = rot
    
  ;  if keyword_set(stop) then stop
                
;	; Check to see if pointing is stable over the time interval.
	if stdev( data.pitch, pitch ) gt 2. or stdev( data.yaw, yaw ) gt 2. then begin
;		print, 'More than one target is selected.'
;		return, -1
	endif
	
	; if desired, correct for pointing offset.
	if keyword_set( xycor ) then begin
		xcen = pitch - shift[0]
		ycen = -yaw - shift[1]		; remember the yaw axis is flipped.
	endif else begin
		xcen = pitch
		ycen = -yaw
	endelse

	; produce image and convert to a map
	time = t0 + trange[0]
;	time = anytim( '2012-nov-02 17:55:00' ) + trange[0]
	image = foxsi_image_det( data, erange=erange, trange=trange, thr_n=thr_n)
	map = make_map( image, xcen=xcen, ycen=ycen, dx=7.735, dy=7.735, time=anytim(time,/yo) )
	rot = rot_map( map, rotation )
	rot.roll_angle = 0.

	; rebin map to desired pixel size.
	size = size( rot.data )
	nx = size[1]*7.735/psize
	ny = size[2]*7.735/psize
	rebin = rebin_map( rot, nx, ny )
	
	; rebin messes up the normalization; restore it here.
	n=n_elements( where(data.hit_energy[1] gt erange[0] and data.hit_energy[1] lt $
						erange[1] and data.hit_energy[0] gt thr_n) )
	scale = float(n) / total(rebin.data)
	rebin.data *= scale
	
	if keyword_set(stop) then stop
	
	return, rebin

END