;----
; NAME: DECONV_FOXSI_SIMPLE
;
; PURPOSE:
;	Function to perform simple deconvolution of FOXSI images using a standard IDL routine
;   (max_likelihood.pro).  In order to use the standard routine, this function 
;	utilizes the same pixel size for the input image and the PSF.  This is cruder than 
;	it could be, because the detector strips are relatively large compared to the PSF.
;	For more sophisticated PSF deconvolution that also deconvolves the strips, use the 
;	custom-built code (coming soon to the FOXSI-SCIENCE repository).
;
;	Notes:
;	-- The PSF can be input as a map.  If you want to use an off-axis PSF, you have to 
;		supply it via keyword.  If you do not supply a PSF map, the routine will use 
;		a standard on-axis PSF obtained from the IDL save file 
;		calibration_data/foxsi_psf_on_axis.sav.  To find this file, the FOXSIDB 
;		directory is used as a landmark.
;	-- Currently the code uses a procedure "max_likelihood2.pro" that is an edited 
;		version of the standard "max_likelihood.pro".  The difference is that it handles 
;		edge effects in the deconvolving routine differently.
;	-- This should work with data from any FOXSI rocket flight (although FOXSI-3 DSDs did
;		not observe enough counts for deconvolution to be useful).  If the source was >2
;		arcmin from the optical axis, make sure to supply an appropriate PSF (rather than 
;		using the default, on-axis PSF).
;	-- There is no specified "best" iteration (i.e. no stopping rule implemented).
;		The user must decide which iteration to use as the result.
;
; INPUT:
;	MAP		A 2-D FOXSI map to deconvolve
;
; RETURN VALUE:  An array of deconvolved images corresponding to the iterations 
;		specified in the ITER variable.  The first map in the array is always the raw 
;		map (using the specified FOV).  Making a movie of this map array will show you 
;		the effects of deconvolution as it progresses.
;
; OPTIONAL KEYWORDS:
;	CEN=CEN	Center of the region to use for deconvolution.  If this keyword is not set, 
;			then the code uses a centroid of the input map as the region center.
;	FOV=FOV	Size (in arcmin) of the region to deconvolve.  Default is 4 arcmin.
;	PSF_IN	plot_map structure containing the point spread function.
;			If this is not provided, the routine will use a standard on-axis PSF.
;			The PSF map must be as large or larger than the FOV requested.
;	ITER	An array of iterations for which to return the deconvolved map.
;			Default: [1,2,3,4,5,10,20,50]
;	RECONV_map	The reconvolved map (deconvolved convolved with PSF) for each iteration
;	CSTAT	Cash statistic for each iteration
;
; HISTORY:
;		2020-feb-12		LG	Updated routines to make it easier to use, added PSF input.
;		2016-oct-30		LG	Created from scraps of my analysis code.
;----

FUNCTION DECONV_FOXSI_SIMPLE, MAP, CEN=CEN, FOV=FOV, PSF_IN=PSF_IN, iter=iter, $
					   RECONV_map = reconv_map, CSTAT=cstat, STOP = STOP
					   					   
	default, fov, 4.
	default, iter, [1,2,3,4,5,10,20,50]
		
	; Step 1: Prepare the PSF map.
	; If a PSF was included as a keyword, use that one.
	; If not, restore the standard on-axis one.
	; Normalize the PSF to unity
	
	if keyword_set (PSF_IN) then psf = psf_in else $
		restore, GETENV('FOXSIDB') + '/../calibration_data/foxsi_psf_on_axis.sav'
	
		psf.roll_angle=0.
 		psf = make_submap( PSF, cen=[psf.xc,psf.yc], fov=fov )
 		psf.data = psf.data / total(psf.data)	; Renormalize
 		;;;size = size(psf.data)
 		
	;
 	; Step 2: Process measured image
 	;
 
	; Find the source and choose a FOV centered on it.
	; This is so that you don't have to deconvolve a large image.
	if keyword_set( CEN ) then map_cen = cen else $
		map_cen = map_centroid( map, thr=0.2*max(map.data) )
	raw = make_submap( map, cen=map_cen, fov=fov )
		
	;
	; Step 3: Coregister the PSF to the input MAP.
	;
	
	psf_temp = psf		; Just a placeholder to put the unaltered PSF for later.
	psf.xc = raw.xc
	psf.yc = raw.yc
	psf.time = raw.time
	psf = coreg_map( PSF, RAW, /rescale, /no_project )
	
	if keyword_set(stop) then stop
 
 	;
 	; Step 4: Do the deconvolution! :D
	;
 
 	n = n_elements(iter)
 	deconv_map = replicate( raw, n+1 )	; including enough for raw image at beginning.
 	reconv_map = replicate( raw, n+1 )
    
 	undefine, deconv
 	undefine, reconv
 	for j=0, iter[n-1] do begin
  		max_likelihood, raw.data, psf.data, deconv, reconv
  		;; Following line uses a different way of handling edge effects.
  		;; For now, this does not seem to be needed.
	  	;;	max_likelihood2, raw.data, psf.data, deconv, reconv
  		if total( j eq iter ) gt 0 then begin
  			i = where( j eq iter )
  			deconv_map[i+1].data = deconv
  			reconv_map[i+1].data = reconv
  			deconv_map[i+1].id = strtrim(iter[i],2)+' iter'
  		endif
 	endfor
 
 	deconv_map.roll_angle = 0.
 	
 	;
 	; Step 5: Compute C-Statistic
 	;
 	
 	cstat = fltarr(n)
	print, 'Cash statistics:'
	for j=0, n-1 do print, 'Iteration ', iter[j], ':  ', $
		c_statistic( reconv_map[j].data, raw.data )
	for j=0, n-1 do cstat[j] = c_statistic( reconv_map[j].data, raw.data )
	
	;
	; Step 6: Plot some maps for debugging by eye.
	;
	
	window, 1, xsize=1000, ysize=400
	!p.multi=[0,4,1]
	plot_map, raw, title='Raw input image'
	plot_map, psf_temp, fov=fov, title = 'Input PSF map'
	plot_map, psf, title = 'Rescaled PSF'
	plot_map, deconv_map[5], title = 'Deconv '+deconv_map[5].id
	!p.multi=0


	return, deconv_map
	
END 
