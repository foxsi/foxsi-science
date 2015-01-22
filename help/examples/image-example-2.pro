; Set auto parameters for 2014 flight.
@foxsi-setup-script-2014

; Choose the time range and location.
trange = [t1_pos2_start, t1_pos2_end]	; time range
xc = cen1_pos2[0]					; coords for Target 1
yc = cen1_pos2[1]

time=anytim('2014-12-11') + average(trange)+tlaunch
time = anytim( time, /yo )

; Basic image production
image6 = foxsi_image_det( data_lvl2_d6, year=2014, trange=trange, $ 
erange=[4.,15.], thr_n=4. )
map6 = make_map( image6, dx=7.78, dy=7.78, xcen=xc, ycen=yc, $
time=time, id='D6' )

; Apply a coarse offset gleaned from comparing images with AIA.
map6 = shift_map( map6, shift6[0], shift6[1] )

; Rotate the image based on the rotation angle for that specific detector.
map6 = rot_map( map6, rot6 )
map6.roll_angle = 0
map6.roll_center = 0

loadct, 5
plot_map, map6
plot_map, map6, /log
