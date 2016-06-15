; June 2016
; STARTUP FOXSI
; Description: 
;
;

PRO make_parameters, YEAR

COMMON FOXSI

if not keyword_set(year) then begin 
	print,'Please provide the year of the FOXSI flight (2012 or 2014).'
	print,'       Example: make_parameters,2014'
endif else begin

	if ((year eq 2012) OR (year eq 2014)) then begin
		; add directory paths
		add_path, FOXSIPKG+'/fermi'
		add_path, FOXSIPKG+'/img'
		add_path, FOXSIPKG+'/resp'
		add_path, FOXSIPKG+'/psf'
		add_path, FOXSIPKG+'/proc'
		add_path, FOXSIPKG+'/spec'
		add_path, FOXSIPKG+'/util'

		if year eq 2014 then begin
			t_launch = 69060
			; Timing info from Jesus's preliminary report.
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
			t_shtr_start   = 438.0 		; Conservative time of attenuator insertion
			t_shtr_end     = 442.0 		; Conservative time for microphonics to die down
			t4_end	       = 466.2
			t5_start       = 470.5
			t5_end	       = 503.2

			date=anytim('2014-dec-11')
			t0 = '11-Dec-2014 19:11:00.000'

			;
			; Positional information
			;

			; Our crude alignment offset determined in-flight
			offset_xy = [360.,-180.]

			; SPARCS pointing positions, from Jesus
			cen1_pos0 = [  -1. ,-251. ] + offset_xy		; 32 sec
			cen1_pos1 = [-361. ,-251. ] + offset_xy		; 25 sec
			cen1_pos2 = [-361. , -71. ] + offset_xy		; 38 sec
			cen2_pos0 = [-361. ,-101. ] + offset_xy		; 11 sec
			cen2_pos1 = [-750. ,-101. ] + offset_xy		; 53 sec
			cen3_pos0 = [ 850.5,-251.5] + offset_xy		; 26 sec
			cen3_pos1 = [ 490. ,-251.5] + offset_xy		; 19 sec
			cen3_pos2 = [ 490. , -71. ] + offset_xy		; 35 sec
			cen4 = 		[-160. , 930. ] + offset_xy		; 92 sec
			cen5 = 		[-360. , -71. ] + offset_xy		; 36 sec

			; Additional shifts for each detector, from comparison with AIA
			; THIS SHOULD BE REDONE USING RHESSI!
			;shift6 = [20.,40.]	; offset for D6, eyeballed.
			;shift0 = [ 34.9, 57.1 ]	; others' shifts are derived by comparing centroids
			;shift1 = [  9.3, 59.5 ]	; with that of D6.
			shift2 = [0.,0.]
			shift3 = [0.,0.]
			;shift4 = [ 13.3, 18.0 ]
			;shift5 = [ 42.6, 44.0 ]

			shift6 = [43.5, 41.7]		; new offset, 2014-mar-19, from comparing last flare w/RHESSI.
			shift0 = [10.,14.] + shift6
			shift1 = [-13.,17.] + shift6
			shift4 = [-6.,-28.] + shift6
			shift5 = [20.,-2.] + shift6

			; Flare and AR locations
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

			; To see ARs on HMI image, open hmi-foxsi2.png


			; Rotation angles for all detectors
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


			; Save the values set here for use by some of the routines.
			; Saving this file each time ensures that updating a value in this setup script
			; propagates through to all routines.
			save, tlaunch, t_launch, t1_pos0_start, t1_pos0_end, t1_pos1_start, $
			t1_pos1_end, t1_pos2_start, t1_pos2_end, t2_pos0_start, t2_pos0_end, $
			t2_pos1_start, t2_pos1_end, t3_pos0_start, t3_pos0_end, t3_pos1_start, t3_pos1_end, $
			t3_pos2_start, t3_pos2_end, t4_start, t_shtr_start, t_shtr_end, t4_end, $
			t5_start, t5_end, date, t0, offset_xy, cen1_pos0, cen1_pos1, cen1_pos2, $
			cen2_pos0, cen2_pos1, cen3_pos0, cen3_pos1, cen3_pos2, cen4, cen5, $
			shift0, shift1, shift2, shift3, shift4, shift5, shift6, rot0, rot1, rot2, rot3, $
			rot4, rot5, rot6, $
			detnum0, detnum1, detnum2, detnum3, detnum4, detnum5, detnum6, $
			file = FOXSIDB+'/data_2014/flight2014-parameters.sav'
			print, 'You just created a file with the parameters and needed' 
			print, 'to do the analysis of the FOXSI 2014 observations.'
			print, ''
			print, 'File location:   '+FOXSIDB+'/data_2014/flight2014-parameters.sav'
		endif

		if year eq 2012 then begin
			; load the Level 2 data.
			;restore, FOXSIDB+'/data_2012/foxsi_level2_data.sav', /v

			t_launch = 64500.
			tlaunch  = 64500.
			t1_start = t_launch + 108.3		; Target 1 (AR)
			t1_end = t_launch + 151.8
			t2_start = t_launch + 154.8		; Target 2 (AR)
			t2_end = t_launch + 244.7
			t3_start = t_launch + 247		; Target 3 (quiet Sun)
			t3_end = t_launch + 337.3
			t4_start = t_launch + 340		; Target 4 (flare)
			t4_end = t_launch + 420.		; slightly altered from nominal 421.2
			t5_start = t_launch + 423.5		; Target 5 (off-pointing)
			t5_end = t_launch + 435.9
			t6_start = t_launch + 438.5		; Target 6 (flare)
			t6_end = t_launch + 498.3

			date=anytim('2012-nov-03')
			t0 = '2-Nov-2012 17:55:00.000'

			; Positional info

			cen1 = [-480,-350]
			cen2 = [-850, 150]
			cen3 = [ 600, 400]
			cen4 = [ 700,-600]
			cen5 = [1000,-900]
			cen6 = [ 700,-600]
			flare = [967,-207]	; from RHESSI flarelist

			; Offsets determined by comparison with the RHESSI flare centroid.
			shift0 = -[ 55.4700,     -135.977 ]
			shift1 = -[ 81.4900,     -131.124 ]
			shift2 = -[ 96.3600,     -130.241 ]
			shift3 = -[ 87.8900,     -92.7310 ]
			shift4 = -[ 48.2700,     -95.3080 ]
			shift5 = -[ 49.5500,     -120.276 ]
			shift6 = -[ 63.4500,     -106.360 ]

			; overall offset
			offset_xy = [0.,0.]

			; Rotation angles for all detectors (as designed, no tweaks).
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

			; Save the values set here for use by some of the routines.
			; Saving this file each time ensures that updating a value in this setup script
			; propagates through to all routines.
			save, tlaunch, t_launch, t1_start, t1_end, t2_start, t2_end, t3_start, t3_end, $
				t4_start, t4_end, t5_start, t5_end, t6_start, t6_end, date, t0, $	
				offset_xy, cen1, cen2, cen3, cen4, cen5, cen6, $
				shift0, shift1, shift2, shift3, shift4, shift5, shift6, $
				rot0, rot1, rot2, rot3, rot4, rot5, rot6, $
				detnum0, detnum1, detnum2, detnum3, detnum4, detnum5, detnum6, $
				file = FOXSIDB+'/data_2012/flight2012-parameters.sav'
			print, 'You just created a file with the parameters and needed' 
			print, 'to do the analysis of the FOXSI 2012 observations.'
			print, ''
			print, 'File location:   '+FOXSIDB+'/data_2012/flight2012-parameters.sav'
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
