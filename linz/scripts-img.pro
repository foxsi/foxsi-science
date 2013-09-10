
r = [-1200,1200]
shftX = 0
shftY = 0
plot_map,m[0],/limb,center=[0,0],fov=50      
oplot, data_lvl2_d0[i0].hit_xy_solar[0]+shftX, data_lvl2_d0[i0].hit_xy_solar[1]+shftY, psym=3;, xr=r,yr=r
;oplot, data_lvl2_d1[i1].hit_xy_solar[0]+shftX, data_lvl2_d1[i1].hit_xy_solar[1]+shftY, psym=3, color=7
oplot, data_lvl2_d2[i2].hit_xy_solar[0]+shftX, data_lvl2_d2[i2].hit_xy_solar[1]+shftY, psym=3, color=8
;oplot, data_lvl2_d3[i3].hit_xy_solar[0]+shftX, data_lvl2_d3[i3].hit_xy_solar[1]+shftY, psym=3, color=9
oplot, data_lvl2_d4[i4].hit_xy_solar[0]+shftX, data_lvl2_d4[i4].hit_xy_solar[1]+shftY, psym=3, color=10
oplot, data_lvl2_d5[i5].hit_xy_solar[0]+shftX, data_lvl2_d5[i5].hit_xy_solar[1]+shftY, psym=3, color=12
oplot, data_lvl2_d6[i6].hit_xy_solar[0]+shftX, data_lvl2_d6[i6].hit_xy_solar[1]+shftY, psym=3, color=2
xyouts, -1100, 1100, strtrim(e1,2)+'-'+strtrim(e2,2)+'keV'


;
; more imaging, this time using Ishikawa's scripts
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
flare = [950,-250]

pix=7.7.
img=foxsi_image_solar(data_lvl2_d6, 6,psize=pix)
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix )
plot_map, map, /limb, dmax=5, cen=cen1, fov=16

img=foxsi_image_solar(d6, 6, psize=50)

pix=8.
erange=[4,15]
tr = [t4_start, t4_end]

img0=foxsi_image_solar(data_lvl2_d0,0,psize=pix,erange=erange,trange=tr,thr_n=4.);,/xycor)
img1=foxsi_image_solar(data_lvl2_d1,1,psize=pix,erange=erange,trange=tr,thr_n=4.);,/xycor)
img2=foxsi_image_solar(data_lvl2_d2,2,psize=pix,erange=erange,trange=tr,thr_n=4.);,/xycor)
img3=foxsi_image_solar(data_lvl2_d3,3,psize=pix,erange=erange,trange=tr,thr_n=4.);,/xycor)
img4=foxsi_image_solar(data_lvl2_d4,4,psize=pix,erange=erange,trange=tr,thr_n=4.);,/xycor)
img5=foxsi_image_solar(data_lvl2_d5,5,psize=pix,erange=erange,trange=tr,thr_n=4.);,/xycor)
img6=foxsi_image_solar(data_lvl2_d6,6,psize=pix,erange=erange,trange=tr,thr_n=4.);,/xycor)
img=foxsi_image_solar_int( data_lvl2_d0, data_lvl2_d1, data_lvl2_d2, $
		data_lvl2_d3, data_lvl2_d4, data_lvl2_d5, data_lvl2_d6, $
		psize=pix, erange=erange, trange=tr, thr_n=4., /nowin);, /xycor )

map0 = make_map( img0, xcen=0., ycen=0., dx=pix, dy=pix, id='D0',time=anytim( anytim(t0)+tr[0], /yo))
map1 = make_map( img1, xcen=0., ycen=0., dx=pix, dy=pix, id='D1',time=anytim( anytim(t0)+tr[0], /yo))
map2 = make_map( img2, xcen=0., ycen=0., dx=pix, dy=pix, id='D2',time=anytim( anytim(t0)+tr[0], /yo))
map3 = make_map( img3, xcen=0., ycen=0., dx=pix, dy=pix, id='D3',time=anytim( anytim(t0)+tr[0], /yo))
map4 = make_map( img4, xcen=0., ycen=0., dx=pix, dy=pix, id='D4',time=anytim( anytim(t0)+tr[0], /yo))
map5 = make_map( img5, xcen=0., ycen=0., dx=pix, dy=pix, id='D5',time=anytim( anytim(t0)+tr[0], /yo))
map6 = make_map( img6, xcen=0., ycen=0., dx=pix, dy=pix, id='D6',time=anytim( anytim(t0)+tr[0], /yo))
map  = make_map( img,  xcen=0., ycen=0., dx=pix, dy=pix, id='5dets',time=anytim( anytim(t0)+tr[0], /yo))

plot_map, map, /limb, cen=flare, fov=3, /cbar


flarecen = [1030,-310]
plot_map, map, /limb, cen=flarecen, fov=2

loadct, 4
TVLCT, r, g, b, /Get
r[0]=255
g[0]=255
b[0]=255

pix=7.7
erange=[4,15]
cen=cen4
;cen=[-200,-200]
;cen=[960,-200]
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
