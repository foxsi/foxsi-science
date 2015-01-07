@foxsi-setup-script-2014

d0 = data_lvl2_d0[ where(data_lvl2_d0.hv eq 200) ]
d1 = data_lvl2_d1[ where(data_lvl2_d1.hv eq 200) ]
d2 = data_lvl2_d2[ where(data_lvl2_d2.hv eq 200) ]
d3 = data_lvl2_d3[ where(data_lvl2_d3.hv eq 200) ]
d4 = data_lvl2_d4[ where(data_lvl2_d4.hv eq 200) ]
d5 = data_lvl2_d5[ where(data_lvl2_d5.hv eq 200) ]
d6 = data_lvl2_d6[ where(data_lvl2_d6.hv eq 200) ]

trange=[205,255]
;trange=[260,310]
;trange=[505,600]
;trange=[375,460]+36
;trange = [t3_adj2+5,t3_end]
;trange = [t3_start, t3_adj1]
;trange = [t1_adj2, t1_end]
trange = [t4_start, t4_end-5]
image0 = foxsi_image_det( d0, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image1 = foxsi_image_det( d1, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image2 = foxsi_image_det( d2, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image3 = foxsi_image_det( d3, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image4 = foxsi_image_det( d4, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image5 = foxsi_image_det( d5, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image6 = foxsi_image_det( d6, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image6a = foxsi_image_det( d6, year=2014, trange=trange, erange=[6,10.], thr_n=4. )

npix = 128
image0 = frebin( image0, npix, npix, /tot )
image1 = frebin( image1, npix, npix, /tot )
image2 = frebin( image2, npix, npix, /tot )
image3 = frebin( image3, npix, npix, /tot )
image4 = frebin( image4, npix, npix, /tot )
image5 = frebin( image5, npix, npix, /tot )
image6 = frebin( image6, npix, npix, /tot )
image6a = frebin( image6a, npix, npix, /tot )

xc = cen4[0]
yc = cen4[1]
map0 = rot_map( make_map( image0, dx=7.78*128/npix, dy=7.78*128/npix, xcen=xc, ycen=yc ), rot0 )
map1 = rot_map( make_map( image1, dx=7.78*128/npix, dy=7.78*128/npix, xcen=xc, ycen=yc ), rot1 )
map2 = rot_map( make_map( image2, dx=7.78*128/npix, dy=7.78*128/npix, xcen=xc, ycen=yc ), rot2 )
map3 = rot_map( make_map( image3, dx=7.78*128/npix, dy=7.78*128/npix, xcen=xc, ycen=yc ), rot3 )
map4 = rot_map( make_map( image4, dx=7.78*128/npix, dy=7.78*128/npix, xcen=xc, ycen=yc ), rot4 )
map5 = rot_map( make_map( image5, dx=7.78*128/npix, dy=7.78*128/npix, xcen=xc, ycen=yc ), rot5 )
map6 = rot_map( make_map( image6, dx=7.78*128/npix, dy=7.78*128/npix, xcen=xc, ycen=yc ), rot6 )
map6a = rot_map( make_map( image6a, dx=7.78*128/npix, dy=7.78*128/npix, xcen=xc, ycen=yc ), rot6 )

map0 = shift_map( map0, shift0[0], shift0[1] )
map1 = shift_map( map1, shift1[0], shift1[1] )
map4 = shift_map( map4, shift4[0], shift4[1] )
map5 = shift_map( map5, shift5[0], shift5[1] )
map6 = shift_map( map6, shift6[0], shift6[1] )
map6a = shift_map( map6a, shift6[0], shift6[1] )

map0.roll_angle = 0
map1.roll_angle = 0
map2.roll_angle = 0
map3.roll_angle = 0
map4.roll_angle = 0
map5.roll_angle = 0
map6.roll_angle = 0
map6a.roll_angle = 0
map0.roll_center = 0
map1.roll_center = 0
map2.roll_center = 0
map3.roll_center = 0
map4.roll_center = 0
map5.roll_center = 0
map6.roll_center = 0
map6a.roll_center = 0

map=map0
map.data = map0.data + map1.data+map4.data+map5.data+map6.data

;plot_map, map, /limb, /cbar, charsi=1.5, lcol=255, lthick=4, xth=5, yth=5, $
;	tit='FOXSI 3rd target, 5 detectors summed'


ch=1.5
!p.multi=[0,3,2]
;popen, 'targ-5-log', xsi=8, ysi=5, /land
plot_map, map0, tit='Det 0', /log, dmin=0.1, charsi=ch
plot_map, map1, tit='Det 1', /log, dmin=0.1, charsi=ch
;plot_map, map2, tit='Det 2', /log, dmin=0.1, charsi=ch
;plot_map, map3, tit='Det 3', /log, dmin=0.1, charsi=ch
plot_map, map4, tit='Det 4', /log, dmin=0.1, charsi=ch
plot_map, map5, tit='Det 5', /log, dmin=0.1, charsi=ch
plot_map, map6, tit='Det 6', /log, dmin=0.1, charsi=ch
;pclose

ch=1.5
!p.multi=[0,3,2]
;popen, 'targ-5-log', xsi=8, ysi=5, /land
plot_map, map0, tit='Det 0', charsi=ch, /limb
plot_map, map1, tit='Det 1', charsi=ch, /limb
;plot_map, map2, tit='Det 2', charsi=ch, /limb
;plot_map, map3, tit='Det 3', charsi=ch, /limb
plot_map, map4, tit='Det 4', charsi=ch, /limb
plot_map, map5, tit='Det 5', charsi=ch, /limb
plot_map, map6, tit='Det 6', charsi=ch, /limb
;pclose

ch=1.1
!p.multi=[0,2,1]
popen, xsi=8, ysi=5, /land
loadct,5
plot_map, map6, tit='Det 6, linear', charsi=ch
plot_map, map6, tit='Det 6, log', charsi=ch, /log, dmin=0.1
;loadct,1
;plot_map, aia, tit='AIA 94A 19:13:01', charsi=ch, fov=20, cen=map6, /log
;plot_map, map6, /over, lev=[8,15,30,50,70,90], /per, col=255, thick=4
;plot_map, aia, tit='AIA 94A 19:13:01', charsi=ch, fov=5, cen=map6, /log
;plot_map, map6, /over, lev=[10,30,50,70,90], /per, col=255, thick=4
pclose


image6 = foxsi_image_det( d6, eran=[-1,100], year=2014, thr_n=-1, trange=[500,600] )
map6 = rot_map( make_map(image6,dx=7.78,dy=7.78), rot6 )
plot_map, map6, tit='Det 6', /log, dmin=0.01

f = file_search( '~/data/aia/20141211/*' )



t1 = '2014-12-11 19:11:00'
t2 = '2014-12-11 19:20:00'
dir = '~/data/aia/20141211/'

result = vso_search( t1, t2, inst='AIA', wave='94' )
log=vso_get( result, out_dir=dir, filenames=fnames, /rice ) 
result = vso_search( t1, t2, inst='AIA', wave='131' )
log=vso_get( result, out_dir=dir, filenames=fnames, /rice ) 
result = vso_search( t1, t2, inst='AIA', wave='171' )
log=vso_get( result, out_dir=dir, filenames=fnames, /rice ) 


; Example for filtering AIA indices to reduce cadence:
cadence = 60.   ; cadence in seconds
j = fix(findgen(n_elements(result)*12/cadence)*cadence/12)
log=vso_get( result[j], out_dir=dir, filenames=fnames, /rice ) 

dir = '~/data/aia/20141211/'
f=file_search(dir+'aia*')
.r
for i=0, n_elements(f)-1 do begin
aia_prep, f[i], -1, ind, dat, outdir=dir, /do_write_fits
undefine, ind
undefine, dat
endfor
end


f=file_search('~/data/aia/20141211/*_0094*')
fits2map, f, aia
 

plot_map, aia[0], /log, fov=16
shift = shift_map( map6, 35, -215 )
shift.roll_angle=0
plot_map, shift, /over, lev=[5,20,80], /per

plot_map, aia[0], fov=5, /cbar, dmax=80, cen=[0,-200]  
plot_map, shift, /over, lev=[5,10,20,40,60,80], /per

popen, xsi=5, ysi=5
aia_lct, r,g,b, wave=94, /load
TVLCT, r, g, b, /Get
TVLCT, Reverse(r), Reverse(g), Reverse(b)
aia[0].id = 'AIA 94'
plot_map, aia[0], fov=5, cen=[25,-220], charsi=1.1, thick=4, dmax=100, dmin=0, xth=5, yth=5, charth=3, color=255
plot_map, shift, /over, lev=[50,60,80], /per, thick=5, col=255
xyouts, -110, -100, '(Black) FOXSI Det 6, 50 seconds', size=1.3, col=255, charth=3
pclose


popen, xsi=5, ysi=5
aia_lct, r,g,b, wave=94, /load
TVLCT, r, g, b, /Get
TVLCT, Reverse(r), Reverse(g), Reverse(b)
aia[6].id = 'AIA 94'
plot_map, aia[6], fov=12, cen=[25,-100], charsi=1.1, thick=4, dmax=100, dmin=0, xth=5, yth=5, charth=3, color=255
plot_map, shift, /over, lev=[10,30,50,70,90], /per, thick=5, col=255          
xyouts, -300, 200, '(Black) FOXSI Det 6, 20 seconds', size=1.3, col=255, charth=3
pclose


; finding the other detector shifts:

; With map6 shifted, but the others not, the centroids are:
IDL> print, map_centroid(map0, thr=5.)   
      175.958      718.822
IDL> print, map_centroid(map1, thr=5.)
      201.560      716.492
IDL> print, map_centroid(map2, thr=5.)
      463.410      892.373
IDL> print, map_centroid(map3, thr=5.)
      569.550      1116.39
IDL> print, map_centroid(map4, thr=5.)
      197.552      758.031
IDL> print, map_centroid(map5, thr=5.)
      168.189      732.004
IDL> print, map_centroid(map6, thr=5.)
      210.838      775.965
      
shift0 = map_centroid(map6, thr=5.) - map_centroid(map0, thr=5.)
shift1 = map_centroid(map6, thr=5.) - map_centroid(map1, thr=5.)
shift4 = map_centroid(map6, thr=5.) - map_centroid(map4, thr=5.)
shift5 = map_centroid(map6, thr=5.) - map_centroid(map5, thr=5.)



plot_map, aia_tot, /limb, cen=map, fov=20, /log
plot_map, map, fov=20, /limb, /cbar      
plot_map, aia_tot, /over, lev=[0.1], /per

plot_map, aia_tot, /limb, cen=map, fov=20, /log
plot_map, map, fov=20, /limb                   


