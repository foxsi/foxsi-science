; setup script to analyze FOXSI data.

; add directory paths
add_path, '~/foxsi/flight-analysis/foxsi-science/fermi'
add_path, '~/foxsi/flight-analysis/foxsi-science/img'
add_path, '~/foxsi/flight-analysis/foxsi-science/resp'
add_path, '~/foxsi/flight-analysis/foxsi-science/psf'
add_path, '~/foxsi/flight-analysis/foxsi-science/proc'
add_path, '~/foxsi/flight-analysis/foxsi-science/spec'
add_path, '~/foxsi/flight-analysis/foxsi-science/util'

; load the Level 2 data.
restore, 'data_2012/foxsi_level2_data.sav', /v

; For reference, times of all target windows (from RLG on or target stable to new 
; target received or RLG off)
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
shift0 = [ 55.4700,     -135.977 ]
shift1 = [ 81.4900,     -131.124 ]
shift2 = [ 96.3600,     -130.241 ]
shift3 = [ 87.8900,     -92.7310 ]
shift4 = [ 48.2700,     -95.3080 ]
shift5 = [ 49.5500,     -120.276 ]
shift6 = [ 63.4500,     -106.360 ]

; Rotation angles for all detectors (as designed, no tweaks).
rot0 = 82.5
rot1 = 75.
rot2 = -67.5
rot3 = -75.
rot4 = 97.5
rot5 = 90.
rot6 = -60.

; Save the values set here for use by some of the routines.
; Saving this file each time ensures that updating a value in this setup script
; propagates through to all routines.
save, tlaunch, t_launch, t1_start, t1_end, t2_start, t2_end, t3_start, t3_end, $
	t4_start, t4_end, t5_start, t5_end, t6_start, t6_end, date, t0, $	
	offset_xy, cen1, cen2, cen3, cen4, cen5, cen6, $
	shift0, shift1, shift4, shift5, shift6, $
	rot0, rot1, rot2, rot3, rot4, rot5, rot6, $
	file = 'data_2012/flight2012-parameters.sav'
