;+
; NAME: DECONV_FOXSI
;
; PURPOSE:
;  	Perform maximum likelihood deconvolution on a real or simulated FOXSI image (where 
;	"image" means a subset of strip values for one or more detectors), using a 
;	Lucy-Richardson style technique.  A transformation matrix is needed that computes the 
;	flux in detector strip j due to source pixel i.  Because the transformation matrix 
;	is time-consuming to compute and can be used for deconvolution of any images that 
;	share dimensions, pixel size, and desired source resolution, that matrix is 
;	computed in a separate function and saved to file.  That filename must be input to 
;	this routine using the MATRIX_FILE keyword.
;	(See DECONV_DEFINE_MATRIX.)
;
;	The matrix should include the transformations for all 7 detectors (but some can be 
;	zeros if you don't want to use those detectors).
;
;	Note that the input maps need to be in detector coordinates (NOT solar coordinates) 
;	since this is the actual measurement basis.  This means that the elements of IMAGE 
;	contain detector images that should look rotated with respect to each other.
;
; INPUT:
;		IMAGE:	The FOXSI image map to deconvolve, in a plot_map structure with 7 
;				elements for the 7 detectors. These must be in detector coordinates.
;				Must be square.
;		MATRIX_FILE:	IDL save file containing the transformation matrix, named MATRIX,
;						and the SOURCE_PIXEL var (source pixel size in arcsec)
;
; OPTIONAL KEYWORDS:
;		MAX_ITER:		Stop after this many iterations.  Default 40.
;
; NOTES:
;		- Would be nice, but not essential, to adapt the code to handle non-square images.
;
;
; HISTORY:
;		2016-oct-30		LG	New version that pulls in many features of the FOXSI-SMEX 
;							version.
;		2020-mar-02		LG	Cleaning up the code to be usable by others.
;-


FUNCTION	DECONV_FOXSI, image, matrix_file, max_iter=max_iter, stop=stop

	default, max_iter, 40
	
	size = size( image.data )
	if size[1] ne size[2] then begin
		print, 'Measured image must be square.'
		return, -1
	endif
	measured_dim = size[1]
	h = reform( double(image.data), measured_dim^2, 7 )
	
	; Must supply a transformation matrix file.
	if not exist(matrix_file) then begin
		print, 'User must supply a matrix file.'
		return, -1
	endif
	
	; Restore matrix file and check that contents are appropriate.
	restore, matrix_file
	if not exist(source_pix) then begin
		print, 'Matrix file must also contain source pixel size.'
		return, -1
	endif

	; Check that matrix is appropriate for the given data.
	size = size( matrix )
	if size[2] ne measured_dim^2 then begin
		print, 'Matrix does not match image dimensions.'
		return, -1
	endif
	
	source_dim = sqrt(size[1])
	
	; Renormalize the detector layers of the matrix so that its total is proportional 
	; to the number of counts in each detector.  This allows for differing effective 
	; areas, but it assumes that differing count numbers are due to that reason only.
	for det=0, 6 do matrix[*,*,det] *= total(h[*,det])
	matrix /= total(matrix)
;;	stop

	; Some useful matrices
	; 2D matrix that reshapes the detector dimension
		matrix_2D = fltarr( (size(matrix))[1], measured_dim^2*7 )
		for i=0, (size(matrix))[1]-1 do matrix_2D[i,*] = reform( matrix[i,*,*], $
			measured_dim^2*7 )
	inv_matrix = transpose( matrix_2D )			; this is S_ji (inverse matrix)

	;
	; Do the deconvolution
	;

	; Grey-scale initial guess for source W
	W0 = dblarr( source_dim^2 )+1./source_dim^2
	; Let the first map in the output be the grey-scale map.
	map = make_map( reform( w0, source_dim, source_dim ), dx=source_pix, dy=source_pix )
	map.id = '0 Iterations'

	w = w0			; current best guess
	C = dblarr( measured_dim^2, 7 )
	for i=1, max_iter do begin
		if i mod (max_iter/20) eq 0 then $
			print, 'Iter ', i, ' of', max_iter, ' , C-state = ', c_statistic(h, w)
		for j=0,6 do C[*,j] = reform( w#matrix[*,*,j] )			; 7 reconvolved maps
		temp1 = h/c
		temp1[ where( finite(temp1) eq 0 ) ] = 0.
		temp2 = reform(temp1,measured_dim^2*7)#inv_matrix
		w = w*reform(temp2)
		map = [map, make_map( reform( w, source_dim, source_dim ), dx=source_pix, $
			dy=source_pix )]
		map[i].id = strtrim(i,2)+' Iterations'
	if keyword_set( stop ) then stop
	endfor
	
	return, map
	
END