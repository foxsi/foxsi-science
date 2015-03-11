;@foxsi-setup-script-2014

; Shorter version

trange=[t1_start, t1_adj1]
;trange=[t1_adj1,t1_adj2]
;trange=[t1_adj2,t1_end]
;trange=[t2_start,t2_adj1]
;trange=[t2_adj1,t2_end]
;trange=[t3_start,t3_adj1]
;trange=[t3_adj1,t3_adj2]
;trange=[t3_adj2,t3_end]
;trange=[t4_start,t_shtr_start]
;trange=[t_shtr_end,t4_end]
;trange=[t5_start,t5_end]

cen=cen1
;cen=cen1_adj1
;cen=cen1_adj2
;cen=cen2
;cen=cen2_adj1
;cen=cen3
;cen=cen3_adj1
;cen=cen3_adj2
;cen=cen4
;cen=cen5

image0 = foxsi_image_det( data_lvl2_d0, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image1 = foxsi_image_det( data_lvl2_d1, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image4 = foxsi_image_det( data_lvl2_d4, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image5 = foxsi_image_det( data_lvl2_d5, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image6 = foxsi_image_det( data_lvl2_d6, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )

xc = cen[0]
yc = cen[1]
map0 = rot_map( make_map( image0, dx=7.78, dy=7.78, xcen=xc, ycen=yc ), rot0 )
map1 = rot_map( make_map( image1, dx=7.78, dy=7.78, xcen=xc, ycen=yc ), rot1 )
map4 = rot_map( make_map( image4, dx=7.78, dy=7.78, xcen=xc, ycen=yc ), rot4 )
map5 = rot_map( make_map( image5, dx=7.78, dy=7.78, xcen=xc, ycen=yc ), rot5 )
map6 = rot_map( make_map( image6, dx=7.78, dy=7.78, xcen=xc, ycen=yc ), rot6 )

map0 = shift_map( map0, shift0[0], shift0[1] )
map1 = shift_map( map1, shift1[0], shift1[1] )
map4 = shift_map( map4, shift4[0], shift4[1] )
map5 = shift_map( map5, shift5[0], shift5[1] )
map6 = shift_map( map6, shift6[0], shift6[1] )

map0.roll_angle = 0
map1.roll_angle = 0
map4.roll_angle = 0
map5.roll_angle = 0
map6.roll_angle = 0
map0.roll_center = 0
map1.roll_center = 0
map4.roll_center = 0
map5.roll_center = 0
map6.roll_center = 0

map=map0
map.data = map0.data + map1.data+map4.data+map5.data+map6.data


; Longer version

trange=[t1_start, t1_adj1]
;trange=[t1_adj1,t1_adj2]
;trange=[t1_adj2,t1_end]
;trange=[t2_start,t2_adj1]
;trange=[t2_adj1,t2_end]
;trange=[t3_start,t3_adj1]
;trange=[t3_adj1,t3_adj2]
;trange=[t3_adj2,t3_end]
;trange=[t4_start,t_shtr_start]
;trange=[t_shtr_end,t4_end]
;trange=[t5_start,t5_end]

cen=cen1
;cen=cen1_adj1
;cen=cen1_adj2
;cen=cen2
;cen=cen2_adj1
;cen=cen3
;cen=cen3_adj1
;cen=cen3_adj2
;cen=cen4
;cen=cen5

image0 = foxsi_image_det( data_lvl2_d0, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image1 = foxsi_image_det( data_lvl2_d1, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image2 = foxsi_image_det( data_lvl2_d2, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image3 = foxsi_image_det( data_lvl2_d3, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image4 = foxsi_image_det( data_lvl2_d4, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image5 = foxsi_image_det( data_lvl2_d5, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image6 = foxsi_image_det( data_lvl2_d6, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )

npix = 128
image0 = frebin( image0, npix, npix, /tot )
image1 = frebin( image1, npix, npix, /tot )
image2 = frebin( image2, npix, npix, /tot )
image3 = frebin( image3, npix, npix, /tot )
image4 = frebin( image4, npix, npix, /tot )
image5 = frebin( image5, npix, npix, /tot )
image6 = frebin( image6, npix, npix, /tot )
image6a = frebin( image6a, npix, npix, /tot )

xc = cen[0]
yc = cen[1]
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
popen, 'targ-2-log', xsi=8, ysi=5, /land
plot_map, map0, tit='Det 0', /log, /limb, lcol=255, lth=4, dmin=0.1, charsi=ch
plot_map, map1, tit='Det 1', /log, /limb, lcol=255, lth=4, dmin=0.1, charsi=ch
;plot_map, map2, tit='Det 2', /log, /limb, lcol=255, lth=4, dmin=0.1, charsi=ch
;plot_map, map3, tit='Det 3', /log, /limb, lcol=255, lth=4, dmin=0.1, charsi=ch
plot_map, map4, tit='Det 4', /log, /limb, lcol=255, lth=4, dmin=0.1, charsi=ch
plot_map, map5, tit='Det 5', /log, /limb, lcol=255, lth=4, dmin=0.1, charsi=ch
plot_map, map6, tit='Det 6', /log, /limb, lcol=255, lth=4, dmin=0.1, charsi=ch
pclose

ch=1.5
!p.multi=[0,3,2]
popen, 'targ-1-lin', xsi=8, ysi=5, /land
plot_map, map0, tit='Det 0', /limb, lcol=255, lth=4, charsi=ch
plot_map, map1, tit='Det 1', /limb, lcol=255, lth=4, charsi=ch
;plot_map, map2, tit='Det 2', /limb, lcol=255, lth=4, charsi=ch
;plot_map, map3, tit='Det 3', /limb, lcol=255, lth=4, charsi=ch
plot_map, map4, tit='Det 4', /limb, lcol=255, lth=4, charsi=ch
plot_map, map5, tit='Det 5', /limb, lcol=255, lth=4, charsi=ch
plot_map, map6, tit='Det 6', /limb, lcol=255, lth=4, charsi=ch
pclose

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

result = vso_search( t1, t2, inst='AIA', wave='193' )
log=vso_get( result, out_dir=dir, filenames=fnames, /rice ) 
result = vso_search( t1, t2, inst='AIA', wave='211' )
log=vso_get( result, out_dir=dir, filenames=fnames, /rice ) 
result = vso_search( t1, t2, inst='AIA', wave='335' )
log=vso_get( result, out_dir=dir, filenames=fnames, /rice ) 


; Example for filtering AIA indices to reduce cadence:
cadence = 60.   ; cadence in seconds
j = fix(findgen(n_elements(result)*12/cadence)*cadence/12)
log=vso_get( result[j], out_dir=dir, filenames=fnames, /rice ) 

dir = '~/data/aia/20141211/'
f=file_search(dir+'aia*335*')
.r
for i=0, n_elements(f)-1 do begin
aia_prep, f[i], -1, ind, dat, outdir=dir, /do_write_fits
spawn, 'rm '+f[i]
undefine, ind
undefine, dat
endfor
end


f=file_search('~/data/aia/20141211/*_0131*')
fits2map, f, m0131
save, m0131, file='aia-131.sav'
 

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




; example

; Choose the time range and location.
trange = [t3_pos2_start, t3_pos2_end]
xc = cen3_pos2[0]
yc = cen3_pos2[1]

; Basic image production
image6 = foxsi_image_det( data_lvl2_d6, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
map6 = make_map( image6, dx=7.78, dy=7.78, xcen=xc, ycen=yc )

; Apply a coarse offset gleaned from comparing images with AIA.
map6 = shift_map( map6, shift6[0], shift6[1] )

; Rotate the image based on the rotation angle for that specific detector.
map6 = rot_map( map6, rot6 )
map6.roll_angle = 0
map6.roll_center = 0

loadct, 5
plot_map, map6
plot_map, map6, /log


f=file_search('~/data/aia/20141211/*_0094*')
fits2map, f, aia

loadct, 1
reverse_ct
plot_map, aia[43], cen=cen5, fov=20, /log, charsi=1.5, charth=2, xth=5, yth=5
hsi_linecolors                                                 
;plot_map, map, /over, lev=[1,5,10,50,90], /per, col=2, thi=5
plot_map, map, /over, lev=[50,70,90,95], /per, col=2, thi=3


loadct, 1
reverse_ct
plot_map, aia[43], cen=cen, fov=20, /log, charsi=1.5, charth=2, xth=5, yth=5
hsi_linecolors                                                 
plot_map, map, /over, lev=[1,5,10,50,90], /per, col=2, thi=5


; starting with map_pos0, map_pos1, map_pos2
shift0 = map_centroid(map_pos2, thr=3) - map_centroid(map_pos0, thr=10)
shift1 = map_centroid(map_pos2, thr=3) - map_centroid(map_pos1, thr=10)
shift_pos0 = shift_map( map_pos0, shift0[0], shift0[1] )
shift_pos1 = shift_map( map_pos1, shift1[0], shift1[1] )

sub0 = make_submap( shift_pos0, cen=[190,-200], fov=10)
sub1 = make_submap( shift_pos1, cen=[190,-200], fov=10)
sub2 = make_submap( map_pos2,   cen=[190,-200], fov=10)

help, sub0.data, sub1.data, sub2.data   

new = sub2
new.data += sub0.data
new.data += sub1.data
plot_map, new


; more imaging

; example

; Choose the time range and location.
trange = [t1_pos2_start, t1_pos2_end]
xc = cen1_pos2[0]
yc = cen1_pos2[1]

; Basic image production
image0 = foxsi_image_det( data_lvl2_d0, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image1 = foxsi_image_det( data_lvl2_d1, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image4 = foxsi_image_det( data_lvl2_d4, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image5 = foxsi_image_det( data_lvl2_d5, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
image6 = foxsi_image_det( data_lvl2_d6, year=2014, trange=trange, erange=[4.,15.], thr_n=4. )
map0 = make_map( image0, dx=7.78, dy=7.78, xcen=xc, ycen=yc )
map1 = make_map( image1, dx=7.78, dy=7.78, xcen=xc, ycen=yc )
map4 = make_map( image4, dx=7.78, dy=7.78, xcen=xc, ycen=yc )
map5 = make_map( image5, dx=7.78, dy=7.78, xcen=xc, ycen=yc )
map6 = make_map( image6, dx=7.78, dy=7.78, xcen=xc, ycen=yc )

; Apply a coarse offset gleaned from comparing images with AIA.
map0 = shift_map( map0, shift0[0], shift0[1] )
map1 = shift_map( map1, shift1[0], shift1[1] )
map4 = shift_map( map4, shift4[0], shift4[1] )
map5 = shift_map( map5, shift5[0], shift5[1] )
map6 = shift_map( map6, shift6[0], shift6[1] )

; Rotate the image based on the rotation angle for that specific detector.
map0 = rot_map( map0, rot0 )
map1 = rot_map( map1, rot1 )
map4 = rot_map( map4, rot4 )
map5 = rot_map( map5, rot5 )
map6 = rot_map( map6, rot6 )
map0.roll_angle = 0
map1.roll_angle = 0
map4.roll_angle = 0
map5.roll_angle = 0
map6.roll_angle = 0
map0.roll_center = 0
map1.roll_center = 0
map4.roll_center = 0
map5.roll_center = 0
map6.roll_center = 0

map = map6
map.data = map0.data + map1.data + map4.data + map5.data + map6.data

loadct, 5
plot_map, map6
plot_map, map6, /log


f=file_search('~/data/aia/20141211/*_0131*')
fits2map, f, aia

loadct, 1
reverse_ct
plot_map, aia[43], cen=cen5, fov=20, /log, charsi=1.5, charth=2, xth=5, yth=5
hsi_linecolors                                                 
;plot_map, map, /over, lev=[1,5,10,50,90], /per, col=2, thi=5
plot_map, map, /over, lev=[50,70,90,95], /per, col=2, thi=3


; with NuSTAR

; AR
restore, 'nustar/nustar-obs3-arA.sav', /v
restore, 'nustar/foxsi-target3-allSi.sav', /v

popen, 'nustar/nustar-foxsi', xsi=7, ysi=7
loadct, 1
reverse_ct
plot_map, nust, /limb, lcol=255, grid=10, gcol=255, lth=4, gth=4, charsi=1.3, $
	xth=5, yth=5, charth=2, color=255
hsi_linecolors
plot_map, map, /over, col=2, thick=10, lev=[10], /per
xyouts, 0.18, 0.01, 'FOXSI 19:17:10 - 19:17:45 single counts', /norm, charsi=1.5, charth=2, col=2
pclose


; North Pole
restore, 'nustar/nustar-obs3-npA.sav', /v
restore, 'nustar/foxsi-target4-allSi.sav', /v

popen, 'nustar/nustar-foxsi', xsi=7, ysi=7
loadct, 3
;reverse_ct
plot_map, nust, /limb, lcol=255, grid=10, gcol=255, lth=4, gth=4, charsi=1.3, $
	xth=5, yth=5, charth=2;, color=255
hsi_linecolors
plot_map, map, /over, col=3, thick=10, lev=[10], /per
xyouts, 0.18, 0.01, 'FOXSI 19:17:49 - 19:19:22 single counts', /norm, charsi=1.5, charth=2, col=3
pclose


; AIA, for comparison

f=file_search('~/data/aia/20141211/*_0131*')
fits2map, f, aia131
f=file_search('~/data/aia/20141211/*_0094*')
fits2map, f, aia094

popen, 'nustar/aia', xsi=7, ysi=7
aia_lct, r,g,b, wave=94, /load
plot_map, aia094[35], /log, cen=[250,950], fov=10, dmax=20, charsi=1.3, $
	xth=5, yth=5, charth=2, /nodate
plot_map, aia094[33], /log, cen=[925,-260], fov=11, dmax=80, charsi=1.3, $
	xth=5, yth=5, charth=2, /nodate
aia_lct, r,g,b, wave=131, /load
plot_map, aia131[35], /log, cen=[250,950], fov=10, dmax=500, charsi=1.3, $
	xth=5, yth=5, charth=2, /nodate
plot_map, aia131[33], /log, cen=[925,-260], fov=11, dmax=1000, charsi=1.3, $
	xth=5, yth=5, charth=2, /nodate
pclose
	

; deconvolution

dec0 = deconv_foxsi( [1,0,0,0,0,0,0], [t1_pos2_start,t1_pos2_end]+tlaunch, year=2014, /meas)
dec1 = deconv_foxsi( [0,1,0,0,0,0,0], [t1_pos2_start,t1_pos2_end]+tlaunch, year=2014, /meas)
dec4 = deconv_foxsi( [0,0,0,0,1,0,0], [t1_pos2_start,t1_pos2_end]+tlaunch, year=2014, /meas)
dec5 = deconv_foxsi( [0,0,0,0,0,1,0], [t1_pos2_start,t1_pos2_end]+tlaunch, year=2014, /meas)
dec6 = deconv_foxsi( [0,0,0,0,0,0,1], [t1_pos2_start,t1_pos2_end]+tlaunch, year=2014, /meas)
	

; using the new "map" routine
; imaging spectroscopy of last target, D6.

trange=[t5_start, t5_end]
m6a = foxsi_image_map( data_lvl2_d6, cen5, erange=[4,6], trange=trange, thr_n=4., smooth=2, /xycorr )
m6b = foxsi_image_map( data_lvl2_d6, cen5, erange=[6,8], trange=trange, thr_n=4., smooth=2, /xycorr )
m6c = foxsi_image_map( data_lvl2_d6, cen5, erange=[8,11], trange=trange, thr_n=4., smooth=2, /xycorr )

popen, 'imspex-targ5', xsi=7, ysi=7
loadct, 3
plot_map, m6a, cen=[-80,0], fov=2
hsi_linecolors
plot_map, m6a, /over, col=6, lev=[30,50,70,90], /per, thick=6
plot_map, m6b, /over, col=12, lev=[30,50,70,90], /per, thick=6
plot_map, m6c, /over, col=1, lev=[30,50,70,90], /per, thick=6
xyouts, -130, 50, '4-6 keV (630 cts)', charsi=1.5, col=6
xyouts, -130, 43, '6-8 keV (311 cts)', charsi=1.5, col=12
xyouts, -130, 36, '8-11 keV (47 cts)', charsi=1.5, col=1
pclose

; explore over time.
t1=t5_start
m6a = foxsi_image_map( data_lvl2_d6, cen5, erange=[8,11], trange=t1+[0,10], thr_n=4., smooth=2, /xycorr )
m6b = foxsi_image_map( data_lvl2_d6, cen5, erange=[8,11], trange=t1+[10,20], thr_n=4., smooth=2, /xycorr )
m6c = foxsi_image_map( data_lvl2_d6, cen5, erange=[8,11], trange=t1+[20,30], thr_n=4., smooth=2, /xycorr )

;
; AR2
;

trange=[t4_start, t_shtr_start]
cen = cen4
en = [4.,12.]
m0 = foxsi_image_map( data_lvl2_d0, cen, erange=en, trange=trange, thr_n=4., /xycorr )
m1 = foxsi_image_map( data_lvl2_d1, cen, erange=en, trange=trange, thr_n=4., /xycorr )
m4 = foxsi_image_map( data_lvl2_d4, cen, erange=en, trange=trange, thr_n=4., /xycorr )
m5 = foxsi_image_map( data_lvl2_d5, cen, erange=en, trange=trange, thr_n=4., /xycorr )
m6 = foxsi_image_map( data_lvl2_d6, cen, erange=en, trange=trange, thr_n=4., /xycorr )

m = m6
m.data = m0.data + m1.data + m4.data + m5.data + m6.data

m2 = shift_map( m, 30, 30)

loadct,1
reverse_ct
plot_map, aia[36], /log, cen=cen4, fov=20
hsi_linecolors
plot_map, m2, /over, col=2, lev=[10,30,50,70,90], /per, thick=3

mask = m2
mask.data[ where(m2.data gt 0.1) ] = 0.
plot_map, mask

;
; AR1 and ARX plots on AIA, again.  Also RHESSI, for comparison.
;

f1=file_search('~/data/aia/20121102/*.94A*')
f2=file_search('~/data/aia/20141211/*_0094*')
;fits2map, f1, aia1
fits2map, f2, aia2

;aia_lct,r,g,b, wave=94, /load

; Set up an unrotated FOV on the targets:
x = [0,0,127,127,0]
y = [0,127,127,0,0]
coords = get_payload_coords( transpose([[x],[y]]), 5 )

loadct, 1
reverse_ct
popen, xsi=7, ysi=7

restore, 'data_2012/flight2012-parameters.sav'
plot_map, aia1[20], dmin=0., dmax=50, thick=5, xth=5,yth=5,charth=2, charsi=1.3, fov=50
oplot, coords[0,*]+cen1[0], coords[1,*]+cen1[1], thick=5, col=255
oplot, coords[0,*]+cen2[0], coords[1,*]+cen2[1], thick=5, col=255
oplot, coords[0,*]+cen3[0], coords[1,*]+cen3[1], thick=5, col=255
oplot, coords[0,*]+cen4[0], coords[1,*]+cen4[1], thick=5, col=255

restore, 'data_2014/flight2014-parameters.sav'
plot_map, aia2[10], dmin=0., dmax=50, thick=5, xth=5,yth=5,charth=2, charsi=1.3, fov=50
oplot, coords[0,*]+cen1_pos2[0], coords[1,*]+cen1_pos2[1], thick=5, col=255
oplot, coords[0,*]+cen2_pos1[0], coords[1,*]+cen2_pos1[1], thick=5, col=255
oplot, coords[0,*]+cen3_pos2[0], coords[1,*]+cen3_pos2[1], thick=5, col=255
oplot, coords[0,*]+cen4[0], coords[1,*]+cen4[1], thick=5, col=255

pclose



trange=[t1_pos2_start, t1_pos2_end]
cen = cen1_pos2
en = [4.,10.]
m1 = foxsi_image_map( data_lvl2_d6, cen, erange=en, trange=trange, thr_n=4., /xycorr )
m1.id = 'FOXSI Det6 4-10 keV'

popen, xsi=7, ysi=7
loadct, 3
reverse_ct                                                            
plot_map, hsi, cen=[10,-100], fov=12, charsi=1.5, /nodate, charth=2, xth=5, yth=5, $
	dmin=0., col=255
xyouts, 140, 170, '50 sec', charsi=3, col=255
loadct, 7
reverse_ct
plot_map, m1, cen=[10,-100], fov=12, charsi=1.5, /nodate, charth=2, xth=5, yth=5, $
	;title='FOXSI Det6 19:14 39 sec', 
	col=255
xyouts, 140, 170, '39 sec', charsi=3, col=255
pclose

plot_map, aia2[10], cen=cen1_pos2, fov=16, /log
plot_map, m1, /over, thick=3

;
; Imspex, ARX
;

trange=[t5_start, t5_end]
cen = cen5

m1 = foxsi_image_map( data_lvl2_d6, cen, erange=[4.,6.], trange=trange, thr_n=4., /xycorr )
m2 = foxsi_image_map( data_lvl2_d6, cen, erange=[6.,8.], trange=trange, thr_n=4., /xycorr )
m3 = foxsi_image_map( data_lvl2_d6, cen, erange=[8.,11.], trange=trange, thr_n=4., /xycorr )

loadct, 1
reverse_ct
popen, xsi=5, ysi=7
ch=1.4
plot_map, m1, cen=[-100,100], fov=3, charsi=ch, xth=5, yth=5, xtit='', tit='D6 Target 5 4-6 keV', col=255
plot_map, m2, cen=[-100,100], fov=3, charsi=ch, xth=5, yth=5, xtit='', tit='D6 Target 5 6-8 keV', col=255
plot_map, m3, cen=[-100,100], fov=3, charsi=ch, xth=5, yth=5, xtit='', tit='D6 Target 5 8-11 keV', col=255
pclose

m1 = foxsi_image_map( data_lvl2_d6, cen, erange=[4.,6.], trange=trange, thr_n=4., /xycorr, smooth=3 )
m2 = foxsi_image_map( data_lvl2_d6, cen, erange=[6.,8.], trange=trange, thr_n=4., /xycorr, smooth=3 )
m3 = foxsi_image_map( data_lvl2_d6, cen, erange=[8.,11.], trange=trange, thr_n=4., /xycorr, smooth=3 )

m1=shift_map(m1,0,-5)
m2=shift_map(m2,0,-5)
m3=shift_map(m3,0,-5)

plot_map, m1, cen=[-100,100], fov=3

ratio = m1
ratio.data = m2.data / m1.data 
ratio.data[ where(m2.data lt 1.1) ] = 0.
ratio.data[ where(m1.data lt 1.1) ] = 0.
plot_map, ratio, /log, cen=[-100,100], fov=3, /cbar
plot_map, m1, /over

f=file_search('~/data/aia/20141211/*_0094*')
fits2map, f, aia2
plot_map, aia2[40], cen=[-90,80], fov=2, /log
plot_map, m1, /over
dmap = make_dmap(aia2[40], ref_map=aia2[10] )
plot_map, dmap, cen=[-90,80], fov=2, /log
plot_map, m1, /over

smap = make_submap( aia2, cen=[-90,80], fov=3)
dmap = make_dmap(smap[15:44], ref_map=smap[10] )
plot_map, dmap, cen=[-90,80], fov=2, /log
plot_map, m1, /over

ratio2 = m1
ratio2.data = m3.data / m2.data 
ratio2.data[ where(m3.data lt 0.3) ] = 0.
ratio2.data[ where(m2.data lt 1.) ] = 0.
plot_map, ratio2, /log, cen=[-100,100], fov=3, /cbar
plot_map, m1, /over

m1.id = 'FOXSI Det6'
smap.id = 'AIA 94A'
dmap.id = 'AIA 94A'

popen, xsi=5, ysi=5
loadct, 5
;plot_map, m1, charsi=1.3, charth=2, xth=5, yth=5, /nodata, cen=[-90,80], fov=2.5, col=255, /nodate
plot_map, m1, charsi=1.4, charth=2, xth=5, yth=5, cen=[-90,80], fov=2.5, dmax=-0.1, /nodate
hsi_linecolors
plot_map, m1, /over, thick=8, col=6, lev=[10,50,90], /per
plot_map, m2, /over, thick=8, col=7, lev=[30,70,90], /per
plot_map, m3, /over, thick=8, col=12, lev=[50,90], /per
xyouts, -160,140, '4-6 keV', col=6, charsi=1.6
xyouts, -160,125, '6-8 keV', col=7, charsi=1.6
xyouts, -160,110, '8-11 keV', col=12, charsi=1.6

loadct, 1
reverse_ct
plot_map, smap[40], charsi=1.4, charth=2, xth=5, yth=5, cen=[-90,80], fov=2.5, col=255, /nodate

loadct, 5
plot_map, ratio, charsi=1.4, charth=2, xth=5, yth=5, cen=[-90,80], fov=2.5, /nodate

loadct, 1
reverse_ct
plot_map, dmap[29], charsi=1.4, charth=2, xth=5, yth=5, cen=[-90,80], fov=2.5, col=255, dmin=-1, dmax=50 , /nodate
hsi_linecolors
plot_map, ratio, /over, thick=8, lev=[10,30], /per, col=255

pclose



;
; CdTe
;

@foxsi-setup-script-2014
trange=[t1_pos2_start, t1_pos2_end]
cen = cen1_pos2
m3 = foxsi_image_map( data_lvl2_d3, cen, trange=trange, thr_n=2.2, /cdte, er=[3.,100])
plot_map, m3, /cbar, /log


