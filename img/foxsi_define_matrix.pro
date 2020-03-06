;+
; NAME: FOXSI_DEFINE_MATRIX
;
; PURPOSE:
;	This routine computes a transformation matrix describing FOXSI's imaging instrument 
;	response.  It is used for deconvolving FOXSI images.  It defines a matrix that 
;	computes the counts in each measured detector strip i due to each source pixel j.  
;	Source and expected image pixels can be sized differently.  No effective area or 
;	spectral response is included.
;
;	Notes:
;	-- The PSF must be >=3x the source image dimensions, and square.
;	-- No actual source is needed at this point.  This computes the transformation
;	   matrix that can be used for any source.  This matrix can be applied to any
;	   detector image with the specified pixel pitch and dimension.
;	-- It's not fast!  Computing the matrix with defaults takes several minutes
;	   on Lindsay's laptop.  There are several ways the routine could be developed to 
;	   compute the matrix more quickly.
;	-- The matrix roughly conserves flux for a centered source, so that most source and 
;	   measured images on each detector will roughly have the same number of photons.  
;      (100k photons/source => 100k photons on each detector.)  This might not be the 
;	   physical case -- for off-axis angles about half the flux might fall of the small 
;	   region of the detector considered here, but getting it right requires better 
;	   knowledge of the PSF wings than we currently have.  Please note that the effective 
;	   area of the instrument is NOT included in this routine.
;
; KEYWORDS:
;	PSF:	plot_map structure containing the point spread function.  The deconvolved 
;			image will have a pixel size equal to the PSF pixel size.  If no PSF is 
;			supplied then the default is an on-axis PSF with 1" pixels.  
;			The PSF FOV should be >3x the image FOV (MEASURED_DIM x STRIP PITCH) in order 
;			to allow for rotations and "full reach." 
;			across the detector.
;	MATRIX_FILE:	Save the matrix variable in an IDL save file of this name.
;					Default is 'matrix.sav' in current directory.
;					To use this routine for anything useful, the matrix must be saved.
;	MEASURED_DIM:	Number of strips across the image.  If this number is n, the 2D image 
;					has n^2 strip crossings. Default: 10 strips
;					This MUST match the size of the image you want to deconvolve.
;					Source map dimensions are calculated from this variable (and pitch 
;					and PSF pixel size) and so runtime goes as MEASURED_DIM^4.
;	PITCH:			Detector strip size in arcsec. Default: 7.735
;					This MUST match the strip size of the image you want to 
;					deconvolve.
;
; HISTORY:
;		2016-oct-30		LG	Created, based on my code for FOXSI-SMEX.
;		2020-mar-02		LG	Cleaned up code for use by others.
;-


FUNCTION	FOXSI_DEFINE_MATRIX, psf=psf, matrix_file=matrix_file, $
								 measured_dim=measured_dim, pitch=pitch, $
								 detector_mask = detector_mask, stop=stop

	COMMON FOXSI_PARAM

	default, matrix_file, 'matrix.sav'
	default, measured_dim, long(10)			; expected image dimensions in detector pixels
	default, pitch, 7.73493					; detector strip pitch (for expected image)
	default, detector_mask, [0,0,0,0,0,0,1]	; which of the 7 detectors to use.

	; Pull the detector rotations (defined in common file)
	rotation = [rot0,rot1,rot2,rot3,rot4,rot5,rot6]

	; If a PSF was supplied, do some basic checks on it and return if errors are found.
	; If no PSF input then get a default one with 0.8 arcsec pixels, 7' off-axis.
	if exist( PSF ) then begin
		; Check basic properties of PSF
		psf_size = size( PSF.data )
		if psf_size[1] ne psf_size[2] or psf.dx ne psf.dy then begin
			print, 'User-supplied PSF must be square and have square pixels."
			return, -1
		endif
		source_pix = psf.dx
		source_FOV = measured_dim*pitch
		source_dim = fix(source_FOV/source_pix)
		if psf_size[1]*source_pix lt 3*source_fov then begin
			print, 'User-supplied PSF must be greater than three times the source FOV'
			return, -1
		endif
	endif else begin
		source_pix = 0.8	; default source pixel size in arcsec
		source_FOV = measured_dim*pitch
		source_dim = fix(source_FOV/source_pix)
		psf = foxsi_psf( pix=source_pix, fov=3*source_fov/60. )
	endelse
	
	; to match variable names in legacy code sections.
	w_dim = long( source_dim )
	h_dim = long( measured_dim )
	
	; Get normalization in order to conserve flux for a source map that is concentrated 
	; at its center.  Reference is a FOV-size submap of the PSF, which should 
	; integrate to 1.
	testmap = make_submap( psf, cen=[0.,0.], fov=h_dim*pitch/60. )
	psf.data = psf.data / total(testmap.data)
	
	; Define the elements of the transformation matrix.
	; Dimensions are source basis, measurement basis, detectors
	matrix = fltarr( w_dim^2, h_dim^2, 7 )

	print
	print, 'Computing transformation matrix.'
	print, w_dim, '^2 source pixels, ', source_pix, ' arcsec'
	print, h_dim, '^2 measuring strips, ', pitch, ' arcsec'
	print

	for det=0, 6 do begin		; loop through detectors
		if detector_mask[ det ] eq 0 then continue

		for col=0, w_dim-1 do begin
			for row=0, w_dim-1 do begin

				undefine, list
				if row eq 0 and col mod 5 eq 0 then print, '  Progress: Det ', det, $
					fix(100*float(col)/w_dim), ' percent.'
				shift_psf = shift_map( psf, col*source_pix, row*source_pix )
				sub_map, shift_psf, small_psf, xr=[-0.5*w_dim,1.5*w_dim], $
					yr=[-0.5*w_dim,1.5*w_dim]

				; This next section does the following:
				; (1) Account for detector rotation by rotating the shifted PSF around the 
				;     center of the positive quadrant (corresponding to detector area).
				; (2) Take the positive quadrant of the rotated image as the true 
				;	  detector area.
				; (3) Rebin to detector strip pitch.
				; (4) Append the values for each strip for a given detector to a list of 
				;     all strip values.
				; Note that the PSF 2D array size is larger than the source 2D array size.  
				; (Positive quadrant is 1.5^2 times the source array size so that sources 
				; at detector corners are not eliminated.)

				center = w_dim*source_pix/2.*[1,1]
				rot_psf0 = rot_map( small_psf, -rotation[det], rcen=center )
				rot_psf0.roll_angle=0
				sub_map, rot_psf0, sub0, xr=center[0]+h_dim*pitch*[-1.,1.]/2, $
					yr=center[1]+h_dim*pitch*[-1.,1.]/2
				; Find the number of source pixels that will divide evenly into the number 
				; of detector strips.  IDL integer math makes this line work!
				dim = fix(h_dim*pitch/source_pix)/h_dim*h_dim
				half = (size( sub0.data ))[1]/2
				img = sub0.data[ half-dim/2:half+dim/2, half-dim/2:half+dim/2 ]
				frebin = frebin( img, h_dim, h_dim, /total )
				push, list, reform( frebin, h_dim^2)

				;;; Geometry checks show the uncommented one below to be correct!
				;;; This was determined empirically.
				;	matrix[w_dim-col*w_dim-row,*,det] = list
				; 	matrix[col*w_dim+row,*,det] = list
				matrix[row*w_dim+col,*,det] = list
				; 	matrix[w_dim-row*w_dim-col,*,det] = list

				if keyword_set( stop ) then stop

			endfor
		endfor
	
	endfor	; end detector loop
	
	; Save matrix and the source pixel size to file.
	; If the filename wasn't given with the extension, add it.
	if strpos( matrix_file, '.sav') lt 0 then matrix_file += '.sav'
	save, matrix, source_pix, file= matrix_file
	print, 'Transformation matrix saved in ', matrix_file, '.'

	return, matrix		; This is no longer technically needed because the matrix is 
						; saved to file, but it is useful for debugging.
	
END
