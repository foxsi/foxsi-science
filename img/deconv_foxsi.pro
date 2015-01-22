; Function to perform deconvolution of FOXSI images using a measured or calculated PSF.

FUNCTION DECONV_FOXSI, DETECTOR, TIME_RANGE, PIX=PIX, FOV=FOV, ERANGE=ERANGE, ALL=ALL, $
					   PLATE_SCALE=PLATE_SCALE, PSF_SMOOTH=PSF_SMOOTH, $
					   IMG_SMOOTH=IMG_SMOOTH, ROTATION=ROTATION, $
					   MEASURED_PSF = MEASURED_PSF, STOP = STOP, FIRST = FIRST, $
					   PSF_map=PSF_map, FIX4=FIX4, iter=iter, $
					   RECONV_map = reconv_map, CSTAT=cstat, year=year
					   
					   
 
 	; Detector should be an index array saying which detectors we're using.
 	; Example [0,0,0,0,0,1] for D6.
 
	default, pix, 1.
	default, fov, 2.
	default, erange, [5.,12.]
	default, plate_scale, 1.3
 	; 2. is a good value for D6, 2. is a good value for D4.
 	; 1.3 is nominal value.
	default, psf_smooth, 15		; only applies to measured PSF
	default, img_smooth, 15
	default, rotation, 79
	default, measured_psf, 0
	default, iter, [1,2,3,4,5,10,20,40,80,100]

	
	print
	print, 'Loading data.'
	print
	
	if year eq 2012 then restore, 'data_2012/foxsi_level2_data.sav' $
		else if year eq 2014 then restore, 'data_2014/foxsi_level2_data.sav' $
		else begin
			print, 'year should be 2012 or 2014'
			return, -1
		endelse
		
	if year eq 2012 then flare=[967,-207] $	; from RHESSI flarelist
		else flare=[0,-200]
	
	; usable times	
	if year eq 2012 then t_launch = 64500 else t_launch = 69060
	t4_start = t_launch + 340		; Target 4 (flare)
	t4_end = t_launch + 420.		; slightly altered from nominal 421.2
	t5_start = t_launch + 423.5		; Target 5 (off-pointing)
	t5_end = t_launch + 435.9
	t6_start = t_launch + 438.5		; Target 6 (flare)
	t6_end = t_launch + 498.3
	
	default, time_range, [t4_start, t6_end]
	
	dim = fov*60./pix

	loadct, 5

	; Step 1: Define a PSF map normalized to unity
	; Use either the X5 measured values for 7' off-axis or else the 3-component 
	; 2D Gaussian PSF that came from a fit to the measurement.
	
	print
	print, 'Defining PSF...'
	print
 
	 if keyword_set(measured_psf) then begin

		if year eq 2012 then $
			f=file_search('data_2012/45az*.fits') $	; file containing measured PSF 7' offaxis
		else f=file_search('data_2014/atfocus_1s_10times.fits')
 		fits_read, f, data, ind
 
 		m0 = make_map( float(data[*,*,0]), dx=plate_scale, dy=plate_scale )
 		m1 = make_map( float(data[*,*,1]), dx=plate_scale, dy=plate_scale )
 		m2 = make_map( float(data[*,*,2]), dx=plate_scale, dy=plate_scale )
 		m3 = make_map( float(data[*,*,3]), dx=plate_scale, dy=plate_scale )
 		m4 = make_map( float(data[*,*,4]), dx=plate_scale, dy=plate_scale )
 		m5 = make_map( float(data[*,*,5]), dx=plate_scale, dy=plate_scale )
 		m6 = make_map( float(data[*,*,6]), dx=plate_scale, dy=plate_scale )
 		m7 = make_map( float(data[*,*,7]), dx=plate_scale, dy=plate_scale )
 		m8 = make_map( float(data[*,*,8]), dx=plate_scale, dy=plate_scale )
 		m9 = make_map( float(data[*,*,9]), dx=plate_scale, dy=plate_scale )
 		m=[m0,m1,m2,m3,m4,m5,m6,m7,m8,m9]
 		m_sum = m0
 		m_sum.data = total(m.data, 3)
 		med = median( m_sum.data )	; subtract a constant value.
 		m_sum.data = m_sum.data - med
 		for i=0, n_elements(m)-1 do begin
   			med = median(m[i].data)
   			m[i].data = m[i].data - med
 		endfor
 		; Switch PSF to center of a map.
 		cen = [250., -326.]/1.3*plate_scale
 		psf = shift_map( make_submap( m_sum, cen=cen, fov=fov ), -cen[0], -cen[1] )
 		psf = rot_map( psf, rotation )
 		psf = make_map( frebin( psf.data, dim, dim, /total ), dx=pix, dy=pix )
 		psf.data = smooth(psf.data, psf_smooth)
  	
  	endif else begin
	
		; or, use a gaussian PSF
		params = [ 0.0, 0.0, 0.0, 0.9875, 0.218387, 0.0762158, 1.27836, 1.77492, 4.36214,$
		   7.21397, 47.5, 240.314, 0.0 ]	; parameters from Steven
		   	
		;psf1 = psf_gaussian( npix=[120,120], /double, st_dev=[1.27836, 1.77492]/pix )
		;psf2 = psf_gaussian( npix=[120,120], /double, $
		;					 st_dev=2.*[4.36214, 7.21397]/pix )*params[4]
		;psf3 = psf_gaussian( npix=[120,120], /double, $
		;					 st_dev=2.*[47.5, 240.314]/pix )*params[4]*params[5]
		psf1 = psf_gaussian( npix=[dim,dim], /double, st_dev=[1.27836, 1.77492]/pix )
		psf2 = psf_gaussian( npix=[dim,dim], /double, $
							 st_dev=2.*[4.36214, 7.21397]/pix )*params[4]
		psf3 = psf_gaussian( npix=[dim,dim], /double, $
							 st_dev=2.*[47.5, 240.314]/pix )*params[4]*params[5]
		psftest = make_map( psf1+psf2+psf3, dx=pix, dy=pix )
		psf = rot_map( psftest, -45 )
		psf.roll_angle=0.
 
 	endelse

 	psf.data = psf.data / total(psf.data)	; Renormalize

 	; Step 2: Retrieve flare data and prep it.
 
	print
 	print, 'Retrieving flare data...'
	print
 
 	t0 = time_range[0] - t_launch
	t1 = time_range[1] - t_launch
	
	tr = [t0,t1]
	
	n_det=n_elements( detector[ where( detector gt 0 ) ] )

	if detector[0] gt 0 then $
		img0=foxsi_image_det( data_lvl2_d0, erange=erange, trange=tr,thr_n=4., year=year)
	if detector[1] gt 0 then $
		img1=foxsi_image_det( data_lvl2_d1, erange=erange, trange=tr,thr_n=4., year=year)
	if detector[2] gt 0 then $
		img2=foxsi_image_det( data_lvl2_d2, erange=erange, trange=tr,thr_n=4., year=year)
	if detector[3] gt 0 then $
		img3=foxsi_image_det( data_lvl2_d3, erange=erange, trange=tr,thr_n=4., year=year)
	if detector[4] gt 0 then $
		img4=foxsi_image_det( data_lvl2_d4, erange=erange, trange=tr,thr_n=4., year=year)
	if detector[5] gt 0 then $
		img5=foxsi_image_det( data_lvl2_d5, erange=erange, trange=tr,thr_n=4., year=year)
	if detector[6] gt 0 then $
		img6=foxsi_image_det( data_lvl2_d6, erange=erange, trange=tr,thr_n=4., year=year)
 
 	; Rotation angles for all detectors (as designed, no tweaks yet).
	rot0 = 82.5
	rot1 = 75.
	rot2 = -67.5
	rot3 = -75.
	rot4 = 97.5
	rot5 = 90.
	rot6 = -60.

;	imdim = 1000/fix(pix)
	imdim=128*7.78/pix

 	if n_det eq 1 then begin

		i = where( detector ne 0 )
		case i of
			0: begin
				img0 = foxsi_image_det( data_lvl2_d0, erange=erange, trange=tr, thr_n=4.)
				map  = rot_map( make_map( img0, dx=7.78, dy=7.78 ), rot0 )
			  	end
			1: begin
				img1 = foxsi_image_det( data_lvl2_d1, erange=erange, trange=tr, thr_n=4.)
				map  = rot_map( make_map( img1, dx=7.78, dy=7.78 ), rot1 )
			  	end
			2: begin
				img2 = foxsi_image_det( data_lvl2_d2, erange=erange, trange=tr, thr_n=4.)
				map  = rot_map( make_map( img2, dx=7.78, dy=7.78 ), rot2 )
			  	end
			3: begin
				img3 = foxsi_image_det( data_lvl2_d3, erange=erange, trange=tr, thr_n=4.)
				map  = rot_map( make_map( img3, dx=7.78, dy=7.78 ), rot3 )
			  	end
			4: begin
				img4 = foxsi_image_det( data_lvl2_d4, erange=erange, trange=tr, thr_n=4.)
				if keyword_set( fix4 ) then img4[18,*] = (img4[17,*] + img4[19,*])/2.
				map  = rot_map( make_map( img4, dx=7.78, dy=7.78 ), rot4 )
			  	end
			5: begin
				img5 = foxsi_image_det( data_lvl2_d5, erange=erange, trange=tr, thr_n=4.)
				map  = rot_map( make_map( img5, dx=7.78, dy=7.78 ), rot5 )
			  	end
			6: begin
				img6 = foxsi_image_det( data_lvl2_d6, erange=erange, trange=tr, thr_n=4.)
				map  = rot_map( make_map( img6, dx=7.78, dy=7.78 ), rot6 )
			  	end
		endcase

	if keyword_set(stop) then stop

		first = map
		first_cen = map_centroid( first, thr=0.1*max(first.data) )
		first = make_submap( first, cen=first_cen, fov=3 )
		; this gets returned in keyword FIRST to use as sample unprocessed image.
		
		flare_new=map_centroid( map, thresh=0.3*max(map.data) ) - 45
		raw = shift_map( make_submap( map, cen=flare_new, fov=fov+1), -flare_new[0], -flare_new[1] )
		raw.xc=0
		raw.yc=0
		raw = rebin_map( raw, dim, dim )
		raw.dx = pix
		raw.dy = pix
		centr = map_centroid( raw )
		raw = make_submap( raw, cen=centr, fov=fov )
		raw.dx = pix
		raw.dy = pix
		raw.data = smooth(raw.data,img_smooth/pix)

	endif else begin
		img0 = foxsi_image_det( data_lvl2_d0, erange=erange, trange=tr, thr_n=4.)
		img1 = foxsi_image_det( data_lvl2_d1, erange=erange, trange=tr, thr_n=4.)
		img2 = foxsi_image_det( data_lvl2_d2, erange=erange, trange=tr, thr_n=4.)
		img3 = foxsi_image_det( data_lvl2_d3, erange=erange, trange=tr, thr_n=4.)
		img4 = foxsi_image_det( data_lvl2_d4, erange=erange, trange=tr, thr_n=4.)
		if keyword_set( fix4 ) then img4[18,*] = (img4[17,*] + img4[19,*])/2.
		img5 = foxsi_image_det( data_lvl2_d5, erange=erange, trange=tr, thr_n=4.)
		img6 = foxsi_image_det( data_lvl2_d6, erange=erange, trange=tr, thr_n=4.)
		map0_raw = make_map( img0, dx=7.78, dy=7.78 )
		map1_raw = make_map( img1, dx=7.78, dy=7.78 )
		map2_raw = make_map( img2, dx=7.78, dy=7.78 )
		map3_raw = make_map( img3, dx=7.78, dy=7.78 )
		map4_raw = make_map( img4, dx=7.78, dy=7.78 )
		map5_raw = make_map( img5, dx=7.78, dy=7.78 )
		map6_raw = make_map( img6, dx=7.78, dy=7.78 )
		map0 = rebin_map( map0_raw, imdim, imdim )
		map1 = rebin_map( map1_raw, imdim, imdim )
		map2 = rebin_map( map2_raw, imdim, imdim )
		map3 = rebin_map( map3_raw, imdim, imdim )
		map4 = rebin_map( map4_raw, imdim, imdim )
		map5 = rebin_map( map5_raw, imdim, imdim )
		map6 = rebin_map( map6_raw, imdim, imdim )
		map0.dx = pix
		map0.dy = pix
		map1.dx = pix
		map1.dy = pix
		map2.dx = pix
		map2.dy = pix
		map3.dx = pix
		map3.dy = pix
		map4.dx = pix
		map4.dy = pix
		map5.dx = pix
		map5.dy = pix
		map6.dx = pix
		map6.dy = pix
		map0.data = map0.data/total(map0.data)*total(img0)
		map1.data = map1.data/total(map1.data)*total(img1)
		map2.data = map2.data/total(map2.data)*total(img2)
		map3.data = map3.data/total(map3.data)*total(img3)
		map4.data = map4.data/total(map4.data)*total(img4)
		map5.data = map5.data/total(map5.data)*total(img5)
		map6.data = map6.data/total(map6.data)*total(img6)
		;map0.data = smooth( map0.data, img_smooth/pix )
		;map1.data = smooth( map1.data, img_smooth/pix )
		;map2.data = smooth( map2.data, img_smooth/pix )
		;map3.data = smooth( map3.data, img_smooth/pix )
		;map4.data = smooth( map4.data, img_smooth/pix )
		;map5.data = smooth( map5.data, img_smooth/pix )
		;map6.data = smooth( map6.data, img_smooth/pix )
		map0 = rot_map( map0, rot0 )
		map1 = rot_map( map1, rot1 )
		map2 = rot_map( map2, rot2 )
		map3 = rot_map( map3, rot3 )
		map4 = rot_map( map4, rot4 )
		map5 = rot_map( map5, rot5 )
		map6 = rot_map( map6, rot6 )
		map0_raw = rot_map( map0_raw, rot0 )
		map1_raw = rot_map( map1_raw, rot1 )
		map2_raw = rot_map( map2_raw, rot2 )
		map3_raw = rot_map( map3_raw, rot3 )
		map4_raw = rot_map( map4_raw, rot4 )
		map5_raw = rot_map( map5_raw, rot5 )
		map6_raw = rot_map( map6_raw, rot6 )
		centr0 = map_centroid(map0,th=0.2*max(map0.data)) - 45
		centr1 = map_centroid(map1,th=0.2*max(map1.data)) - 45
		centr2 = map_centroid(map2,th=0.2*max(map2.data)) - 45
		centr3 = map_centroid(map3,th=0.2*max(map3.data)) - 45
		centr4 = map_centroid(map4,th=0.2*max(map4.data)) - 45
		centr5 = map_centroid(map5,th=0.2*max(map5.data)) - 45
		centr6 = map_centroid(map6,th=0.2*max(map6.data)) - 45
		raw0 = shift_map( make_submap( map0, cen=centr0, fov=fov+1), -centr0[0], -centr0[1] )
		raw1 = shift_map( make_submap( map1, cen=centr1, fov=fov+1), -centr1[0], -centr1[1] )
		raw2 = shift_map( make_submap( map2, cen=centr2, fov=fov+1), -centr2[0], -centr2[1] )
		raw3 = shift_map( make_submap( map3, cen=centr3, fov=fov+1), -centr3[0], -centr3[1] )
		raw4 = shift_map( make_submap( map4, cen=centr4, fov=fov+1), -centr4[0], -centr4[1] )
		raw5 = shift_map( make_submap( map5, cen=centr5, fov=fov+1), -centr5[0], -centr5[1] )
		raw6 = shift_map( make_submap( map6, cen=centr6, fov=fov+1), -centr6[0], -centr6[1] )
	
		; choose which dets to include in the image!
		raw=raw6
		raw.data = detector[0]*raw0.data + $
				   detector[1]*raw1.data + $
				   detector[2]*raw2.data + $
				   detector[3]*raw3.data + $
				   detector[4]*raw4.data + $
				   detector[5]*raw5.data + $
				   detector[6]*raw6.data
				   
		; save a raw, totally unprocessed image.
		first=map6_raw
		first.data = detector[0]*map0_raw.data + $
				   	 detector[1]*map1_raw.data + $
				     detector[2]*map2_raw.data + $
				     detector[3]*map3_raw.data + $
				     detector[4]*map4_raw.data + $
				     detector[5]*map5_raw.data + $
				     detector[6]*map6_raw.data
		first_cen = map_centroid( first, thr=0.1*max(first.data) )
		first = make_submap( first, cen=first_cen, fov=3 )
		; this gets returned in keyword FIRST to use as sample unprocessed image.

;		raw.xc=0
;		raw.yc=0
;		raw.dx = pix
;		raw.dy = pix
		
		raw.data = smooth( raw.data, img_smooth/pix )	
		raw = make_submap( raw, cen=[0.,0.], fov=fov )

	endelse  
	
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
 
 	;iter = [1,2,3,4,5,10,20,40,80,100]
 	n = n_elements(iter)
 	deconv_map = replicate( raw, n+1 )	; leave an extra at beginning to contain raw image.
 	reconv_map = replicate( raw, n+1 )
    
;	for j=0, n-1 do begin
;		undefine, deconv
;		print, j, iter[j]
;		for i=0, iter[j] do max_likelihood, raw.data, psf.data, deconv, reconv
;		deconv_map[j+1].data = deconv
;		reconv_map[j+1].data = reconv
;		deconv_map[j+1].id=strtrim(iter[j],2)+' iter'
;	endfor
 
 	undefine, deconv
 	undefine, reconv
 	for j=0, iter[n-1] do begin
  		max_likelihood, raw.data, psf.data, deconv, reconv
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

	ch=1.2
 	popen, 'deconv-result', xsi=8, ysi=11
 	!p.multi=[0,3,4]
 	if measured_psf eq 1 then tit='D5 measured PSF' else tit='D5 fit PSF'
 	plot_map, psf, tit=tit+' smooth='+strtrim(psf_smooth,2), charsi=ch
 	plot_map, raw, tit='Raw FOXSI image', charsi=ch
 	for j=1, n do plot_map, deconv_map[j], tit=deconv_map[j].id, charsi=ch
 
 	; Plot on top of AIA 131 image.
; 	restore, 'data_2012/aia-maps-flare.sav'
; 	!p.multi=[0,2,2]
; 	for j=7, 10 do begin
;		plot_map, aia[0], fov=1.5
; 		plot_map, shift_map(deconv_map[j], flare[0]-6, flare[1]+3), /over, /per,$
; 			color=255, thick=4, lev=[10,30,50,70,90]
; 	endfor
  
	; Plot on top of AIA diff image.  Find AIA image closest in time.

 	restore, 'data_2012/aia_avg.sav'
	iavg = closest( anytim(avg.time), anytim('2012-nov-2')+time_range[0] )
 
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

	ch=1.1
	fov=1.5
	!p.multi=[0,2,2]
  	plot_map, psf, tit='PSF', charsi=ch, fov=fov
  	plot_map, psf, /over, lev=[50], /per, thick=5, col=255
	xyouts, -40, 35, '50% contour', size=1.2, col=255
 	plot_map, raw, tit='Raw image', charsi=ch, fov=fov
 	plot_map, raw, /over, lev=[50], /per, thick=5, col=255
	xyouts, -40, 35, '50% contour', size=1.2, col=255
	plot_map, deconv_map[8], tit=deconv_map[8].id+', deconvolved', charsi=ch, fov=fov
	plot_map, deconv_map[8], /over, lev=[50], /per, thick=5, col=255
	xyouts, -40, 35, '50% contour', size=1.2, col=255
	plot_map, reconv_map[8], tit=deconv_map[8].id+', reconvolved', charsi=ch, fov=fov
	plot_map, reconv_map[8], /over, lev=[50], /per, thick=5, col=255
	xyouts, -40, 35, '50% contour', size=1.2, col=255

	pclose
	
	psf_map = psf
	
	return, deconv_map
	
END 