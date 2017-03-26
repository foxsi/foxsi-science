;+
;
; Purpose:
; 	This routine computes a 2D intensity array cut on a circular
;   area of interest for a single detector, in detector coords.
;	By default returns a map, but can return the number of counts 
;	inside the circle or the good_fraction by using the appropiate
;	keywords.
;
; Inputs:
;		DATA	FOXSI Level 2 data structure
; 		TARGET  Chose one of: cen1_pos0, cen1_pos1, cen1_pos2, cen2_pos0
;							  cen2_pos1, cen3_pos0, cen3_pos1, cen3_pos2
;							  cen4, cen5
;
; Keywords:
;		CENTER			Center of the circular area of interest.
;		RADIUS  		Radius of the circle of interest.
;		ERANGE			Energy range to include in image (in keV).  Default [4,15]
;		TRANGE			Time range to include in image (in seconds *from launch*)
;						Default entire flight
;		THR_N			Threshold to use for n-side data.
;		GOOD_FRACTION 	Routine returns the good_fraction for the chose target and time
;		COUNTS			Funtion returns the counts inside the circular area of interest
;		FLUX			Return counts per second per keV per solar surface area, correcting 
;						for the effective area of the optical module. 
;		PLOT    		Plot of the region of interest
;		STOP 			Stop to debugg program
;
;
; Examples:
; 	To make a cut circular image for D6 for the FOXSI-2 flight:
;
;	cmap = foxsi_surface_brightness( data_lvl2_d6, cen1_pos2, /plot)
;	counts = foxsi_surface_brightness( data_lvl2_d0,center=[400.,-440.],radius=[200.],cen1_pos0 ,/counts)
;	flux = foxsi_surface_brightness( data_lvl2_d0,center=[400.,-440.],radius=[200.],cen1_pos1 ,/flux)
;
;
; History:	
;		2017 March	Milo	Wrote routine
;-

FUNCTION FOXSI_SURFACE_BRIGHTNESS, DATA,TARGET,CENTER=CENTER,RADIUS=RADIUS,ERANGE=ERANGE, TRANGE=TRANGE, $
						THR_N=THR_N,GOOD_FRACTION=GOOD_FRACTION,COUNTS=COUNTS,FLUX=FLUX,$
						Uncertainty=Uncertainty,PLOT=PLOT,STOP=STOP
COMMON FOXSI_PARAM
default, center, target
default, radius, [200.]
default, erange, [4.,15.]
default, thr_n, 4.		; n-side keV threshold

detnum = data[0].det_num
targetnum = fix(strmid(scope_varname(target),3,1))


if keyword_set( TRANGE ) then begin 
	trange = trange 
endif else begin 
	case scope_varname(target) of
		'CEN1_POS0': trange = [t1_pos0_start,t1_pos0_end]
		'CEN1_POS1': trange = [t1_pos1_start,t1_pos1_end]
		'CEN1_POS2': trange = [t1_pos2_start,t1_pos2_end]
		'CEN2_POS0': trange = [t2_pos0_start,t2_pos0_end]
		'CEN2_POS1': trange = [t2_pos1_start,t2_pos1_end]
		'CEN3_POS0': trange = [t3_pos0_start,t3_pos0_end]
		'CEN3_POS1': trange = [t3_pos1_start,t3_pos1_end]
		'CEN3_POS2': trange = [t3_pos2_start,t3_pos2_end]
		'CEN4': 	 trange = [t4_start,t4_end]
		'CEN5':      trange = [t5_start,t5_end]
		else: begin
				print, 'Incorrect Target! Chose one of: cen1_pos0, cen1_pos1, cen1_pos2, cen2_pos0'
				print, 'cen2_pos1, cen3_pos0, cen3_pos1, cen3_pos2, cen4, cen5'
				return, -1
		end
	endcase
endelse

cdata = area_cut( data, center, radius, /xycorr)
cdata = time_cut( cdata, trange[0], trange[1], energy=erange )
if is_struct(cdata) eq 0 then begin
	print,'Counts = ', 0
	print,'Flux   = ', 0
	print,'Uncertainty   = ', -1
	Uncertainty = -1
	return, 0 
endif
cmap = foxsi_image_map(cdata, target, erange=erange, trange=trange, thr_n=thr_n, /xycorr )

if keyword_set( GOOD_FRACTION ) then begin
	datat = time_cut( data, trange[0], trange[1], energy=[5.,10.] )
	n_all = n_elements( datat )
	n_good = n_elements( datat[ where( datat.error_flag eq 0 ) ] )
	good_fraction = double(n_good) / n_all
	print, 'The Good Fraction = ',good_fraction
	print, 'For time = ',trange
	print, 'Detector = ',detnum
	return, good_fraction
endif

if keyword_set( COUNTS ) then begin
	Counts = n_elements( cdata[ where( cdata.error_flag eq 0 ) ] ) 
	print, 'Counts = ', Counts
	print, 'Center [arcsec] = ', Center
	print, 'Radius [arcsec] = ', Radius
	print, where( cdata.error_flag eq 0 )
	return, Counts
endif

if keyword_set( FLUX ) then begin
	dt = trange[1] - trange[0] ; delta time
	dE = erange[1] - erange[0] ; delta Energy
	theta = center - target ;off_axis distance
	offaxis_angle = sqrt(theta[0]*theta[0] + theta[1]*theta[1])/60. ;arcmin
	EA = get_foxsi_optics_effarea(module_number=detnum,energy_arr=erange,offaxis_angle=offaxis_angle)
	cir_area = !pi * radius[0] * radius[0] * 2.353e-11 ; steradian
	Flux = (n_elements( cdata[ where( cdata.error_flag eq 0 ) ] ) ) $
			/ ( dt * dE * average(EA.eff_area_cm2) * cir_area )
	Uncertainty = sqrt((n_elements( cdata[ where( cdata.error_flag eq 0 ) ] ) )) $
			/ ( dt * dE * average(EA.eff_area_cm2) * cir_area )
	print, 'Flux [photons/(s keV cm2 steradian)]= ', Flux
	print, 'Poisson Uncertainty = ', Uncertainty
	print, 'Center [arcsec] = ', Center
	print, 'Radius [arcsec] = ', Radius
	print, 'Off axis angle [arcmin] = ', offaxis_angle
	print, 'Effective Area [cm2] = ', average(EA.eff_area_cm2)
	print, 'circular area [steradian] = ', cir_area
	return, Flux
endif

if keyword_set( PLOT ) then begin
	loadct, 2
	reverse_ct
	plot_map, cmap, /limb, lcol=255, col=255, charsi=1.2;, title=cmap.id

	case scope_varname(target) of
		'CEN1_POS0': shift = CEN1_POS0-CEN1_POS2
		'CEN1_POS1': shift = CEN1_POS1-CEN1_POS2
		'CEN1_POS2': shift = CEN1_POS2-CEN1_POS2
		'CEN2_POS0': shift = CEN2_POS0-CEN2_POS1
		'CEN2_POS1': shift = CEN2_POS1-CEN2_POS1
		'CEN3_POS0': shift = CEN3_POS0-CEN3_POS2
		'CEN3_POS1': shift = CEN3_POS1-CEN3_POS2
		'CEN3_POS2': shift = CEN3_POS2-CEN3_POS2
		'CEN4': 	 shift = CEN4-CEN4
		'CEN5':      shift = CEN5-CEN5
	endcase
	draw_fov,det=detnum,target=targetnum[0],shift=shift
	tvcircle,radius,center[0],center[1],/data
endif

if keyword_set( STOP ) then stop


return, cmap
END


