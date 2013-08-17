; setup script to analyze FOXSI data.

; add directory paths
add_path, '~/Documents/foxsi/flight-analysis/foxsi-science/fermi'
add_path, '~/Documents/foxsi/flight-analysis/foxsi-science/img'
add_path, '~/Documents/foxsi/flight-analysis/foxsi-science/resp'
add_path, '~/Documents/foxsi/flight-analysis/foxsi-science/psf'
add_path, '~/Documents/foxsi/flight-analysis/foxsi-science/proc'
add_path, '~/Documents/foxsi/flight-analysis/foxsi-science/spec'
add_path, '~/Documents/foxsi/flight-analysis/foxsi-science/util'

; load the Level 2 data.
restore, 'data_2012/foxsi_level2_data.sav', /v

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

