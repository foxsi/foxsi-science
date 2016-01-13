; Function to perform deconvolution of FOXSI images using a measured or calculated PSF.

FUNCTION DECONV_FOXSI_SIMPLE, MAP, $
						PIX=PIX, FOV=FOV, $
						 ALL=ALL, $
					   PSF_SMOOTH=PSF_SMOOTH, $
					   IMG_SMOOTH=IMG_SMOOTH, ROTATION=ROTATION, $
					   STOP = STOP, FIRST = FIRST, $
					   PSF_map=PSF_map, FIX4=FIX4, iter=iter, $
					   RECONV_map = reconv_map, CSTAT=cstat, year=year
					   
					   
 
 	; Detector should be an index array saying which detectors we're using.
 	; Example [0,0,0,0,0,1] for D6.
 
	default, pix, 7.735
	default, fov, 4.
	default, erange, [5.,12.]
	default, psf_smooth, 15		; only applies to measured PSF
	default, img_smooth, 15
	default, rotation, 79
	default, iter, [1,2,3,4,5,10,20,40,80,100]
		
	;if year eq 2012 then flare=[967,-207] $	; from RHESSI flarelist
	;	else flare=[0,-200]
	
	dim = fov*60./pix

	loadct, 5



	; Step 1: Define a PSF map normalized to unity
	; Use either the X5 measured values for 7' off-axis or else the 3-component 
	; 2D Gaussian PSF that came from a fit to the measurement.
	
	print
	print, 'Defining PSF...'
	print
	
		; or, use a gaussian PSF
		params = [ 0.0, 0.0, 0.0, 0.9875, 0.218387, 0.0762158, 1.27836, 1.77492, 4.36214,$
		   7.21397, 47.5, 240.314, 0.0 ]	; parameters from Steven
		   	
		psf1 = psf_gaussian( npix=[dim,dim], /double, st_dev=[1.27836, 1.77492]/pix )
		psf2 = psf_gaussian( npix=[dim,dim], /double, $
							 st_dev=2.*[4.36214, 7.21397]/pix )*params[4]
		psf3 = psf_gaussian( npix=[dim,dim], /double, $
							 st_dev=2.*[47.5, 240.314]/pix )*params[4]*params[5]
		psftest = make_map( psf1+psf2+psf3, dx=pix, dy=pix )
		psf = rot_map( psftest, -45 )
		psf.roll_angle=0.
 
 		psf.data = psf.data / total(psf.data)	; Renormalize
 		size = size(psf.data)
 		
 		; rebin to detector pixel size.
 		;new_data = frebin( psf.data, size[1]/7.735, size[2]/7.735, /total )
 		;psf = make_map( new_data, xcen=psf.xc, ycen=psf.yc, dx=7.735, dy=7.735 )


	;
 	; Step 2: Process measured image
 	;
 
	print
 	print, 'Setting up raw image...'
	print
 
;	imdim = 1000/fix(pix)
	imdim=128*7.78/pix

;	if keyword_set(stop) then stop

	; Find and isolate a FOV around the source.
		first = map
		first_cen = map_centroid( first, thr=0.1*max(first.data) )
		first = make_submap( first, cen=first_cen, fov=3 )
		; this gets returned in keyword FIRST to use as sample unprocessed image.
		
		; Here's the fudge factor...
;		flare_new=map_centroid( map, thresh=0.3*max(map.data) ) - 45
		flare_new=map_centroid( map, thresh=0.3*max(map.data) )
;		raw = shift_map( make_submap( map, cen=flare_new, fov=fov+1), -flare_new[0], -flare_new[1] )
		raw = shift_map( make_submap( map, cen=flare_new, fov=fov), -flare_new[0], -flare_new[1] )
		raw.xc=0
		raw.yc=0
		raw = rebin_map( raw, dim, dim )
		raw.dx = pix
		raw.dy = pix
		centr = map_centroid( raw )
		;raw = make_submap( raw, cen=centr, fov=fov )
		;raw.dx = pix
		;raw.dy = pix
		;raw.data = smooth(raw.data,img_smooth/pix)

	;
	; Some last housekeeping before we iterate.
	;
	
	; a kludge to fix the problem that im dimensions may one-off.
	data_psf = psf.data
	data_raw = raw.data
	nDimPsf = size( psf.data )
	nDimRaw = size( raw.data )
	if n_elements(raw.data) gt n_elements(psf.data) then begin
		sub_map, raw, new, dim=nDimPsf[1:2], ref=psf
		raw = new
	endif
	if n_elements(psf.data) gt n_elements(raw.data) then begin
		sub_map, psf, new, dim=nDimRaw[1:2], ref=raw
		psf = new
	endif
	

 	; Step 3: Do the deconvolution! :D
 
	print
 	print, 'Performing deconvolution...'
	print
 
 	n = n_elements(iter)
 	deconv_map = replicate( raw, n+1 )	; leave an extra at beginning to contain raw image.
 	reconv_map = replicate( raw, n+1 )
    
	smallpsf = make_submap( psf, cen=[0.,0.], fov=1)

 	undefine, deconv
 	undefine, reconv
 	for j=0, iter[n-1] do begin
  		max_likelihood2, raw.data, smallpsf.data, deconv, reconv
  		if total( j eq iter ) gt 0 then begin
  			i = where( j eq iter )
  			deconv_map[i+1].data = deconv
  			reconv_map[i+1].data = reconv
  			deconv_map[i+1].id=strtrim(iter[i],2)+' iter'
  		endif
 	endfor
 
 	print
 	print, 'Done.'
	print

 	deconv_map.roll_angle = 0.
 	
	if keyword_set(stop) then stop
 
 	cstat = fltarr(n)
	print, 'Cash statistics:'
	for j=0, n-1 do print, 'Iteration ', iter[j], ':  ', $
		c_statistic( reconv_map[j].data, raw.data )
	for j=0, n-1 do cstat[j] = c_statistic( reconv_map[j].data, raw.data )

;	ch=1.2
; 	popen, 'deconv-result', xsi=8, ysi=11
; 	!p.multi=[0,3,4]
; 	if measured_psf eq 1 then tit='D5 measured PSF' else tit='D5 fit PSF'
; 	plot_map, psf, tit=tit+' smooth='+strtrim(psf_smooth,2), charsi=ch
; 	plot_map, raw, tit='Raw FOXSI image', charsi=ch
; 	for j=1, n do plot_map, deconv_map[j], tit=deconv_map[j].id, charsi=ch
 
 	; Plot on top of AIA 131 image.
; 	restore, 'data_2012/aia-maps-flare.sav'
; 	!p.multi=[0,2,2]
; 	for j=7, 10 do begin
;		plot_map, aia[0], fov=1.5
; 		plot_map, shift_map(deconv_map[j], flare[0]-6, flare[1]+3), /over, /per,$
; 			color=255, thick=4, lev=[10,30,50,70,90]
; 	endfor
  
	; Plot on top of AIA diff image.  Find AIA image closest in time.

; 	restore, 'data_2012/aia_avg.sav'
;	iavg = closest( anytim(avg.time), anytim('2012-nov-2')+time_range[0] )
 
; 	ch=1.2
; 	!p.multi=[0,2,2]
; 	for j=7, 10 do begin
; 		rotmap = rot_map( deconv_map[j], (rotation-90) )
; 		rotmap.roll_angle=0.
;    	plot_map, avg[iavg], fov=1.5, dmin=0., $
;    		title = strtrim(iter[j-1],2)+ ' iter'
;    	plot_map, shift_map(rotmap, flare[0]-6, flare[1]+3), /over, 4, $
;    		col=255, thick=4, lev=[20,40,60,80], /per
; 	endfor

;	ch=1.1
;	fov=1.5
;	!p.multi=[0,2,2]
;  	plot_map, psf, tit='PSF', charsi=ch, fov=fov
;  	plot_map, psf, /over, lev=[50], /per, thick=5, col=255
;	xyouts, -40, 35, '50% contour', size=1.2, col=255
; 	plot_map, raw, tit='Raw image', charsi=ch, fov=fov
; 	plot_map, raw, /over, lev=[50], /per, thick=5, col=255
;	xyouts, -40, 35, '50% contour', size=1.2, col=255
;	plot_map, deconv_map[8], tit=deconv_map[8].id+', deconvolved', charsi=ch, fov=fov
;	plot_map, deconv_map[8], /over, lev=[50], /per, thick=5, col=255
;	xyouts, -40, 35, '50% contour', size=1.2, col=255
;	plot_map, reconv_map[8], tit=deconv_map[8].id+', reconvolved', charsi=ch, fov=fov
;	plot_map, reconv_map[8], /over, lev=[50], /per, thick=5, col=255
;	xyouts, -40, 35, '50% contour', size=1.2, col=255

;	pclose
	
	return, deconv_map
	
END 