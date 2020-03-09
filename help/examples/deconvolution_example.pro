;;;
;;; Examples of using both FOXSI deconvolution methods.
;;;

;
; The "simple" method (just a wrapper for max_likelihood.pro)
;

foxsi, 2014

;;;;; Create FOXSI map 

dat = data_lvl2_d6	
cen_map = cen1_pos0
trange = [t1_pos0_start, t1_pos0_end]	
t1 = trange[0] + t_launch
t2 = trange[1] + t_launch
i = where(dat.wsmr_time gt t1 and dat.wsmr_time lt t2 and dat.error_flag eq 0)
map = foxsi_image_map(dat[i],erange=[4.,15.],cen_map,/xy)

; Find centroid of FOXSI data
center = [33,-233]	; this is the centroid for RHESSI data (microflare 1)
sub_map, map, sub, xrange=[center[0]-100.,center[0]+100.], yrange=[center[1]-100.,center[1]+100.]
cenmap = map_centroid(sub,threshold=0.05*max(sub.data))

; Refine centroid of FOXSI data
sub_map, map, sub, xrange=[cenmap[0]-100.,cenmap[0]+100.], yrange=[cenmap[1]-100.,cenmap[1]+100.]
cenmap = map_centroid(sub,threshold=0.05*max(sub.data))

; Use centroid to shift map to align with RHESSI data
shiftmap =  center - cenmap
map = shift_map(map,shiftmap[0],shiftmap[1])

; Restore whichever PSF you want.
restore, GETENV('FOXSIDB') + '/../calibration_data/foxsi_psf_targ1_pos0_367.sav'

deconv = deconv_foxsi_simple( map, psf_in=psf )
movie_map, deconv, /noscale


;
; The FOXSI custom-built method that uses a maximum likelihood method to find a 
; probable source given data in various detector strips
;

foxsi, 2014

pitch = 7.735		; strip pitch in um
npix = 12.			; number of strips on one side of an image
fov = pitch*(npix-1)/60.	; field of view of the image

; Choose some FOXSI data.
tr = [t1_pos2_start,t1_pos2_end]	; Time range (example here is first target, pos 2)
d0 = data_lvl2_d0[ where(data_lvl2_d0.error_flag eq 0)]
d1 = data_lvl2_d1[ where(data_lvl2_d1.error_flag eq 0)]
d4 = data_lvl2_d4[ where(data_lvl2_d4.error_flag eq 0)]
d5 = data_lvl2_d5[ where(data_lvl2_d5.error_flag eq 0)]
d6 = data_lvl2_d6[ where(data_lvl2_d6.error_flag eq 0)]

; This method requires that the data be in their native form - i.e. the counts collected 
; in each detector strip (NOT maps made by rebinning the data to rotate all the detectors
; to the same orientation).  So make the maps in detector coordinates.  Note that the maps 
; will all be rotated differently.
map0 = make_map( foxsi_image_det( d0, trange = tr ), dx=pitch, dy=pitch )
map1 = make_map( foxsi_image_det( d1, trange = tr ), dx=pitch, dy=pitch )
map4 = make_map( foxsi_image_det( d4, trange = tr ), dx=pitch, dy=pitch )
map5 = make_map( foxsi_image_det( d5, trange = tr ), dx=pitch, dy=pitch )
map6 = make_map( foxsi_image_det( d6, trange = tr ), dx=pitch, dy=pitch )

; Select a submap with a small FOV (because large ones take forever to run!)
map0 = make_submap( map0, cen=map_centroid(map0, thresh=0.3*max(map0.data)), fov=fov )
map1 = make_submap( map1, cen=map_centroid(map1, thresh=0.3*max(map1.data)), fov=fov )
map4 = make_submap( map4, cen=map_centroid(map4, thresh=0.3*max(map4.data)), fov=fov )
map5 = make_submap( map5, cen=map_centroid(map5, thresh=0.3*max(map5.data)), fov=fov )
map6 = make_submap( map6, cen=map_centroid(map6, thresh=0.3*max(map6.data)), fov=fov )

; This avoids issues like some maps being slightly different sizes.
map1 = coreg_map( map1, map0, /same, /resc )
map4 = coreg_map( map4, map0, /same, /resc )
map5 = coreg_map( map5, map0, /same, /resc )
map6 = coreg_map( map6, map0, /same, /resc )

; Append maps into one array.
; Detectors 2 and 3 are just zero arrays; we will only use the Si detectors for now.
maps = replicate( map0, 7 )
maps[0].data = map0.data
maps[1].data = map1.data
maps[2].data = 0.
maps[3].data = 0.
maps[4].data = map4.data
maps[5].data = map5.data
maps[6].data = map6.data

; Now the data are prepared!
; Next is to compute the transformation matrix that captures FOXSI's imaging response.
; This step takes a lot of computation!  (Several minutes for this example)
; Once you have the matrix file saved, you can use it for any measured image set that has 
; the same number of strips, same detectors, and same PSF.
matrix_file = 'workdir/matrix.sav'
measured_dim = npix			; dimensions of (square) measured image
det = [1,1,0,0,1,1,1]
restore, 'calibration_data/foxsi_psf_on_axis.sav', /v		; on-axis PSF

; Here's the matrix computation.
matrix = foxsi_define_matrix( matrix=matrix_file, psf=psf, $
				measured_dim=measured_dim, detector=det )

; This step actually does the deconvolution.  The output is a set of maps after various 
; numbers of deconvolution iterations.  It is up to the user to decide what iteration 
; number to go to.
deconv = foxsi_deconv( maps, matrix_file, max=20 )
movie_map, deconv, /nosc
