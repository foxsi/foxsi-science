tr=[t1_pos0_start,t2_pos1_end]
dt = 15.

d0 = data_lvl2_d0[ where(data_lvl2_d0.error_flag eq 0) ]
d1 = data_lvl2_d1[ where(data_lvl2_d1.error_flag eq 0) ]
d4 = data_lvl2_d4[ where(data_lvl2_d4.error_flag eq 0) ]
d5 = data_lvl2_d5[ where(data_lvl2_d5.error_flag eq 0) ]
d6 = data_lvl2_d6[ where(data_lvl2_d6.error_flag eq 0) ]

.r
undefine, m0
undefine, m1
undefine, m4
undefine, m5
undefine, m6
for i=0, fix((tr[1]-tr[0]-1)/dt) do begin
	tint = tr[0]+dt*[i,i+1]
	if tint[1] lt t1_pos0_end then cen=cen1_pos0 $
	else if tint[1] lt t1_pos1_end then cen=cen1_pos1 $
	else if tint[1] lt t1_pos2_end then cen=cen2_pos1
	n0 = foxsi_image_map(d0, cen, tra=tint, era=[4.,8.])
	n1 = foxsi_image_map(d1, cen, tra=tint, era=[4.,8.])
	n4 = foxsi_image_map(d4, cen, tra=tint, era=[4.,8.])
	n5 = foxsi_image_map(d5, cen, tra=tint, era=[4.,8.])
	n6 = foxsi_image_map(d6, cen, tra=tint, era=[4.,8.])
	n0.data = smooth(n0.data, 2)
	n1.data = smooth(n1.data, 2)
	n4.data = smooth(n4.data, 2)
	n5.data = smooth(n5.data, 2)
	n6.data = smooth(n6.data, 2)
	push, m0, n0
	push, m1, n1
	push, m4, n4
	push, m5, n5
	push, m6, n6
endfor
end
;movie_map, m, /log, cen=[0,-250], fov=3
;movie_map, m0, cen=[0,-250], fov=5, /nosc
;movie_map, m6, cen=[0,-250], fov=5, /nosc

!p.multi=[0,6,5]
for i=0,5 do plot_map, m0[i], cen=[0,-250], fov=5, /log, dmin=0.1, dmax=max(m0.data)
for i=0,5 do plot_map, m1[i], cen=[0,-250], fov=5, /log, dmin=0.1, dmax=max(m1.data)
for i=0,5 do plot_map, m4[i], cen=[0,-250], fov=5, /log, dmin=0.1, dmax=max(m1.data)
for i=0,5 do plot_map, m5[i], cen=[0,-250], fov=5, /log, dmin=0.1, dmax=max(m1.data)
for i=0,5 do plot_map, m6[i], cen=[0,-250], fov=5, /log, dmin=0.1, dmax=max(m6.data)


sub = make_submap( m, cen=[-400,-300], fov=3 )

; Make a map for the first target, after all adjustments are done ("target 1, pos 2")
map_all = foxsi_image_map( data_lvl2_d6, cen1_pos2, tra=[t1_pos2_start,t1_pos2_end])
plot_map, map_all
plot_map, map_all, /log

; Try to narrow the data down to an area of the disk.
cut = area_cut(data_lvl2_d6, [0.,-300], 200., /xy)
map_cut = foxsi_image_map(cut, cen1_pos2, tra=[t1_pos2_start,t1_pos2_end])       
plot_map, map_cut


d0 = data_lvl2_d0[ where(data_lvl2_d0.error_flag eq 0 and data_lvl2_d0.hit_energy[1] gt 4. and data_lvl2_d0.hit_energy[1] lt 15.) ]
d1 = data_lvl2_d1[ where(data_lvl2_d1.error_flag eq 0 and data_lvl2_d1.hit_energy[1] gt 4. and data_lvl2_d1.hit_energy[1] lt 15.) ]
d4 = data_lvl2_d4[ where(data_lvl2_d4.error_flag eq 0 and data_lvl2_d4.hit_energy[1] gt 4. and data_lvl2_d4.hit_energy[1] lt 15.) ]
d5 = data_lvl2_d5[ where(data_lvl2_d5.error_flag eq 0 and data_lvl2_d5.hit_energy[1] gt 4. and data_lvl2_d5.hit_energy[1] lt 15.) ]
d6 = data_lvl2_d6[ where(data_lvl2_d6.error_flag eq 0 and data_lvl2_d6.hit_energy[1] gt 4. and data_lvl2_d6.hit_energy[1] lt 15.) ]

plot, d6.wsmr_time, d6.hit_xy_solar[0,*]+360., /psy, yr=[-500,500]

dt = 5.
dy = 10.
min1=fix(min(d6.wsmr_time-tlaunch))
max1=fix(max(d6.wsmr_time-tlaunch))
nbin1=fix((max1-min1)/dt)
min2=fix(min(d6.hit_xy_solar[0,*]+360.))
max2=fix(max(d6.hit_xy_solar[0,*]+360.))
nbin2=fix((max2-min2)/dy)
im = hist_2d( d6.wsmr_time-tlaunch, d6.hit_xy_solar[0,*]+360., bin1=dt, bin2=dy, min1=min1, max1=max1, min2=min2, max2=max2 )

t = findgen( nbin1+1 ) + min1
y = findgen( nbin2+1 ) + min2
spec = spectrogram(im, t, y)
spec->plot, yr=[-950,-850], /log

