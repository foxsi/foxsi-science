@foxsi-setup-script

map0.time = '02-Nov-2012 18:02:00'
map1.time = '02-Nov-2012 18:02:00'
map2.time = '02-Nov-2012 18:02:00'
map3.time = '02-Nov-2012 18:02:00'
map4.time = '02-Nov-2012 18:02:00'
map5.time = '02-Nov-2012 18:02:00'
map6.time = '02-Nov-2012 18:02:00'
map0.id = 'Det 0 raw data'
map1.id = 'Det 1 raw data'
map2.id = 'Det 2 raw data'
map3.id = 'Det 3 raw data'
map4.id = 'Det 4 raw data'
map5.id = 'Det 5 raw data'
map6.id = 'Det 6 raw data'

popen, xsi=8, ysi=4
!p.multi=[0,4,2]
plot_map, map0, cen=map_centroid(map0,thresh=0.3*max(map0.data)), fov=3, /nodate
plot_map, map1, cen=map_centroid(map2,thresh=0.3*max(map2.data)), fov=3, /nodate
plot_map, map2, cen=map_centroid(map2,thresh=0.3*max(map2.data)), fov=3, /nodate
plot_map, map3, cen=map_centroid(map3,thresh=0.3*max(map3.data)), fov=3, /nodate
plot_map, map4, cen=map_centroid(map4,thresh=0.3*max(map4.data)), fov=3, /nodate
plot_map, map5, cen=map_centroid(map5,thresh=0.3*max(map5.data)), fov=3, /nodate
plot_map, map6, cen=map_centroid(map6,thresh=0.3*max(map6.data)), fov=3, /nodate
pclose


; this selection isn't really necessary since foxsi_image_solar already makes this cut.
i0 = where( data_lvl2_d0.error_flag eq 0 )
i1 = where( data_lvl2_d1.error_flag eq 0 )
i2 = where( data_lvl2_d2.error_flag eq 0 )
i3 = where( data_lvl2_d3.error_flag eq 0 )
i4 = where( data_lvl2_d4.error_flag eq 0 )
i5 = where( data_lvl2_d5.error_flag eq 0 )
i6 = where( data_lvl2_d6.error_flag eq 0 )

pix=3.
er=[4,10]
tr = [t4_start, t6_end]

popen, 'test', xsi=8, ysi=8
!p.multi=[0,3,3]
.r
for i=0, 109 do begin
rot=i
img=foxsi_image_solar(data_lvl2_d0, 0, ps=pix, er=erange, tr=tr-t_launch, thr_n=4.,rot=rot);,/xy )
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix )
map.id=strtrim(i,2)
plot_map, map, /limb, cen=[1030,-310], fov=2
endfor
end
pclose

;plot_map, map, /limb, cen=flare, fov=2
plot_map, map, /limb, dmax=5, cen=cen3, fov=5

img=foxsi_image_solar(d6, 6, psize=50)

pix=3.
er=[4,15]
tr = [t4_start, t6_end]

img0=foxsi_image_solar( data_lvl2_d0, 0, ps=pix, er=er, tr=tr-t_launch, thr_n=4., /xy)
img1=foxsi_image_solar( data_lvl2_d1, 1, ps=pix, er=er, tr=tr-t_launch, thr_n=4., /xy)
img2=foxsi_image_solar( data_lvl2_d2, 2, ps=pix, er=er, tr=tr-t_launch, thr_n=4., /xy)
img3=foxsi_image_solar( data_lvl2_d3, 3, ps=pix, er=er, tr=tr-t_launch, thr_n=4., /xy)
img4=foxsi_image_solar( data_lvl2_d4, 4, ps=pix, er=er, tr=tr-t_launch, thr_n=4., /xy)
img5=foxsi_image_solar( data_lvl2_d5, 5, ps=pix, er=er, tr=tr-t_launch, thr_n=4., /xy)
img6=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=er, tr=tr-t_launch, thr_n=4., /xy)
img =foxsi_image_solar_int( data_lvl2_d0, data_lvl2_d1, data_lvl2_d2, $
		data_lvl2_d3, data_lvl2_d4, data_lvl2_d5, data_lvl2_d6, $
		psize=pix, erange=er, trange=tr-t_launch, thr_n=4.);, /xycor )

map0 = make_map( img0, xcen=0., ycen=0., dx=pix, dy=pix, id='D0',time=anytim( anytim(t0)+tr[0], /yo))
map1 = make_map( img1, xcen=0., ycen=0., dx=pix, dy=pix, id='D1',time=anytim( anytim(t0)+tr[0], /yo))
map2 = make_map( img2, xcen=0., ycen=0., dx=pix, dy=pix, id='D2',time=anytim( anytim(t0)+tr[0], /yo))
map3 = make_map( img3, xcen=0., ycen=0., dx=pix, dy=pix, id='D3',time=anytim( anytim(t0)+tr[0], /yo))
map4 = make_map( img4, xcen=0., ycen=0., dx=pix, dy=pix, id='D4',time=anytim( anytim(t0)+tr[0], /yo))
map5 = make_map( img5, xcen=0., ycen=0., dx=pix, dy=pix, id='D5',time=anytim( anytim(t0)+tr[0], /yo))
map6 = make_map( img6, xcen=0., ycen=0., dx=pix, dy=pix, id='D6',time=anytim( anytim(t0)+tr[0], /yo))
map  = make_map( img,  xcen=0., ycen=0., dx=pix, dy=pix, id='5dets',time=anytim( anytim(t0)+tr[0], /yo))

plot_map, map, /limb, cen=cen1, fov=20, /cbar

plot_map, map6, /limb, cen=[1025,-300], /cbar, fov=3

;
; Flare centroids by detector (with no coregistration)
;

flarecen = [1025,-310]	; approx
plot_map, map0, /limb, cen=flarecen, fov=2

IDL> print, map_centroid( map0, thr=0.1*max(map0.data))                    
      1018.40     -329.255
IDL> print, map_centroid( map1, thr=0.1*max(map1.data))
      1046.76     -335.004
IDL> print, map_centroid( map2, thr=0.1*max(map2.data))
      1064.08     -336.065
IDL> print, map_centroid( map3, thr=0.1*max(map3.data))
      1050.04     -288.905
IDL> print, map_centroid( map4, thr=0.1*max(map4.data))
      1011.97     -296.289
IDL> print, map_centroid( map5, thr=0.1*max(map5.data))
      1015.68     -325.529
IDL> print, map_centroid( map6, thr=0.1*max(map6.data))
      1028.67     -310.445

xy = fltarr(2,7)
xy[*,0] = [1018.4, -329.3]
xy[*,1] = [1046.8, -335.0]
xy[*,2] = [1064.1, -336.1]
xy[*,3] = [1050.0, -288.9]
xy[*,4] = [1012.0, -296.3]
xy[*,5] = [1015.7, -325.5]
xy[*,6] = [1028.7, -310.4]

; Source angle, with origin at target center and angles measured from solar west.
phi = 180./!pi*atan( (xy[1,*] - cen4[1]) / (xy[0,*] - cen4[0]) )
phi_hsi = 180./!pi*atan( (float(flare[1])-cen4[1]) / (float(flare[0])-cen4[0]) )

dphi = phi - phi_hsi

rot0 = rot_map( map0, dphi[0] )
rot1 = rot_map( map1, dphi[1] )
rot2 = rot_map( map2, dphi[2] )
rot3 = rot_map( map3, dphi[3] )
rot4 = rot_map( map4, dphi[4] )
rot5 = rot_map( map5, dphi[5] )
rot6 = rot_map( map6, dphi[6] )

dxy = xy
dxy[0,*] = xy[0,*] - flare[0]
dxy[1,*] = xy[1,*] - flare[1]

;
; Look at flare "track" during offpointing
;

@linz/foxsi-setup-script

d0 = data_lvl2_d0
d1 = data_lvl2_d1
d2 = data_lvl2_d2
d3 = data_lvl2_d3
d4 = data_lvl2_d4
d5 = data_lvl2_d5
d6 = data_lvl2_d6

j4=where( (d4.wsmr_time gt t4_end and d4.wsmr_time lt t5_start) or 	$
		  (d4.wsmr_time gt t5_end and d4.wsmr_time lt t6_start) and	$
		  (d4.error_flag eq 0 and d4.hit_energy[0] gt 4.), n4)
j5=where( (d5.wsmr_time gt t4_end and d5.wsmr_time lt t5_start) or 	$
		  (d5.wsmr_time gt t5_end and d5.wsmr_time lt t6_start) and	$
		  (d5.error_flag eq 0 and d5.hit_energy[0] gt 4.), n4)
j6=where( (d6.wsmr_time gt t4_end and d6.wsmr_time lt t5_start) or	$
		  (d6.wsmr_time gt t5_end and d6.wsmr_time lt t6_start) and	$
		  (d6.error_flag eq 0 and d6.hit_energy[0] gt 4.), n4)

j4=where(d4.wsmr_time gt 64918 and d4.wsmr_time lt 64942 and d4.error_flag eq 0 and d4.hit_energy[0] gt 4., n4)
j5=where(d5.wsmr_time gt 64918 and d5.wsmr_time lt 64942 and d5.error_flag eq 0 and d5.hit_energy[0] gt 4., n5)
j6=where(d6.wsmr_time gt 64918 and d6.wsmr_time lt 64942 and d6.error_flag eq 0 and d6.hit_energy[0] gt 4., n6)

j4=j4[0:70]

loadct,5
hsi_linecolors

plot, d4[j4].pitch - d4[j4[n4-1]].pitch, -d4[j4].yaw + d4[j4[n4-1]].yaw, /psy, xr=[-200,200], yr=[-200,200]
oplot, d0[j0[n0-1]].hit_xy_pay[0]-d0[j0].hit_xy_pay[0], d0[j0[n0-1]].hit_xy_pay[1]-d0[j0].hit_xy_pay[1], /psy, col=6
oplot, d1[j1[n1-1]].hit_xy_pay[0]-d1[j1].hit_xy_pay[0], d1[j1[n1-1]].hit_xy_pay[1]-d1[j1].hit_xy_pay[1], /psy, col=7
oplot, d2[j2[n2-1]].hit_xy_pay[0]-d2[j2].hit_xy_pay[0], d2[j2[n2-1]].hit_xy_pay[1]-d2[j2].hit_xy_pay[1], /psy, col=8
oplot, d3[j3[n3-1]].hit_xy_pay[0]-d3[j3].hit_xy_pay[0], d3[j3[n3-1]].hit_xy_pay[1]-d3[j3].hit_xy_pay[1], /psy, col=9
oplot, d4[j4[n4-1]].hit_xy_pay[0]-d4[j4].hit_xy_pay[0], d4[j4[n4-1]].hit_xy_pay[1]-d4[j4].hit_xy_pay[1], /psy, col=10
oplot, d5[j5[n5-1]].hit_xy_pay[0]-d5[j5].hit_xy_pay[0], d5[j5[n5-1]].hit_xy_pay[1]-d5[j5].hit_xy_pay[1], /psy, col=12
oplot, d6[j6[n6-1]].hit_xy_pay[0]-d6[j6].hit_xy_pay[0], d6[j6[n6-1]].hit_xy_pay[1]-d6[j6].hit_xy_pay[1], /psy, col=2

; Get SPARCS center coords for the hits on each detector.
;xLISS0 = d0[j0].pitch
;xLISS1 = d1[j1].pitch
;xLISS2 = d2[j2].pitch
;xLISS3 = d3[j3].pitch
xLISS4 = d4[j4].pitch
xLISS5 = d5[j5].pitch
xLISS6 = d6[j6].pitch
;yLISS0 = -d0[j0].yaw
;yLISS1 = -d1[j1].yaw
;yLISS2 = -d2[j2].yaw
;yLISS3 = -d3[j3].yaw
yLISS4 = -d4[j4].yaw
yLISS5 = -d5[j5].yaw
yLISS6 = -d6[j6].yaw

; Get raw (uncorrected) flare hit position for each detector.
;x0a = d0[j0].hit_xy_pay[0]
;x1a = d1[j1].hit_xy_pay[0]
;x2a = d2[j2].hit_xy_pay[0]
;x3a = d3[j3].hit_xy_pay[0]
x4a  = d4[j4].hit_xy_pay[0]
x5a  = d5[j5].hit_xy_pay[0]
x6a  = d6[j6].hit_xy_pay[0]
;y0a = d0[j0].hit_xy_pay[1]
;y1a = d1[j1].hit_xy_pay[1]
;y2a = d2[j2].hit_xy_pay[1]
;y3a = d3[j3].hit_xy_pay[1]
y4a  = d4[j4].hit_xy_pay[1]
y5a  = d5[j5].hit_xy_pay[1]
y6a  = d6[j6].hit_xy_pay[1]

; Throw out any funky values.
;;x0 = x0a[ where( x0a gt -100 and x0a lt 200 and y0a gt -150 and y0a lt 0 ) ]
;;x1 = x1a[ where( x1a gt 150 and x1a lt 400 and y1a gt 300 and y1a lt 450 ) ]
;;x2 = x2a[ where( x2a gt 150 and x2a lt 400 and y2a gt 300 and y2a lt 450 ) ]
;;x3 = x3a[ where( x3a gt 150 and x3a lt 400 and y3a gt 300 and y3a lt 450 ) ]
;x4 = x4a[ where( x4a gt -100 and x4a lt 100 and y4a gt -100 and y4a lt 350 ) ]
;x5 = x5a[ where( x5a gt -50 and x5a lt 100 and y5a gt -100 and y5a lt 100 ) ]
;x6 = x6a[ where( x6a gt -50 and x6a lt 100 and y6a gt -100 and y6a lt 100 ) ]
;;y0 = y0a[ where( x0a gt -100 and x0a lt 200 and y0a gt -150 and y0a lt 0 ) ]
;;y1 = y1a[ where( x1a gt 150 and x1a lt 400 and y1a gt 300 and y1a lt 450 ) ]
;;y2 = y2a[ where( x2a gt 150 and x2a lt 400 and y2a gt 300 and y2a lt 450 ) ]
;;y3 = y3a[ where( x3a gt 150 and x3a lt 400 and y3a gt 300 and y3a lt 450 ) ]
;y4 = y4a[ where( x4a gt -100 and x4a lt 100 and y4a gt -100 and y4a lt 350 ) ]
;y5 = y5a[ where( x5a gt -50 and x5a lt 100 and y5a gt -100 and y5a lt 100 ) ]
;y6 = y6a[ where( x6a gt -50 and x6a lt 100 and y6a gt -100 and y6a lt 100 ) ]

x4 = x4a
x5 = x5a
x6 = x6a
y4 = y4a
y5 = y5a
y6 = y6a

; Get median of early points to use as a flare position.
xmedLISS4 = median( xLISS4[0:9] )
xmedLISS5 = median( xLISS4[0:9] )
xmedLISS6 = median( xLISS4[0:9] )
ymedLISS4 = median( yLISS4[0:9] )
ymedLISS5 = median( yLISS5[0:9] )
ymedLISS6 = median( yLISS6[0:9] )
xmed4 = median( x4a[0:9] )
xmed5 = median( x5a[0:9] )
xmed6 = median( x6a[0:9] )
ymed4 = median( y4a[0:9] )
ymed5 = median( y5a[0:9] )
ymed6 = median( y6a[0:9] )

;xliss4 = xliss4[ where( x4a gt -100 and x4a lt 100 and y4a gt -100 and y4a lt 350 ) ]
;xliss5 = xliss5[ where( x5a gt -50 and x5a lt 100 and y5a gt -100 and y5a lt 100 ) ]
;xliss6 = xliss6[ where( x6a gt -50 and x6a lt 100 and y6a gt -100 and y6a lt 100 ) ]
;yliss4 = yliss4[ where( x4a gt -100 and x4a lt 100 and y4a gt -100 and y4a lt 350 ) ]
;yliss5 = yliss5[ where( x5a gt -50 and x5a lt 100 and y5a gt -100 and y5a lt 100 ) ]
;yliss6 = yliss6[ where( x6a gt -50 and x6a lt 100 and y6a gt -100 and y6a lt 100 ) ]

; Fit a straight line to the data.
fit_liss4 = poly_fit( xliss4-xmedliss4, yliss4-ymedliss4, 1, yfit=yfitLISS4 )
fit_liss5 = poly_fit( xliss5-xmedliss5, yliss5-ymedliss5, 1, yfit=yfitLISS5 )
fit_liss6 = poly_fit( xliss6-xmedliss6, yliss6-ymedliss6, 1, yfit=yfitLISS6 )
fit4 = poly_fit( x4-xmed4, y4-xmed4, 1, yfit=yfit4 )
fit5 = poly_fit( x5-xmed5, y5-xmed5, 1, yfit=yfit5 )
fit6 = poly_fit( x6-xmed6, y6-xmed6, 1, yfit=yfit6 )

theta4 = atan( (fit4)[1] )*180/!pi - atan( (fit_liss4)[1] )*180/!pi
theta5 = atan( (fit5)[1] )*180/!pi - atan( (fit_liss5)[1] )*180/!pi
theta6 = atan( (fit6)[1] )*180/!pi - atan( (fit_liss6)[1] )*180/!pi

; plot results
!p.multi=[0,2,2]
ch=1.5

plot,  xLISS4-xmedliss4, yLISS4-ymedliss4, /psy, tit='D4', chars=ch, xr=minmax([xliss4-xmedliss4,x4-xmed4]), yr=minmax([yliss4-ymedliss4,y4-ymed4])
oplot, xLISS4-xmedLISS4, yfitLISS4
oplot, x4-xmed4, y4-ymed4, /psy, col=2
oplot, x4-xmed4, yfit4, col=2
legend, strtrim( theta4 ), /bot, /left

plot,  xLISS5-xmedliss5, yLISS5-ymedliss5, /psy, tit='D5', chars=ch, xr=minmax([xliss5-xmedliss5,x5-xmed5]), yr=minmax([yliss5-ymedliss5,y5-ymed5])
oplot, xLISS5-xmedliss5, yfitLISS5
oplot, x5-xmed5, y5-ymed5, /psy, col=2
oplot, x5-xmed5, yfit5, col=2
legend, strtrim( theta5 ), /bot, /left

plot,  xLISS6-xmedliss6, yLISS6-xmedliss6, /psy, tit='D6', chars=ch, xr=minmax([xliss6-xmedliss6,x6-xmed6]), yr=minmax([yliss6-ymedliss6,y6-ymed6])
oplot, xLISS6-xmedliss6, yfitLISS6
oplot, x6-xmed6, y6-xmed6, /psy, col=2
oplot, x6-xmed6, yfit6, col=2
legend, strtrim( theta6 ), /bot, /left





data_struct = data_lvl2_d4
data_struct.hit_xy_solar[0] = data_struct.hit_xy_pay[0]
data_struct.hit_xy_solar[1] =  data_struct.hit_xy_pay[1]
pix=3.
er=[4,15]
tr = [t5_end, t6_start]
img=foxsi_image_solar( data_struct, 4, ps=pix, er=er, tr=tr-t_launch, thr_n=4.)
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, id='D6',time=anytim( anytim(t0)+tr[0], /yo))
plot_map, map, cen=[300,300], fov=10, /log
draw_fov, det=4

i=where(data_struct.wsmr_time gt t4_end and data_struct.wsmr_time lt t5_start and $
	data_struct.error_flag eq 0 and data_struct.hit_energy[0] gt 4.)
j=where(data_struct.wsmr_time gt t5_end and data_struct.wsmr_time lt t6_start and $
	data_struct.error_flag eq 0 and data_struct.hit_energy[0] gt 4.)
k=where(data_struct.wsmr_time gt t5_start and data_struct.wsmr_time lt t5_end)

plot,  data_struct[i].pitch, -data_struct[i].yaw, xr=[600,1000], yr=[-1000,600], /psy
oplot, data_struct[j].pitch, -data_struct[j].yaw, /psy
oplot, data_struct[k].pitch, -data_struct[k].yaw, /psy

plot,  data_struct[i].hit_xy_pay[0], data_struct[i].hit_xy_pay[1], /psy
;oplot, data_struct[j].hit_xy_pay[0], data_struct[j].hit_xy_pay[1], /psy, col=200

data_struct=d0
j=j0
plot, data_struct[j].hit_xy_pay[0], data_struct[j].hit_xy_pay[1], /nodata
for m=0, n_elements(j)-1 do oplot, [data_struct[j[m]].hit_xy_pay[0]], [data_struct[j[m]].hit_xy_pay[1]], psy=4, col=30+10*m, symsize=2, thick=5

plot, data_struct[j].pitch, -data_struct[j].yaw.yaw, /psy, xr=[-200,200], yr=[-200,200]
oplot, data_struct[j[28]].hit_xy_pay[0]-data_struct[j].hit_xy_pay[0], data_struct[j[28]].hit_xy_pay[1]-data_struct[j].hit_xy_pay[1], /psy, col=200

;
; Look at first target
;

get_target_data, 4, d0,d1,d2,d3,d4,d5,d6

pix=10.
er=[4,15]
tr = [t1_start, t6_end]

img0=foxsi_image_solar( d0, 0, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img1=foxsi_image_solar( d1, 1, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img2=foxsi_image_solar( d2, 2, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img3=foxsi_image_solar( d3, 3, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img4=foxsi_image_solar( d4, 4, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img5=foxsi_image_solar( d5, 5, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img6=foxsi_image_solar( d6, 6, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img =foxsi_image_solar_int( d0,d1,d2,d3,d4,d5,d6, $
		psize=pix, erange=er, trange=tr-t_launch, thr_n=4.);, /xycor )

map0 = make_map( img0, xcen=0., ycen=0., dx=pix, dy=pix, id='D0',time=anytim( anytim(t0)+tr[0], /yo))
map1 = make_map( img1, xcen=0., ycen=0., dx=pix, dy=pix, id='D1',time=anytim( anytim(t0)+tr[0], /yo))
map2 = make_map( img2, xcen=0., ycen=0., dx=pix, dy=pix, id='D2',time=anytim( anytim(t0)+tr[0], /yo))
map3 = make_map( img3, xcen=0., ycen=0., dx=pix, dy=pix, id='D3',time=anytim( anytim(t0)+tr[0], /yo))
map4 = make_map( img4, xcen=0., ycen=0., dx=pix, dy=pix, id='D4',time=anytim( anytim(t0)+tr[0], /yo))
map5 = make_map( img5, xcen=0., ycen=0., dx=pix, dy=pix, id='D5',time=anytim( anytim(t0)+tr[0], /yo))
map6 = make_map( img6, xcen=0., ycen=0., dx=pix, dy=pix, id='D6',time=anytim( anytim(t0)+tr[0], /yo))
map  = make_map( img,  xcen=0., ycen=0., dx=pix, dy=pix, id='5dets',time=anytim( anytim(t0)+tr[0], /yo))

plot_map, map, cen=cen1, fov=20, /limb

plot_map, aia_maps[0], cen=cen1, fov=20, /limb
plot_map, map, /over

shift = [-200, -45]
plot_map, aia_maps[0], cen=[-300,-200], fov=7, /limb, /log
;plot_map, aia_maps[9], cen=[cen1[0]+180,cen1[1]-50], fov=7, /limb, /log
plot_map, shift_map(map, shift[0], shift[1]), /over




loadct, 4
TVLCT, r, g, b, /Get
r[0]=255
g[0]=255
b[0]=255

pix=7.7
erange=[4,15]
cen=cen4
tr = [t4_start, t4_end]
ind = [1,0,1,0,1,1,1]
img=foxsi_image_solar_int( data_lvl2_d0[i0], data_lvl2_d1[i1], data_lvl2_d2[i2], $
		data_lvl2_d3[i3], data_lvl2_d4[i4], data_lvl2_d5[i5], data_lvl2_d6[i6], $
		psize=pix, erange=erange, trange=tr, index=ind, /xycor, thr_n=4., /nowin )
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, id='', $
	time=anytim( anytim(t0)+tr[0], /yo) )
;popen, 'plots/target1-pix80', xsize=7, ysize=7
;plot_map, map, /limb, /cbar, cen=[900,250], fov=25, color=1, $
;	lcolor=200, lthick=6, charsize=1.2, charthick=2
;pclose
;plot_map, map, /limb, /cbar, cen=cen, fov=25
plot_map, map, /limb, /cbar, cen=cen, fov=5


loadct, 1
TVLCT, r, g, b, /get
;r[254:255]=[255,0]
;g[254:255]=[0,0]
;b[254:255]=[255,0]
TVLCT, reverse(r), reverse(g), reverse(b)
pix=100.
erange=[4,10]
tr = [t2_start, t2_end]
ind = [1,0,1,0,1,1,1]
img=foxsi_image_solar_int( data_lvl2_d0[i0], data_lvl2_d1[i1], data_lvl2_d2[i2], $
		data_lvl2_d3[i3], data_lvl2_d4[i4], data_lvl2_d5[i5], data_lvl2_d6[i6], $
		psize=pix, erange=erange, trange=tr, index=ind, /xycor, thr_n=4., /nowin )
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, id='FOXSI', $
	time=anytim( anytim(t0)+tr[0], /yo) )
popen, 'plots/target1-pix100', xsize=7, ysize=7
plot_map, map, /limb, /cbar, cen=[-900,250], fov=25, color=255, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, top=200, thick=3
xyouts, -1600, 900, '90 sec integration', color=255, size=1.2
xyouts, -1600, 800, '4-10 keV', color=255, size=1.2
pclose

;plot_map, map, /limb, /cbar, lthick=2,cen=[960,-200],fov=2
plot_map, map, /limb, /cbar, cen=[-900,250], fov=25

c=map_centroid(map, thresh=10)
oplot, [c[0]], [c[1]], /psy, symsize=5, color=255

plot_map, map, /limb, /cbar, fov=50, lthick=2

plot_map, map, /limb, /cbar, center=[960,-210], fov=2
plot_map, map, /over, levels=[50,95], /per;, color=1
plot_map, map, /limb, /cbar, center=[0,0], fov=50, /log, lcolor=0


cgdisplay, 800,800  
plot_map, map, /limb, dmax=5, xr=xr, yr=yr, charsize=2, charthick=2, /cbar, $
	lcolor=176, lthick=3, color=1, fov=50
xyouts, 400, 1300, 'FOXSI Target 1', color=1, charthick=3, size=2
xyouts, 400, 1100, '90 seconds', color=1, charthick=3, size=2
xyouts, -1300, 1300, 'D0, D2, D4, D5, D6', color=1, charthick=3, size=2
xyouts, -1300, 1100, '15-90 keV', color=1, charthick=3, size=2


;
; Plot flare centroid positions with and without Ishikawa's correction.
;

pix=80.
erange=[4,15]
tr = [t2_start, t2_end]

img0=foxsi_image_solar(data_lvl2_d0[i0],0,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img1=foxsi_image_solar(data_lvl2_d1[i1],1,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img2=foxsi_image_solar(data_lvl2_d2[i2],2,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img3=foxsi_image_solar(data_lvl2_d3[i3],3,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img4=foxsi_image_solar(data_lvl2_d4[i4],4,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img5=foxsi_image_solar(data_lvl2_d5[i5],5,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img6=foxsi_image_solar(data_lvl2_d6[i6],6,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img=foxsi_image_solar_int( data_lvl2_d0[i0], data_lvl2_d1[i1], data_lvl2_d2[i2], $
		data_lvl2_d3[i3], data_lvl2_d4[i4], data_lvl2_d5[i5], data_lvl2_d6[i6], $
		psize=pix, erange=erange, trange=tr, index=ind, thr_n=4., /nowin, /xycor )

map0 = make_map( img0, xcen=0., ycen=0., dx=pix, dy=pix, id='D0',time=anytim( anytim(t0)+tr[0], /yo))
map1 = make_map( img1, xcen=0., ycen=0., dx=pix, dy=pix, id='D1',time=anytim( anytim(t0)+tr[0], /yo))
map2 = make_map( img2, xcen=0., ycen=0., dx=pix, dy=pix, id='D2',time=anytim( anytim(t0)+tr[0], /yo))
map3 = make_map( img3, xcen=0., ycen=0., dx=pix, dy=pix, id='D3',time=anytim( anytim(t0)+tr[0], /yo))
map4 = make_map( img4, xcen=0., ycen=0., dx=pix, dy=pix, id='D4',time=anytim( anytim(t0)+tr[0], /yo))
map5 = make_map( img5, xcen=0., ycen=0., dx=pix, dy=pix, id='D5',time=anytim( anytim(t0)+tr[0], /yo))
map6 = make_map( img6, xcen=0., ycen=0., dx=pix, dy=pix, id='D6',time=anytim( anytim(t0)+tr[0], /yo))
map  = make_map( img,  xcen=0., ycen=0., dx=pix, dy=pix, id='5dets',time=anytim( anytim(t0)+tr[0], /yo))

;!p.multi=[0,2,4]
loadct, 1	; before it was 5
TVLCT, r, g, b, /get
TVLCT, reverse(r), reverse(g), reverse(b)
mx=5
cen=cen2
targ=2
;popen, xsi=5, ysi=10
plot_map, map0, /limb, /cbar, cen=cen, fov=22, color=255, dmax=mx, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=0, target=targ, col=255
plot_map, map1, /limb, /cbar, cen=cen, fov=22, color=255, dmax=mx, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=1, target=targ, col=255
plot_map, map2, /limb, /cbar, cen=cen, fov=22, color=255, dmax=mx, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=2, target=targ, col=255
plot_map, map3, /limb, /cbar, cen=cen, fov=22, color=255, dmax=mx, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=3, target=targ, col=255
plot_map, map4, /limb, /cbar, cen=cen, fov=22, color=255, dmax=mx, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=4, target=targ, col=255
plot_map, map5, /limb, /cbar, cen=cen, fov=22, color=255, dmax=mx, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=5, target=targ, col=255
plot_map, map6, /limb, /cbar, cen=cen, fov=22, color=255, dmax=mx, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=6, target=targ, col=255
popen, xsi=5, ysi=5
plot_map, map, /limb, /cbar, cen=cen, fov=30, color=255, dmax=10, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3, $
	title = '2-Nov-2012 17:57:35 -- 17:59:04'
xyouts, -1600, -600, '4-15 keV', size=1.2, color=255
draw_fov, /all, target=targ, col=255, /xycor
pclose

plot_map, aia_maps[0], /log, fov=50, /limb, charthick=2, thick=2
draw_fov, det=4, targ=1, thick=2
draw_fov, det=4, targ=2, thick=2
draw_fov, det=4, targ=3, thick=2
draw_fov, det=4, targ=4, thick=2
xyouts, -950, -750, '0', size=2
xyouts, -1300, -200, '1', size=2
xyouts, 975, 675, '2', size=2
xyouts, 1000, -1000, '3', size=2
hsi_linecolors
oplot, [965],[-200], psym=1, symsize=5, thick=5, color=12

mapRaw = [map0, map1, map2, map3, map4, map5, map6]
centroidRaw = fltarr(2,7)
for i=0, 6 do centroidRaw[*,i] = map_centroid( mapRaw[i], thresh=10 )

popen, xsi=5, ysi=10
!p.multi=[0,2,4]
loadct, 1
TVLCT, r, g, b, /get
r[254:255]=[255,0]
g[254:255]=[0,0]
b[254:255]=[255,0]
TVLCT, reverse(r), reverse(g), reverse(b)
plot_map, map0, cen=[1000,-300], fov=5, bot=2, tit='Det 0, Target 3, No coalign'
oplot, [centr0[0]], [centr0[1]], /psy, symsize=3, thick=4, color=1
xyouts,875,-425,'Centroid: '+ string(fix(centr0[0]))+ string(fix(centr0[1])) +' arcsec',$
	size=0.7
plot_map, map1, cen=[1000,-300], fov=5, bot=2, tit='Det 1, Target 3, No coalign'
oplot, [centr1[0]], [centr1[1]], /psy, symsize=3, thick=4, color=1
xyouts,875,-425,'Centroid: '+ string(fix(centr1[0]))+ string(fix(centr1[1])) +' arcsec',$
	size=0.7
plot_map, map2, cen=[1000,-300], fov=5, bot=2, tit='Det 2, Target 3, No coalign'
oplot, [centr2[0]], [centr2[1]], /psy, symsize=3, thick=4, color=1
xyouts,875,-425,'Centroid: '+ string(fix(centr2[0]))+ string(fix(centr2[1])) +' arcsec',$
	size=0.7
plot_map, map3, cen=[1000,-300], fov=5, bot=2, tit='Det 3, Target 3, No coalign'
oplot, [centr3[0]], [centr3[1]], /psy, symsize=3, thick=4, color=1
xyouts,875,-425,'Centroid: '+ string(fix(centr3[0]))+ string(fix(centr3[1])) +' arcsec',$
	size=0.7
plot_map, map4, cen=[1000,-300], fov=5, bot=2, tit='Det 4, Target 3, No coalign'
oplot, [centr4[0]], [centr4[1]], /psy, symsize=3, thick=4, color=1
xyouts,875,-425,'Centroid: '+ string(fix(centr4[0]))+ string(fix(centr4[1])) +' arcsec',$
	size=0.7
plot_map, map5, cen=[1000,-300], fov=5, bot=2, tit='Det 5, Target 3, No coalign'
oplot, [centr5[0]], [centr5[1]], /psy, symsize=3, thick=4, color=1
xyouts,875,-425,'Centroid: '+ string(fix(centr5[0]))+ string(fix(centr5[1])) +' arcsec',$
	size=0.7
plot_map, map6, cen=[1000,-300], fov=5, bot=2, tit='Det 6, Target 3, No coalign'
oplot, [centr6[0]], [centr6[1]], /psy, symsize=3, thick=4, color=1
xyouts,875,-425,'Centroid: '+ string(fix(centr6[0]))+ string(fix(centr6[1])) +' arcsec',$
	size=0.7
pclose

img0corr=foxsi_image_solar(data_lvl2_d0[i0],0,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img1corr=foxsi_image_solar(data_lvl2_d1[i1],1,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img2corr=foxsi_image_solar(data_lvl2_d2[i2],2,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img3corr=foxsi_image_solar(data_lvl2_d3[i3],3,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img4corr=foxsi_image_solar(data_lvl2_d4[i4],4,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img5corr=foxsi_image_solar(data_lvl2_d5[i5],5,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img6corr=foxsi_image_solar(data_lvl2_d6[i6],6,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)

map0corr = make_map( img0corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D0 target3 w/alignment')
map1corr = make_map( img1corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D1 target3 w/alignment')
map2corr = make_map( img2corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D2 target3 w/alignment')
map3corr = make_map( img3corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D3 target3 w/alignment')
map4corr = make_map( img4corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D4 target3 w/alignment')
map5corr = make_map( img5corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D5 target3 w/alignment')
map6corr = make_map( img6corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D6 target3 w/alignment')

mapCorr = [map0corr, map1corr, map2corr, map3corr, map4corr, map5corr, map6corr]
centroidCorr = fltarr(2,7)
for i=0, 6 do centroidCorr[*,i] = map_centroid( mapCorr[i], thresh=10 )

popen, xsi=5, ysi=10
!p.multi=[0,2,4]
loadct, 1
TVLCT, r, g, b, /get
r[254:255]=[255,0]
g[254:255]=[0,0]
b[254:255]=[255,0]
TVLCT, reverse(r), reverse(g), reverse(b)
cen=[975,-175]
cen=[1000,-300]
plot_map, map0corr, cen=cen, fov=5, bot=2, tit='Det 0, Target 3, Ishikawa coalign'
oplot, [centr0corr[0]], [centr0corr[1]], /psy, symsize=3, thick=4, color=1
xyouts,850,-300,'Centroid: '+ string(fix(centr0corr[0]))+ string(fix(centr0corr[1])) +' arcsec',$
	size=0.7
plot_map, map1corr, cen=cen, fov=5, bot=2, tit='Det 1, Target 3, Ishikawa coalign'
oplot, [centr1corr[0]], [centr1corr[1]], /psy, symsize=3, thick=4, color=1
xyouts,850,-300,'Centroid: '+ string(fix(centr1corr[0]))+ string(fix(centr1corr[1])) +' arcsec',$
	size=0.7
plot_map, map2corr, cen=cen, fov=5, bot=2, tit='Det 2, Target 3, Ishikawa coalign'
oplot, [centr2corr[0]], [centr2corr[1]], /psy, symsize=3, thick=4, color=1
xyouts,850,-300,'Centroid: '+ string(fix(centr2corr[0]))+ string(fix(centr2corr[1])) +' arcsec',$
	size=0.7
plot_map, map3corr, cen=cen, fov=5, bot=2, tit='Det 3, Target 3, Ishikawa coalign'
oplot, [centr3corr[0]], [centr3corr[1]], /psy, symsize=3, thick=4, color=1
xyouts,850,-300,'Centroid: '+ string(fix(centr3corr[0]))+ string(fix(centr3corr[1])) +' arcsec',$
	size=0.7
plot_map, map4corr, cen=cen, fov=5, bot=2, tit='Det 4, Target 3, Ishikawa coalign'
oplot, [centr4corr[0]], [centr4corr[1]], /psy, symsize=3, thick=4, color=1
xyouts,850,-300,'Centroid: '+ string(fix(centr4corr[0]))+ string(fix(centr4corr[1])) +' arcsec',$
	size=0.7
plot_map, map5corr, cen=cen, fov=5, bot=2, tit='Det 5, Target 3, Ishikawa coalign'
oplot, [centr5corr[0]], [centr5corr[1]], /psy, symsize=3, thick=4, color=1
xyouts,850,-300,'Centroid: '+ string(fix(centr5corr[0]))+ string(fix(centr5corr[1])) +' arcsec',$
	size=0.7
plot_map, map6corr, cen=cen, fov=5, bot=2, tit='Det 6, Target 3, Ishikawa coalign'
oplot, [centr6corr[0]], [centr6corr[1]], /psy, symsize=3, thick=4, color=1
xyouts,850,-300,'Centroid: '+ string(fix(centr6corr[0]))+ string(fix(centr6corr[1])) +' arcsec',$
	size=0.7
pclose

;
; Fix the roll!  Start from the uncorrected images.
; Fix it all to D6.
;

rhessi_cen = [963.3,-203.5]

for i=0, 6 do centroidRaw[*,i] = map_centroid( mapRaw[i], thresh=8 )  
cenFOV = [700,-600]
theta = fltarr(7)
for i=0, 6 do $
	theta[i] = atan( (centroidRaw[1,i]-cenFOV[1])/(centroidRaw[0,i]-cenFOV[0]) ) $
			 - atan( (centroidRaw[1,6]-cenFOV[1])/(centroidRaw[0,6]-cenFOV[0]) )
print,theta

for i=0, 6 do mapCorr[i] = rot_map( mapRaw[i], 180/!pi*theta[i], cen=cenFOV )
for i=0, 6 do centroidCorr[*,i] = map_centroid( mapCorr[i], thresh=8 )  
plot, centroidRaw[0,*], centroidRaw[1,*], psym=1,color=2,xr=[900,1200],yr=[-400,-200]
oplot, centroidCorr[0,*], centroidCorr[1,*], psym=1, color=1

;
; Next correction: translate to RHESSI position
;

offsetXY = fltarr(2,7)
for i=0, 6 do offsetXY[*,i] = rhessi_cen - centroidCorr[*,i]
plot, centroidRaw[0,*], centroidRaw[1,*], psym=1,color=2,xr=[800,1200],yr=[-400,-100]
oplot, centroidCorr[0,*], centroidCorr[1,*], psym=1, color=1
oplot, centroidCorr[0,*]+offsetXY[0,*], centroidCorr[1,*]+offsetXY[1,*], psym=1, color=64

;
; Now we have the corrections; apply them to an image.
;

pix=40.
erange=[4,15]
tr = [t1_start, t1_end]
;cenFOV = [-850,150]
;ind = [1,0,1,0,1,1,1]
img=foxsi_image_solar(data_lvl2_d0[i0], 0, psize=pix, eran=erange, tran=tr, thr=4.)
map0 = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, id='')
img=foxsi_image_solar(data_lvl2_d2[i2], 2, psize=pix, eran=erange, tran=tr, thr=4.)
map2 = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, id='')
img=foxsi_image_solar(data_lvl2_d4[i4], 4, psize=pix, eran=erange, tran=tr, thr=4.)
map4 = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, id='')
img=foxsi_image_solar(data_lvl2_d5[i5], 5, psize=pix, eran=erange, tran=tr, thr=4.)
map5 = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, id='')
img=foxsi_image_solar(data_lvl2_d6[i6], 6, psize=pix, eran=erange, tran=tr, thr=4.)
map6 = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, id='')
;map0 = rot_map( map0, theta[0]*180/!pi, cen=cenFOV )
;map2 = rot_map( map2, theta[2]*180/!pi, cen=cenFOV )
;map4 = rot_map( map4, theta[4]*180/!pi, cen=cenFOV )
;map5 = rot_map( map5, theta[5]*180/!pi, cen=cenFOV )
;map6 = rot_map( map6, theta[6]*180/!pi, cen=cenFOV )
map0.xc += offsetXY[0,0]
map2.xc += offsetXY[0,2]
map4.xc += offsetXY[0,4]
map5.xc += offsetXY[0,5]
map6.xc += offsetXY[0,6]
map0.yc += offsetXY[1,0]
map2.yc += offsetXY[1,2]
map4.yc += offsetXY[1,4]
map5.yc += offsetXY[1,5]
map6.yc += offsetXY[1,6]
plot_map, map0, /limb, /cbar, cen=[-900,250], fov=25
plot_map, map2, /limb, /cbar, cen=[-900,250], fov=25
plot_map, map4, /limb, /cbar, cen=[-900,250], fov=25
plot_map, map5, /limb, /cbar, cen=[-900,250], fov=25
plot_map, map6, /limb, /cbar, cen=[-900,250], fov=25
map = map0
map.data = map0.data+map2.data+map4.data+map5.data+map6.data
plot_map, map, /limb, /cbar, cen=[-900,250], fov=25



restore,'data_2012/rhessi_imaging_foxsi_flare_march2013.sav',/ver

loadct2,3
center=[960,-205]
fov=1.5
!p.multi=[0,4,1]
;RHESSI
loadct2,5
plot_map,c3n,/limb,center=center,fov=fov,bot=8,lcolor=255,gcolor=255,grid=2
plot_map,vff,/over,/per,levels=[50],color=255,thick=2
plot_map,njmap,/limb,center=center,fov=fov,bot=8,lcolor=255,gcolor=255,grid=2
plot_map,vff,/over,/per,levels=[50],color=255,thick=2
plot_map,vff,/limb,center=center,fov=fov,bot=8,lcolor=255,gcolor=255,grid=2
plot_map,vff,/over,/per,levels=[50],color=255,thick=2
plot_map,pmap,/limb,center=center,fov=fov,bot=8,lcolor=255,gcolor=255,grid=2
plot_map,vff,/over,/per,levels=[50],color=255,thick=2



;
; Look at some profiles of the blob
;

add_path,'img'
restore, 'data_2012/foxsi_level2_data.sav', /v
i0 = where( data_lvl2_d0.error_flag eq 0 )
i1 = where( data_lvl2_d1.error_flag eq 0 )
i2 = where( data_lvl2_d2.error_flag eq 0 )
i3 = where( data_lvl2_d3.error_flag eq 0 )
i4 = where( data_lvl2_d4.error_flag eq 0 )
i5 = where( data_lvl2_d5.error_flag eq 0 )
i6 = where( data_lvl2_d6.error_flag eq 0 )

t0 = '2-Nov-2012 17:55:00.000'
t1_start = 108.3		; Target 1 (AR)
t1_end = 151.8
t2_start = 154.8		; Target 2 (AR)
t2_end = 244.7
t3_start = 247			; Target 3 (quiet Sun)
t3_end = 337.3
t4_start = 340			; Target 4 (flare)
t4_end = 421.2
t5_start = 423.5		; Target 5 (off-pointing)
t5_end = 435.9
t6_start = 438.5		; Target 6 (flare)
t6_end = 498.3

cen1 = [-480,-350]
cen2 = [-850, 150]
cen3 = [ 600, 400]
cen4 = [ 700,-600]
cen5 = [1000,-900]
cen6 = [ 700,-600]
flarecen = [1030,-310]

popen, xsi=8, ysi=4
!p.multi=[0,4,2]
pix=4.
img=foxsi_image_solar(data_lvl2_d6, 6, psize=pix, size=[3000,3000])
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix  )
plot_map, map, /limb, cen=flarecen, fov=3
xyouts, 950, -235, 'pix = 4 arcsec', col=255
pix=5.
img=foxsi_image_solar(data_lvl2_d6, 6, psize=pix, size=[3000,3000])
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix  )
plot_map, map, /limb, cen=flarecen, fov=3
xyouts, 950, -235, 'pix = 5 arcsec', col=255
pix=6.
img=foxsi_image_solar(data_lvl2_d6, 6, psize=pix, size=[3000,3000])
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix  )
plot_map, map, /limb, cen=flarecen, fov=3
xyouts, 950, -235, 'pix = 6 arcsec', col=255
pix=7.
img=foxsi_image_solar(data_lvl2_d6, 6, psize=pix, size=[3000,3000])
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix  )
plot_map, map, /limb, cen=flarecen, fov=3
xyouts, 950, -235, 'pix = 7 arcsec', col=255
pix=8.
img=foxsi_image_solar(data_lvl2_d6, 6, psize=pix, size=[3000,3000])
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix  )
plot_map, map, /limb, cen=flarecen, fov=3
xyouts, 950, -235, 'pix = 8 arcsec', col=255
pix=9.
img=foxsi_image_solar(data_lvl2_d6, 6, psize=pix, size=[3000,3000])
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix  )
plot_map, map, /limb, cen=flarecen, fov=3
xyouts, 950, -235, 'pix = 9 arcsec', col=255
pix=10.
img=foxsi_image_solar(data_lvl2_d6, 6, psize=pix, size=[3000,3000])
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix  )
plot_map, map, /limb, cen=flarecen, fov=3, col=255
xyouts, 950, -235, 'pix = 10 arcsec', col=255
pclose

sub_map, map, sub, xr=[950,1100], yr=[-400,-200]
x = sub.data[*,0]
plot, findgen(21)*7.7, x, psym=10

; correct map for D6 offset.
sub.xc += -63.45
sub.yc += +106.36

;  	xerr=[55.4700,    81.490,   96.360,  87.8900,  48.2700,   49.550,   63.450]
;  	yerr=[-135.977, -131.124, -130.241, -92.7310, -95.3080, -120.276, -106.360]

plot_map, aia[0], center=[960,-225], fov=2                       
plot_map, sub, /over

sub.id='FOXSI D6 whole flight'
sub.time=['2012-Nov-2']

ch=1.
th=3
col=255

popen, 'D6-131-overlay', xsi=8, ysi=8
!p.multi=[0,2,2]
plot_map, aia[0], fov=2, /limb, /nodate, charsi=ch, lcol=col, lth=th
plot_map, sub, cen=aia[0], fov=2, /limb, title='FOXSI D6 whole flight 4-15keV', charsi=ch, lcol=255, lth=th
plot_map, aia[0], fov=2, /limb, /nodate, charsi=ch, lcol=255, lth=th
plot_map, sub, /over, thick=th, col=col
xyouts, 905, -155, 'D6 autolevels', col=col
plot_map, aia[0], fov=2, /limb, /nodate, charsi=ch, lcol=255, lth=th
plot_map, sub, /over, levels=[50],/per, thick=th, col=col
xyouts, 905, -155, 'D6 50%', col=col
pclose



;
; stray code
;



;; or use this if you want to select the positions.
; rough flare centroid for each detector
pos0 = [ 320, 280 ]
pos1 = [ 340, 270 ]
pos2 = [ 350, 250 ]
pos3 = [ 350, 300 ]
pos4 = [ 300, 300 ]
pos5 = [ 305, 280 ]
pos6 = [ 320, 280 ]
rad = 50
i0 = where(data_lvl2_d0.wsmr_time gt t1 and data_lvl2_d0.wsmr_time lt t2) and $
		   data_lvl2_d0.hit_xy_pay[0] gt (pos0[0] - rad) and $
		   data_lvl2_d0.hit_xy_pay[0] lt (pos0[0] + rad) and $
		   data_lvl2_d0.hit_xy_pay[1] gt (pos0[1] - rad) and $
		   data_lvl2_d0.hit_xy_pay[1] lt (pos0[1] + rad) )
i1 = where(data_lvl2_d1.wsmr_time gt t1 and data_lvl2_d1.wsmr_time lt t2) and $
		   data_lvl2_d1.hit_xy_pay[0] gt (pos1[0] - rad) and $
		   data_lvl2_d1.hit_xy_pay[0] lt (pos1[0] + rad) and $
		   data_lvl2_d1.hit_xy_pay[1] gt (pos1[1] - rad) and $
		   data_lvl2_d1.hit_xy_pay[1] lt (pos1[1] + rad) )
i2 = where(data_lvl2_d2.wsmr_time gt t1 and data_lvl2_d2.wsmr_time lt t2) and $
		   data_lvl2_d2.hit_xy_pay[0] gt (pos2[0] - rad) and $
		   data_lvl2_d2.hit_xy_pay[0] lt (pos2[0] + rad) and $
		   data_lvl2_d2.hit_xy_pay[1] gt (pos2[1] - rad) and $
		   data_lvl2_d2.hit_xy_pay[1] lt (pos2[1] + rad) )
i3 = where(data_lvl2_d3.wsmr_time gt t1 and data_lvl2_d3.wsmr_time lt t2) and $
		   data_lvl2_d3.hit_xy_pay[0] gt (pos3[0] - rad) and $
		   data_lvl2_d3.hit_xy_pay[0] lt (pos3[0] + rad) and $
		   data_lvl2_d3.hit_xy_pay[1] gt (pos3[1] - rad) and $
		   data_lvl2_d3.hit_xy_pay[1] lt (pos3[1] + rad) )
i4 = where(data_lvl2_d4.wsmr_time gt t1 and data_lvl2_d4.wsmr_time lt t2) and $
		   data_lvl2_d4.hit_xy_pay[0] gt (pos4[0] - rad) and $
		   data_lvl2_d4.hit_xy_pay[0] lt (pos4[0] + rad) and $
		   data_lvl2_d4.hit_xy_pay[1] gt (pos4[1] - rad) and $
		   data_lvl2_d4.hit_xy_pay[1] lt (pos4[1] + rad) )
i5 = where(data_lvl2_d5.wsmr_time gt t1 and data_lvl2_d5.wsmr_time lt t2) and $
		   data_lvl2_d5.hit_xy_pay[0] gt (pos5[0] - rad) and $
		   data_lvl2_d5.hit_xy_pay[0] lt (pos5[0] + rad) and $
		   data_lvl2_d5.hit_xy_pay[1] gt (pos5[1] - rad) and $
		   data_lvl2_d5.hit_xy_pay[1] lt (pos5[1] + rad) )
i6 = where(data_lvl2_d6.wsmr_time gt t1 and data_lvl2_d6.wsmr_time lt t2) and $
		   data_lvl2_d6.hit_xy_pay[0] gt (pos6[0] - rad) and $
		   data_lvl2_d6.hit_xy_pay[0] lt (pos6[0] + rad) and $
		   data_lvl2_d6.hit_xy_pay[1] gt (pos6[1] - rad) and $
		   data_lvl2_d6.hit_xy_pay[1] lt (pos6[1] + rad) )

;
; Quick look at the flare HPD
;

flare_xy = [ [1018,-340], [1044,-335], [1058,-334], [1050,-297], [1010,-299], [1012,-324], [1026,-310] ]

rad = 120.

get_target_data, 4, d0,d1,d2,d3,d4,d5,d6, rad=500, center=flare_xy, eband=[4.,12.]

; Make some images to illustrate problem and technique
flare_xy_corr = [960,-210]
pix=8.
;get_target_data, 4, d0,d1,d2,d3,d4,d5,d6, eband=[4.,12.]
img=foxsi_image_solar_int(d0,d1,d2,d3,d4,d5,d6, psize=pix, index=[1,1,1,0,1,1,1], /xyc, /nowin, siz=[600,600])
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, time=anytim(anytim(date)+t4_start,/yo) )
map.id = '4th target, 4-12 keV, D0,1,2,4,5,6'

popen, xsi=8, ysi=8
ch=1.
!p.multi=[0,1,2]
loadct, 5
plot_map, map, /limb, cen=flare_xy_corr, fov=20, charsi=ch, lcol=255, lth=2, tit=map.id
hsi_linecolors
draw_fov, /all, target=4, /xycor, col=1, thick=4
loadct, 5
plot_map, map, /limb, cen=flare_xy_corr, fov=20, /log, charsi=ch, lcol=255, lth=2, tit=map.id
hsi_linecolors
draw_fov, /all, target=4, /xycor, col=1, thick=4
xyouts, 0.65, 0.92, 'LINEAR', /norm, color=1
xyouts, 0.65, 0.42, 'LOG', /norm, color=1
pclose

popen, xsi=8, ysi=8
ch=1.2
!p.multi=0
loadct, 5
plot_map, map, cen=flare_xy_corr, fov=20, charsi=ch, tit='Attempt 1', /log
hsi_linecolors
draw_fov, /all, target=4, /xycor, col=1, thick=4
circ1 = circle( flare_xy_corr[0], flare_xy_corr[1], 30 )
circ2 = circle( flare_xy_corr[0], flare_xy_corr[1], 75 )
circ3 = circle( flare_xy_corr[0], flare_xy_corr[1], 150 )
circ4 = circle( flare_xy_corr[0], flare_xy_corr[1], 300 )
circ5 = circle( flare_xy_corr[0], flare_xy_corr[1], 600 )
circ6 = circle( flare_xy_corr[0], flare_xy_corr[1], 1200 )
polyfill, circ1, col=2
oplot, circ1[0,*], circ1[1,*], col=2, thick=4
oplot, circ2[0,*], circ2[1,*], col=2, thick=4
oplot, circ3[0,*], circ3[1,*], col=2, thick=4
oplot, circ4[0,*], circ4[1,*], col=2, thick=4
oplot, circ5[0,*], circ5[1,*], col=2, thick=4
oplot, circ6[0,*], circ6[1,*], col=2, thick=4
pclose

popen, xsi=8, ysi=8
ch=1.2
!p.multi=0
loadct, 5
plot_map, map, cen=flare_xy_corr, fov=20, charsi=ch, tit='Attempt 2', /log
hsi_linecolors
draw_fov, /all, target=4, /xycor, col=1, thick=4
polyfill, circ5, col=2, ori=0, spac=0.15
polyfill, [[circ4[*,50:74]],[reverse(circ5[*,50:74],2)]], col=2, ori=90, spac=0.15
polyfill, circ4, col=3, ori=0, spac=0.15
polyfill, [[circ3[*,50:74]],[reverse(circ4[*,50:74],2)]], col=3, ori=90, spac=0.15
polyfill, circ3, col=4, ori=0, spac=0.15
polyfill, [[circ2[*,50:74]],[reverse(circ3[*,50:74],2)]], col=4, ori=90, spac=0.15
plots, circ2, col=2, thick=4
pclose

rad = [10.,20.,30.,40.,50.,60.,70.,80.,90.,100.,120.,150.,200.,300.,400.,500.]
n_rad = n_elements(rad)
flux = fltarr(7,n_rad)
quad = fltarr(7,n_rad)
flare_xy = [ [1018,-340], [1044,-335], [1058,-334], [1050,-297], [1010,-299], [1012,-324], [1026,-310] ]

.run
for i=0, n_rad-1 do begin
	;get_target_data, 4, d0,d1,d2,d3,d4,d5,d6, rad=rad[i], center=flare_xy, eband=[4.,12.], /good
	;flux[0,i] = n_elements(d0)
	;flux[1,i] = n_elements(d1)
	;flux[2,i] = n_elements(d2)
	;flux[3,i] = n_elements(d3)
	;flux[4,i] = n_elements(d4)
	;flux[5,i] = n_elements(d5)
	;flux[6,i] = n_elements(d6)
	get_target_data, 4, d0,d1,d2,d3,d4,d5,d6, rad=rad[i], center=flare_xy, eband=[4.,12.], /good, /quad
	quad[0,i] = n_elements(d0)
	quad[1,i] = n_elements(d1)
	quad[2,i] = n_elements(d2)
	quad[3,i] = n_elements(d3)
	quad[4,i] = n_elements(d4)
	quad[5,i] = n_elements(d5)
	quad[6,i] = n_elements(d6)
endfor
end

res = fltarr(7, n_rad)
res[*,0:7] = flux[*,0:7]
res[*,8]  = res[*,7]  + ( quad[*,8]-quad[*,7] )*4
res[*,9]  = res[*,8]  + ( quad[*,9]-quad[*,8] )*4
res[*,10] = res[*,9]  + ( quad[*,10]-quad[*,9] )*4
res[*,11] = res[*,10] + ( quad[*,11]-quad[*,10] )*4
res[*,12] = res[*,11] + ( quad[*,12]-quad[*,11] )*4
res[*,13] = res[*,12] + ( quad[*,13]-quad[*,12] )*4
res[*,14] = res[*,13] + ( quad[*,14]-quad[*,13] )*4
res[*,15] = res[*,14] + ( quad[*,15]-quad[*,14] )*4


loadct, 0
popen, xsi=7, ysi=5
hsi_linecolors
plot, 2*rad, flux[6,0:14]/flux[6,14], /nodata, xtitle='diameter [arcsec]', $
	ytit='Encircled flux (normalized to full FOV)', charsize=1.2, xr=[0,800], $
	title='Flare HPD, 81 sec, 4-12 keV, no bkgd correction'
oplot, 2*rad[0:14], flux[0,0:14]/flux[0,14], psym=-1, color=6, thick=3, line=2
oplot, 2*rad[0:14], flux[1,0:14]/flux[1,14], psym=-1, color=7, thick=3, line=2
oplot, 2*rad[0:14], flux[2,0:14]/flux[2,14], psym=-1, color=8, thick=3, line=2
oplot, 2*rad[0:14], flux[3,0:14]/flux[3,14], psym=-1, color=9, thick=3, line=2
oplot, 2*rad[0:14], flux[4,0:14]/flux[4,14], psym=-1, color=10, thick=3, line=2
oplot, 2*rad[0:14], flux[5,0:14]/flux[5,14], psym=-1, color=12, thick=3, line=2
oplot, 2*rad[0:14], flux[6,0:14]/flux[6,14], psym=-1, color=2, thick=3, line=2
oplot, 2*rad[0:14], res[0,0:14]/res[0,14], psym=-1, color=6, thick=3
oplot, 2*rad[0:14], res[1,0:14]/res[1,14], psym=-1, color=7, thick=3
oplot, 2*rad[0:14], res[2,0:14]/res[2,14], psym=-1, color=8, thick=3
oplot, 2*rad[0:14], res[3,0:14]/res[3,14], psym=-1, color=9, thick=3
oplot, 2*rad[0:14], res[4,0:14]/res[4,14], psym=-1, color=10, thick=3
oplot, 2*rad[0:14], res[5,0:14]/res[5,14], psym=-1, color=12, thick=3
oplot, 2*rad[0:14], res[6,0:14]/res[6,14], psym=-1, color=2, thick=3
legend, ['D0','D1','D2','D3','D4','D5','D6','Method 1','Method 2'], $
	color=[6,7,8,9,10,12,2,0,0], line=[0,0,0,0,0,0,0,2,0], $
;	/left,  /top,$
	/right, /bot,$
	thick=3, charsize=1.1
oplot, [0,2600],[0.5,0.5], line=1, thick=3
xyouts, 0.43, 0.51, 'Method 1', /norm
xyouts, 0.53, 0.51, 'Method 2', /norm
xyouts, 0.4, 0.47, strtrim(hpd[0,0]), /norm
xyouts, 0.5, 0.47, strtrim(hpd[1,0]), /norm
xyouts, 0.4, 0.44, strtrim(hpd[0,1]), /norm
xyouts, 0.5, 0.44, strtrim(hpd[1,1]), /norm
xyouts, 0.4, 0.41, strtrim(hpd[0,2]), /norm
xyouts, 0.5, 0.41, strtrim(hpd[1,2]), /norm
xyouts, 0.4, 0.38, strtrim(hpd[0,3]), /norm
xyouts, 0.5, 0.38, strtrim(hpd[1,3]), /norm
xyouts, 0.4, 0.35, strtrim(hpd[0,4]), /norm
xyouts, 0.5, 0.35, strtrim(hpd[1,4]), /norm
xyouts, 0.4, 0.32, strtrim(hpd[0,5]), /norm
xyouts, 0.5, 0.32, strtrim(hpd[1,5]), /norm
xyouts, 0.4, 0.29, strtrim(hpd[0,6]), /norm
xyouts, 0.5, 0.29, strtrim(hpd[1,6]), /norm
pclose

x = findgen(1000)
y0 = interpol( flux[0,0:14], 2*rad[0:14], x )
y1 = interpol( flux[1,0:14], 2*rad[0:14], x )
y2 = interpol( flux[2,0:14], 2*rad[0:14], x )
y3 = interpol( flux[3,0:14], 2*rad[0:14], x )
y4 = interpol( flux[4,0:14], 2*rad[0:14], x )
y5 = interpol( flux[5,0:14], 2*rad[0:14], x )
y6 = interpol( flux[6,0:14], 2*rad[0:14], x )
z0 = interpol( res[0,0:14], 2*rad[0:14], x )
z1 = interpol( res[1,0:14], 2*rad[0:14], x )
z2 = interpol( res[2,0:14], 2*rad[0:14], x )
z3 = interpol( res[3,0:14], 2*rad[0:14], x )
z4 = interpol( res[4,0:14], 2*rad[0:14], x )
z5 = interpol( res[5,0:14], 2*rad[0:14], x )
z6 = interpol( res[6,0:14], 2*rad[0:14], x )

hpd = fltarr(2, 7)
hpd[0,0] = x[ (where( y0 gt 0.5*flux[0,14]))[0] ]
hpd[0,1] = x[ (where( y1 gt 0.5*flux[1,14]))[0] ]
hpd[0,2] = x[ (where( y2 gt 0.5*flux[2,14]))[0] ]
hpd[0,3] = x[ (where( y3 gt 0.5*flux[3,14]))[0] ]
hpd[0,4] = x[ (where( y4 gt 0.5*flux[4,14]))[0] ]
hpd[0,5] = x[ (where( y5 gt 0.5*flux[5,14]))[0] ]
hpd[0,6] = x[ (where( y6 gt 0.5*flux[6,14]))[0] ]
hpd[1,0] = x[ (where( z0 gt 0.5*res[0,14]))[0] ]
hpd[1,1] = x[ (where( z1 gt 0.5*res[1,14]))[0] ]
hpd[1,2] = x[ (where( z2 gt 0.5*res[2,14]))[0] ]
hpd[1,3] = x[ (where( z3 gt 0.5*res[3,14]))[0] ]
hpd[1,4] = x[ (where( z4 gt 0.5*res[4,14]))[0] ]
hpd[1,5] = x[ (where( z5 gt 0.5*res[5,14]))[0] ]
hpd[1,6] = x[ (where( z6 gt 0.5*res[6,14]))[0] ]

;
; OLD RESULTS!  DIDN'T ACCOUNT FOR GOOD EVENTS...
; did this for rad ranging from 10" to 1300".
; Results:

rad = [10.,20.,30.,40.,50.,60.,70.,80.,90.,100.,120.,150.,200.,300.,400.,500.,700.,900.,1100.,1300.]

f0 = [46, 178, 287, 352, 405, 465, 492, 516, 537, 549, 574, 614, 678, 802, 926, 942, 983, 1036, 1039, 1039]
f1 = [25,  66, 102, 114, 129, 142, 162, 168, 172, 176, 188, 196, 226, 260, 296, 399, 625, 1062, 1086, 1086]
f2 = [125, 306, 446, 586, 664, 709, 739, 769, 784, 802, 818, 848, 891, 1118, 1156, 1193, 1237, 1343, 1344, 1344]
f3 = [16, 56, 88, 126, 150, 164, 174, 180, 184, 191, 195, 204, 217, 262, 310, 330, 361, 398, 399, 399]
f4 = [233, 596, 929, 1104, 1214, 1323, 1381, 1420, 1450, 1486, 1544, 1591, 1676, 1782, 1826, 1854, 2025, 2421, 2436, 2436]
f5 = [196, 537, 841, 1074, 1211, 1276, 1332, 1371, 1398, 1426, 1466, 1514, 1598, 1724, 1966, 2034, 2198, 2509, 2535, 2535]
f6 = [276, 704, 1021, 1215, 1308, 1378, 1420, 1460, 1483, 1504, 1533, 1653, 1899, 2182, 2342, 2410, 2616, 2637, 2639, 2639]

; Repeated using the lower left quadrant only.
rad2 = [10.,20.,30.,40.,50.,60.,70.,80.,90.,100.,120.,150.,200.,300.,400.,500.,600.]
f02 = [14,27,40,44,52,58,61,64,66,66,69,83,119,187,304,318,327]
f12 = [5,10,14,14,16,19,35,35,38,38,46,50,58,78,111,211,275]
f22 = [21,72,108,158,173,187,195,210,215,217,220,227,241,261,274,303,328]
f32 = [4,12,23,29,36,39,43,44,47,48,49,54,58,66,78,83,93]
f42 = [57,170,200,229,256,281,294,301,310,319,339,360,392,455,478,499,547]
f52 = [33,97,166,206,224,234,243,253,262,265,278,293,328,418,609,642,672]
f62 = [62,200,297,367,406,427,438,445,453,459,465,471,488,505,520,539,550]

res0 = [f0[0:7],fltarr(8)]
res1 = [f1[0:7],fltarr(8)]
res2 = [f2[0:7],fltarr(8)]
res3 = [f3[0:7],fltarr(8)]
res4 = [f4[0:7],fltarr(8)]
res5 = [f5[0:7],fltarr(8)]
res6 = [f6[0:7],fltarr(8)]

res0[8]  = res0[7]  + ( f02[8]-f02[7] )*4
res0[9]  = res0[8]  + ( f02[9]-f02[8] )*4
res0[10] = res0[9]  + ( f02[10]-f02[9] )*4
res0[11] = res0[10] + ( f02[11]-f02[10] )*4
res0[12] = res0[11] + ( f02[12]-f02[11] )*4
res0[13] = res0[12] + ( f02[13]-f02[12] )*4
res0[14] = res0[13] + ( f02[14]-f02[13] )*4
res0[15] = res0[14] + ( f02[15]-f02[14] )*4

res1[8]  = res1[7]  + ( f12[8]-f12[7] )*4
res1[9]  = res1[8]  + ( f12[9]-f12[8] )*4
res1[10] = res1[9]  + ( f12[10]-f12[9] )*4
res1[11] = res1[10] + ( f12[11]-f12[10] )*4
res1[12] = res1[11] + ( f12[12]-f12[11] )*4
res1[13] = res1[12] + ( f12[13]-f12[12] )*4
res1[14] = res1[13] + ( f12[14]-f12[13] )*4
res1[15] = res1[14] + ( f12[15]-f12[14] )*4

res2[8]  = res2[7]  + ( f22[8]-f22[7] )*4
res2[9]  = res2[8]  + ( f22[9]-f22[8] )*4
res2[10] = res2[9]  + ( f22[10]-f22[9] )*4
res2[11] = res2[10] + ( f22[11]-f22[10] )*4
res2[12] = res2[11] + ( f22[12]-f22[11] )*4
res2[13] = res2[12] + ( f22[13]-f22[12] )*4
res2[14] = res2[13] + ( f22[14]-f22[13] )*4
res2[15] = res2[14] + ( f22[15]-f22[14] )*4

res3[8]  = res3[7]  + ( f32[8]-f32[7] )*4
res3[9]  = res3[8]  + ( f32[9]-f32[8] )*4
res3[10] = res3[9]  + ( f32[10]-f32[9] )*4
res3[11] = res3[10] + ( f32[11]-f32[10] )*4
res3[12] = res3[11] + ( f32[12]-f32[11] )*4
res3[13] = res3[12] + ( f32[13]-f32[12] )*4
res3[14] = res3[13] + ( f32[14]-f32[13] )*4
res3[15] = res3[14] + ( f32[15]-f32[14] )*4

res4[8]  = res4[7]  + ( f42[8]-f42[7] )*4
res4[9]  = res4[8]  + ( f42[9]-f42[8] )*4
res4[10] = res4[9]  + ( f42[10]-f42[9] )*4
res4[11] = res4[10] + ( f42[11]-f42[10] )*4
res4[12] = res4[11] + ( f42[12]-f42[11] )*4
res4[13] = res4[12] + ( f42[13]-f42[12] )*4
res4[14] = res4[13] + ( f42[14]-f42[13] )*4
res4[15] = res4[14] + ( f42[15]-f42[14] )*4

res5[8]  = res5[7]  + ( f52[8]-f52[7] )*4
res5[9]  = res5[8]  + ( f52[9]-f52[8] )*4
res5[10] = res5[9]  + ( f52[10]-f52[9] )*4
res5[11] = res5[10] + ( f52[11]-f52[10] )*4
res5[12] = res5[11] + ( f52[12]-f52[11] )*4
res5[13] = res5[12] + ( f52[13]-f52[12] )*4
res5[14] = res5[13] + ( f52[14]-f52[13] )*4
res5[15] = res5[14] + ( f52[15]-f52[14] )*4

res6[8]  = res6[7]  + ( f62[8]-f62[7] )*4
res6[9]  = res6[8]  + ( f62[9]-f62[8] )*4
res6[10] = res6[9]  + ( f62[10]-f62[9] )*4
res6[11] = res6[10] + ( f62[11]-f62[10] )*4
res6[12] = res6[11] + ( f62[12]-f62[11] )*4
res6[13] = res6[12] + ( f62[13]-f62[12] )*4
res6[14] = res6[13] + ( f62[14]-f62[13] )*4
res6[15] = res6[14] + ( f62[15]-f62[14] )*4

plot, rad[0:15], res4, /nodata
oplot, rad[0:15], res0, sym=-1, col=6
oplot, rad[0:15], f0[0:15], psym=-1, col=6, line=2
oplot, rad[0:15], res1, psym=-1, col=7
oplot, rad[0:15], f1[0:15], psym=-1, col=7, line=2
oplot, rad[0:15], res2, psym=-1, col=8
oplot, rad[0:15], f2[0:15], psym=-1, col=8, line=2
oplot, rad[0:15], res3, psym=-1, col=9
oplot, rad[0:15], f3[0:15], psym=-1, col=9, line=2
oplot, rad[0:15], res4, psym=-1, col=10
oplot, rad[0:15], f4[0:15], psym=-1, col=10, line=2
oplot, rad[0:15], res5, psym=-1, col=12
oplot, rad[0:15], f5[0:15], psym=-1, col=12, line=2
oplot, rad[0:15], res6, psym=-1, col=2
oplot, rad[0:15], f6[0:15], psym=-1, col=2, line=2

loadct, 0
hsi_linecolors
!p.multi=[0,1,2]
popen, xsi=7, ysi=10
plot, 2*rad, f0/float(f0[19]), /nodata, xr=[0,400], yr=[0.,1.], xtitle='diameter [arcsec]', $
	ytit='Encircled flux (normalized to full FOV)', charsize=1.2, $
	title='Flare HPD, 81 sec, 4-12 keV, no bkgd or geometrical corrections'
oplot, 2*rad, f0/float(f0[19]), psym=-1, color=6, thick=3
oplot, 2*rad, f1/float(f1[19]), psym=-1, color=7, thick=3
oplot, 2*rad, f2/float(f2[19]), psym=-1, color=8, thick=3
oplot, 2*rad, f3/float(f3[19]), psym=-1, color=9, thick=3
oplot, 2*rad, f4/float(f4[19]), psym=-1, color=10, thick=3
oplot, 2*rad, f5/float(f5[19]), psym=-1, color=12, thick=3
oplot, 2*rad, f6/float(f6[19]), psym=-1, color=2, thick=3
legend, ['D0','D1','D2','D3','D4','D5','D6'], color=[6,7,8,9,10,12,2], line=0, $
	/left,  /top,$
;	/right, /bot,$
	thick=3, charsize=1.1
oplot, [0,2600],[0.5,0.5], line=1, thick=3



;
; AIA
;

f=file_search( '~/data/aia/20121102/aia*131A*' )
aia_prep, f, -1, i, d, /do_write_fits, outdir='~/data/aia/20121102/'

f2 = file_search( '~/data/aia/20121102/AIA*0131.fits' )

;
; Images for Ishikawa's paper
;

; Make FOXSI image.
@foxsi-setup-script
get_target_data, 1, d0,d1,d2,d3,d4,d5,d6
pix=10.
er=[4,15]
tr = [t1_start, t1_end]
img4g=foxsi_image_solar( d4, 4, ps=pix, er=er, tr=tr-t_launch, thr_n=4., /xy)
map4g = make_map( img4g, xcen=0., ycen=0., dx=pix, dy=pix, id='D4',time=anytim( anytim(t0)+tr[0], /yo))

; Figure out offset.  From flare image, FOXSI coords need to be adjusted [-69", 116"].
; The FOXSI image is already adjusted.
; Target 1 nominal center is [-480,-350]; adjusted center is [-549,-234].
; AR center is approx [-320,-402].  This is [160,-52], or 2.8 arcmin off.
; From FOXSI's pointing center, AR center is [229,-168], or 4.7 arcmin.
cen1_adj = [-549,-234]

; Get AIA data.
; 171 [index 3] is nicest; 131 [index 0] is also a good choice.
restore, 'data_2012/aia_maps.sav'

popen, xsi=7, ysi=7
aia_lct, rr, gg, bb, wavelnth=171, /load
plot_map, aia_maps[3], cen=cen1_adj, fov=20, /log, dmin=100., charsi=1.1
plot_map, map4g, /over, col=255, thick=6
draw_fov, det=4, target=1, /xycor, thick=6, col=255
pclose
