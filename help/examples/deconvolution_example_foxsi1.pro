;;;
;;; Examples of using both FOXSI deconvolution methods.
;;;

;
; EXAMPLE 1: The "simple" method (just a wrapper for max_likelihood.pro)
; For Detector 6 only.
; See next example for a multi-detector case.
;

foxsi, 2012

;;;;; Create FOXSI map 
 dat = data_lvl2_d6	
 cen_map = cen4
 i = where((dat.wsmr_time ge t4_start and dat.wsmr_time le t4_end) or (dat.wsmr_time ge t6_start and dat.wsmr_time le t6_end) and dat.error_flag eq 0)
 map = foxsi_image_map(dat[i],erange=[4.,15.],cen_map,/xy)

 ; Find centroid of FOXSI data
 cenmap = map_centroid(map,threshold=0.05*max(map.data))

 ; Refine centroid of FOXSI data
 sub_map, map, sub, xrange=[cenmap[0]-100.,cenmap[0]+100.], yrange=[cenmap[1]-100.,cenmap[1]+100.]
 cenmap = map_centroid(sub,threshold=0.05*max(sub.data))

; Get the PSF.  Because the foxsi_psf routine was written specifically for the FOXSI-1 flare, it is at the correct off-axis angle and rotation.
psf=foxsi_psf( pix = sub.dx, fov=sub.dx*sqrt(n_elements(sub.data))/60. )

deconv = deconv_foxsi_simple( map, psf_in=psf, iter=[1,2,5,10,25,50,100,200] )
movie_map, deconv, /noscale


;
; EXAMPLE 2: The "simple" method (just a wrapper for max_likelihood.pro)
; This one uses all the detector data except for Det3.
; It also plots the results if you have an AIA context image.
;

foxsi, 2012

;;;;; Create FOXSI map 
cen_map = cen4
d0 = data_lvl2_d0[ where(data_lvl2_d0.error_flag eq 0)]
d1 = data_lvl2_d1[ where(data_lvl2_d1.error_flag eq 0)]
d2 = data_lvl2_d1[ where(data_lvl2_d2.error_flag eq 0)]
d4 = data_lvl2_d4[ where(data_lvl2_d4.error_flag eq 0)]
d5 = data_lvl2_d5[ where(data_lvl2_d5.error_flag eq 0)]
d6 = data_lvl2_d6[ where(data_lvl2_d6.error_flag eq 0)]

; Select the data from EITHER target 4 OR target 6. (Both targets are the same position.)
tr4 = [t4_start,t4_end]
tr6 = [t6_start,t6_end]
d0 = d0[ where( (d0.wsmr_time ge tr4[0] and d0.wsmr_time le tr4[1]) or (d0.wsmr_time ge tr6[0] and d0.wsmr_time le tr6[1]) ) ]
d1 = d1[ where( (d1.wsmr_time ge tr4[0] and d1.wsmr_time le tr4[1]) or (d1.wsmr_time ge tr6[0] and d1.wsmr_time le tr6[1]) ) ]
d2 = d2[ where( (d2.wsmr_time ge tr4[0] and d2.wsmr_time le tr4[1]) or (d2.wsmr_time ge tr6[0] and d2.wsmr_time le tr6[1]) ) ]
d4 = d4[ where( (d4.wsmr_time ge tr4[0] and d4.wsmr_time le tr4[1]) or (d4.wsmr_time ge tr6[0] and d4.wsmr_time le tr6[1]) ) ]
d5 = d5[ where( (d5.wsmr_time ge tr4[0] and d5.wsmr_time le tr4[1]) or (d5.wsmr_time ge tr6[0] and d5.wsmr_time le tr6[1]) ) ]
d6 = d6[ where( (d6.wsmr_time ge tr4[0] and d6.wsmr_time le tr4[1]) or (d6.wsmr_time ge tr6[0] and d6.wsmr_time le tr6[1]) ) ]

map0 = foxsi_image_map( d0, erange=[4.,15.],cen_map,/xy )
map1 = foxsi_image_map( d1, erange=[4.,15.],cen_map,/xy )
map2 = foxsi_image_map( d2, erange=[4.,15.],cen_map,/xy )
map4 = foxsi_image_map( d4, erange=[4.,15.],cen_map,/xy )
map5 = foxsi_image_map( d5, erange=[4.,15.],cen_map,/xy )
map6 = foxsi_image_map( d6, erange=[4.,15.],cen_map,/xy )

; Select a submap with a small FOV (because large ones take forever to run!)
fov=3.
map0 = make_submap( map0, cen=map_centroid(map0, thresh=0.3*max(map0.data)), fov=fov )
map1 = make_submap( map1, cen=map_centroid(map1, thresh=0.3*max(map1.data)), fov=fov )
map2 = make_submap( map2, cen=map_centroid(map1, thresh=0.3*max(map2.data)), fov=fov )
map4 = make_submap( map4, cen=map_centroid(map4, thresh=0.3*max(map4.data)), fov=fov )
map5 = make_submap( map5, cen=map_centroid(map5, thresh=0.3*max(map5.data)), fov=fov )
map6 = make_submap( map6, cen=map_centroid(map6, thresh=0.3*max(map6.data)), fov=fov )

; This avoids issues like some maps being slightly different sizes.
map1 = coreg_map( map1, map0, /same, /resc )
map2 = coreg_map( map2, map0, /same, /resc )
map4 = coreg_map( map4, map0, /same, /resc )
map5 = coreg_map( map5, map0, /same, /resc )
map6 = coreg_map( map6, map0, /same, /resc )

temp = [map0,map1,map2,map4,map5,map6]
map = map0
map.data = total(temp.data,3)
print, 'Total photons: ', total(map.data)
print, 'Photons per detector: ', total(map.data)/6.
; IDL> print, 'Total photons: ', total(map.data)
; Total photons:       7166.12
; IDL> print, 'Photons per detector: ', total(map.data)/6.
; Photons per detector:       1194.35

; Get the PSF.  Because the foxsi_psf routine was written specifically for the FOXSI-1 
; flare, it is at the correct off-axis angle and rotation.
psf=foxsi_psf( pix = map0.dx, fov=map0.dx*sqrt(n_elements(map0.data))/60. )

deconv = deconv_foxsi_simple( map, psf_in=psf, iter=[1,2,5,10,25,50,50,75,100] )
movie_map, deconv, /noscale

; The next part overplots the result on AIA.  This requires you to have an AIA map 
; already.  Replace the directory and file with yours.
i = 5		; which AIA frame to use.
j = 9		; which FOXSI frame to use.
restore, getenv('FOXSIPKG')+'/data_2012/aia-maps-flare.sav', /v
cen = map_centroid(aia[i],thresh=0.3*max(aia[i].data))
fx_map = shift_map( deconv[j], cen[0]-deconv[j].xc+12, cen[1]-deconv[j].yc+2 )
ref_map = shift_map( deconv[0], cen[0]-deconv[0].xc+7, cen[1]-deconv[0].yc+2 )
fx_map.data = gauss_smooth(fx_map.data,0.5)
;;;ref_map.data = gauss_smooth(ref_map.data,0.5)	; image doesn't really need smoothing
aia[i].id = 'AIA 94A'
fraction = [30,50,70,90]/100.		; fractions of encircled energy for contour levels

popen, 'foxsi1_deconv_simple_on_aia', xsi=7, ysi=7, /port
	!p.multi=0
	aia_lct, r,g,b, wave=94, /load
	reverse_ct
	plot_map, aia[i], fov=1.8, cen=cen, col=255, charsi=1.5, /limb, grid=2, gcol=255, $
		lcol=255
	loadct, 7
	plot_map, fx_map, /over, col=128, th=6, $
		levels=levels_encircled_energy( fx_map.data, fraction)
	xyouts, 910, -170, 'FOXSI 4-15 keV ', col=128, charsi=1.8
	xyouts, 910, -255, 'Deconvolved '+fx_map.id, col=128, charsi=1.8
	xyouts, 0.2, 0.94, 'Targets 4+6, Det 0,1,2,4,5,6', /norm, charsi=2
	xyouts, 0.3, 0.0, 'Gauss smooth = 0.6', /norm, charsi=2
pclose
spawn, 'open foxsi1_deconv_simple_on_aia.ps'
spawn, 'ps2eps -s legal foxsi1_deconv_simple_on_aia.ps'
popen, 'foxsi1_raw_on_aia', xsi=7, ysi=7, /port
	!p.multi=0
	aia_lct, r,g,b, wave=94, /load
	reverse_ct
	plot_map, aia[i], fov=1.8, cen=cen, col=255, charsi=1.5, /limb, grid=2, gcol=255, $
		lcol=255
	loadct, 7
	plot_map, ref_map, /over, col=128, th=6, $
		levels=levels_encircled_energy( ref_map.data, fraction)
	xyouts, 910, -170, 'FOXSI 4-15 keV ', col=128, charsi=1.8
	xyouts, 910, -255, 'Raw map', col=128, charsi=1.8
	xyouts, 0.2, 0.94, 'Targets 4+6, Det 0,1,2,4,5,6', /norm, charsi=2
	xyouts, 0.38, 0.0, 'No smooth', /norm, charsi=2
pclose
spawn, 'open foxsi1_raw_on_aia.ps'
spawn, 'ps2eps -s legal foxsi1_raw_on_aia.ps'



;
; The FOXSI custom-built method that uses a maximum likelihood method to find a 
; probable source given data in various detector strips
;

foxsi, 2012

pitch = 7.735		; strip pitch in um
npix = 12.			; number of strips on one side of an image
fov = pitch*(npix-1)/60.	; field of view of the image

; Choose some FOXSI data.
d0 = data_lvl2_d0[ where(data_lvl2_d0.error_flag eq 0)]
d1 = data_lvl2_d1[ where(data_lvl2_d1.error_flag eq 0)]
d2 = data_lvl2_d1[ where(data_lvl2_d2.error_flag eq 0)]
d4 = data_lvl2_d4[ where(data_lvl2_d4.error_flag eq 0)]
d5 = data_lvl2_d5[ where(data_lvl2_d5.error_flag eq 0)]
d6 = data_lvl2_d6[ where(data_lvl2_d6.error_flag eq 0)]

; Select the data from EITHER target 4 OR target 6. (Both targets are the same position.)
tr4 = [t4_start,t4_end]
tr6 = [t6_start,t6_end]
d0 = d0[ where( (d0.wsmr_time ge tr4[0] and d0.wsmr_time le tr4[1]) or (d0.wsmr_time ge tr6[0] and d0.wsmr_time le tr6[1]) ) ]
d1 = d1[ where( (d1.wsmr_time ge tr4[0] and d1.wsmr_time le tr4[1]) or (d1.wsmr_time ge tr6[0] and d1.wsmr_time le tr6[1]) ) ]
d2 = d2[ where( (d2.wsmr_time ge tr4[0] and d2.wsmr_time le tr4[1]) or (d2.wsmr_time ge tr6[0] and d2.wsmr_time le tr6[1]) ) ]
d4 = d4[ where( (d4.wsmr_time ge tr4[0] and d4.wsmr_time le tr4[1]) or (d4.wsmr_time ge tr6[0] and d4.wsmr_time le tr6[1]) ) ]
d5 = d5[ where( (d5.wsmr_time ge tr4[0] and d5.wsmr_time le tr4[1]) or (d5.wsmr_time ge tr6[0] and d5.wsmr_time le tr6[1]) ) ]
d6 = d6[ where( (d6.wsmr_time ge tr4[0] and d6.wsmr_time le tr4[1]) or (d6.wsmr_time ge tr6[0] and d6.wsmr_time le tr6[1]) ) ]


; This method requires that the data be in their native form - i.e. the counts collected 
; in each detector strip (NOT maps made by rebinning the data to rotate all the detectors
; to the same orientation).  So make the maps in detector coordinates.  Note that the maps 
; will all be rotated differently.
map0 = make_map( foxsi_image_det( d0, erange=[4.,15.] ), dx=pitch, dy=pitch )
map1 = make_map( foxsi_image_det( d1, erange=[4.,15.] ), dx=pitch, dy=pitch )
map2 = make_map( foxsi_image_det( d2, erange=[4.,15.] ), dx=pitch, dy=pitch )
map4 = make_map( foxsi_image_det( d4, erange=[4.,15.] ), dx=pitch, dy=pitch )
map5 = make_map( foxsi_image_det( d5, erange=[4.,15.] ), dx=pitch, dy=pitch )
map6 = make_map( foxsi_image_det( d6, erange=[4.,15.] ), dx=pitch, dy=pitch )

; Select a submap with a small FOV (because large ones take forever to run!)
map0 = make_submap( map0, cen=map_centroid(map0, thresh=0.3*max(map0.data)), fov=fov )
map1 = make_submap( map1, cen=map_centroid(map1, thresh=0.3*max(map1.data)), fov=fov )
map2 = make_submap( map2, cen=map_centroid(map1, thresh=0.3*max(map2.data)), fov=fov )
map4 = make_submap( map4, cen=map_centroid(map4, thresh=0.3*max(map4.data)), fov=fov )
map5 = make_submap( map5, cen=map_centroid(map5, thresh=0.3*max(map5.data)), fov=fov )
map6 = make_submap( map6, cen=map_centroid(map6, thresh=0.3*max(map6.data)), fov=fov )

; This avoids issues like some maps being slightly different sizes.
map1 = coreg_map( map1, map0, /same, /resc )
map2 = coreg_map( map2, map0, /same, /resc )
map4 = coreg_map( map4, map0, /same, /resc )
map5 = coreg_map( map5, map0, /same, /resc )
map6 = coreg_map( map6, map0, /same, /resc )

; Append maps into one array.
; Detectors 2 and 3 are just zero arrays; we will only use the Si detectors for now.
maps = replicate( map0, 7 )
maps[0].data = map0.data
maps[1].data = map1.data
maps[2].data = map2.data
maps[3].data = 0.
maps[4].data = map4.data
maps[5].data = map5.data
maps[6].data = map6.data

; Now the data are prepared!
; Next is to compute the transformation matrix that captures FOXSI's imaging response.
; This step takes a lot of computation!  (Several minutes for this example)
; Once you have the matrix file saved, you can use it for any measured image set that has 
; the same number of strips, same detectors, and same PSF.
matrix_file = 'matrix_foxsi1_flare.sav'
measured_dim = npix			; dimensions of (square) measured image
det = [1,1,1,0,1,1,1]
psf=foxsi_psf( pix = 1, fov=5. )

; Here's the matrix computation.
; THIS IS SLOW!  IF YOU HAVE ALREADY DONE IT, DON'T REPEAT.
matrix = foxsi_define_matrix( matrix=matrix_file, psf=psf, $
				measured_dim=measured_dim, detector=det )

; This step actually does the deconvolution.  The output is a set of maps after various 
; numbers of deconvolution iterations.  It is up to the user to decide what iteration 
; number to go to.
deconv = foxsi_deconv( maps, matrix_file, max=100 )
movie_map, deconv, /nosc

print, 'Total photons: ', total(maps.data)
print, 'Photons per detector: ', total(maps.data)/6.

;IDL> print, 'Total photons: ', total(maps.data)
;Total photons:       6181.00
;IDL> print, 'Photons per detector: ', total(maps.data)/6.
;Photons per detector:       1030.17

; The next part overplots the result on AIA.  This requires you to have an AIA map 
; already.  Replace the directory and file with yours.
i = 5		; which AIA frame to use.
j = 20		; which FOXSI frame to use.
restore, getenv('FOXSIPKG')+'/data_2012/aia-maps-flare.sav', /v
cen = map_centroid(aia[i],thresh=0.3*max(aia[i].data))
fx_map = shift_map( deconv[j], cen[0]-deconv[j].xc+5, cen[1]-deconv[j].yc+3 )
aia[i].id = 'AIA 94A'
fraction = [30,50,70,90]/100.		; fractions of encircled energy for contour levels

popen, 'foxsi1_deconv_on_aia', xsi=7, ysi=7, /port
	!p.multi=0
	aia_lct, r,g,b, wave=94, /load
	reverse_ct
	plot_map, aia[i], fov=1.8, cen=cen, col=255, charsi=1.5, /limb, grid=2, gcol=255, lcol=255
	loadct, 7
	plot_map, fx_map, /over, col=128, th=6, $
		levels=levels_encircled_energy( fx_map.data, fraction)
	xyouts, 910, -170, 'FOXSI 4-15 keV ', col=128, charsi=1.8
	xyouts, 910, -255, 'Deconvolved '+fx_map.id, col=128, charsi=1.8
	xyouts, 0.2, 0.94, 'Targets 4+6, Det 0,1,2,4,5,6', /norm, charsi=2
	xyouts, 0.38, 0.0, 'No smooth', /norm, charsi=2
pclose
spawn, 'open foxsi1_deconv_on_aia.ps'
spawn, 'ps2eps -s legal foxsi1_deconv_on_aia.ps'

