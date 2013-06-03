PRO	DRAW_ALL, PIX=PIX, ERANGE=ERANGE, TARGET=TARGET, FOV=FOV, FILE=FILE, MAX=MAX

restore, 'data_2012/foxsi_level2_data.sav', /v

default, pix, 100.
default, erange, [4,15]
default, target, 4
default, fov, 30
default, file, 'plot'
default, max, 5

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

start = [t1_start, t2_start, t3_start, t4_start, t5_start, t6_start]
finish =[t1_end, t2_end, t3_end, t4_end, t5_end, t6_end]

tr = [start[target-1],finish[target-1]]

cen1 = [-480,-350]
cen2 = [-850, 150]
cen3 = [ 600, 400]
cen4 = [ 700,-600]
cen5 = [1000,-900]
cen6 = [ 700,-600]

cenX = [cen1[0], cen2[0], cen3[0], cen4[0], cen5[0], cen6[0]]
cenY = [cen1[1], cen2[1], cen3[1], cen4[1], cen5[1], cen6[1]]

center = [cenX[target-1], cenY[target-1]]

img0=foxsi_image_solar(data_lvl2_d0[i0],0,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img1=foxsi_image_solar(data_lvl2_d1[i1],1,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img2=foxsi_image_solar(data_lvl2_d2[i2],2,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img3=foxsi_image_solar(data_lvl2_d3[i3],3,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img4=foxsi_image_solar(data_lvl2_d4[i4],4,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img5=foxsi_image_solar(data_lvl2_d5[i5],5,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img6=foxsi_image_solar(data_lvl2_d6[i6],6,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img=foxsi_image_solar_int( data_lvl2_d0[i0], data_lvl2_d1[i1], data_lvl2_d2[i2], $
		data_lvl2_d3[i3], data_lvl2_d4[i4], data_lvl2_d5[i5], data_lvl2_d6[i6], $
		psize=pix, erange=erange, trange=tr, index=[1,1,1,1,1,1,1], thr_n=4., /nowin, /xycor )

map0 = make_map( img0, xcen=0., ycen=0., dx=pix, dy=pix, id='D0',time=anytim( anytim(t0)+tr[0], /yo))
map1 = make_map( img1, xcen=0., ycen=0., dx=pix, dy=pix, id='D1',time=anytim( anytim(t0)+tr[0], /yo))
map2 = make_map( img2, xcen=0., ycen=0., dx=pix, dy=pix, id='D2',time=anytim( anytim(t0)+tr[0], /yo))
map3 = make_map( img3, xcen=0., ycen=0., dx=pix, dy=pix, id='D3',time=anytim( anytim(t0)+tr[0], /yo))
map4 = make_map( img4, xcen=0., ycen=0., dx=pix, dy=pix, id='D4',time=anytim( anytim(t0)+tr[0], /yo))
map5 = make_map( img5, xcen=0., ycen=0., dx=pix, dy=pix, id='D5',time=anytim( anytim(t0)+tr[0], /yo))
map6 = make_map( img6, xcen=0., ycen=0., dx=pix, dy=pix, id='D6',time=anytim( anytim(t0)+tr[0], /yo))
map  = make_map( img,  xcen=0., ycen=0., dx=pix, dy=pix, id='All',time=anytim( anytim(t0)+tr[0], /yo))

!p.multi=[0,2,4]
loadct,5
TVLCT, r, g, b, /get
TVLCT, reverse(r), reverse(g), reverse(b)
cen=center
targ=target
popen, file, xsi=5, ysi=10
plot_map, map0, /limb, /cbar, cen=cen, fov=fov, color=255, dmax=max, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=0, target=targ, col=255, /xycor
plot_map, map1, /limb, /cbar, cen=cen, fov=fov, color=255, dmax=max, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=1, target=targ, col=255, /xycor
plot_map, map2, /limb, /cbar, cen=cen, fov=fov, color=255, dmax=max, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=2, target=targ, col=255, /xycor
plot_map, map3, /limb, /cbar, cen=cen, fov=fov, color=255, dmax=max, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=3, target=targ, col=255, /xycor
plot_map, map4, /limb, /cbar, cen=cen, fov=fov, color=255, dmax=max, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=4, target=targ, col=255, /xycor
plot_map, map5, /limb, /cbar, cen=cen, fov=fov, color=255, dmax=max, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=5, target=targ, col=255, /xycor
plot_map, map6, /limb, /cbar, cen=cen, fov=fov, color=255, dmax=max, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=6, target=targ, col=255, /xycor
plot_map, map, /limb, /cbar, cen=cen, fov=fov, color=255, dmax=max, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, /all, target=targ, col=255, /xycor
pclose

END