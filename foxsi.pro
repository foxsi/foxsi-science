; June 2016
; STARTUP FOXSI
; Description: 
;
;

PRO FOXSI, YEAR
COMMON PARAM
if not keyword_set(year) then begin 
	print,'Please provide the year of the FOXSI flight (2012 or 2014).'
	print,'       Example: foxsi,2014'
endif else begin

	if ((year eq 2012) OR (year eq 2014)) then begin
		if year eq 2014 then begin
			; load the Level 2 data.
			t_launch = 69060
			tlaunch        = 69060
			t1_pos0_start  = 102.0
			t1_pos0_end    = 134.3
			t1_pos1_start  = 138.0
			t1_pos1_end    = 162.6
			t1_pos2_start  = 166.5
			t1_pos2_end    = 205.0
			t2_pos0_start  = 209.0
			t2_pos0_end    = 219.6
			t2_pos1_start  = 224.0
			t2_pos1_end    = 276.7
			t3_pos0_start  = 280.6
			t3_pos0_end    = 307.2
			t3_pos1_start  = 311.0
			t3_pos1_end    = 330.1
			t3_pos2_start  = 334.0
			t3_pos2_end    = 369.2
			t4_start       = 373.5
			t_shtr_start   = 438.0
			t_shtr_end     = 442.0
			t4_end	       = 466.2
			t5_start       = 470.5
			t5_end	       = 503.2
			date=anytim('2014-dec-11')
			t0 = '11-Dec-2014 19:11:00.000'
			offset_xy = [360.,-180.]
			cen1_pos0 = [  -1. ,-251. ] + offset_xy
			cen1_pos1 = [-361. ,-251. ] + offset_xy
			cen1_pos2 = [-361. , -71. ] + offset_xy
			cen2_pos0 = [-361. ,-101. ] + offset_xy
			cen2_pos1 = [-750. ,-101. ] + offset_xy
			cen3_pos0 = [ 850.5,-251.5] + offset_xy
			cen3_pos1 = [ 490. ,-251.5] + offset_xy
			cen3_pos2 = [ 490. , -71. ] + offset_xy
			cen4 = 		[-160. , 930. ] + offset_xy
			cen5 = 		[-360. , -71. ] + offset_xy
			shift2 = [0.,0.]
			shift3 = [0.,0.]
			shift6 = [43.5, 41.7]
			shift0 = [10.,14.] + shift6
			shift1 = [-13.,17.] + shift6
			shift4 = [-6.,-28.] + shift6
			shift5 = [20.,-2.] + shift6
			flare1 = [30,-220]
			flare2 = [-70,90]
			ar27 = [713, -45]
			ar30 = [82,-245]
			ar32 = [-391,177]
			ar33 = [186,59]
			ar34 = [-84,93]
			ar35 = [-742,-113]
			ar25 = [940,-251]
			ar29 = [635,-376]
			ar31 = [640,-44]
			rot0 = 82.5
			rot1 = 75.
			rot2 = -67.5
			rot3 = -75.
			rot4 = 97.5
			rot5 = 90.
			rot6 = -60.
			detnum0 = 108
			detnum1 = 101
			detnum2 = 0
			detnum3 = 0
			detnum4 = 104
			detnum5 = 105
			detnum6 = 102
			restore, '$FOXSIDB'+'/data_2014/foxsi_level2_data.sav', /v
			DATA_LVL2_D0=DATA_LVL2_D0
			DATA_LVL2_D1=DATA_LVL2_D1
			DATA_LVL2_D2=DATA_LVL2_D2
			DATA_LVL2_D3=DATA_LVL2_D3
			DATA_LVL2_D4=DATA_LVL2_D4
			DATA_LVL2_D5=DATA_LVL2_D5
			DATA_LVL2_D6=DATA_LVL2_D6
			print, 'You just load all the parameters and data needed' 
			print, 'to do the analysis of the FOXSI 2014 observations.'
			print
			print, 'Type help if you want to check the 2014-parameters.'
			return	
		endif
		if year eq 2012 then begin
			; load the Level 2 data.
			t_launch = 64500.
			tlaunch  = 64500.
			t1_start = t_launch + 108.3
			t1_end = t_launch + 151.8
			t2_start = t_launch + 154.8
			t2_end = t_launch + 244.7
			t3_start = t_launch + 247
			t3_end = t_launch + 337.3
			t4_start = t_launch + 340
			t4_end = t_launch + 420.
			t5_start = t_launch + 423.5
			t5_end = t_launch + 435.9
			t6_start = t_launch + 438.5
			t6_end = t_launch + 498.3
			date=anytim('2012-nov-03')
			t0 = '2-Nov-2012 17:55:00.000'
			cen1 = [-480,-350]
			cen2 = [-850, 150]
			cen3 = [ 600, 400]
			cen4 = [ 700,-600]
			cen5 = [1000,-900]
			cen6 = [ 700,-600]
			flare = [967,-207]
			shift0 = -[ 55.4700,     -135.977 ]
			shift1 = -[ 81.4900,     -131.124 ]
			shift2 = -[ 96.3600,     -130.241 ]
			shift3 = -[ 87.8900,     -92.7310 ]
			shift4 = -[ 48.2700,     -95.3080 ]
			shift5 = -[ 49.5500,     -120.276 ]
			shift6 = -[ 63.4500,     -106.360 ]
			offset_xy = [0.,0.]
			rot0 = 82.5
			rot1 = 75.
			rot2 = -67.5
			rot3 = -75.
			rot4 = 97.5
			rot5 = 90.
			rot6 = -60.
			detnum0 = 108
			detnum1 = 109
			detnum2 = 102
			detnum3 = 103
			detnum4 = 104
			detnum5 = 105
			detnum6 = 106
			restore, '$FOXSIDB'+'/data_2012/foxsi_level2_data.sav', /v
			DATA_LVL2_D0=DATA_LVL2_D0
			DATA_LVL2_D1=DATA_LVL2_D1
			DATA_LVL2_D2=DATA_LVL2_D2
			DATA_LVL2_D3=DATA_LVL2_D3
			DATA_LVL2_D4=DATA_LVL2_D4
			DATA_LVL2_D5=DATA_LVL2_D5
			DATA_LVL2_D6=DATA_LVL2_D6
			print, 'You just load all the parameters and data needed' 
			print, 'to do the analysis of the FOXSI 2012 observations.'
			print
			print, 'Type help if you want to check the 2012-parameters.'
			return
		endif		
	endif else begin
		print, 'FOXSI did not fly that year.'
		print, 'Please use one of the next years:'
		print, '       - 2012'
		print, '       - 2014'
		print, 'Example: foxsi,2014'
	endelse
endelse
END
