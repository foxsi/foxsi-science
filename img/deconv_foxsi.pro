;
; Set of routines for performing FOXSI-1 (and FOXSI-2?) image deconvolution.
; 

FUNCTION	DEFINE_MATRIX, W_DIM=W_DIM, H_DIM=H_DIM, DET=DET, MATRIX_FILE=MATRIX_FILE, $
	X_SHIFT=X_SHIFT, Y_SHIFT=Y_SHIFT, YEAR=YEAR, PSF_in = PSF_in, stop=stop

	default, w_dim, 40*2			; source dimensions (in 1 arcsec steps)
	default, h_dim, 5*2			; measured data dimensions (in detector pixels)
	default, det, [0,0,0,0,0,0,1]					; detector mask
	default, x_shift, 0.
	default, y_shift, 0.
	default, year, 2012

	; some derived and hard-coded parameters
	dim = w_dim*3 - 1			; to use in setting up PSF map
	pix=1
	pitch = 7.73493
	npix = fix( w_dim / pitch )
	factor=float(w_dim)/h_dim
	params = [ 0.0, 0.0, 0.0, 0.9875, 0.218387, 0.0762158, 1.27836, 1.77492, 4.36214,$
			   		 7.21397, 47.5, 240.314, 0.0 ]
	n_det = total( det )
	
	restore, '/Users/glesener/foxsi/flight-analysis/foxsi-science/data_2012/flight2012-parameters.sav
	

	; Set up the PSF.
	; Later, a way should be found to allow the user to specify this.
	
	if not keyword_set( PSF_in ) then begin

		psf1 = psf_gaussian( npix=[dim,dim], /double, st_dev=[1.27836, 1.77492]/pix )
		psf2 = psf_gaussian( npix=[dim,dim], /double, st_dev=2.*[4.36214, 7.21397]/pix )*params[4]
		psf3 = psf_gaussian( npix=[dim,dim], /double, st_dev=2.*[47.5, 240.314]/pix )*params[4]*params[5]
		psftest = make_map( psf1+psf2+psf3, dx=pix, dy=pix )
		if year eq 2014 then psf = rot_map( psftest, 45 ) else	psf = rot_map( psftest, -45 )
		psf.roll_angle=0
	endif else begin
		psf = make_submap( PSF_in, cen=[psf_in.xc,psf_in.yc], fov=dim/60. )
		psf.data *= 1000.
	endelse

	if keyword_set( STOP ) then stop

	; Define the elements of the transformation matrix S.

	matrix = fltarr( w_dim^2, n_det*h_dim^2 )

	print, 'Computing transformation matrix.'
	for col=0, w_dim-1 do begin
		for row=0, w_dim-1 do begin
			if row eq 0 and col mod 5 eq 0 then print, fix(100*float(col)/w_dim), ' percent.'
			undefine, list
			shift_psf = shift_map( psf, col, row )

			; This next part (1) rotates the shifted PSF around the center of the positive quadrant corresponding to 
			; the detector area, (2) takes a subset of the rotated image corresponding to the image 2D array size, and (3) rebins to image pixel size
			; The PSF 2D array size is larger than the source 2D array size.  (Positive quadrant is 
			; 1.5^2 times the source array size so that sources at detector corners are not eliminated.)
			if det[0] eq 1 then begin
				rot_psf0 = rot_map( shift_psf, -rot0, cen=h_dim*factor/2.*[1,1] )
				rot_psf0.roll_angle=0
				sub_map, rot_psf0, sub0, xr=[0+x_shift,h_dim*factor-1+x_shift], yr=[0+y_shift,h_dim*factor-1+x_shift]
				rebin0 = frebin( sub0.data, npix, npix, /tot )
				push, list, reform(rebin0, npix^2)
			endif
			if det[1] eq 1 then begin
				rot_psf1 = rot_map( shift_psf, -rot1, cen=h_dim*factor/2.*[1,1] )
				rot_psf1.roll_angle=0
				sub_map, rot_psf1, sub1, xr=[0+x_shift,h_dim*factor-1+x_shift], yr=[0+y_shift,h_dim*factor-1+x_shift]
				rebin1 = frebin( sub1.data, npix, npix, /tot )
				push, list, reform(rebin1, npix^2)
			endif
			if det[2] eq 1 then begin
				rot_psf2 = rot_map( shift_psf, -rot2, cen=h_dim*factor/2.*[1,1] )
				rot_psf2.roll_angle=0
				sub_map, rot_psf2, sub2, xr=[0+x_shift,h_dim*factor-1+x_shift], yr=[0+y_shift,h_dim*factor-1+x_shift]
				rebin2 = frebin( sub2.data, npix, npix, /tot )
				push, list, reform(rebin2, npix^2)
			endif
			if det[3] eq 1 then begin
				rot_psf3 = rot_map( shift_psf, -rot3, cen=h_dim*factor/2.*[1,1] )
				rot_psf3.roll_angle=0
				sub_map, rot_psf3, sub3, xr=[0+x_shift,h_dim*factor-1+x_shift], yr=[0+y_shift,h_dim*factor-1+x_shift]
				rebin3 = frebin( sub3.data, npix, npix, /tot )
				push, list, reform(rebin3, npix^2)
			endif
			if det[4] eq 1 then begin
				rot_psf4 = rot_map( shift_psf, -rot4, cen=h_dim*factor/2.*[1,1] )
				rot_psf4.roll_angle=0
				sub_map, rot_psf4, sub4, xr=[0+x_shift,h_dim*factor-1+x_shift], yr=[0+y_shift,h_dim*factor-1+x_shift]
				rebin4 = frebin( sub4.data, npix, npix, /tot )
				push, list, reform(rebin4, npix^2)
			endif
			if det[5] eq 1 then begin
				rot_psf5 = rot_map( shift_psf, -rot5, cen=h_dim*factor/2.*[1,1] )
				rot_psf5.roll_angle=0
				sub_map, rot_psf5, sub5, xr=[0+x_shift,h_dim*factor-1+x_shift], yr=[0+y_shift,h_dim*factor-1+x_shift]
				rebin5 = frebin( sub5.data, npix, npix, /tot )
			push, list, reform(rebin5, npix^2)
			endif
			if det[6] eq 1 then begin
				rot_psf6 = rot_map( shift_psf, -rot6, cen=h_dim*factor/2.*[1,1] )
				rot_psf6.roll_angle=0
				sub_map, rot_psf6, sub6, xr=[0+x_shift,h_dim*factor-1+x_shift], yr=[0+y_shift,h_dim*factor-1+x_shift]
				rebin6 = frebin( sub6.data, npix, npix, /tot )
				push, list, reform(rebin6, npix^2)
			endif

;;;;;; Geometry checks show the uncommented one below to be correct!
;			matrix[w_dim-col*w_dim-row,*] = list
;			matrix[col*w_dim+row,*] = list
			matrix[row*w_dim+col,*] = list
;			matrix[w_dim-row*w_dim-col,*] = list

		endfor
	endfor
	
	if keyword_set( matrix_file) then begin
		save, matrix, file= matrix_file
		print, 'Transformation matrix saved in ', matrix_file, '.'
	endif

	return, matrix
	
END


FUNCTION	PREP_IMAGE, H_DIM=H_DIM, DET=DET, flatfield=flatfield, STOP=STOP

	default, h_dim, 5*2			; measured data dimensions (in detector pixels)
	default, det, [0,0,0,0,0,0,1]					; detector mask
	
	; some derived and hard-coded parameters
	pitch = 7.73493
	n_det = total( det )
	
	; Get the detector images and identify the ROI.
	; As a future improvement, this ROI could be chosen by the user.

	cd,'/Users/glesener/foxsi/flight-analysis/foxsi-science/', current=curdir
	restore, 'data_2012/flight2012-parameters.sav'
	get_target_data, 4, d0a,d1a,d2a,d3a,d4a,d5a,d6a, /good, year=2012
	get_target_data, 6, d0b,d1b,d2b,d3b,d4b,d5b,d6b, /good, year=2012

	if det[0] eq 1 then img0 = foxsi_image_det( [d0a,d0b], year=2012, flatfield=flatfield )
	if det[1] eq 1 then img1 = foxsi_image_det( [d1a,d1b], year=2012, flatfield=flatfield )
	if det[2] eq 1 then img2 = foxsi_image_det( [d2a,d2b], year=2012, flatfield=flatfield )
	if det[3] eq 1 then img3 = foxsi_image_det( [d3a,d3b], year=2012, flatfield=flatfield )
	if det[4] eq 1 then img4 = foxsi_image_det( [d4a,d4b], year=2012, flatfield=flatfield )
	if det[5] eq 1 then img5 = foxsi_image_det( [d5a,d5b], year=2012, flatfield=flatfield )
	if det[6] eq 1 then img6 = foxsi_image_det( [d6a,d6b], year=2012, flatfield=flatfield )
	cd, curdir
	if det[0] eq 1 then det_map0 = make_map( img0, dx=pitch, dy=pitch )
	if det[1] eq 1 then det_map1 = make_map( img1, dx=pitch, dy=pitch )
	if det[2] eq 1 then det_map2 = make_map( img2, dx=pitch, dy=pitch )
	if det[3] eq 1 then det_map3 = make_map( img3, dx=pitch, dy=pitch )
	if det[4] eq 1 then det_map4 = make_map( img4, dx=pitch, dy=pitch )
	if det[5] eq 1 then det_map5 = make_map( img5, dx=pitch, dy=pitch )
	if det[6] eq 1 then det_map6 = make_map( img6, dx=pitch, dy=pitch )
	; Get bright spot location in detector coords
	if det[0] eq 1 then centr0 = map_centroid(det_map0, thr=0.3*max(img0) )
	if det[1] eq 1 then centr1 = map_centroid(det_map1, thr=0.3*max(img1) )
	if det[2] eq 1 then centr2 = map_centroid(det_map2, thr=0.3*max(img2) )
	if det[3] eq 1 then centr3 = map_centroid(det_map3, thr=0.3*max(img3) )
	if det[4] eq 1 then centr4 = map_centroid(det_map4, thr=0.3*max(img4) )
	if det[5] eq 1 then centr5 = map_centroid(det_map5, thr=0.3*max(img5) )
	if det[6] eq 1 then centr6 = map_centroid(det_map6, thr=0.3*max(img6) )
	if det[0] eq 1 then sub_map, det_map0, submap0, xr=centr0[0]+pitch*h_dim/2.*[-1,1], yr=centr0[1]+pitch*h_dim/2.*[-1,1], dim=[h_dim,h_dim]
	if det[1] eq 1 then sub_map, det_map1, submap1, xr=centr1[0]+pitch*h_dim/2.*[-1,1], yr=centr1[1]+pitch*h_dim/2.*[-1,1], dim=[h_dim,h_dim]
	if det[2] eq 1 then sub_map, det_map2, submap2, xr=centr2[0]+pitch*h_dim/2.*[-1,1], yr=centr2[1]+pitch*h_dim/2.*[-1,1], dim=[h_dim,h_dim]
	if det[3] eq 1 then sub_map, det_map3, submap3, xr=centr3[0]+pitch*h_dim/2.*[-1,1], yr=centr3[1]+pitch*h_dim/2.*[-1,1], dim=[h_dim,h_dim]
	if det[4] eq 1 then sub_map, det_map4, submap4, xr=centr4[0]+pitch*h_dim/2.*[-1,1], yr=centr4[1]+pitch*h_dim/2.*[-1,1], dim=[h_dim,h_dim]
	if det[5] eq 1 then sub_map, det_map5, submap5, xr=centr5[0]+pitch*h_dim/2.*[-1,1], yr=centr5[1]+pitch*h_dim/2.*[-1,1], dim=[h_dim,h_dim]
	if det[6] eq 1 then sub_map, det_map6, submap6, xr=centr6[0]+pitch*h_dim/2.*[-1,1], yr=centr6[1]+pitch*h_dim/2.*[-1,1], dim=[h_dim,h_dim]

	;; Det 4 has a suppressed strip; fill this in with data from neighboring strips.
	;if det[4] eq 1 then if n_elements(submap4.data) eq 100 then $
	;		submap4.data[4,*] = average( [submap4.data[3,*],submap4.data[5,*]], 1 )

	undefine, h
	if det[0] eq 1 then push, h, reform( submap0.data, h_dim^2 )
	if det[1] eq 1 then push, h, reform( submap1.data, h_dim^2 )
	if det[2] eq 1 then push, h, reform( submap2.data, h_dim^2 )
	if det[3] eq 1 then push, h, reform( submap3.data, h_dim^2 )
	if det[4] eq 1 then push, h, reform( submap4.data, h_dim^2 )
	if det[5] eq 1 then push, h, reform( submap5.data, h_dim^2 )
	if det[6] eq 1 then push, h, reform( submap6.data, h_dim^2 )
	
	if keyword_set( stop ) then stop
	
	return, h
	
END



FUNCTION	PREP_IMAGE_MAP, MAPS, H_DIM=H_DIM, DET=DET, flatfield=flatfield, STOP=STOP

	default, h_dim, 5*2			; measured data dimensions (in detector pixels)
	default, det, [0,0,0,0,0,0,1]					; detector mask
	
	; some derived and hard-coded parameters
	pitch = 7.73493
	n_det = total( det )
	
	if det[0] eq 1 then det_map0 = maps[0]
	if det[1] eq 1 then det_map1 = maps[1]
	if det[2] eq 1 then det_map2 = maps[2]
	if det[3] eq 1 then det_map3 = maps[3]
	if det[4] eq 1 then det_map4 = maps[4]
	if det[5] eq 1 then det_map5 = maps[5]
	if det[6] eq 1 then det_map6 = maps[6]
	
	; Get bright spot location in detector coords
	if det[0] eq 1 then centr0 = map_centroid(det_map0, thr=0.3*max(det_map0.data) )
	if det[1] eq 1 then centr1 = map_centroid(det_map1, thr=0.3*max(det_map1.data) )
	if det[2] eq 1 then centr2 = map_centroid(det_map2, thr=0.3*max(det_map2.data) )
	if det[3] eq 1 then centr3 = map_centroid(det_map3, thr=0.3*max(det_map3.data) )
	if det[4] eq 1 then centr4 = map_centroid(det_map4, thr=0.3*max(det_map4.data) )
	if det[5] eq 1 then centr5 = map_centroid(det_map5, thr=0.3*max(det_map5.data) )
	if det[6] eq 1 then centr6 = map_centroid(det_map6, thr=0.3*max(det_map6.data) )
	if det[0] eq 1 then sub_map, det_map0, submap0, xr=centr0[0]+pitch*h_dim/2.*[-1,1], yr=centr0[1]+pitch*h_dim/2.*[-1,1], dim=[h_dim,h_dim]
	if det[1] eq 1 then sub_map, det_map1, submap1, xr=centr1[0]+pitch*h_dim/2.*[-1,1], yr=centr1[1]+pitch*h_dim/2.*[-1,1], dim=[h_dim,h_dim]
	if det[2] eq 1 then sub_map, det_map2, submap2, xr=centr2[0]+pitch*h_dim/2.*[-1,1], yr=centr2[1]+pitch*h_dim/2.*[-1,1], dim=[h_dim,h_dim]
	if det[3] eq 1 then sub_map, det_map3, submap3, xr=centr3[0]+pitch*h_dim/2.*[-1,1], yr=centr3[1]+pitch*h_dim/2.*[-1,1], dim=[h_dim,h_dim]
	if det[4] eq 1 then sub_map, det_map4, submap4, xr=centr4[0]+pitch*h_dim/2.*[-1,1], yr=centr4[1]+pitch*h_dim/2.*[-1,1], dim=[h_dim,h_dim]
	if det[5] eq 1 then sub_map, det_map5, submap5, xr=centr5[0]+pitch*h_dim/2.*[-1,1], yr=centr5[1]+pitch*h_dim/2.*[-1,1], dim=[h_dim,h_dim]
	if det[6] eq 1 then sub_map, det_map6, submap6, xr=centr6[0]+pitch*h_dim/2.*[-1,1], yr=centr6[1]+pitch*h_dim/2.*[-1,1], dim=[h_dim,h_dim]

	undefine, h
	if det[0] eq 1 then push, h, reform( submap0.data, h_dim^2 )
	if det[1] eq 1 then push, h, reform( submap1.data, h_dim^2 )
	if det[2] eq 1 then push, h, reform( submap2.data, h_dim^2 )
	if det[3] eq 1 then push, h, reform( submap3.data, h_dim^2 )
	if det[4] eq 1 then push, h, reform( submap4.data, h_dim^2 )
	if det[5] eq 1 then push, h, reform( submap5.data, h_dim^2 )
	if det[6] eq 1 then push, h, reform( submap6.data, h_dim^2 )
	
	if keyword_set( stop ) then stop
	
	return, h
	
END



FUNCTION	DECONV_FOXSI, H, W_DIM=W_DIM, H_DIM=H_DIM, MATRIX_VAR=MATRIX_VAR,$
					MATRIX_FILE=MATRIX_FILE, MAX_ITER=MAX_ITER, stop=stop

	default, w_dim, 40*2			; source dimensions (in 1 arcsec steps)
	default, h_dim, 5*2			; measured data dimensions (in detector pixels)
	default, max_iter, 99
	
	; needed to supply a matrix or a matrix file, but not both.
	if not keyword_set(matrix_var) and not keyword_set(matrix_file) then begin
		print, 'User must supply either a matrix or a matrix file.'
		return, -1
	endif

	if keyword_set(matrix_var) and keyword_set(matrix_file) then begin
		print, 'User must supply either a matrix or a matrix file, but not both!'
		return, -1
	endif

	; some derived and hard-coded parameters
	dim = w_dim*3 - 1			; to use in setting up PSF map
	pix=1
	pitch = 7.73493
	npix = fix( w_dim / pitch )
	factor=float(w_dim)/h_dim
	
	;
	; Do the deconvolution
	;

	; Matrix and its inverse
	if keyword_set( matrix_file ) then restore, matrix_file else matrix=matrix_var
	inv_matrix = transpose( matrix )			; this is S_ji

	; Grey-scale initial guess for W
	W0 = fltarr( w_dim^2 )+1./w_dim^2

	w = w0
	undefine, map
	for i=0, max_iter do begin
		C = reform( w#matrix )			; reconv
		temp = reform( (h/c)#inv_matrix )
		w = w*temp
		push, map, make_map( reform( w, w_dim, w_dim ) )
		map[i].id = strtrim(i,2)+' Iterations'
	endfor
	
	map.time = '2-Nov-2012'
	
	if keyword_set( stop ) then stop

	return, map
	
END


FUNCTION	SIMULATE_FOXSI_SOURCE, fwhm, nData, w_dim=w_dim, h_dim=h_dim, det=det, $
																 source=source, conv_unrot=conv_unrot, conv_rot=conv_rot, $
																 rebin=rebin, smear=smear, $
																 pock=pock, loop=loop, stop=stop

	; example: fwhm=[15,5] nData=2000
	
	; Right now this works only for one detector at a time.

	default, w_dim, 40*2			; source dimensions (in 1 arcsec steps)
	default, h_dim, 5*2			; measured data dimensions (in detector pixels)
	default, det, [0,0,0,0,0,0,1]					; detector mask.  Only one detector at a time!!

	; some derived and hard-coded parameters
	dim = w_dim*3 - 1			; to use in setting up PSF map
	pix=1
	pitch = 7.73493
	npix = fix( w_dim / pitch )
	factor=float(w_dim)/h_dim
	; now these params are not being used. Revitalize this later!
	params = [ 0.0, 0.0, 0.0, 0.9875, 0.218387, 0.0762158, 1.27836, 1.77492, 4.36214,$
			   		 7.21397, 47.5, 240.314, 0.0 ]
	n_det = total( det )
	
	restore, '~/foxsi/flight-analysis/foxsi-science/data_2012/flight2012-parameters.sav'
	if det[0] eq 1 then rot = rot0
	if det[1] eq 1 then rot = rot1
	if det[2] eq 1 then rot = rot2
	if det[3] eq 1 then rot = rot3
	if det[4] eq 1 then rot = rot4
	if det[5] eq 1 then rot = rot5
	if det[6] eq 1 then rot = rot6
	
	; Set up the source shape with the right statistics.
	source = make_map( psf_gaussian( npixel=[w_dim,w_dim], fwhm=fwhm, cen=w_dim/2*[1,1] ) )
	source.data = source.data / total(source.data) * nData

	if keyword_set( loop ) then begin
		; 2 circles
;		g1 = psf_gaussian( npixel=[w_dim,w_dim], fwhm=[30,28], cen=w_dim/2*[1,1] )
;		g2 = psf_gaussian( npixel=[w_dim,w_dim], fwhm=[24,25], cen=w_dim/2*[1,1] )
		g1 = psf_gaussian( npixel=[w_dim,w_dim], fwhm=[20,18], cen=w_dim/2*[1,1] )
		g2 = psf_gaussian( npixel=[w_dim,w_dim], fwhm=[14,15], cen=w_dim/2*[1,1] )
		source = make_map( g1-g2 )
		; mask half of the difference into a half circle
		mask=[fltarr(w_dim/2,w_dim),fltarr(w_dim/2,w_dim)+1]
		source.data = source.data*mask
		;plot_map, source
	endif

	; This was used for debugging, if you want a "pock mark" in the corner.
	if keyword_set( pock ) then $
	source.data += 30.*psf_gaussian( npixel=[w_dim,w_dim], fwhm=5, cen=[10,70] )

	; Set up the PSF.
	; Later, a way should be found to allow the user to specify this.
	psf1 = psf_gaussian( npix=[dim,dim], /double, st_dev=[1.27836, 1.77492]/pix )
	psf2 = psf_gaussian( npix=[dim,dim], /double, st_dev=2.*[4.36214, 7.21397]/pix )*params[4]
	psf3 = psf_gaussian( npix=[dim,dim], /double, st_dev=2.*[47.5, 240.314]/pix )*params[4]*params[5]
	psftest = make_map( psf1+psf2+psf3, dx=pix, dy=pix )
	psf = rot_map( psftest, -45 )
	psf.roll_angle=0
	size_psf = size(psf.data)
	ind = size_psf[1]/2 + [-w_dim/2,-w_dim/2+w_dim-1]
	small_psf = psf.data[ ind[0]:ind[1], ind[0]:ind[1] ]

	; Convolve the source with the PSF.
	conv_unrot = make_map( convolve( source.data, small_psf ) )
	conv_unrot.data = conv_unrot.data / total(conv_unrot.data)*nData
	conv_rot = make_submap( rot_map( conv_unrot, -rot ), cen=[conv_unrot.xc,conv_unrot.yc], fov=2.5 )

	; Bin the data.
	npix = fix( n_elements( conv_rot.data[0,*] )/pitch )
	rebin = make_map( frebin( conv_rot.data, npix, npix, /tot ), dx=pitch, dy=pitch )

	; Smear each pixel value by statistical uncertainty
	; seed=0		; this was used for debugging to get a consistent smearing.
	smear = rebin
	for i=0, n_elements(smear.data[*,0])-1 do $
		for j=0, n_elements(smear.data[0,*])-1 do $
			smear.data[i,j] = smear.data[i,j] + randomn( seed, 1 )*sqrt( smear.data[i,j] )
	smear.data[ where(smear.data lt 0.) ] = 0.
	smear.data[ where( finite(smear.data) eq 0 ) ] = 0.

	h = reform( smear.data, h_dim^2 )

	if keyword_set( source_list ) then source_list = reform( source.data, w_dim^2 )

	if keyword_set( stop ) then stop

	return, h
	
END


;FUNCTION	SIMULATE_ARBITRARY_SOURCE, source, psf, fwhm, nData, w_dim=w_dim, h_dim=h_dim, $
;																		 det=det, source=source, conv_unrot=conv_unrot, $
;																		 conv_rot=conv_rot, rebin=rebin, smear=smear, $
;																		 pock=pock, stop=stop
;
;	; nData is the number of photons in the image.
;
;	default, w_dim, 40*2			; source dimensions (in 1 arcsec steps)
;	default, h_dim, 5*2			; measured data dimensions (in detector pixels)
;	default, det, [0,0,0,0,0,0,1]					; detector mask.  Only one detector at a time!!
;
;	my_source = make_submap( source, center=[source.xc,source.yc], fov=w_dim/60. )
;
;
;
;	; some derived and hard-coded parameters
;	dim = w_dim*3 - 1			; to use in setting up PSF map
;	pix=1
;	pitch = 7.73493
;	npix = fix( w_dim / pitch )
;	factor=float(w_dim)/h_dim
;	; now these params are not being used. Revitalize this later!
;	params = [ 0.0, 0.0, 0.0, 0.9875, 0.218387, 0.0762158, 1.27836, 1.77492, 4.36214,$
;			   		 7.21397, 47.5, 240.314, 0.0 ]
;	n_det = total( det )
;	
;	restore, '~/foxsi/flight-analysis/foxsi-science/data_2012/flight2012-parameters.sav'
;	if det[0] eq 1 then rot = rot0
;	if det[1] eq 1 then rot = rot1
;	if det[2] eq 1 then rot = rot2
;	if det[3] eq 1 then rot = rot3
;	if det[4] eq 1 then rot = rot4
;	if det[5] eq 1 then rot = rot5
;	if det[6] eq 1 then rot = rot6
;	
;	; Set up the source shape with the right statistics.
;	source = make_map( psf_gaussian( npixel=[w_dim,w_dim], fwhm=fwhm, cen=w_dim/2*[1,1] ) )
;	source.data = source.data / total(source.data) * nData
;
;	if keyword_set( loop ) then begin
;		; 2 circles
;;		g1 = psf_gaussian( npixel=[w_dim,w_dim], fwhm=[30,28], cen=w_dim/2*[1,1] )
;;		g2 = psf_gaussian( npixel=[w_dim,w_dim], fwhm=[24,25], cen=w_dim/2*[1,1] )
;		g1 = psf_gaussian( npixel=[w_dim,w_dim], fwhm=[20,18], cen=w_dim/2*[1,1] )
;		g2 = psf_gaussian( npixel=[w_dim,w_dim], fwhm=[14,15], cen=w_dim/2*[1,1] )
;		source = make_map( g1-g2 )
;		; mask half of the difference into a half circle
;		mask=[fltarr(w_dim/2,w_dim),fltarr(w_dim/2,w_dim)+1]
;		source.data = source.data*mask
;		;plot_map, source
;	endif
;
;	; This was used for debugging, if you want a "pock mark" in the corner.
;	if keyword_set( pock ) then $
;	source.data += 30.*psf_gaussian( npixel=[w_dim,w_dim], fwhm=5, cen=[10,70] )
;
;	; Set up the PSF.
;	; Later, a way should be found to allow the user to specify this.
;	psf1 = psf_gaussian( npix=[dim,dim], /double, st_dev=[1.27836, 1.77492]/pix )
;	psf2 = psf_gaussian( npix=[dim,dim], /double, st_dev=2.*[4.36214, 7.21397]/pix )*params[4]
;	psf3 = psf_gaussian( npix=[dim,dim], /double, st_dev=2.*[47.5, 240.314]/pix )*params[4]*params[5]
;	psftest = make_map( psf1+psf2+psf3, dx=pix, dy=pix )
;	psf = rot_map( psftest, -45 )
;	psf.roll_angle=0
;	size_psf = size(psf.data)
;	ind = size_psf[1]/2 + [-w_dim/2,-w_dim/2+w_dim-1]
;	small_psf = psf.data[ ind[0]:ind[1], ind[0]:ind[1] ]
;
;	; Convolve the source with the PSF.
;	conv_unrot = make_map( convolve( source.data, small_psf ) )
;	conv_unrot.data = conv_unrot.data / total(conv_unrot.data)*nData
;	conv_rot = make_submap( rot_map( conv_unrot, -rot ), cen=[conv_unrot.xc,conv_unrot.yc], fov=2.5 )
;
;	; Bin the data.
;	npix = fix( n_elements( conv_rot.data[0,*] )/pitch )
;	rebin = make_map( frebin( conv_rot.data, npix, npix, /tot ), dx=pitch, dy=pitch )
;
;	; Smear each pixel value by statistical uncertainty
;	; seed=0		; this was used for debugging to get a consistent smearing.
;	smear = rebin
;	for i=0, n_elements(smear.data[*,0])-1 do $
;		for j=0, n_elements(smear.data[0,*])-1 do $
;			smear.data[i,j] = smear.data[i,j] + randomn( seed, 1 )*sqrt( smear.data[i,j] )
;	smear.data[ where(smear.data lt 0.) ] = 0.
;	smear.data[ where( finite(smear.data) eq 0 ) ] = 0.
;
;	h = reform( smear.data, h_dim^2 )
;
;	if keyword_set( source_list ) then source_list = reform( source.data, w_dim^2 )
;
;	if keyword_set( stop ) then stop
;
;	return, h
;	
;END