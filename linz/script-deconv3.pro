;
; Scripts to try for a point spread function deconvolution...
 ;
 
;
; THIS ONE USES IMAGES IN DETECTOR COORDS, NOT PAYLOAD COORDS!
; 
 
 pix=1.
 fov=2.    ; 2 arcmin is probably the best to use, although it doesn't make much difference.
 dim = fov*60./pix
 erange=[6,15]
 loadct, 5
 det = 6
 all = 1
 plate_scale = 1.8   ; arcsec
 	; 2. is a good value for D6, 2. is a good value for D4.
 	; 1.3 is nominal value.
 psf_smooth = 15
 img_smooth = 15
 rotation = 90.	; nominal value ~79
 measured_psf = 0
 
 
 ;;;;;; STEP 1 ;;;;;;;;
 
 print, 'Defining PSF...'
 
 if measured_psf eq 1 then begin &$
	f=file_search('data_2012/45az*.fits') &$
 	fits_read, f, data, ind &$
 
 	m0 = make_map( float(data[*,*,0]), dx=plate_scale, dy=plate_scale ) &$
 	m1 = make_map( float(data[*,*,1]), dx=plate_scale, dy=plate_scale ) &$
 	m2 = make_map( float(data[*,*,2]), dx=plate_scale, dy=plate_scale ) &$
 	m3 = make_map( float(data[*,*,3]), dx=plate_scale, dy=plate_scale ) &$
 	m4 = make_map( float(data[*,*,4]), dx=plate_scale, dy=plate_scale ) &$
 	m5 = make_map( float(data[*,*,5]), dx=plate_scale, dy=plate_scale ) &$
 	m6 = make_map( float(data[*,*,6]), dx=plate_scale, dy=plate_scale ) &$
 	m7 = make_map( float(data[*,*,7]), dx=plate_scale, dy=plate_scale ) &$
 	m8 = make_map( float(data[*,*,8]), dx=plate_scale, dy=plate_scale ) &$
 	m9 = make_map( float(data[*,*,9]), dx=plate_scale, dy=plate_scale ) &$
 	m=[m0,m1,m2,m3,m4,m5,m6,m7,m8,m9] &$
 	m_sum = m0 &$
 	m_sum.data = total(m.data, 3) &$
 	med = median( m_sum.data ) &$
 	m_sum.data = m_sum.data - med &$
 	for i=0, n_elements(m)-1 do begin & $
   		med = median(m[i].data) & $
   		m[i].data = m[i].data - med & $
 	endfor     &$
 	; Switch PSF to center of a map.
 	cen = [250., -326.]/1.3*plate_scale &$
 	psf = shift_map( make_submap( m_sum, cen=cen, fov=fov ), -cen[0], -cen[1] ) &$
 	psf = rot_map( psf, rotation ) &$
 	psf = make_map( frebin( psf.data, dim, dim, /total ), dx=pix, dy=pix ) &$
 	psf.data = psf_smooth(psf.data, smooth) &$
  endif else begin &$
	; or, use a gaussian PSF &$
	psf1 = psf_gaussian( npix=[120,120], /double, st_dev=[1.27836, 1.77492]/pix ) &$
	psf2 = psf_gaussian( npix=[120,120], /double, st_dev=2.*[4.36214, 7.21397]/pix )*params[4] &$
	psf3 = psf_gaussian( npix=[120,120], /double, st_dev=2.*[47.5, 240.314]/pix )*params[4]*params[5] &$
	psftest = make_map( psf1+psf2+psf3, dx=pix, dy=pix ) &$
	psf = rot_map( psftest, -45 ) &$
	psf.roll_angle=0. &$
	; plot_map, psf, fov=0.5 &$
	; plot_map, psf, /over, level=[50],/per &$
 endelse

 psf.data = psf.data / total(psf.data)	; Renormalize

 
  ;;;;; STEP 2 ;;;;;;
 
 print, 'Retrieving flare data...'
 
 t0 = t6_start - t_launch
 t1 = t6_end - t_launch
; t1 = t4_start - t_launch + 48.
; t0 = t4_start - t_launch + 48.
; t1 = t4_start - t_launch + 2*48.
; t0 = t6_start - t_launch
; t1 = t6_start - t_launch + 2*32.
 tr = [t0, t1]
 iavg=0
 
; IDL> avg[0].id = 'AIA131 18:00:32.62-18:01:08.62'
; IDL> avg[1].id = 'AIA131 18:01:20.62-18:01:56.62'
; IDL> avg[2].id = 'AIA131 18:02:20.62-18:02:44.62'
; IDL> avg[3].id = 'AIA131 18:02:56.62-18:03:20.62'

 
if det eq 0 or all eq 1 then img0=foxsi_image_det(data_lvl2_d0,erange=erange,trange=tr,thr_n=4.)
if det eq 1 or all eq 1 then img1=foxsi_image_det(data_lvl2_d1,erange=erange,trange=tr,thr_n=4.)
if det eq 2 or all eq 1 then img2=foxsi_image_det(data_lvl2_d2,erange=erange,trange=tr,thr_n=4.)
if det eq 3 or all eq 1 then img3=foxsi_image_det(data_lvl2_d3,erange=erange,trange=tr,thr_n=4.)
if det eq 4 or all eq 1 then img4=foxsi_image_det(data_lvl2_d4,erange=erange,trange=tr,thr_n=4.)
if det eq 5 or all eq 1 then img5=foxsi_image_det(data_lvl2_d5,erange=erange,trange=tr,thr_n=4.)
if det eq 6 or all eq 1 then img6=foxsi_image_det(data_lvl2_d6,erange=erange,trange=tr,thr_n=4.)
 
if det eq 0 then map = rot_map( make_map( img0, dx=7.78, dy=7.78 ), rot0 )
if det eq 1 then map = rot_map( make_map( img1, dx=7.78, dy=7.78 ), rot1 )
if det eq 2 then map = rot_map( make_map( img2, dx=7.78, dy=7.78 ), rot2 )
if det eq 3 then map = rot_map( make_map( img3, dx=7.78, dy=7.78 ), rot3 )
if det eq 4 then map = rot_map( make_map( img4, dx=7.78, dy=7.78 ), rot4 )
if det eq 5 then map = rot_map( make_map( img5, dx=7.78, dy=7.78 ), rot5 )
if det eq 6 then map = rot_map( make_map( img6, dx=7.78, dy=7.78 ), rot6 )

imdim = 1000/fix(pix)

.compile rebin_map
if all eq 1 then begin	&$
	map0 = rebin_map( make_map( img0, dx=7.78, dy=7.78 ), imdim, imdim )	&$
	map1 = rebin_map( make_map( img1, dx=7.78, dy=7.78 ), imdim, imdim )	&$
	map2 = rebin_map( make_map( img2, dx=7.78, dy=7.78 ), imdim, imdim )	&$
	map3 = rebin_map( make_map( img3, dx=7.78, dy=7.78 ), imdim, imdim )	&$
	map4 = rebin_map( make_map( img4, dx=7.78, dy=7.78 ), imdim, imdim )	&$
	map5 = rebin_map( make_map( img5, dx=7.78, dy=7.78 ), imdim, imdim )	&$
	map6 = rebin_map( make_map( img6, dx=7.78, dy=7.78 ), imdim, imdim )	&$
	map0.data = map0.data/total(map0.data)*total(img0)	&$
	map1.data = map1.data/total(map1.data)*total(img1)	&$
	map2.data = map2.data/total(map2.data)*total(img2)	&$
	map3.data = map3.data/total(map3.data)*total(img3)	&$
	map4.data = map4.data/total(map4.data)*total(img4)	&$
	map5.data = map5.data/total(map5.data)*total(img5)	&$
	map6.data = map6.data/total(map6.data)*total(img6)	&$
	map0.data = smooth( map0.data, img_smooth/pix )	&$
	map1.data = smooth( map1.data, img_smooth/pix )	&$
	map2.data = smooth( map2.data, img_smooth/pix )	&$
	map3.data = smooth( map3.data, img_smooth/pix )	&$
	map4.data = smooth( map4.data, img_smooth/pix )	&$
	map5.data = smooth( map5.data, img_smooth/pix )	&$
	map6.data = smooth( map6.data, img_smooth/pix )	&$
	map0 = rot_map( map0, rot0 )	&$
	map1 = rot_map( map1, rot1 )	&$
	map2 = rot_map( map2, rot2 )	&$
	map3 = rot_map( map3, rot3 )	&$
	map4 = rot_map( map4, rot4 )	&$
	map5 = rot_map( map5, rot5 )	&$
	map6 = rot_map( map6, rot6 )	&$
	centr0 = map_centroid(map0,th=0.1*max(map6.data))	&$
	centr1 = map_centroid(map1,th=0.1*max(map6.data))	&$
	centr2 = map_centroid(map2,th=0.1*max(map6.data))	&$
	centr3 = map_centroid(map3,th=0.1*max(map6.data))	&$
	centr4 = map_centroid(map4,th=0.1*max(map6.data))	&$
	centr5 = map_centroid(map5,th=0.1*max(map6.data))	&$
	centr6 = map_centroid(map6,th=0.1*max(map6.data))	&$
	raw0 = shift_map( make_submap( map0, cen=centr0, fov=fov+1), -centr0[0], -centr0[1] )	&$
	raw1 = shift_map( make_submap( map1, cen=centr1, fov=fov+1), -centr1[0], -centr1[1] )	&$
	raw2 = shift_map( make_submap( map2, cen=centr2, fov=fov+1), -centr2[0], -centr2[1] )	&$
	raw3 = shift_map( make_submap( map3, cen=centr3, fov=fov+1), -centr3[0], -centr3[1] )	&$
	raw4 = shift_map( make_submap( map4, cen=centr4, fov=fov+1), -centr4[0], -centr4[1] )	&$
	raw5 = shift_map( make_submap( map5, cen=centr5, fov=fov+1), -centr5[0], -centr5[1] )	&$
	raw6 = shift_map( make_submap( map6, cen=centr6, fov=fov+1), -centr6[0], -centr6[1] )	&$
	raw=raw6	&$
	raw.data = raw0.data+raw1.data+raw2.data+raw4.data+raw5.data+raw6.data	&$
	;raw.data = raw4.data+raw5.data+raw6.data	&$
	raw.xc=0	&$
	raw.yc=0	&$
	raw.dx = pix	&$
	raw.dy = pix	&$
	raw = make_submap( raw, cen=[0.,0.], fov=fov )	&$

endif else begin	&$
	
	flare_new=map_centroid( map, thresh=0.3*max(map.data) ) 	&$
	; Selecting subregions...'	&$
	;raw = make_submap( map, cen=flare_new, fov=fov )	&$
	raw = shift_map( make_submap( map, cen=flare_new, fov=fov+1), -flare_new[0], -flare_new[1] )	&$
	;raw = make_submap( raw, cen=flare_new, fov=fov ) 	&$
	raw.xc=0	&$
	raw.yc=0	&$
	raw = rebin_map( raw, dim, dim )	&$
	raw.dx = pix	&$
	raw.dy = pix	&$
	centr = map_centroid( raw )	&$
	raw = make_submap( raw, cen=centr, fov=fov )	&$
	;;raw = shift_map( raw, -centr[0], -centr[1] ) 	&$
	raw.dx = pix	&$
	raw.dy = pix	&$
	; smooth data by pixel size.	&$
	raw.data = smooth(raw.data,7.7/pix)	&$
	
endelse  

 ;;;;;; STEP 3 ;;;;;;
 
 print, 'Performing deconvolution...'
 
 iter = [1,2,3,4,5,10,20,40,60,80]
; iter = [1,2,4,10,20,40,60,80,100,200]
 n = n_elements(iter)
 undefine, deconv_map
 deconv_map = replicate( raw, n )
 reconv_map = replicate( raw, n )
  
 for j=0, n-1 do begin & $
  undefine, deconv & $
  for i=0, iter[j] do max_likelihood, raw.data, psf.data, deconv, reconv & $
  deconv_map[j].data = deconv & $
  reconv_map[j].data = reconv & $
  deconv_map[j].id=strtrim(iter[j],2)+' iter' & $
 endfor & $
 
 print, 'Done.'
 
 cstat = fltarr(n)
print, 'Cash statistics:'
for j=0, n-1 do print, 'Iteration ', iter[j], ':  ', c_statistic( reconv_map[j].data, raw.data )
for j=0, n-1 do cstat[j] = c_statistic( reconv_map[j].data, raw.data )

ch=1.2
 popen, 'test', xsi=8, ysi=11
 ;popen, 'deconvolution-D5-pix'+strtrim(fix(pix),2)+'arcsec', xsi=8, ysi=11
 !p.multi=[0,3,4]
 plot_map, psf, tit='PSF (measured post-flight D5), smooth='+strtrim(smooth,2), charsi=ch
 plot_map, raw, tit='Raw Det image', charsi=ch
 for j=0, n-1 do plot_map, deconv_map[j], tit=deconv_map[j].id, charsi=ch
; pclose
 
 restore, 'data_2012/aia-maps-flare.sav', /v
 restore, 'data_2012/aia_avg.sav', /v
 
 deconv_map.roll_angle = 0.
 ;reconv_map.roll_angle = 0.
 
 !p.multi=[0,2,2]
 for j=6,9 do begin &$
	plot_map, aia[0], fov=1.5 &$
 	plot_map, shift_map(deconv_map[j], flare[0]-6, flare[1]+3), /over, /per,$
 		color=255, thick=4, lev=[10,30,50,70,90] &$
 endfor
  
 ch=1.2
; popen, 'test2', xsi=8, ysi=11
 !p.multi=[0,2,2]
 for j=6, 9 do begin & $
 	rotmap = rot_map( deconv_map[j], (rotation-90) ) & $
 	rotmap.roll_angle=0. & $
    plot_map, avg[iavg], fov=1.5, dmin=0., $
    	title = 'Det '+strtrim(det,2)+', '+strtrim(iter[j],2)+ ' iter' & $
    plot_map, shift_map(rotmap, flare[0]-6, flare[1]+3), /over, $
    	col=255, thick=4, lev=[20,40,60,80], /per & $
 endfor
; pclose
 
;popen, 'test3', xsi=8, ysi=8
	ch=1.1
	fov=1.5
	!p.multi=[0,2,2]
  	plot_map, psf, tit='PSF', charsi=ch, fov=fov
  	plot_map, psf, /over, lev=[50], /per, thick=5, col=255
	xyouts, -40, 35, '50% contour', size=1.2, col=255
 	plot_map, raw, tit='Raw Det 6 image', charsi=ch, fov=fov
 	plot_map, raw, /over, lev=[50], /per, thick=5, col=255
	xyouts, -40, 35, '50% contour', size=1.2, col=255
	plot_map, deconv_map[8], tit=deconv_map[8].id+', deconvolved', charsi=ch, fov=fov
	plot_map, deconv_map[8], /over, lev=[50], /per, thick=5, col=255
	xyouts, -40, 35, '50% contour', size=1.2, col=255
	plot_map, reconv_map[8], tit=deconv_map[8].id+', reconvolved', charsi=ch, fov=fov
	plot_map, reconv_map[8], /over, lev=[50], /per, thick=5, col=255
	xyouts, -40, 35, '50% contour', size=1.2, col=255
pclose
 