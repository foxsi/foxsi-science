; Create Level 0 data
filename = 'data_2014/36_295_Krucker_FLIGHT_HOT_TM2.log'
data_lvl0_D0 = wsmr_data_to_level0( filename, det=0, year=2014 )
data_lvl0_D1 = wsmr_data_to_level0( filename, det=1, year=2014 )
data_lvl0_D2 = wsmr_data_to_level0( filename, det=2, year=2014 )
data_lvl0_D3 = wsmr_data_to_level0( filename, det=3, year=2014 )
data_lvl0_D4 = wsmr_data_to_level0( filename, det=4, year=2014 )
data_lvl0_D5 = wsmr_data_to_level0( filename, det=5, year=2014 )
data_lvl0_D6 = wsmr_data_to_level0( filename, det=6, year=2014 )
save, data_lvl0_D0, data_lvl0_D1, data_lvl0_D2, data_lvl0_D3, data_lvl0_D4, $
	data_lvl0_D5, data_lvl0_d6, $
	file = 'data_2014/foxsi_level0_data.sav'

; Create Level 1 data
.compile foxsi_level0_to_level1
filename = 'data_2014/foxsi_level0_data.sav'
data_lvl1_D0 = foxsi_level0_to_level1( filename, det=0, ground=0 )
data_lvl1_D1 = foxsi_level0_to_level1( filename, det=1, ground=0 )
data_lvl1_D2 = foxsi_level0_to_level1( filename, det=2, ground=0, /cdte )
data_lvl1_D3 = foxsi_level0_to_level1( filename, det=3, ground=0, /cdte )
data_lvl1_D4 = foxsi_level0_to_level1( filename, det=4, ground=0 )
data_lvl1_D5 = foxsi_level0_to_level1( filename, det=5, ground=0 )
data_lvl1_D6 = foxsi_level0_to_level1( filename, det=6, ground=0 )
save, data_lvl1_D0, data_lvl1_D1, data_lvl1_D2, data_lvl1_D3, data_lvl1_D4, $
	data_lvl1_D5, data_lvl1_d6, $
	file = 'data_2014/foxsi_level1_data.sav'

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
file0 = 'data_2014/foxsi_level0_data.sav'
file1 = 'data_2014/foxsi_level1_data.sav'
cal0 = 'calibration_data/peaks_det108.sav'
cal1 = 'calibration_data/peaks_det109.sav'
cal2 = 'calibration_data/peaks_det102.sav'
cal3 = 'calibration_data/peaks_det103.sav'
cal4 = 'calibration_data/peaks_det104.sav'
cal5 = 'calibration_data/peaks_det105.sav'
cal6 = 'calibration_data/peaks_det106.sav'
data_lvl2_D0 = foxsi_level1_to_level2( file0, file1, det=0, calib=cal0 )
data_lvl2_D1 = foxsi_level1_to_level2( file0, file1, det=1, calib=cal1 )
data_lvl2_D2 = foxsi_level1_to_level2( file0, file1, det=2, calib=cal2 )
data_lvl2_D3 = foxsi_level1_to_level2( file0, file1, det=3, calib=cal3 )
data_lvl2_D4 = foxsi_level1_to_level2( file0, file1, det=4, calib=cal4 )
data_lvl2_D5 = foxsi_level1_to_level2( file0, file1, det=5, calib=cal5 )
data_lvl2_D6 = foxsi_level1_to_level2( file0, file1, det=6, calib=cal6 )
save, data_lvl2_D0, data_lvl2_D1, data_lvl2_D2, data_lvl2_D3, $
	data_lvl2_D4, data_lvl2_D5, data_lvl2_d6, $
	file = 'data_2014/foxsi_level2_data.sav'

