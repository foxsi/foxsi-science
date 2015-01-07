; setup script to analyze FOXSI data, now for 2014 launch.  (FOXSI-2)

; add directory paths
add_path, '~/foxsi/flight-analysis/foxsi-science/fermi'
add_path, '~/foxsi/flight-analysis/foxsi-science/img'
add_path, '~/foxsi/flight-analysis/foxsi-science/resp'
add_path, '~/foxsi/flight-analysis/foxsi-science/psf'
add_path, '~/foxsi/flight-analysis/foxsi-science/proc'
add_path, '~/foxsi/flight-analysis/foxsi-science/spec'
add_path, '~/foxsi/flight-analysis/foxsi-science/util'

; load the Level 2 data.
restore, 'data_2014/foxsi_level2_data.sav', /v

t_launch = 69060

;yaw adjustments are at
;start 100
;165
;210
;*275
;325
;*370
;*470
;end 500

;pitch adjustments are at
;start 100
;140
;220
;*275
;310
;*370
;*470
;end 500

; Right now target times are eyeballed from Jesus's plots.  Later, we'll get the real data.
offset = 36.		; time offset in WSMR data, for unknown reason.
tlaunch = 69060
t1_start = 100. + offset
t1_adj1  = 140. + offset
t1_adj2  = 165. + offset
t1_end   = 210. + offset
t2_start = 220. + offset
t2_end 	 = 275. + offset
t3_start = 280. + offset
t3_adj1	 = 310. + offset
t3_adj2  = 325. + offset
t3_end	 = 370. + offset
t4_start = 370. + offset
t4_end	 = 470. + offset
t5_start = 470. + offset
t5_end	 = 500. + offset


date=anytim('2014-dec-11')
t0 = '11-Dec-2014 19:11:00.000'

cen1 = [   0,-250 ]
cen2 = [-750,-100]
cen3 = [ 850,-250]
cen4 = [ 200, 750]
cen5 = [   0,-250 ]

shift6 = [20,40]	; offset for D6, eyeballed.
shift0 = [ 34.8801, 57.1428 ]	; others shifts are derived by comparing centroids
shift1 = [  9.2774, 59.4729 ]	; with that of D6.
shift4 = [ 13.2861, 17.9339 ]
shift5 = [ 42.6485, 43.9609 ]


; Rotation angles for all detectors
rot0 = 82.5
rot1 = 75.
rot2 = -67.5
rot3 = -75.
rot4 = 97.5
rot5 = 90.
rot6 = -60.



