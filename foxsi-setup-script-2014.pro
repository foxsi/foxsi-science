; setup script to analyze FOXSI data, now for 2014 launch.  (FOXSI-2)
COMMON foxsi, t0, data, data_dir, calibration_data_path, data_file, name, sparcs, flight_data, $
    optic_effarea 

; Set Path where foxsi-science is
CD, Current=fs_location

foxsilib_root_path = fs_location
; add directory paths
add_path, foxsilib_root_path+'/fermi'
add_path, foxsilib_root_path+'/img'
add_path, foxsilib_root_path+'/resp'
add_path, foxsilib_root_path+'/psf'
add_path, foxsilib_root_path+'/proc'
add_path, foxsilib_root_path+'/spec'
add_path, foxsilib_root_path+'/util'
calibration_data_path = foxsilib_root_path + '/calibration_data/'

user_name = strsplit(expand_tilde('~'), '/', /extract)
add_path, foxsilib_root_path + user_name[-1]

; launch time and date
date=anytim('2014-dec-11')
t0 = '11-Dec-2014 19:11:00.000'
data_dir = 'data_2014/'
data_file = data_dir + 'foxsi_level2_data.sav'
name = 'FOXSI-2'

; load the Level 2 data.
restore, data_file, /v

; now load the sparcs data
sparcs = load_sparcs_data()

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
shift6 = [20.,40.]	; offset for D6, eyeballed.
shift0 = [ 34.9, 57.1 ]	; others' shifts are derived by comparing centroids
shift1 = [  9.3, 59.5 ]	; with that of D6.
shift2 = [0.,0.]
shift3 = [0.,0.]
shift4 = [ 13.3, 18.0 ]
shift5 = [ 42.6, 44.0 ]

;shift6 += [-10,-26]
;shift0 += [-10,-26]
;shift1 += [-10,-26]
;shift4 += [-10,-26]
;shift5 += [-10,-26]


; Rotation angles for all detectors
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
save, tlaunch, t_launch, t1_pos0_start, t1_pos0_end, t1_pos1_start, $
	t1_pos1_end, t1_pos2_start, t1_pos2_end, t2_pos0_start, t2_pos0_end, $
	t2_pos1_start, t2_pos1_end, t3_pos0_start, t3_pos0_end, t3_pos1_start, t3_pos1_end, $
	t3_pos2_start, t3_pos2_end, t4_start, t_shtr_start, t_shtr_end, t4_end, $
	t5_start, t5_end, date, t0, offset_xy, cen1_pos0, cen1_pos1, cen1_pos2, $
	cen2_pos0, cen2_pos1, cen3_pos0, cen3_pos1, cen3_pos2, cen4, cen5, $
	shift0, shift1, shift2, shift3, shift4, shift5, shift6, rot0, rot1, rot2, rot3, $
	rot4, rot5, rot6, file = data_dir + 'flight2014-parameters.sav'


module0 = load_foxsi_optics_effarea(0)
module1 = load_foxsi_optics_effarea(1)
module2 = load_foxsi_optics_effarea(2)
module3 = load_foxsi_optics_effarea(3)
module4 = load_foxsi_optics_effarea(4)
module5 = load_foxsi_optics_effarea(5)
;module6 = load_foxsi_optics_effarea(6)

optic_effarea = create_struct('module0', module0, 'module1', module1, 'module2', module2, $
                                'module3', module3, 'module4', module4, 'module5', module5, $
                                'module6', '')

level2 = create_struct('det0', DATA_LVL2_D0, 'det1', DATA_LVL2_D1, 'det2', DATA_LVL2_D2, $
                        'det3', DATA_LVL2_D3, 'det4', DATA_LVL2_D4, 'det5', DATA_LVL2_D5, $
                        'det6', DATA_LVL2_D6)

flight_data = create_struct('level0', '', 'level1', '', 'level2', level2)
