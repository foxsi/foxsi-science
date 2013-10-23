;
; Scripts to try for a point spread function deconvolution...
;

; Step 1: Define the point spread function in terms of an intensity map centered at the peak.
; Step 2: Pull out flare image (D6) and center it.
; Resize the two to match dimensions.
; Step 3: Loop through the deconvolution, displaying results at each step.


pix=3.
fov=2.		; 2 arcmin is probably the best to use, although it doesn't make much difference.
dim = fov*60./pix
erange=[4,15]
loadct, 5


;;;;;; STEP 1 ;;;;;;;;

print, 'Defining PSF...'

f=file_search('data_2012/45az*.fits')

fits_read, f, data, ind

plate_scale = 1.3   ; arcsec

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

cen = [250., -326.]
psf = shift_map( make_submap( m_sum, cen=cen, fov=fov ), -cen[0], -cen[1] )
psf = rot_map( psf, 90 )

psf = make_map( frebin( psf.data, dim, dim, /total ), dx=pix, dy=pix )

; renormalize:
psf.data = psf.data / total(psf.data)

;;;;; STEP 2 ;;;;;;

print, 'Retrieving flare data...'

t4_start = 340			; Target 4 (flare)
t4_end = 421.2
;tr = [t4_start, t4_end]
flare = [967,-205]

;flare = [1025, -315]

t6_start = 438.5		; Target 6 (flare)
t6_end = 498.3

tr = [t4_start, t6_end]
tr = [ 360, 420 ]

imdim = 10000/fix(pix)
img0=foxsi_image_solar(data_lvl2_d0,0,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor, size=[imdim,imdim])
img1=foxsi_image_solar(data_lvl2_d1,1,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor, size=[imdim,imdim])
img2=foxsi_image_solar(data_lvl2_d2,2,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor, size=[imdim,imdim])
img3=foxsi_image_solar(data_lvl2_d3,3,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor, size=[imdim,imdim])
img4=foxsi_image_solar(data_lvl2_d4,4,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor, size=[imdim,imdim])
img5=foxsi_image_solar(data_lvl2_d5,5,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor, size=[imdim,imdim])
img6=foxsi_image_solar(data_lvl2_d6,6,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor, size=[imdim,imdim])
;img0=foxsi_image_solar(data_lvl2_d0,0,psize=pix,erange=erange,trange=tr,thr_n=4., size=[imdim,imdim])
;img1=foxsi_image_solar(data_lvl2_d1,1,psize=pix,erange=erange,trange=tr,thr_n=4., size=[imdim,imdim])
;img2=foxsi_image_solar(data_lvl2_d2,2,psize=pix,erange=erange,trange=tr,thr_n=4., size=[imdim,imdim])
;img3=foxsi_image_solar(data_lvl2_d3,3,psize=pix,erange=erange,trange=tr,thr_n=4., size=[imdim,imdim])
;img4=foxsi_image_solar(data_lvl2_d4,4,psize=pix,erange=erange,trange=tr,thr_n=4., size=[imdim,imdim])
;img5=foxsi_image_solar(data_lvl2_d5,5,psize=pix,erange=erange,trange=tr,thr_n=4., size=[imdim,imdim])
;img6=foxsi_image_solar(data_lvl2_d6,6,psize=pix,erange=erange,trange=tr,thr_n=4., size=[imdim,imdim])

map0 = make_map( img0, xcen=0., ycen=0., dx=pix, dy=pix )
map1 = make_map( img1, xcen=0., ycen=0., dx=pix, dy=pix )
map2 = make_map( img2, xcen=0., ycen=0., dx=pix, dy=pix )
map3 = make_map( img3, xcen=0., ycen=0., dx=pix, dy=pix )
map4 = make_map( img4, xcen=0., ycen=0., dx=pix, dy=pix )
map5 = make_map( img5, xcen=0., ycen=0., dx=pix, dy=pix )
map6 = make_map( img6, xcen=0., ycen=0., dx=pix, dy=pix )
;plot_map, map6, /limb, cen=flare, fov=2, /cbar

; Selecting subregions...'

raw0 = shift_map( make_submap( map0, cen=flare, fov=fov), -flare[0], -flare[1] )
raw1 = shift_map( make_submap( map1, cen=flare, fov=fov), -flare[0], -flare[1] )
raw2 = shift_map( make_submap( map2, cen=flare, fov=fov), -flare[0], -flare[1] )
raw3 = shift_map( make_submap( map3, cen=flare, fov=fov), -flare[0], -flare[1] )
raw4 = shift_map( make_submap( map4, cen=flare, fov=fov), -flare[0], -flare[1] )
raw5 = shift_map( make_submap( map5, cen=flare, fov=fov), -flare[0], -flare[1] )
raw6 = shift_map( make_submap( map6, cen=flare, fov=fov), -flare[0], -flare[1] )

raw0 = make_map( raw0.data[0:dim-1,0:dim-1], dx=pix, dy=pix )
raw1 = make_map( raw1.data[0:dim-1,0:dim-1], dx=pix, dy=pix )
raw2 = make_map( raw2.data[0:dim-1,0:dim-1], dx=pix, dy=pix )
raw3 = make_map( raw3.data[0:dim-1,0:dim-1], dx=pix, dy=pix )
raw4 = make_map( raw4.data[0:dim-1,0:dim-1], dx=pix, dy=pix )
raw5 = make_map( raw5.data[0:dim-1,0:dim-1], dx=pix, dy=pix )
raw6 = make_map( raw6.data[0:dim-1,0:dim-1], dx=pix, dy=pix )

;plot_map, raw6, /limb, /cbar

;;;;;; STEP 3 ;;;;;;

print, 'Performing deconvolution...'

iter = [1,2,3,4,5,10,20,40,60,80]
n = n_elements(iter)
deconv_map = replicate( raw6, n )

raw = raw5
;raw.data = raw0.data+raw1.data+raw2.data+raw4.data+raw5.data+raw6.data
;raw.data = raw4.data+raw6.data

;.r
for j=0, n-1 do begin & $
undefine, deconv & $
for i=0, iter[j] do max_likelihood, raw.data, psf.data, deconv & $
deconv_map[j].data = deconv & $
deconv_map[j].id=strtrim(iter[j],2)+' iter' & $
endfor & $
;end

print, 'Done.'

ch=1.2
popen, 'test', xsi=8, ysi=11
;popen, 'deconvolution-D5-pix'+strtrim(fix(pix),2)+'arcsec', xsi=8, ysi=11
!p.multi=[0,3,4]
plot_map, psf, tit='PSF (measured post-flight D5)', charsi=ch
plot_map, raw, tit='Raw Det 6 image', charsi=ch
for j=0, n-1 do plot_map, deconv_map[j], tit=deconv_map[j].id, charsi=ch
pclose

restore, 'data_2012/aia-maps-flare.sav', /v

;r0 = deconv0[6]
;r0.data = transpose( r0.data )
;r0 = rot_map(r0,-90)
;r0.roll_angle=0

!p.multi=0
plot_map, aia[0]
plot_map, shift_map(deconv_map[6], flare[0], flare[1]), /over, lev=[5,10,20,40,60,80], /per
