;+
;
; Purpose:
;	This routine is a wrapper for FOXSI_IMAGE_DET.
;	It performs some additional steps to turn the image into a plot_map in solar coords.
;
; Inputs:
;		DATA	FOXSI Level 2 data structure
;		CENTER	Center of that target.
; 
; Keywords:
;		ERANGE	Energy range to include in image (in keV).  Default [4,15]
;		TRANGE	Time range to include in image (in seconds *from launch*)
;				Default entire flight
;		CENTER	Map center
;		THR_N	Threshold to use for n-side data.
;		YEAR	2012 or 2014 flight.  Default 2014.
;		KEEPALL	Keep all events, not just the "good" ones (i.e. those w/no error flags)
;		XYCORR	If set, use the position offset for that detector.
;
;
; Example:
; 	To make an image for D6 for the FOXSI-2 flight:
;
;	map6 = foxsi_image_map( data_lvl2_d6, cen1_pos2, trange=[t1_pos2_start, t1_pos2_end] )
;	plot_map, map6, /log, /cbar
;
; History:	
;		2015 Jan 19	Linz	Created routine.
;-

FUNCTION FOXSI_IMAGE_MAP, DATA,  CENTER, ERANGE = ERANGE, TRANGE = TRANGE, $
                          THR_N = THR_N, KEEPALL = KEEPALL, $
                          YEAR=YEAR, XYCORR=XYCORR, STOP = STOP

	default, erange, [4.,15.]
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

	xc = center[0]
	yc = center[1]
	
	detnum = data[0].det_num

	; Map time will be the center of the given time interval.
	time = anytim( date ) + average(trange)+tlaunch
	time = anytim( time, /yo )

	; Basic image production
	image = foxsi_image_det( data, trange=trange, erange=erange, $
		keepall=keepall, year=year, thr_n=thr_n )

	if year eq 2014 and ( detnum eq 2 or detnum eq 3) then $
		stripsize = 7.7349 else stripsize = 6.1879

	map = make_map( image, dx=stripsize, dy=stripsize, xcen=xc, ycen=yc, $
		time=time, id='Det'+strtrim(detnum,2) )

	case detnum of
		0: shift = shift0
		1: shift = shift1
		2: shift = shift2
		3: shift = shift3
		4: shift = shift4
		5: shift = shift5
		6: shift = shift6
		else: begin
			print, 'Incorrect detector number; bad data!'
			return, -1
		end
	endcase

	; Apply positioning corrections, if desired.
	if keyword_set( XYCORR ) then map = shift_map( map, shift[0], shift[1] )

	case detnum of
		0: rot = rot0
		1: rot = rot1
		2: rot = rot2
		3: rot = rot3
		4: rot = rot4
		5: rot = rot5
		6: rot = rot6
		else: begin
			print, 'Incorrect detector number; bad data!'
			return, -1
		end
	endcase

	; Rotate the image based on the rotation angle for that specific detector.
	map = rot_map( map, rot )
	map.roll_angle = 0.
	map.roll_center = 0.

	return, map
	
END
