add_path, 'img'

; store times for ease in looking at any target interval.
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

; restore Level 2 data and select the known good events.
restore, 'data_2012/foxsi_level2_data.sav', /v
d0 = data_lvl2_d0[ where( data_lvl2_d0.error_flag eq 0 ) ]
d1 = data_lvl2_d1[ where( data_lvl2_d1.error_flag eq 0 ) ]
d2 = data_lvl2_d2[ where( data_lvl2_d2.error_flag eq 0 ) ]
d3 = data_lvl2_d3[ where( data_lvl2_d3.error_flag eq 0 ) ]
d4 = data_lvl2_d4[ where( data_lvl2_d4.error_flag eq 0 ) ]
d5 = data_lvl2_d5[ where( data_lvl2_d5.error_flag eq 0 ) ]
d6 = data_lvl2_d6[ where( data_lvl2_d6.error_flag eq 0 ) ]

; choose parameters for image.
pix=7.8
erange=[4,15]
tr = [t4_start, t4_end]
ind = [1,0,1,0,1,1,1]

; make image and store in a map.
img = foxsi_image_solar_int( d0,d1,d2,d3,d4,d5,d6, psize=pix, erange=erange, trange=tr, $
							 index=ind, /xycor, thr_n=4., /nowin )
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, id='', $
				time=anytim( anytim(t0)+tr[0], /yo) )
plot_map, map, /limb, /cbar, center=[960,-210], fov=2
