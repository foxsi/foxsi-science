;
; Scripts to try for a point spread function deconvolution...
 ;
 
;
; THIS ONE IS ONLY FOR THE NOT-FULLY-PROCESSED DATA!!!!!
; 
 
 pix=3.
 fov=2.    ; 2 arcmin is probably the best to use, although it doesn't make much difference.
 dim = fov*60./pix
 erange=[4,15]
 loadct, 5
 det = 6
 plate_scale = 0.8   ; arcsec
 smooth = 2
 
 
 ;;;;;; STEP 1 ;;;;;;;;
 
 print, 'Defining PSF...'
 
 f=file_search('data_2012/45az*.fits')
 
 fits_read, f, data, ind
 
 ;plate_scale = 1.3   ; arcsec
 
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
 med = median( m_sum.data )
 m_sum.data = m_sum.data - med
 
 for i=0, n_elements(m)-1 do begin & $
   med = median(m[i].data) & $
   m[i].data = m[i].data - med & $
 endfor
 

 ;plot_map, m0, cen=[200,-250], fov=2
 ;plot_map, m0, /cbar, dmax=15000, cen=[200,-246], fov=1
 
 ;IDL> print, map_centroid( m_sum, thresh=1253, upper=20000)    
 ;      254.958     -328.105
       
 ; Switch PSF to center of a map.
 
 cen = [250., -326.]/1.3*plate_scale
 psf = shift_map( make_submap( m_sum, cen=cen, fov=fov ), -cen[0], -cen[1] )
; psf = rot_map( psf, 79 )
 psf = rot_map( psf, 110 )
 
 psf = make_map( frebin( psf.data, dim, dim, /total ), dx=pix, dy=pix )
 
 ; renormalize:
 psf.data = psf.data / total(psf.data)
 
; BIG CHANGE!!
;psf.data[ where(psf.data lt 0.05*max(psf.data)) ] = 0. 
psf.data = smooth(psf.data, smooth)
 
 
  ;;;;; STEP 2 ;;;;;;
 
 print, 'Retrieving flare data...'
 
 t4_start = 340      ; Target 4 (flare)
 t4_end = 421.2
 ;tr = [t4_start, t4_end]
 flare_real = [967,-205]
 
if det eq 0 then map = map0 
if det eq 1 then map = map1 
if det eq 2 then map = map2 
if det eq 3 then map = map3 
if det eq 4 then map = map4 
if det eq 5 then map = map5 
if det eq 6 then map = map6 

flare=map_centroid( map, thresh=0.3*max(map.data) )
 
; if det eq 0 then flare=map_centroid( map0, thresh=0.3*max(map0.data) )
; if det eq 1 then flare=map_centroid( map1, thresh=0.3*max(map1.data) )
; if det eq 2 then flare=map_centroid( map2, thresh=0.3*max(map2.data) )
; if det eq 3 then flare=map_centroid( map3, thresh=0.3*max(map3.data) )
; if det eq 4 then flare=map_centroid( map4, thresh=0.3*max(map4.data) )
; if det eq 5 then flare=map_centroid( map5, thresh=0.3*max(map5.data) )
; if det eq 6 then flare=map_centroid( map6, thresh=0.3*max(map6.data) )
 
; flare = flare_real
; flare = [1025, -315]
; flare = [325,300]
 
 t6_start = 438.5    ; Target 6 (flare)
 t6_end = 498.3
 
 tr = [t4_start, t6_end]
; tr = [ 360, 420 ]
 
 imdim = 10000/fix(pix)
 
; Selecting subregions...'

;raw = make_submap( map, cen=flare, fov=fov )
raw = shift_map( make_submap( map, cen=flare, fov=fov+1), -flare[0], -flare[1] )
;raw = make_submap( raw, cen=flare, fov=fov )
 
;if det eq 0 then raw0 = shift_map( make_submap( map0, cen=flare, fov=fov+1), -flare[0], -flare[1] )
;if det eq 1 then raw1 = shift_map( make_submap( map1, cen=flare, fov=fov+1), -flare[0], -flare[1] )
;if det eq 2 then raw2 = shift_map( make_submap( map2, cen=flare, fov=fov+1), -flare[0], -flare[1] )
;if det eq 3 then raw3 = shift_map( make_submap( map3, cen=flare, fov=fov+1), -flare[0], -flare[1] )
;if det eq 4 then raw4 = shift_map( make_submap( map4, cen=flare, fov=fov+1), -flare[0], -flare[1] )
;if det eq 5 then raw5 = make_submap( map5, cen=flare, fov=fov+1)
;if det eq 6 then raw6 = shift_map( make_submap( map6, cen=flare, fov=fov+1), -flare[0], -flare[1] )

raw.xc=0
raw.yc=0

raw = rebin_map( raw, dim, dim )
raw.dx = pix
raw.dy = pix

;if det eq 0 then raw = rebin_map( raw0, dim, dim )
;if det eq 1 then raw = rebin_map( raw1, dim, dim )
;if det eq 2 then raw = rebin_map( raw2, dim, dim )
;if det eq 3 then raw = rebin_map( raw3, dim, dim )
;if det eq 4 then raw = rebin_map( raw4, dim, dim )
;if det eq 5 then raw = rebin_map( raw5, dim, dim )
;if det eq 6 then raw = rebin_map( raw6, dim, dim )

;.compile map_centroid
;centr = map_centroid( raw )
raw = make_submap( raw, cen=centr, fov=fov )
;;raw = shift_map( raw, -centr[0], -centr[1] )
 
raw.dx = pix
raw.dy = pix
  

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
 pclose
 
 restore, 'data_2012/aia-maps-flare.sav', /v
 deconv_map.roll_angle = 0.
 
 ;r0 = deconv0[6]
 ;r0.data = transpose( r0.data )
 ;r0 = rot_map(r0,-90)
 ;r0.roll_angle=0
 
 !p.multi=0
 plot_map, aia[0], fov=1.5
 plot_map, shift_map(deconv_map[9], flare_real[0], flare_real[1]), /over, lev=[20,40,60,80], /per
 
 ch=1.2
 popen, 'test2', xsi=8, ysi=11
 !p.multi=[0,2,2]
 for j=6, 9 do begin & $
    plot_map, aia[0], fov=1.5, title = 'Det '+strtrim(det,2)+', '+strtrim(iter[j],2)+ ' iter' & $
    plot_map, shift_map(deconv_map[j], flare_real[0], flare_real[1]), /over, $
    	col=255, thick=4, lev=[20,40,60,80], /per & $
 endfor
 pclose

 