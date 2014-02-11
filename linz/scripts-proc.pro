; Create Level 0 data
.compile wsmr_data_to_level0
filename = 'data_2012/36.255_TM2_Flight_2012-11-02.log'
data_lvl0_D0 = wsmr_data_to_level0( filename, det=0 )
data_lvl0_D1 = wsmr_data_to_level0( filename, det=1 )
data_lvl0_D2 = wsmr_data_to_level0( filename, det=2 )
data_lvl0_D3 = wsmr_data_to_level0( filename, det=3 )
data_lvl0_D4 = wsmr_data_to_level0( filename, det=4 )
data_lvl0_D5 = wsmr_data_to_level0( filename, det=5 )
data_lvl0_D6 = wsmr_data_to_level0( filename, det=6 )
save, data_lvl0_D0, data_lvl0_D1, data_lvl0_D2, data_lvl0_D3, data_lvl0_D4, $
	data_lvl0_D5, data_lvl0_d6, $
	file = 'data_2012/foxsi_level0_data.sav'

; Create Level 1 data
.compile foxsi_level0_to_level1
filename = 'data_2012/foxsi_level0_data.sav'
data_lvl1_D0 = foxsi_level0_to_level1( filename, det=0 )
data_lvl1_D1 = foxsi_level0_to_level1( filename, det=1 )
data_lvl1_D2 = foxsi_level0_to_level1( filename, det=2 )
data_lvl1_D3 = foxsi_level0_to_level1( filename, det=3 )
data_lvl1_D4 = foxsi_level0_to_level1( filename, det=4 )
data_lvl1_D5 = foxsi_level0_to_level1( filename, det=5 )
data_lvl1_D6 = foxsi_level0_to_level1( filename, det=6 )
save, data_lvl1_D0, data_lvl1_D1, data_lvl1_D2, data_lvl1_D3, data_lvl1_D4, $
	data_lvl1_D5, data_lvl1_d6, $
	file = 'data_2012/foxsi_level1_data.sav'

; Plot positions from Level 1 data
t_launch = 64500
t4_start = t_launch + 340		; Target 4 (flare)
t4_end = t_launch + 421.2
d=data_lvl1_d6
i=where(d.error_flag eq 0 and d.wsmr_time gt t4_start and d.wsmr_time lt t4_end )
;plot,d[i].hit_xy_pay[0],d[i].hit_xy_pay[1],/psy
plot,d[i].hit_xy_pay[0],d[i].hit_xy_pay[1],/psy, xr=[200,400], yr=[200,400]
oplot, [median(d[i].hit_xy_pay[0])], [median(d[i].hit_xy_pay[1])], color=144, $
	/psy, symsize=4, thick=4
print, median( d[i].hit_xy_pay[0] ), median( d[i].hit_xy_pay[1] )
;oplot,[350],[270],/psy,color=6,symsize=5,thick=3

; Create Level 2 data
file0 = 'data_2012/foxsi_level0_data.sav'
file1 = 'data_2012/foxsi_level1_data.sav'
cal0 = 'detector_data/peaks_det108.sav'
cal1 = 'detector_data/peaks_det109.sav'
cal2 = 'detector_data/peaks_det102.sav'
cal3 = 'detector_data/peaks_det103.sav'
cal4 = 'detector_data/peaks_det104.sav'
cal5 = 'detector_data/peaks_det105.sav'
cal6 = 'detector_data/peaks_det106.sav'
data_lvl2_D0 = foxsi_level1_to_level2( file0, file1, det=0, calib=cal0 )
data_lvl2_D1 = foxsi_level1_to_level2( file0, file1, det=1, calib=cal1 )
data_lvl2_D2 = foxsi_level1_to_level2( file0, file1, det=2, calib=cal2 )
data_lvl2_D3 = foxsi_level1_to_level2( file0, file1, det=3, calib=cal3 )
data_lvl2_D4 = foxsi_level1_to_level2( file0, file1, det=4, calib=cal4 )
data_lvl2_D5 = foxsi_level1_to_level2( file0, file1, det=5, calib=cal5 )
data_lvl2_D6 = foxsi_level1_to_level2( file0, file1, det=6, calib=cal6 )
save, data_lvl2_D0, data_lvl2_D1, data_lvl2_D2, data_lvl2_D3, $
	data_lvl2_D4, data_lvl2_D5, data_lvl2_d6, $
	file = 'data_2012/foxsi_level2_data.sav'


;
;	Look at a sequence test file for comparison.
;

filename = 'data_2012/36.255_TM2_T-1hr_Vert_2012-11-02.log'
data_lvl0_D0 = wsmr_data_to_level0( filename, det=0 )
data_lvl0_D1 = wsmr_data_to_level0( filename, det=1 )
data_lvl0_D2 = wsmr_data_to_level0( filename, det=2 )
data_lvl0_D3 = wsmr_data_to_level0( filename, det=3 )
data_lvl0_D4 = wsmr_data_to_level0( filename, det=4 )
data_lvl0_D5 = wsmr_data_to_level0( filename, det=5 )
data_lvl0_D6 = wsmr_data_to_level0( filename, det=6 )
save, data_lvl0_D0, data_lvl0_D1, data_lvl0_D2, data_lvl0_D3, data_lvl0_D4, $
	data_lvl0_D5, data_lvl0_d6, $
	file = 'data_2012/sequence_level0_data.sav'

; Create Level 1 data
filename = 'data_2012/sequence_level0_data.sav'
data_lvl1_D0 = foxsi_level0_to_level1( filename, det=0 )
data_lvl1_D1 = foxsi_level0_to_level1( filename, det=1 )
data_lvl1_D2 = foxsi_level0_to_level1( filename, det=2 )
data_lvl1_D3 = foxsi_level0_to_level1( filename, det=3 )
data_lvl1_D4 = foxsi_level0_to_level1( filename, det=4 )
data_lvl1_D5 = foxsi_level0_to_level1( filename, det=5 )
data_lvl1_D6 = foxsi_level0_to_level1( filename, det=6 )
save, data_lvl1_D0, data_lvl1_D1, data_lvl1_D2, data_lvl1_D3, data_lvl1_D4, $
	data_lvl1_D5, data_lvl1_d6, $
	file = 'data_2012/sequence_level1_data.sav'

; Create Level 2 data
file0 = 'data_2012/sequence_level0_data.sav'
file1 = 'data_2012/sequence_level1_data.sav'
cal0 = 'detector_data/peaks_det108.sav'
cal1 = 'detector_data/peaks_det109.sav'
cal2 = 'detector_data/peaks_det102.sav'
cal3 = 'detector_data/peaks_det103.sav'
cal4 = 'detector_data/peaks_det104.sav'
cal5 = 'detector_data/peaks_det105.sav'
cal6 = 'detector_data/peaks_det106.sav'
data_lvl2_D0 = foxsi_level1_to_level2( file0, file1, det=0, calib=cal0, /ground )
data_lvl2_D1 = foxsi_level1_to_level2( file0, file1, det=1, calib=cal1, /ground )
data_lvl2_D2 = foxsi_level1_to_level2( file0, file1, det=2, calib=cal2, /ground )
data_lvl2_D3 = foxsi_level1_to_level2( file0, file1, det=3, calib=cal3, /ground )
data_lvl2_D4 = foxsi_level1_to_level2( file0, file1, det=4, calib=cal4, /ground )
data_lvl2_D5 = foxsi_level1_to_level2( file0, file1, det=5, calib=cal5, /ground )
data_lvl2_D6 = foxsi_level1_to_level2( file0, file1, det=6, calib=cal6, /ground )
save, data_lvl2_D0, data_lvl2_D1, data_lvl2_D2, data_lvl2_D3, $
	data_lvl2_D4, data_lvl2_D5, data_lvl2_d6, $
	file = 'data_2012/sequence_level2_data.sav'

i0=where(data_lvl2_d0.hv eq 200)
i1=where(data_lvl2_d1.hv eq 200)
i2=where(data_lvl2_d2.hv eq 200)
i3=where(data_lvl2_d3.hv eq 200)
i4=where(data_lvl2_d4.hv eq 200)
i5=where(data_lvl2_d5.hv eq 200)
i6=where(data_lvl2_d6.hv eq 200)

; Plot basic spectra
spex0=make_spectrum( data_lvl2_d0[i0], bin=0.5, /corr )
spex1=make_spectrum( data_lvl2_d1[i1], bin=0.5, /corr  )
spex2=make_spectrum( data_lvl2_d2[i2], bin=0.5, /corr  )
spex3=make_spectrum( data_lvl2_d3[i3], bin=0.5, /corr  )
spex4=make_spectrum( data_lvl2_d4[i4], bin=0.5, /corr  )
spex5=make_spectrum( data_lvl2_d5[i5], bin=0.5, /corr  )
spex6=make_spectrum( data_lvl2_d6[i6], bin=0.5, /corr  )
sum = spex0.spec_p + spex1.spec_p + spex2.spec_p + spex3.spec_p $
	 + spex4.spec_p + spex5.spec_p + spex6.spec_p

plot, spex0.energy_kev, sum, psym=10

;
; Look at alignment images to check orientation.
; (Data taken postflight, Nov. 3 2012)
;

@linz/foxsi-setup-script
.compile cal_data_to_level0

f0 = '~/FOXSI-calib/20121103/data_121103_2028.dat'
f1 = '~/FOXSI-calib/20121103/data_121103_2048.dat'
f2 = '~/FOXSI-calib/20121103/data_121103_2041.dat'
f4 = '~/FOXSI-calib/20121103/data_121103_2037.dat'
f5 = '~/FOXSI-calib/20121103/data_121103_2033.dat'
;f6 = '~/FOXSI-calib/20121103/data_121103_1928.dat'
f6 = '~/FOXSI-calib/20121103/data_121103_1939.dat'
data_121103_2037.dat

data_lvl0_d0 = formatter_data_to_level0( f0, det=0)
data_lvl0_d1 = formatter_data_to_level0( f1, det=1)
data_lvl0_d2 = formatter_data_to_level0( f2, det=2)
data_lvl0_d4 = formatter_data_to_level0( f4, det=4)
data_lvl0_d5 = formatter_data_to_level0( f5, det=5)
data_lvl0_d6 = formatter_data_to_level0( f6, det=6)
save, data_lvl0_d0, data_lvl0_d1, data_lvl0_d2, data_lvl0_d4, data_lvl0_d5, data_lvl0_d6, $
	file = 'data_2012/post-check-lvl0.sav'

data_lvl1_d0 = foxsi_level0_to_level1( 'data_2012/post-check-lvl0.sav', det=0 )
data_lvl1_d1 = foxsi_level0_to_level1( 'data_2012/post-check-lvl0.sav', det=1 )
data_lvl1_d2 = foxsi_level0_to_level1( 'data_2012/post-check-lvl0.sav', det=2 )
data_lvl1_d4 = foxsi_level0_to_level1( 'data_2012/post-check-lvl0.sav', det=4 )
data_lvl1_d5 = foxsi_level0_to_level1( 'data_2012/post-check-lvl0.sav', det=5 )
data_lvl1_d6 = foxsi_level0_to_level1( 'data_2012/post-check-lvl0.sav', det=6 )
save, data_lvl1_d0, data_lvl1_d1, data_lvl1_d2, data_lvl1_d4, data_lvl1_d5, data_lvl1_d6, $
	file = 'data_2012/post-check-lvl1.sav'

cal0 = 'detector_data/peaks_det108.sav'
cal1 = 'detector_data/peaks_det109.sav'
cal2 = 'detector_data/peaks_det102.sav'
cal3 = 'detector_data/peaks_det103.sav'
cal4 = 'detector_data/peaks_det104.sav'
cal5 = 'detector_data/peaks_det105.sav'
cal6 = 'detector_data/peaks_det106.sav'

d0 = foxsi_level1_to_level2( 'data_2012/post-check-lvl0.sav', 'data_2012/post-check-lvl1.sav', det=0, calib=cal0, /ground )
d1 = foxsi_level1_to_level2( 'data_2012/post-check-lvl0.sav', 'data_2012/post-check-lvl1.sav', det=1, calib=cal1, /ground )
d2 = foxsi_level1_to_level2( 'data_2012/post-check-lvl0.sav', 'data_2012/post-check-lvl1.sav', det=2, calib=cal2, /ground )
d4 = foxsi_level1_to_level2( 'data_2012/post-check-lvl0.sav', 'data_2012/post-check-lvl1.sav', det=4, calib=cal4, /ground )
d5 = foxsi_level1_to_level2( 'data_2012/post-check-lvl0.sav', 'data_2012/post-check-lvl1.sav', det=5, calib=cal5, /ground )
d6 = foxsi_level1_to_level2( 'data_2012/post-check-lvl0.sav', 'data_2012/post-check-lvl1.sav', det=6, calib=cal6, /ground )

save, d0,d1,d2,d4,d5,d6, file='data_2012/post-check-lvl2.sav'

pix=10.
img0 = foxsi_image_solar(d0, 0, psize=pix, tr=[-100000.,100000.])
img1 = foxsi_image_solar(d1, 1, psize=pix, tr=[-100000.,100000.])
img2 = foxsi_image_solar(d2, 2, psize=pix, tr=[-100000.,100000.])
img4 = foxsi_image_solar(d4, 4, psize=pix, tr=[-100000.,100000.])
img5 = foxsi_image_solar(d5, 5, psize=pix, tr=[-100000.,100000.])
img6 = foxsi_image_solar(d6, 6, psize=pix, tr=[-100000.,100000.])
map0 = make_map( img0, xcen=0., ycen=0., dx=pix, dy=pix )
map1 = make_map( img1, xcen=0., ycen=0., dx=pix, dy=pix )
map2 = make_map( img2, xcen=0., ycen=0., dx=pix, dy=pix )
map4 = make_map( img4, xcen=0., ycen=0., dx=pix, dy=pix )
map5 = make_map( img5, xcen=0., ycen=0., dx=pix, dy=pix )
map6 = make_map( img6, xcen=0., ycen=0., dx=pix, dy=pix )

!p.multi=[0,2,3]
ch=1.2
popen, 'post-flight-alignment', xsi=6, ysi=9
plot_map, map0, fov=16, charsi=ch, dmax=50
plot_map, map1, fov=16, charsi=ch
plot_map, map2, fov=16, charsi=ch
plot_map, map4, fov=16, charsi=ch
plot_map, map5, fov=16, charsi=ch
plot_map, map6, fov=16, charsi=ch
pclose


i0=where(data_lvl2_d0.hv eq 200)
i1=where(data_lvl2_d1.hv eq 200)
i2=where(data_lvl2_d2.hv eq 200)
i3=where(data_lvl2_d3.hv eq 200)
i4=where(data_lvl2_d4.hv eq 200)
i5=where(data_lvl2_d5.hv eq 200)
i6=where(data_lvl2_d6.hv eq 200)


;-----

t1=t1_start
t2=t3_end
e1=3
e2=15

i0 = where( data_lvl2_d0.error_flag eq 0 $
	and data_lvl2_d0.wsmr_time gt t1 and data_lvl2_d0.wsmr_time lt t2  $
	and data_lvl2_d0.hit_energy[1] gt e1 $
	and data_lvl2_d0.hit_energy[1] lt e2 $
	)
i1 = where( data_lvl2_d1.error_flag eq 0 and  $
	data_lvl2_d1.wsmr_time gt t1 and data_lvl2_d1.wsmr_time lt t2 and  $
	data_lvl2_d1.hit_energy[1] gt e1 and $
	data_lvl2_d1.hit_energy[1] lt e2 )
i2 = where( data_lvl2_d2.error_flag eq 0 and  $
	data_lvl2_d2.wsmr_time gt t1 and data_lvl2_d2.wsmr_time lt t2 and  $
	data_lvl2_d2.hit_energy[1] gt e1 and $
	data_lvl2_d2.hit_energy[1] lt e2 )
i3 = where( data_lvl2_d3.error_flag eq 0 and  $
	data_lvl2_d3.wsmr_time gt t1 and data_lvl2_d3.wsmr_time lt t2 and $ 
	data_lvl2_d3.hit_energy[1] gt e1 and $
	data_lvl2_d3.hit_energy[1] lt e2 )
i4 = where( data_lvl2_d4.error_flag eq 0 and  $
	data_lvl2_d4.wsmr_time gt t1 and data_lvl2_d4.wsmr_time lt t2 and  $
	data_lvl2_d4.hit_energy[1] gt e1 and $
	data_lvl2_d4.hit_energy[1] lt e2 )
i5 = where( data_lvl2_d5.error_flag eq 0 and  $
	data_lvl2_d5.wsmr_time gt t1 and data_lvl2_d5.wsmr_time lt t2 and  $
	data_lvl2_d5.hit_energy[1] gt e1 and $
	data_lvl2_d5.hit_energy[1] lt e2 )
i6 = where( data_lvl2_d6.error_flag eq 0 and  $
	data_lvl2_d6.wsmr_time gt t1 and data_lvl2_d6.wsmr_time lt t2 and  $
	data_lvl2_d6.hit_energy[1] gt e1 and $
	data_lvl2_d6.hit_energy[1] lt e2 )

; Plot basic spectra
spex0=make_spectrum( data_lvl2_d0[i0], bin=1.0);, /corr )
spex1=make_spectrum( data_lvl2_d1[i1], bin=1.0);, /corr  )
spex2=make_spectrum( data_lvl2_d2[i2], bin=1.0);, /corr  )
spex3=make_spectrum( data_lvl2_d3[i3], bin=1.0);, /corr  )
spex4=make_spectrum( data_lvl2_d4[i4], bin=1.0);, /corr  )
spex5=make_spectrum( data_lvl2_d5[i5], bin=1.0);, /corr  )
spex6=make_spectrum( data_lvl2_d6[i6], bin=1.0);, /corr  )
sum = spex0.spec_p + spex2.spec_p + spex4.spec_p + spex5.spec_p + spex6.spec_p

plot, spex6.energy_kev, spex6.spec_p, psym=10, /xlo, /ylo, xr=[2.,20.], yr=[1.,100.]

;
; Repeat for preflight data 
;

f0 = '~/FOXSI-calib/20121024/data_121024_2349.dat'
f1 = '~/FOXSI-calib/20121024/data_121024_2202.dat'
f2 = '~/FOXSI-calib/20121024/data_121024_2218.dat'
f3 = '~/FOXSI-calib/20121024/data_121024_2233.dat'
f4 = '~/FOXSI-calib/20121024/data_121024_2248.dat'
f5 = '~/FOXSI-calib/20121024/data_121024_2335.dat'
f6 = '~/FOXSI-calib/20121004/data_121004_161700.dat'

; translated vertically
f0 = '~/FOXSI-calib/20121024/data_121025_0139_det0_translateY.dat'
f1 = '~/FOXSI-calib/20121024/data_121025_0144_det1_translateY.dat'
f2 = '~/FOXSI-calib/20121024/data_121025_0150_det2_translateY.dat'
f3 = '~/FOXSI-calib/20121024/data_121025_0155_det3_translateY.dat'
f4 = '~/FOXSI-calib/20121024/data_121025_0203_det4_translateY.dat'
f5 = '~/FOXSI-calib/20121024/data_121025_0134_det5_translateY.dat'
f6 = '~/FOXSI-calib/20121024/data_121025_0159_det6_translateY.dat'

data_lvl0_d0 = formatter_data_to_level0( f0, det=0)
data_lvl0_d1 = formatter_data_to_level0( f1, det=1)
data_lvl0_d2 = formatter_data_to_level0( f2, det=2)
data_lvl0_d3 = formatter_data_to_level0( f3, det=3)
data_lvl0_d4 = formatter_data_to_level0( f4, det=4)
data_lvl0_d5 = formatter_data_to_level0( f5, det=5)
data_lvl0_d6 = formatter_data_to_level0( f6, det=6)
save, data_lvl0_d0, data_lvl0_d1, data_lvl0_d2, data_lvl0_d3, data_lvl0_d4, data_lvl0_d5,$
	data_lvl0_d6, file = 'data_2012/pre-check-lvl0.sav'

data_lvl1_d0 = foxsi_level0_to_level1( 'data_2012/pre-check-lvl0.sav', det=0 )
data_lvl1_d1 = foxsi_level0_to_level1( 'data_2012/pre-check-lvl0.sav', det=1 )
data_lvl1_d2 = foxsi_level0_to_level1( 'data_2012/pre-check-lvl0.sav', det=2 )
data_lvl1_d3 = foxsi_level0_to_level1( 'data_2012/pre-check-lvl0.sav', det=3 )
data_lvl1_d4 = foxsi_level0_to_level1( 'data_2012/pre-check-lvl0.sav', det=4 )
data_lvl1_d5 = foxsi_level0_to_level1( 'data_2012/pre-check-lvl0.sav', det=5 )
data_lvl1_d6 = foxsi_level0_to_level1( 'data_2012/pre-check-lvl0.sav', det=6 )
save, data_lvl1_d0, data_lvl1_d1, data_lvl1_d2, data_lvl1_d4, data_lvl1_d5, data_lvl1_d3,$
	data_lvl1_d6, file = 'data_2012/pre-check-lvl1.sav'

cal0 = 'detector_data/peaks_det108.sav'
cal1 = 'detector_data/peaks_det109.sav'
cal2 = 'detector_data/peaks_det102.sav'
cal3 = 'detector_data/peaks_det103.sav'
cal4 = 'detector_data/peaks_det104.sav'
cal5 = 'detector_data/peaks_det105.sav'
cal6 = 'detector_data/peaks_det106.sav'

d0 = foxsi_level1_to_level2( 'data_2012/pre-check-lvl0.sav', 'data_2012/pre-check-lvl1.sav', det=0, calib=cal0, /ground )
d1 = foxsi_level1_to_level2( 'data_2012/pre-check-lvl0.sav', 'data_2012/pre-check-lvl1.sav', det=1, calib=cal1, /ground )
d2 = foxsi_level1_to_level2( 'data_2012/pre-check-lvl0.sav', 'data_2012/pre-check-lvl1.sav', det=2, calib=cal2, /ground )
d4 = foxsi_level1_to_level2( 'data_2012/pre-check-lvl0.sav', 'data_2012/pre-check-lvl1.sav', det=4, calib=cal4, /ground )
d5 = foxsi_level1_to_level2( 'data_2012/pre-check-lvl0.sav', 'data_2012/pre-check-lvl1.sav', det=5, calib=cal5, /ground )
d6 = foxsi_level1_to_level2( 'data_2012/pre-check-lvl0.sav', 'data_2012/pre-check-lvl1.sav', det=6, calib=cal6, /ground )

save, d0,d1,d2,d4,d5,d6, file='data_2012/pre-check-lvl2.sav'

; Compare pre- and post-flight data.

restore, 'data_2012/pre-check-lvl2.sav'
pre0 = d0
pre1 = d1
pre2 = d2
pre4 = d4
pre5 = d5
pre6 = d6
restore, 'data_2012/post-check-lvl2.sav'
post0 = d0
post1 = d1
post2 = d2
post4 = d4
post5 = d5
post6 = d6

t0_pre  = (pre0[ n_elements(pre0)-1 ].frame_time - pre0[0].frame_time)*1.e-7
t1_pre  = (pre1[ n_elements(pre1)-1 ].frame_time - pre1[0].frame_time)*1.e-7
t2_pre  = (pre2[ n_elements(pre2)-1 ].frame_time - pre2[0].frame_time)*1.e-7
t4_pre  = (pre4[ n_elements(pre4)-1 ].frame_time - pre4[0].frame_time)*1.e-7
t5_pre  = (pre5[ n_elements(pre5)-1 ].frame_time - pre5[0].frame_time)*1.e-7
t6_pre  = (pre6[ n_elements(pre6)-1 ].frame_time - pre6[0].frame_time)*1.e-7
t0_post = (post0[ n_elements(post0)-1 ].frame_time - post0[0].frame_time)*1.e-7
t1_post = (post1[ n_elements(post1)-1 ].frame_time - post1[0].frame_time)*1.e-7
t2_post = (post2[ n_elements(post2)-1 ].frame_time - post2[0].frame_time)*1.e-7
t4_post = (post4[ n_elements(post4)-1 ].frame_time - post4[0].frame_time)*1.e-7
t5_post = (post5[ n_elements(post5)-1 ].frame_time - post5[0].frame_time)*1.e-7
t6_post = (post6[ n_elements(post6)-1 ].frame_time - post6[0].frame_time)*1.e-7

pre0[ where( pre0.error_flag eq 8 ) ].error_flag = 0
pre1[ where( pre1.error_flag eq 8 ) ].error_flag = 0
pre2[ where( pre2.error_flag eq 8 ) ].error_flag = 0
pre4[ where( pre4.error_flag eq 8 ) ].error_flag = 0
pre5[ where( pre5.error_flag eq 8 ) ].error_flag = 0
pre6[ where( pre6.error_flag eq 8 ) ].error_flag = 0
post0[ where( post0.error_flag eq 8 ) ].error_flag = 0
post1[ where( post1.error_flag eq 8 ) ].error_flag = 0
post2[ where( post2.error_flag eq 8 ) ].error_flag = 0
post4[ where( post4.error_flag eq 8 ) ].error_flag = 0
post5[ where( post5.error_flag eq 8 ) ].error_flag = 0
post6[ where( post6.error_flag eq 8 ) ].error_flag = 0
pre0.inflight = 1
pre1.inflight = 1
pre2.inflight = 1
pre4.inflight = 1
pre5.inflight = 1
pre6.inflight = 1
post0.inflight = 1
post1.inflight = 1
post2.inflight = 1
post4.inflight = 1
post5.inflight = 1
post6.inflight = 1

spex_pre0=make_spectrum( pre0, bin=0.3, /corr)
spex_pre1=make_spectrum( pre1, bin=0.3, /corr)
spex_pre2=make_spectrum( pre2, bin=0.3, /corr)
spex_pre4=make_spectrum( pre4, bin=0.3, /corr)
spex_pre5=make_spectrum( pre5, bin=0.3, /corr)
spex_pre6=make_spectrum( pre6, bin=0.3, /corr)
spex_post0=make_spectrum( post0, bin=0.3, /corr)
spex_post1=make_spectrum( post1, bin=0.3, /corr)
spex_post2=make_spectrum( post2, bin=0.3, /corr)
spex_post4=make_spectrum( post4, bin=0.3, /corr)
spex_post5=make_spectrum( post5, bin=0.3, /corr)
spex_post6=make_spectrum( post6, bin=0.3, /corr)

spex_pre0.spec_p = spex_pre0.spec_p / t0_pre
spex_pre1.spec_p = spex_pre1.spec_p / t1_pre
spex_pre2.spec_p = spex_pre2.spec_p / t2_pre
spex_pre4.spec_p = spex_pre4.spec_p / t4_pre
spex_pre5.spec_p = spex_pre5.spec_p / t5_pre
spex_pre6.spec_p = spex_pre6.spec_p / t6_pre
spex_post0.spec_p = spex_post0.spec_p / t0_post
spex_post1.spec_p = spex_post1.spec_p / t1_post
spex_post2.spec_p = spex_post2.spec_p / t2_post
spex_post4.spec_p = spex_post4.spec_p / t4_post
spex_post5.spec_p = spex_post5.spec_p / t5_post
spex_post6.spec_p = spex_post6.spec_p / t6_post

; blanketing ratios
mylar=82.55
al=2.6
kapton=203.2
area = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/')
areaX2 = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/', $
			mylar=2.*mylar, al=2*al, kap=2*kapton)
areaX4 = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/', $
			mylar=4.*mylar, al=4*al, kap=4*kapton)
areaX6 = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/', $
			mylar=6.*mylar, al=6*al, kap=6*kapton)

!p.multi=[0,2,3]
th=6
ch=1.1
imax=57
plot, spex_pre0.energy_kev, spex_pre0.spec_p/spex_pre0.spec_p[imax], psym=10, /xlo, /ylo, xr=[2.,30.], yr=[1.e-4,1.2], thick=th, xtit='Energy [keV]', ytit='Normalized counts', tit='Detector 0 Trufocus spex', charsi=ch
oplot, spex_post0.energy_kev, spex_post0.spec_p/spex_post0.spec_p[imax], psym=10, color=6, thick=th
legend, ['Pre-flight','Post-flight'], line=0, thick=th, color=[0,6], charsize=0.7, box=0

plot, spex_pre1.energy_kev, spex_pre1.spec_p/spex_pre1.spec_p[imax], psym=10, /xlo, /ylo, xr=[2.,30.], yr=[1.e-4,1.2], thick=th, xtit='Energy [keV]', ytit='Normalized counts', tit='Detector 1 Trufocus spex', charsi=ch
oplot, spex_post1.energy_kev, spex_post1.spec_p/spex_post1.spec_p[imax], psym=10, color=6, thick=th
legend, ['Pre-flight','Post-flight'], line=0, thick=th, color=[0,6], charsize=0.7, box=0

plot, spex_pre2.energy_kev, spex_pre2.spec_p/spex_pre2.spec_p[imax], psym=10, /xlo, /ylo, xr=[2.,30.], yr=[1.e-4,1.2], thick=th, xtit='Energy [keV]', ytit='Normalized counts', tit='Detector 2 Trufocus spex', charsi=ch
oplot, spex_post2.energy_kev, spex_post2.spec_p/spex_post2.spec_p[imax], psym=10, color=6, thick=th
legend, ['Pre-flight','Post-flight'], line=0, thick=th, color=[0,6], charsize=0.7, box=0

plot, spex_pre4.energy_kev, spex_pre4.spec_p/spex_pre4.spec_p[imax], psym=10, /xlo, /ylo, xr=[2.,30.], yr=[1.e-4,1.2], thick=th, xtit='Energy [keV]', ytit='Normalized counts', tit='Detector 4 Trufocus spex', charsi=ch
oplot, spex_post4.energy_kev, spex_post4.spec_p/spex_post4.spec_p[imax], psym=10, color=6, thick=th
legend, ['Pre-flight','Post-flight'], line=0, thick=th, color=[0,6], charsize=0.7, box=0

plot, spex_pre5.energy_kev, spex_pre5.spec_p/spex_pre5.spec_p[imax], psym=10, /xlo, /ylo, xr=[2.,30.], yr=[1.e-4,1.2], thick=th, xtit='Energy [keV]', ytit='Normalized counts', tit='Detector 5 Trufocus spex', charsi=ch
oplot, spex_post5.energy_kev, spex_post5.spec_p/spex_post5.spec_p[imax], psym=10, color=6, thick=th
legend, ['Pre-flight','Post-flight'], line=0, thick=th, color=[0,6], charsize=0.7, box=0

plot, spex_pre6.energy_kev, spex_pre6.spec_p/spex_pre6.spec_p[imax], psym=10, /xlo, /ylo, xr=[2.,30.], yr=[1.e-4,1.2], thick=th, xtit='Energy [keV]', ytit='Normalized counts', tit='Detector 6 Trufocus spex', charsi=ch
oplot, spex_post6.energy_kev, spex_post6.spec_p/spex_post6.spec_p[imax], psym=10, color=6, thick=th
legend, ['Pre-flight','Post-flight'], line=0, thick=th, color=[0,6], charsize=0.7, box=0

plot, spex_pre0.energy_kev, (spex_post0.spec_p/spex_post0.spec_p[imax])/(spex_pre0.spec_p/spex_pre0.spec_p[imax]), psym=10, xr=[2.,30.], yr=[0,1.5], thick=th, xtit='Energy [keV]', ytit='Ratio post/pre counts', tit='Detector 0 ratio'
oplot, area.energy_kev, areaX2.eff_area_cm2/area.eff_area_cm2, thick=4, line=1
oplot, area.energy_kev, areaX4.eff_area_cm2/area.eff_area_cm2, thick=4, line=2
oplot, area.energy_kev, areaX6.eff_area_cm2/area.eff_area_cm2, thick=4, line=3
legend, ['Ratio','2X blankets', '4X blankets', '6X blankets'], line=[0,1,2,3], charsi=0.7, box=0
plot, spex_pre1.energy_kev, (spex_post1.spec_p/spex_post1.spec_p[imax])/(spex_pre1.spec_p/spex_pre1.spec_p[imax]), psym=10, xr=[2.,30.], yr=[0,1.5], thick=th, xtit='Energy [keV]', ytit='Ratio post/pre counts', tit='Detector 1 ratio'
oplot, area.energy_kev, areaX2.eff_area_cm2/area.eff_area_cm2, thick=4, line=1
oplot, area.energy_kev, areaX4.eff_area_cm2/area.eff_area_cm2, thick=4, line=2
oplot, area.energy_kev, areaX6.eff_area_cm2/area.eff_area_cm2, thick=4, line=3
legend, ['Ratio','2X blankets', '4X blankets', '6X blankets'], line=[0,1,2,3], charsi=0.7, box=0
plot, spex_pre2.energy_kev, (spex_post2.spec_p/spex_post2.spec_p[imax])/(spex_pre2.spec_p/spex_pre2.spec_p[imax]), psym=10, xr=[2.,30.], yr=[0,1.5], thick=th, xtit='Energy [keV]', ytit='Ratio post/pre counts', tit='Detector 2 ratio'
oplot, area.energy_kev, areaX2.eff_area_cm2/area.eff_area_cm2, thick=4, line=1
oplot, area.energy_kev, areaX4.eff_area_cm2/area.eff_area_cm2, thick=4, line=2
oplot, area.energy_kev, areaX6.eff_area_cm2/area.eff_area_cm2, thick=4, line=3
legend, ['Ratio','2X blankets', '4X blankets', '6X blankets'], line=[0,1,2,3], charsi=0.7, box=0
plot, spex_pre4.energy_kev, (spex_post4.spec_p/spex_post4.spec_p[imax])/(spex_pre4.spec_p/spex_pre4.spec_p[imax]), psym=10, xr=[2.,30.], yr=[0,1.5], thick=th, xtit='Energy [keV]', ytit='Ratio post/pre counts', tit='Detector 4 ratio'
oplot, area.energy_kev, areaX2.eff_area_cm2/area.eff_area_cm2, thick=4, line=1
oplot, area.energy_kev, areaX4.eff_area_cm2/area.eff_area_cm2, thick=4, line=2
oplot, area.energy_kev, areaX6.eff_area_cm2/area.eff_area_cm2, thick=4, line=3
legend, ['Ratio','2X blankets', '4X blankets', '6X blankets'], line=[0,1,2,3], charsi=0.7, box=0
plot, spex_pre5.energy_kev, (spex_post5.spec_p/spex_post5.spec_p[imax])/(spex_pre5.spec_p/spex_pre5.spec_p[imax]), psym=10, xr=[2.,30.], yr=[0,1.5], thick=th, xtit='Energy [keV]', ytit='Ratio post/pre counts', tit='Detector 5 ratio'
oplot, area.energy_kev, areaX2.eff_area_cm2/area.eff_area_cm2, thick=4, line=1
oplot, area.energy_kev, areaX4.eff_area_cm2/area.eff_area_cm2, thick=4, line=2
oplot, area.energy_kev, areaX6.eff_area_cm2/area.eff_area_cm2, thick=4, line=3
legend, ['Ratio','2X blankets', '4X blankets', '6X blankets'], line=[0,1,2,3], charsi=0.7, box=0
plot, spex_pre6.energy_kev, (spex_post6.spec_p/spex_post6.spec_p[imax])/(spex_pre6.spec_p/spex_pre6.spec_p[imax]), psym=10, xr=[2.,30.], yr=[0,1.5], thick=th, xtit='Energy [keV]', ytit='Ratio post/pre counts', tit='Detector 6 ratio'
oplot, area.energy_kev, areaX2.eff_area_cm2/area.eff_area_cm2, thick=4, line=1
oplot, area.energy_kev, areaX4.eff_area_cm2/area.eff_area_cm2, thick=4, line=2
oplot, area.energy_kev, areaX6.eff_area_cm2/area.eff_area_cm2, thick=4, line=3
legend, ['Ratio','2X blankets', '4X blankets', '6X blankets'], line=[0,1,2,3], charsi=0.7, box=0


;;;;
; Measured flight data spectra
;;;;

; For reference, times of all target windows (from RLG on or target stable to new 
; target received or RLG off)
t_launch = 64500
t1_start = t_launch + 108.3		; Target 1 (AR)
t1_end = t_launch + 151.8
t2_start = t_launch + 154.8		; Target 2 (AR)
t2_end = t_launch + 244.7
t3_start = t_launch + 247		; Target 3 (quiet Sun)
t3_end = t_launch + 337.3
t4_start = t_launch + 340		; Target 4 (flare)
t4_end = t_launch + 421.2
t5_start = t_launch + 423.5		; Target 5 (off-pointing)
t5_end = t_launch + 435.9
t6_start = t_launch + 438.5		; Target 6 (flare)
t6_end = t_launch + 498.3
t1 = t4_start
t2 = t4_end
binwidth=0.5

;;; Method 1: This is the old way to do it, using a hacked routine I wrote
;; (needed before we had Level 2 data)
;restore, 'data_2012/foxsi_level0_data.sav'
;lvl0 = data_D6
;restore, 'data_2012/foxsi_level1_data.sav'
;lvl1 = data_D6
;i=where(lvl1.error_flag eq 0 and lvl1.wsmr_time gt t1 and lvl1.wsmr_time lt t2)
;data = lvl0[i]
;spec = counts2energy_diagonal( data, peaksfile='detector_data/peaks_det106.sav', $
;	binwidth=binwidth  )
;plot,  sim.energy_kev, sim.counts., xr=[1,20],yr=[10.,1.e4], thick=4, psym=10, $
;  xtitle='Energy [keV]', ytitle='FOXSI counts/keV', /ylog, /xlog, xstyle=1, line=1, $
;  title = 'FOXSI counts for 1 minute, single optic/detector'
;oplot, spec[*,2,0], spec[*,2,1]/binwidth, psym=10, thick=4, color=6
;legend, ['Simulated flare counts','Actual D6 counts'], $
;		 thick=4, line=[1,0], color=[0,6]

;
; Try flatfielding.  For this we need to process an Am241 calibration file.
;

.compile cal_data_to_level0

file0 = file_search('~/FOXSI-calib/det108/struct_data_*_am*')
file1 = file_search('~/FOXSI-calib/det109/struct_data_*_am*')
file2 = file_search('~/FOXSI-calib/det102/struct_data_*_am*')
file3 = file_search('~/FOXSI-calib/det103/struct_data_*_am*')
file4 = file_search('~/FOXSI-calib/det104/struct_data_*_am*')
file5 = file_search('~/FOXSI-calib/det105/struct_data_*_am*')
file6 = file_search('~/FOXSI-calib/det106/struct_data_*_am*')

cal0 = 'detector_data/peaks_det108.sav'
cal1 = 'detector_data/peaks_det109.sav'
cal2 = 'detector_data/peaks_det102.sav'
cal3 = 'detector_data/peaks_det103.sav'
cal4 = 'detector_data/peaks_det104.sav'
cal5 = 'detector_data/peaks_det105.sav'
cal6 = 'detector_data/peaks_det106.sav'
cal = [cal0,cal1,cal2,cal3,cal4,cal5,cal6]

det = 6

.r
for i=0, n_elements(file6  )-1 do begin
	data_lvl0_d6     = usb_data_to_level0( file6[i]     , det=det )
	save, data_lvl0_d6     , file='data_2012/usb_lvl0-'+strtrim(i,2)+'_D'+strtrim(det,2)+'.sav'
	data_lvl1_d6     = foxsi_level0_to_level1( 'data_2012/usb_lvl0-'+strtrim(i,2)+'_D'+strtrim(det,2)+'.sav', det=det )
	save, data_lvl1_d6     , file = 'data_2012/usb_lvl1-'+strtrim(i,2)+'_D'+strtrim(det,2)+'.sav'
	d6     = foxsi_level1_to_level2( 'data_2012/usb_lvl0-'+strtrim(i,2)+'_D'+strtrim(det,2)+'.sav', 'data_2012/usb_lvl1-'+strtrim(i,2)+'_D'+strtrim(det,2)+'.sav', det=det, calib=cal[det], /ground )
	save, d6     , file='data_2012/usb_lvl2-'+strtrim(i,2)+'_D'+strtrim(det,2)+'sav'
endfor
end

f0 = file_search('data_2012/usb_lvl2*D0sav')
f1 = file_search('data_2012/usb_lvl2*D1sav')
f2 = file_search('data_2012/usb_lvl2*D2sav')
f3 = file_search('data_2012/usb_lvl2*D3sav')
f4 = file_search('data_2012/usb_lvl2*D4sav')
f5 = file_search('data_2012/usb_lvl2*D5sav')
f6 = file_search('data_2012/usb_lvl2*D6sav')

restore, f0[0]
data0 = d0
restore, f1[0]
data1 = d1
restore, f2[0]
data2 = d2
restore, f3[0]
data3 = d3
restore, f4[0]
data4 = d4
restore, f5[0]
data5 = d5
restore, f6[0]
data6 = d6

.r
for i=1,4 do begin
	restore, f0[i]
	restore, f1[i]
	restore, f2[i]
	restore, f3[i]
	restore, f4[i]
	restore, f5[i]
	restore, f6[i]
	data0=[data0,d0]
	data1=[data1,d1]
	data2=[data2,d2]
	data3=[data3,d3]
	data4=[data4,d4]
	data5=[data5,d5]
	data6=[data6,d6]
endfor
end


window,0
pix=5.
img0 = foxsi_image_solar( data0, 0, psize=pix, tr=[-100000.,100000.], erange=[4,70])
img1 = foxsi_image_solar( data1, 1, psize=pix, tr=[-100000.,100000.], erange=[4,70])
img2 = foxsi_image_solar( data2, 2, psize=pix, tr=[-100000.,100000.], erange=[4,70])
img3 = foxsi_image_solar( data3, 3, psize=pix, tr=[-100000.,100000.], erange=[4,70])
img4 = foxsi_image_solar( data4, 4, psize=pix, tr=[-100000.,100000.], erange=[4,70])
img5 = foxsi_image_solar( data5, 5, psize=pix, tr=[-100000.,100000.], erange=[4,70])
img6 = foxsi_image_solar( data6, 6, psize=pix, tr=[-100000.,100000.], erange=[4,70])
map0 = make_map( img0, xcen=0., ycen=0., dx=pix, dy=pix )
map1 = make_map( img1, xcen=0., ycen=0., dx=pix, dy=pix )
map2 = make_map( img2, xcen=0., ycen=0., dx=pix, dy=pix )
map3 = make_map( img3, xcen=0., ycen=0., dx=pix, dy=pix )
map4 = make_map( img4, xcen=0., ycen=0., dx=pix, dy=pix )
map5 = make_map( img5, xcen=0., ycen=0., dx=pix, dy=pix )
map6 = make_map( img6, xcen=0., ycen=0., dx=pix, dy=pix )
plot_map, map, fov=20
plot_map, map, fov=4, cen=[-400,200]

img4 = foxsi_image_solar( data4, 4, psize=pix, tr=[-100000.,100000.], erange=[4,70])
map4 = make_map( img4, xcen=0., ycen=0., dx=pix, dy=pix )
plot_map, map4, fov=10
