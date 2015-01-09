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

; Timing info from Jesus's preliminary report.
offset_t = 36.		; time offset in WSMR data, for unknown reason.
tlaunch = 69060
t1_start = 102. + offset_t
t1_adj1  = 138. + offset_t
t1_adj2  = 166.5 + offset_t
t1_end   = 205. + offset_t
t2_start = 209. + offset_t
t2_adj1  = 224. + offset_t
t2_end 	 = 276.7 + offset_t
t3_start = 280.6 + offset_t
t3_adj1	 = 311. + offset_t
t3_adj2  = 334. + offset_t
t3_end	 = 369. + offset_t
t4_start = 373.5. + offset_t
t_shtr_start= 438 + offset_t	; Conservative time of attenuator insertion
t_shtr_end = 442 + offset_t		; Conservative time for microphonics to die down
t4_end	 = 466. + offset_t
t5_start = 470. + offset_t
t5_end	 = 505.6 + offset_t


date=anytim('2014-dec-11')
t0 = '11-Dec-2014 19:11:00.000'

;
; Positional information
;

; Our crude alignment offset determined in-flight
offset_xy = [-360.,+180.]

; SPARCS pointing positions, from Jesus
cen1 = 		[  -1. ,-251. ] + offset_xy		; 32 sec
cen1_adj1 = [-361. ,-251. ] + offset_xy		; 25 sec
cen1_adj2 = [-361. , -71. ] + offset_xy		; 38 sec
cen2 = 		[-361. ,-101. ] + offset_xy		; 11 sec
cen2_adj1 = [-750. ,-101. ] + offset_xy		; 53 sec
cen3 = 		[ 850.5,-251.5] + offset_xy		; 26 sec
cen3_adj1 = [ 490. ,-251.5] + offset_xy		; 19 sec
cen3_adj2 = [ 490. , -71. ] + offset_xy		; 35 sec
cen4 = 		[-160. , 930. ] + offset_xy		; 92 sec
cen5 = 		[-360. , -71. ] + offset_xy		; 36 sec

; Additional shifts for each detector, from comparison with AIA
; THIS SHOULD BE REDONE USING RHESSI!
shift6 = [20.,40.]	; offset for D6, eyeballed.
shift0 = [ 34.9, 57.1 ]	; others' shifts are derived by comparing centroids
shift1 = [  9.3, 59.5 ]	; with that of D6.
shift4 = [ 13.3, 18.0 ]
shift5 = [ 42.6, 44.0 ]

; Rotation angles for all detectors
rot0 = 82.5
rot1 = 75.
rot2 = -67.5
rot3 = -75.
rot4 = 97.5
rot5 = 90.
rot6 = -60.



