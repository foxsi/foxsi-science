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

; Plot positions
d=d6
i=where(d.error_flag eq 0 )
plot,d[i].hit_xy_pay[0],d[i].hit_xy_pay[1],/psy
oplot,[350],[270],/psy,color=6,symsize=5,thick=3

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

; Plot basic spectra (integrated over whole flight)
spex0=make_spectrum( data_lvl2_d0, bin=0.1, /corr )
spex1=make_spectrum( data_lvl2_d1, bin=0.1, /corr )
spex2=make_spectrum( data_lvl2_d2, bin=0.1, /corr )
spex3=make_spectrum( data_lvl2_d3, bin=0.1, /corr )
spex4=make_spectrum( data_lvl2_d4, bin=0.1, /corr )
spex5=make_spectrum( data_lvl2_d5, bin=0.1, /corr )
spex6=make_spectrum( data_lvl2_d6, bin=0.1, /corr )

popen, 'plots/integrated-spectra', xsize=7, ysize=5
xtit = 'Energy [kev]'
ytit = 'Counts keV!U-1!N'
yr = [10.,1.e4]
ch = 1.2
leg = ['P-side','N-side']
plot, spex0.energy_kev, spex0.spec_p, psym=10,xr=[0,15], /ylog, yr=yr, thick=4, $
	xtit=xtit, ytit=ytit, charsize=ch, title='Detector 0'
oplot, spex0.energy_kev, spex0.spec_n, line=1, psym=10
legend, leg, line=[0,1], thick=4, /right, charsize=1.2
plot, spex1.energy_kev, spex1.spec_p, psym=10,xr=[0,15], /ylog, yr=yr, thick=4, $
	xtit=xtit, ytit=ytit, charsize=ch, title='Detector 1'
oplot, spex1.energy_kev, spex1.spec_n, line=1, psym=10
legend, leg, line=[0,1], thick=4, /right, charsize=1.2
plot, spex2.energy_kev, spex2.spec_p, psym=10,xr=[0,15], /ylog, yr=yr, thick=4, $
	xtit=xtit, ytit=ytit, charsize=ch, title='Detector 2'
oplot, spex2.energy_kev, spex2.spec_n, line=1, psym=10
legend, leg, line=[0,1], thick=4, /right, charsize=1.2
plot, spex3.energy_kev, spex3.spec_p, psym=10,xr=[0,15], /ylog, yr=yr, thick=4, $
	xtit=xtit, ytit=ytit, charsize=ch, title='Detector 3'
oplot, spex3.energy_kev, spex3.spec_n, line=1, psym=10
legend, leg, line=[0,1], thick=4, /right, charsize=1.2
plot, spex4.energy_kev, spex4.spec_p, psym=10,xr=[0,15], /ylog, yr=yr, thick=4, $
	xtit=xtit, ytit=ytit, charsize=ch, title='Detector 4'
oplot, spex4.energy_kev, spex4.spec_n, line=1, psym=10
legend, leg, line=[0,1], thick=4, /right, charsize=1.2
plot, spex5.energy_kev, spex5.spec_p, psym=10,xr=[0,15], /ylog, yr=yr, thick=4, $
	xtit=xtit, ytit=ytit, charsize=ch, title='Detector 5'
oplot, spex5.energy_kev, spex5.spec_n, line=1, psym=10
legend, leg, line=[0,1], thick=4, /right, charsize=1.2
plot, spex6.energy_kev, spex6.spec_p, psym=10,xr=[0,15], /ylog, yr=yr, thick=4, $
	xtit=xtit, ytit=ytit, charsize=ch, title='Detector 6'
oplot, spex6.energy_kev, spex6.spec_n, line=1, psym=10
legend, leg, line=[0,1], thick=4, /right, charsize=1.2
pclose


; Some outstanding notes
; OUTSTANDING ISSUES!!!
; -- Livetime has some odd values (4 striations).  Look at this carefully.
; 		Also, it will be difficult to calculate livetime accurately w/o knowing
;   	some info about what frames might be missing...

;;;;;;;;;;;;;;;;;;;;
;;; March 4 2013 ;;;
;;;;;;;;;;;;;;;;;;;;

; Using simulation scripts and FOXSI response routines to calculate  expected counts for
; our microflare.

;T = 9.0  ; temperature in MK
T = 9.4  ; temperature in MK
EM = 4.8e-3  ; emission measure in units of 10^49
;EM = 3.8e-3  ; emission measure in units of 10^49

e1 = dindgen(1200)/100
e2 = get_edges(e1,/edges_2)
emid = get_edges(e1,/mean)

; Simulate a FOXSI spectrum for the thermal plasma.
sim_tot = foxsi_count_spectrum( em, t, time=60., binsize=0.5, data_dir='detector_data/', $
						 		let_file='efficiency_det106_asic3.sav')
; Divide by 7 to get the simulated rate for one detector only.
sim_1det = sim_tot
sim_1det.counts = sim_tot.counts / 7.
sim_1det.count_error = sqrt(sim_1det.counts)

;; This section is to be used when stopped in the above routine.
rhessi = rhessi_eff_area(e1, 0.25, 0)
loadct,0
hsi_linecolors
popen, 'plots/response_factors', xsize=7, ysize=5
plot, area_bare.energy_kev, area_blankets.eff_area_cm2/area_bare.eff_area_cm2, $
	charsize=1.2, thick=4, 	title='Attenuation factors in FOXSI response', $
	xtitle='Energy [keV]', ytitle='Response', /nodata, $
oplot, area_bare.energy_kev, area_blankets.eff_area_cm2/area_bare.eff_area_cm2, thick=4, $
	color=6
oplot, area_bare.energy_kev, area_det.eff_area_cm2/area_bare.eff_area_cm2, thick=4, $
	color=7
oplot, area_bare.energy_kev, area_offaxis.eff_area_cm2/area_bare.eff_area_cm2, thick=4, $
	color=8
legend, ['Blanketing','Detector efficiency (inc LET)','Off-axis response'], thick=4, $
	color=[6,7,8], /bottom, /right, line=[0,0,0]
plot, area_bare.energy_kev, area_bare.eff_area_cm2, charsize=1.2, thick=4, yr=[0,250], $
	xtitle='Energy [keV]', ytitle='Effective area [cm!U2!N]', line=2
oplot, area_bare.energy_kev, area_blankets.eff_area_cm2, thick=4, color=6
oplot, area_bare.energy_kev, area_det.eff_area_cm2, thick=4, color=7
oplot, area_bare.energy_kev, area_offaxis.eff_area_cm2, thick=4, color=8
oplot, area.energy_kev, area.eff_area_cm2, thick=4
oplot, e1, rhessi, thick=4, line=1
legend, ['Optics eff area','Optics eff area inc. blankets',$
	'Optics eff area inc det efficiency',$
	'Optics eff area at 7 arcmin','Total FOXSI effective area for microflare',$
	'RHESSI eff area'],$
	thick=4, /top, /right, line=[2,0,0,0,0,1], color=[0,6,7,8,0,0]
pclose
;; end section in stopped routine.

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
t1 = t1_start
t2 = t1_end
binwidth=0.3

;; Method 1: This is the old way to do it, using a hacked routine I wrote
; (needed before we had Level 2 data)
restore, 'data_2012/foxsi_level0_data.sav'
lvl0 = data_D6
restore, 'data_2012/foxsi_level1_data.sav'
lvl1 = data_D6
i=where(lvl1.error_flag eq 0 and lvl1.wsmr_time gt t1 and lvl1.wsmr_time lt t2)
data = lvl0[i]
spec = counts2energy_diagonal( data, peaksfile='detector_data/peaks_det106.sav', $
	binwidth=binwidth  )
plot,  sim.energy_kev, sim.counts., xr=[1,20],yr=[10.,1.e4], thick=4, psym=10, $
  xtitle='Energy [keV]', ytitle='FOXSI counts/keV', /ylog, /xlog, xstyle=1, line=1, $
  title = 'FOXSI counts for 1 minute, single optic/detector'
oplot, spec[*,2,0], spec[*,2,1]/binwidth, psym=10, thick=4, color=6
legend, ['Simulated flare counts','Actual D6 counts'], $
		 thick=4, line=[1,0], color=[0,6]

;; Method 2: Do it from the Level 2 data (better).
; Use function "make spectrum"
; Select only events w/o errors and in desired time range.
; Use /corr keyword to correct the spectrum for the thrown-out counts.
restore, 'data_2012/foxsi_level2_data.sav', /v
t1 = t2_start
t2 = t2_end
delta_t = t2 - t1
i0 = where(data_lvl2_d0.wsmr_time gt t1 and data_lvl2_d0.wsmr_time lt t2); and $
i1 = where(data_lvl2_d1.wsmr_time gt t1 and data_lvl2_d1.wsmr_time lt t2); and $
i2 = where(data_lvl2_d2.wsmr_time gt t1 and data_lvl2_d2.wsmr_time lt t2); and $
i3 = where(data_lvl2_d3.wsmr_time gt t1 and data_lvl2_d3.wsmr_time lt t2); and $
i4 = where(data_lvl2_d4.wsmr_time gt t1 and data_lvl2_d4.wsmr_time lt t2); and $
i5 = where(data_lvl2_d5.wsmr_time gt t1 and data_lvl2_d5.wsmr_time lt t2); and $
i6 = where(data_lvl2_d6.wsmr_time gt t1 and data_lvl2_d6.wsmr_time lt t2); and $
spec_d0 = make_spectrum( data_lvl2_d0[i0], bin=binwidth, /correct )
spec_d1 = make_spectrum( data_lvl2_d1[i1], bin=binwidth, /correct )
spec_d2 = make_spectrum( data_lvl2_d2[i2], bin=binwidth, /correct )
spec_d3 = make_spectrum( data_lvl2_d3[i3], bin=binwidth, /correct )
spec_d4 = make_spectrum( data_lvl2_d4[i4], bin=binwidth, /correct )
spec_d5 = make_spectrum( data_lvl2_d5[i5], bin=binwidth, /correct )
spec_d6 = make_spectrum( data_lvl2_d6[i6], bin=binwidth, /correct )
spec_sum = spec_d0.spec_p + spec_d2.spec_p + spec_d3.spec_p + $
	spec_d4.spec_p + spec_d5.spec_p + spec_d6.spec_p

; popen, 'plots/target2-fullrange', xsize=7, ysize=5
;plot,  spec_d6.energy_kev, spec_sum/delta_t, xr=[2,20],yr=[1.e-2,1.e3], thick=4, psym=10, $
;  xtitle='Energy [keV]', ytitle='FOXSI counts s!U-1!N keV!U-1!N', /ylog, /xlog, xstyle=1, line=1, $
;  title = 'FOXSI count spectra, corrected, Target 6 (flare)', charsize=1.2
plot,  spec_d6.energy_kev, spec_sum/delta_t, xr=[2,100], thick=4, psym=10, /xlog, $
  xtitle='Energy [keV]', ytitle='FOXSI counts s!U-1!N keV!U-1!N', xstyle=1, line=1, $
  title = 'FOXSI count spectra, corrected, Target 2', charsize=1.2
oplot, spec_d0.energy_kev, spec_d0.spec_p/delta_t, psym=10, thick=4, color=6
oplot, spec_d1.energy_kev, spec_d1.spec_p/delta_t, psym=10, thick=4, color=7
oplot, spec_d2.energy_kev, spec_d2.spec_p/delta_t, psym=10, thick=4, color=8
oplot, spec_d3.energy_kev, spec_d3.spec_p/delta_t, psym=10, thick=4, color=9
oplot, spec_d4.energy_kev, spec_d4.spec_p/delta_t, psym=10, thick=4, color=10
oplot, spec_d5.energy_kev, spec_d5.spec_p/delta_t, psym=10, thick=4, color=12
oplot, spec_d6.energy_kev, spec_d6.spec_p/delta_t, psym=10, thick=4, color=2
legend, ['Summed, except D1','Det0','Det1','Det2','Det3','Det4','Det5','Det6'], $
		 thick=4, line=[1,0,0,0,0,0,0,0], color=[0,6,7,8,9,10,12,2], /right, box=0

pclose

spec_flare = spec_sum
dt_flare = delta_t

plot,  spec_d6.energy_kev, spec_sum/delta_t, xr=[2,20], thick=4, psym=10, /xlog, $
  xtitle='Energy [keV]', ytitle='FOXSI counts s!U-1!N keV!U-1!N', xstyle=1,$
  title = 'FOXSI count spectrum, Target 1', charsize=1.2, /ylog, yr=[1.e-1,1.e1]
plot,  spec_d6.energy_kev, spec_flare/dt_flare, xr=[2,20], thick=4, psym=10, /xlog, $
  xtitle='Energy [keV]', ytitle='FOXSI counts s!U-1!N keV!U-1!N', xstyle=1,$
  title = 'FOXSI count spectrum, B-class flare', charsize=1.2, /ylog, yr=[1.e-1,1.e2]

;; or use this if you want to select the positions.
; rough flare centroid for each detector
pos0 = [ 320, 280 ]
pos1 = [ 340, 270 ]
pos2 = [ 350, 250 ]
pos3 = [ 350, 300 ]
pos4 = [ 300, 300 ]
pos5 = [ 305, 280 ]
pos6 = [ 320, 280 ]
rad = 50
i0 = where(data_lvl2_d0.wsmr_time gt t1 and data_lvl2_d0.wsmr_time lt t2) and $
		   data_lvl2_d0.hit_xy_pay[0] gt (pos0[0] - rad) and $
		   data_lvl2_d0.hit_xy_pay[0] lt (pos0[0] + rad) and $
		   data_lvl2_d0.hit_xy_pay[1] gt (pos0[1] - rad) and $
		   data_lvl2_d0.hit_xy_pay[1] lt (pos0[1] + rad) )
i1 = where(data_lvl2_d1.wsmr_time gt t1 and data_lvl2_d1.wsmr_time lt t2) and $
		   data_lvl2_d1.hit_xy_pay[0] gt (pos1[0] - rad) and $
		   data_lvl2_d1.hit_xy_pay[0] lt (pos1[0] + rad) and $
		   data_lvl2_d1.hit_xy_pay[1] gt (pos1[1] - rad) and $
		   data_lvl2_d1.hit_xy_pay[1] lt (pos1[1] + rad) )
i2 = where(data_lvl2_d2.wsmr_time gt t1 and data_lvl2_d2.wsmr_time lt t2) and $
		   data_lvl2_d2.hit_xy_pay[0] gt (pos2[0] - rad) and $
		   data_lvl2_d2.hit_xy_pay[0] lt (pos2[0] + rad) and $
		   data_lvl2_d2.hit_xy_pay[1] gt (pos2[1] - rad) and $
		   data_lvl2_d2.hit_xy_pay[1] lt (pos2[1] + rad) )
i3 = where(data_lvl2_d3.wsmr_time gt t1 and data_lvl2_d3.wsmr_time lt t2) and $
		   data_lvl2_d3.hit_xy_pay[0] gt (pos3[0] - rad) and $
		   data_lvl2_d3.hit_xy_pay[0] lt (pos3[0] + rad) and $
		   data_lvl2_d3.hit_xy_pay[1] gt (pos3[1] - rad) and $
		   data_lvl2_d3.hit_xy_pay[1] lt (pos3[1] + rad) )
i4 = where(data_lvl2_d4.wsmr_time gt t1 and data_lvl2_d4.wsmr_time lt t2) and $
		   data_lvl2_d4.hit_xy_pay[0] gt (pos4[0] - rad) and $
		   data_lvl2_d4.hit_xy_pay[0] lt (pos4[0] + rad) and $
		   data_lvl2_d4.hit_xy_pay[1] gt (pos4[1] - rad) and $
		   data_lvl2_d4.hit_xy_pay[1] lt (pos4[1] + rad) )
i5 = where(data_lvl2_d5.wsmr_time gt t1 and data_lvl2_d5.wsmr_time lt t2) and $
		   data_lvl2_d5.hit_xy_pay[0] gt (pos5[0] - rad) and $
		   data_lvl2_d5.hit_xy_pay[0] lt (pos5[0] + rad) and $
		   data_lvl2_d5.hit_xy_pay[1] gt (pos5[1] - rad) and $
		   data_lvl2_d5.hit_xy_pay[1] lt (pos5[1] + rad) )
i6 = where(data_lvl2_d6.wsmr_time gt t1 and data_lvl2_d6.wsmr_time lt t2) and $
		   data_lvl2_d6.hit_xy_pay[0] gt (pos6[0] - rad) and $
		   data_lvl2_d6.hit_xy_pay[0] lt (pos6[0] + rad) and $
		   data_lvl2_d6.hit_xy_pay[1] gt (pos6[1] - rad) and $
		   data_lvl2_d6.hit_xy_pay[1] lt (pos6[1] + rad) )

; popen, 'plots/flare_counts', xsize=7, ysize=5
plot,  sim_1det.energy_kev, sim_1det.counts, xr=[1,20],yr=[10.,1.e4], thick=4, psym=10, $
  xtitle='Energy [keV]', ytitle='FOXSI counts/keV', /ylog, /xlog, xstyle=1, line=1, $
  title = 'FOXSI counts for 1 minute, single optic/detector (N-side counts)'
oplot, spec_d0.energy_kev, spec_d0.spec_p, psym=10, thick=4, color=6
oplot, spec_d1.energy_kev, spec_d1.spec_p, psym=10, thick=4, color=7
oplot, spec_d2.energy_kev, spec_d2.spec_p, psym=10, thick=4, color=8
oplot, spec_d3.energy_kev, spec_d3.spec_p, psym=10, thick=4, color=9
oplot, spec_d4.energy_kev, spec_d4.spec_p, psym=10, thick=4, color=10
oplot, spec_d5.energy_kev, spec_d5.spec_p, psym=10, thick=4, color=12
oplot, spec_d6.energy_kev, spec_d6.spec_p, psym=10, thick=4, color=2
legend, ['Simulated flare counts','Det0','Det1','Det2','Det3','Det4','Det5','Det6'], $
		 thick=4, line=[1,0,0,0,0,0,0,0], color=[0,6,7,8,9,10,12,2]
; pclose


;;; Try to characterize blanket absorption
; Simulate a FOXSI spectrum for the thermal plasma.
T = 9.4  ; temperature in MK
EM = 4.8e-3  ; emission measure in units of 10^49
bin=0.3

time_int = 60.

sim_det0 = foxsi_count_spectrum(em, t, time=time_int, binsize=bin, data_dir='detector_data/', $
						 		let_file='efficiency_det108_asic2.sav', /single )
sim_det1 = foxsi_count_spectrum(em, t, time=time_int, binsize=bin, data_dir='detector_data/', $
						 		let_file='efficiency_det109_asic2.sav', /single )
sim_det2 = foxsi_count_spectrum(em, t, time=time_int, binsize=bin, data_dir='detector_data/', $
						 		let_file='efficiency_det102_asic3.sav', /single )
sim_det3 = foxsi_count_spectrum(em, t, time=time_int, binsize=bin, data_dir='detector_data/', $
						 		let_file='efficiency_det103_asic3.sav', /single )
sim_det4 = foxsi_count_spectrum(em, t, time=time_int, binsize=bin, data_dir='detector_data/', $
						 		let_file='efficiency_det104_asic2.sav', /single )
sim_det5 = foxsi_count_spectrum(em, t, time=time_int, binsize=bin, data_dir='detector_data/', $
						 		let_file='efficiency_det105_asic2.sav', /single )
sim_det6 = foxsi_count_spectrum(em, t, time=time_int, binsize=bin, data_dir='detector_data/', $
						 		let_file='efficiency_det106_asic3.sav', /single )

; correct simulated spectra for livetime.
sim_det0 = foxsi_live_correct( sim_det0, time_int )
sim_det1 = foxsi_live_correct( sim_det1, time_int )
sim_det2 = foxsi_live_correct( sim_det2, time_int )
sim_det3 = foxsi_live_correct( sim_det3, time_int )
sim_det4 = foxsi_live_correct( sim_det4, time_int )
sim_det5 = foxsi_live_correct( sim_det5, time_int )
sim_det6 = foxsi_live_correct( sim_det6, time_int )

;plot, sim_det6.energy_kev, sim_det6.counts, xr=[2,10], /xlo, /ylo, /xsty, /ysty, $
plot, sim_det6.energy_kev, test.counts, xr=[2,10], /xlo, /ylo, /xsty, /ysty, $
;	yr=[0.,1.], $
	thick=4, charsize=1.2, xtitle='Energy [keV]', $
;	ytitle='ratio of measured to simulated counts', $
;	title='Comparison of sim and measured counts for detector 6 (1 minute)', $
	psym=10
oplot, spec_d6.energy_kev, spec_d6.spec_p, psym=10, color=2


; Calculate absorption due to various multiples of the blanketing.
mylar=82.55
al=2.6
kapton=203.2

; plot ratio of two and compare to blanketing schemes.
area = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/')
areaX2 = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/', $
			mylar=2.*mylar, al=2*al, kap=2*kapton)
areaX4 = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/', $
			mylar=4.*mylar, al=4*al, kap=4*kapton)
areaX6 = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/', $
			mylar=6.*mylar, al=6*al, kap=6*kapton)

plot, sim_det0.energy_kev, spec_d6.spec_p / sim_det0.counts, xr=[2,10], $
	yr=[0.,1.], $
	thick=4, charsize=1.2, xtitle='Energy [keV]', $
	ytitle='ratio of measured to simulated counts', $
	title='Comparison of sim and measured counts for detector 6 (1 minute)', $
	psym=10, /nodata
oplot, sim_det0.energy_kev, spec_d0.spec_p / 0.9/sim_det0.counts, psym=-1, line=1, color=6
oplot, sim_det1.energy_kev, spec_d1.spec_p / 0.9/sim_det1.counts, psym=-1, line=1, color=7
oplot, sim_det2.energy_kev, spec_d2.spec_p / 0.9/sim_det2.counts, psym=-1, line=1, color=8
oplot, sim_det3.energy_kev, spec_d3.spec_p / 0.9/sim_det3.counts, psym=-1, line=1, color=9
oplot, sim_det4.energy_kev, spec_d4.spec_p / 0.9/sim_det4.counts, psym=-1, line=1, color=10
oplot, sim_det5.energy_kev, spec_d5.spec_p / 0.9/sim_det5.counts, psym=-1, line=1, color=12
oplot, spec_d6.energy_kev, spec_d6.spec_p / 0.9/sim_det6.counts, psym=-1, line=1, color=2

;plot, sim_1det.energy_kev, sim_1det.counts, xr=[2,10], $
;	yr=[0.,1.], $
;	thick=4, charsize=1.2, xtitle='Energy [keV]', $
;	ytitle='ratio of measured to simulated counts', $
;	title='Comparison of sim and measured counts for detector 6 (1 minute)', $
;	psym=10, /nodata
;oplot, sim_det0.energy_kev, 60*(s4_0.spec_p/delta_t4 - s2_0.spec_p/delta_t2) / 0.9/sim_det0.counts, psym=-1, line=1, color=6
;oplot, sim_det1.energy_kev, 60*(s4_1.spec_p/delta_t4 - s2_1.spec_p/delta_t2) / 0.9/sim_det1.counts, psym=-1, line=1, color=7
;oplot, sim_det2.energy_kev, 60*(s4_2.spec_p/delta_t4 - s2_2.spec_p/delta_t2) / 0.9/sim_det2.counts, psym=-1, line=1, color=8
;oplot, sim_det3.energy_kev, 60*(s4_3.spec_p/delta_t4 - s2_3.spec_p/delta_t2) / 0.9/sim_det3.counts, psym=-1, line=1, color=9
;oplot, sim_det4.energy_kev, 60*(s4_4.spec_p/delta_t4 - s2_4.spec_p/delta_t2) / 0.9/sim_det4.counts, psym=-1, line=1, color=10
;oplot, sim_det5.energy_kev, 60*(s4_5.spec_p/delta_t4 - s2_5.spec_p/delta_t2) / 0.9/sim_det5.counts, psym=-1, line=1, color=12
;oplot, sim_det6.energy_kev, 60*(s4_6.spec_p/delta_t4 - s2_6.spec_p/delta_t2) / 0.9/sim_det6.counts, psym=-1, line=1, color=2

oplot_err, sim_1det.energy_kev, spec_d0.spec_p / sim_1det.counts, $
	yerr = sqrt(spec_d0.spec_p)/sim_1det.counts, psym=-1, line=1, color=6
oplot_err, sim_1det.energy_kev, spec_d1.spec_p / sim_1det.counts, $
	yerr = sqrt(spec_d1.spec_p)/sim_1det.counts, psym=-1, line=1, color=7
oplot_err, sim_1det.energy_kev, spec_d2.spec_p / sim_1det.counts, $
	yerr = sqrt(spec_d2.spec_p)/sim_1det.counts, psym=-1, line=1, color=8
oplot_err, sim_1det.energy_kev, spec_d3.spec_p / sim_1det.counts, $
	yerr = sqrt(spec_d3.spec_p)/sim_1det.counts, psym=-1, line=1, color=9
oplot_err, sim_1det.energy_kev, spec_d4.spec_p / sim_1det.counts, $
	yerr = sqrt(spec_d4.spec_p)/sim_1det.counts, psym=-1, line=1, color=10
oplot_err, sim_1det.energy_kev, spec_d5.spec_p / sim_1det.counts, $
	yerr = sqrt(spec_d5.spec_p)/sim_1det.counts, psym=-1, line=1, color=12
oplot_err, sim_1det.energy_kev, spec_d6.spec_p / sim_1det.counts, $
	yerr = sqrt(spec_d6.spec_p)/sim_1det.counts, psym=-1, line=1, color=2

oplot, area.energy_kev, areaX2.eff_area_cm2/area.eff_area_cm2, thick=4, line=1
oplot, area.energy_kev, areaX4.eff_area_cm2/area.eff_area_cm2, thick=4, line=2
oplot, area.energy_kev, areaX6.eff_area_cm2/area.eff_area_cm2, thick=4, line=3
legend, ['effect of 2X blanketing', '4X blanketing', '6X blanketing', $
		 'Det0','Det1','Det2','Det3','Det4','Det5','Det6'], $
		 thick=4, line=[1,2,3,0,0,0,0,0,0,0], color=[1,1,1,6,7,8,9,10,12,2]
		 

plot, sim_1det.energy_kev, spec_d6.spec_p / sim_1det.counts, xr=[2,10], $
	yr=[0.,1.], $
	thick=4, charsize=1.2, xtitle='Energy [keV]', $
	ytitle='ratio of measured to simulated counts', $
	title='Comparison of sim and measured counts for detector 6 (1 minute)', $
	psym=10, /nodata
oplot, sim_1det.energy_kev, spec_d0.spec_n / sim_1det.counts, psym=-1, line=1, color=6
oplot, sim_1det.energy_kev, spec_d1.spec_n / sim_1det.counts, psym=-1, line=1, color=7
oplot, sim_1det.energy_kev, spec_d2.spec_n / sim_1det.counts, psym=-1, line=1, color=8
oplot, sim_1det.energy_kev, spec_d3.spec_n / sim_1det.counts, psym=-1, line=1, color=9
oplot, sim_1det.energy_kev, spec_d4.spec_n / sim_1det.counts, psym=-1, line=1, color=10
oplot, sim_1det.energy_kev, spec_d5.spec_n / sim_1det.counts, psym=-1, line=1, color=12
oplot, sim_1det.energy_kev, spec_d6.spec_n / sim_1det.counts, psym=-1, line=1, color=2

oplot, area.energy_kev, areaX2.eff_area_cm2/area.eff_area_cm2, thick=4, line=1
oplot, area.energy_kev, areaX4.eff_area_cm2/area.eff_area_cm2, thick=4, line=2
oplot, area.energy_kev, areaX6.eff_area_cm2/area.eff_area_cm2, thick=4, line=3
legend, ['effect of 2X blanketing', '4X blanketing', '6X blanketing', $
		 'Det0','Det1','Det2','Det3','Det4','Det5','Det6'], $
		 thick=4, line=[1,2,3,0,0,0,0,0,0,0], color=[1,1,1,6,7,8,9,10,12,2]
		 

;
;	Single-strip events vs shared-charge events
;	Detector 6 as example.
;

shared = make_spectrum( data_lvl2_d6[i6], bin=binwidth, /correct)            
single = make_spectrum( data_lvl2_d6[i6], bin=binwidth, /correct, /single)
plot, shared.energy_kev, shared.spec_p, xr=[1,20], /xlog, /ylog, yr=[1.,1.e4], $
	psym=10, /xsty, /ysty, charsize=1.2, thick=4, $
	xtitle='Energy [keV]', ytitle='Cts/keV', title='D6 spectrum, 6.5-min flight'
oplot, single.energy_kev, single.spec_p, line=1, psym=10, thick=4
legend, ['1-strip energy','3-strip energy'], line=[1,0], thick=4, charsize=1.2, /right


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


t1=t1_start
t2=t6_end
e1=3
e2=15

i0 = where( data_lvl2_d0.error_flag eq 0 and $
	data_lvl2_d0.wsmr_time gt t1 and data_lvl2_d0.wsmr_time lt t2 and  $
	data_lvl2_d0.hit_energy[1] gt e1 and $
	data_lvl2_d0.hit_energy[1] lt e2 )
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


r = [-1200,1200]
shftX = 0
shftY = 0
plot_map,m[0],/limb,center=[0,0],fov=50      
oplot, data_lvl2_d0[i0].hit_xy_solar[0]+shftX, data_lvl2_d0[i0].hit_xy_solar[1]+shftY, psym=3;, xr=r,yr=r
;oplot, data_lvl2_d1[i1].hit_xy_solar[0]+shftX, data_lvl2_d1[i1].hit_xy_solar[1]+shftY, psym=3, color=7
oplot, data_lvl2_d2[i2].hit_xy_solar[0]+shftX, data_lvl2_d2[i2].hit_xy_solar[1]+shftY, psym=3, color=8
;oplot, data_lvl2_d3[i3].hit_xy_solar[0]+shftX, data_lvl2_d3[i3].hit_xy_solar[1]+shftY, psym=3, color=9
oplot, data_lvl2_d4[i4].hit_xy_solar[0]+shftX, data_lvl2_d4[i4].hit_xy_solar[1]+shftY, psym=3, color=10
oplot, data_lvl2_d5[i5].hit_xy_solar[0]+shftX, data_lvl2_d5[i5].hit_xy_solar[1]+shftY, psym=3, color=12
oplot, data_lvl2_d6[i6].hit_xy_solar[0]+shftX, data_lvl2_d6[i6].hit_xy_solar[1]+shftY, psym=3, color=2
xyouts, -1100, 1100, strtrim(e1,2)+'-'+strtrim(e2,2)+'keV'


;
; more imaging, this time using Ishikawa's scripts
;

restore, 'data_2012/foxsi_level2_data.sav', /v
i0 = where( data_lvl2_d0.error_flag eq 0 )
i1 = where( data_lvl2_d1.error_flag eq 0 )
i2 = where( data_lvl2_d2.error_flag eq 0 )
i3 = where( data_lvl2_d3.error_flag eq 0 )
i4 = where( data_lvl2_d4.error_flag eq 0 )
i5 = where( data_lvl2_d5.error_flag eq 0 )
i6 = where( data_lvl2_d6.error_flag eq 0 )

t0 = '2-Nov-2012 17:55:00.000'
t1_start = 108.3		; Target 1 (AR)
t1_end = 151.8
t2_start = 154.8		; Target 2 (AR)
t2_end = 244.7
t3_start = 247			; Target 3 (quiet Sun)
t3_end = 337.3
t4_start = 340			; Target 4 (flare)
t4_end = 421.2
t5_start = 423.5		; Target 5 (off-pointing)
t5_end = 435.9
t6_start = 438.5		; Target 6 (flare)
t6_end = 498.3

pix=20.
xr=[-1300,1300]
yr=[-1300,1300]
img=foxsi_image_solar(data_lvl2_d6, 6,psize=pix)
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix )
plot_map, map, /limb, dmax=5, xr=xr, yr=yr

loadct,4
TVLCT, r, g, b, /Get
TVLCT, Reverse(r), Reverse(g), Reverse(b)


pix=10.
erange=[4,10]
tr = [t4_start, t4_end]
;ind = [1,0,1,0,1,1,1]
ind = [1,0,1,0,1,1,1]
img=foxsi_image_solar_int( data_lvl2_d0[i0], data_lvl2_d1[i1], data_lvl2_d2[i2], $
		data_lvl2_d3[i3], data_lvl2_d4[i4], data_lvl2_d5[i5], data_lvl2_d6[i6], $
		psize=pix, erange=erange, trange=tr, index=ind, /xycor, thr_n=4., /nowin )
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, id='', $
	time=anytim( anytim(t0)+tr[0], /yo) )
plot_map, map, /limb, /cbar, lthick=2,cen=[-750,100],fov=20
plot_map, map, /limb, /cbar, lthick=2,cen=[960,-200],fov=2
plot_map, map, /limb, /cbar, fov=50, lthick=2

plot_map, map, /limb, /cbar, center=[960,-210], fov=2
plot_map, map, /over, levels=[50,95], /per;, color=1
plot_map, map, /limb, /cbar, center=[0,0], fov=50, /log, lcolor=0


cgdisplay, 800,800  
plot_map, map, /limb, dmax=5, xr=xr, yr=yr, charsize=2, charthick=2, /cbar, $
	lcolor=176, lthick=3, color=1, fov=50
xyouts, 400, 1300, 'FOXSI Target 1', color=1, charthick=3, size=2
xyouts, 400, 1100, '90 seconds', color=1, charthick=3, size=2
xyouts, -1300, 1300, 'D0, D2, D4, D5, D6', color=1, charthick=3, size=2
xyouts, -1300, 1100, '15-90 keV', color=1, charthick=3, size=2


; plot effective area, including what we think ours was.

e1 = dindgen(1200)/100+3
e2 = get_edges(e1,/edges_2)
emid = get_edges(e1,/mean)

rhessi = rhessi_eff_area(e1, 0.25, 0)
area = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/')

plot, area.energy_kev, area.eff_area_cm2, line=2, thick=4, yr=[1.,1000], charsize=1.2, $
	xtitle='Energy[keV]', ytitle='Effective area [cm!U2!N]', /ylog
oplot, emid, rhessi, line=1, thick=4
area1 = interpol( area.eff_area_cm2, area.energy_kev, sim_det6.energy_kev )
avg  = spec_d0.spec_p/sim_det0.counts
avg += spec_d1.spec_p/sim_det1.counts
avg += spec_d2.spec_p/sim_det2.counts
avg += spec_d3.spec_p/sim_det3.counts
avg += spec_d4.spec_p/sim_det4.counts
avg += spec_d5.spec_p/sim_det5.counts
avg += spec_d6.spec_p/sim_det6.counts
avg = avg/7.
avg[ where(avg gt 1.) ] = 1.
oplot, sim_det6.energy_kev, avg*area1, thick=4
oplot, sim_det6.energy_kev, area1[where(sim_det6.energy_kev gt 8)], thick=4
legend, ['Nominal FOXSI','FOXSI in-flight','RHESSI'], line=[2,0,1], thick=4

;
; Plot flare centroid positions with and without Ishikawa's correction.
;

pix=10.
erange=[4,15]
tr = [t6_start, t6_end]

img0=foxsi_image_solar(data_lvl2_d0[i0],0,psize=pix,erange=erange,trange=tr,thr_n=4.)
img1=foxsi_image_solar(data_lvl2_d1[i1],0,psize=pix,erange=erange,trange=tr,thr_n=4.)
img2=foxsi_image_solar(data_lvl2_d2[i2],0,psize=pix,erange=erange,trange=tr,thr_n=4.)
img3=foxsi_image_solar(data_lvl2_d3[i3],0,psize=pix,erange=erange,trange=tr,thr_n=4.)
img4=foxsi_image_solar(data_lvl2_d4[i4],0,psize=pix,erange=erange,trange=tr,thr_n=4.)
img5=foxsi_image_solar(data_lvl2_d5[i5],0,psize=pix,erange=erange,trange=tr,thr_n=4.)
img6=foxsi_image_solar(data_lvl2_d6[i6],0,psize=pix,erange=erange,trange=tr,thr_n=4.)

map0 = make_map( img0, xcen=0., ycen=0., dx=pix, dy=pix, id='D0 target3 no alignment')
map1 = make_map( img1, xcen=0., ycen=0., dx=pix, dy=pix, id='D1 target3 no alignment')
map2 = make_map( img2, xcen=0., ycen=0., dx=pix, dy=pix, id='D2 target3 no alignment')
map3 = make_map( img3, xcen=0., ycen=0., dx=pix, dy=pix, id='D3 target3 no alignment')
map4 = make_map( img4, xcen=0., ycen=0., dx=pix, dy=pix, id='D4 target3 no alignment')
map5 = make_map( img5, xcen=0., ycen=0., dx=pix, dy=pix, id='D5 target3 no alignment')
map6 = make_map( img6, xcen=0., ycen=0., dx=pix, dy=pix, id='D6 target3 no alignment')

plot_map, map0, cen=[1000,-300], fov=5
plot_map, map0, cen=[960,-210], fov=5

img0corr=foxsi_image_solar(data_lvl2_d0[i0],0,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img1corr=foxsi_image_solar(data_lvl2_d1[i1],0,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img2corr=foxsi_image_solar(data_lvl2_d2[i2],0,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img3corr=foxsi_image_solar(data_lvl2_d3[i3],0,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img4corr=foxsi_image_solar(data_lvl2_d4[i4],0,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img5corr=foxsi_image_solar(data_lvl2_d5[i5],0,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img6corr=foxsi_image_solar(data_lvl2_d6[i6],0,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)

map0corr = make_map( img0corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D0 target3 w/alignment')
map1corr = make_map( img1corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D1 target3 w/alignment')
map2corr = make_map( img2corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D2 target3 w/alignment')
map3corr = make_map( img3corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D3 target3 w/alignment')
map4corr = make_map( img4corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D4 target3 w/alignment')
map5corr = make_map( img5corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D5 target3 w/alignment')
map6corr = make_map( img6corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D6 target3 w/alignment')

plot_map, map0corr, cen=[960,-210], fov=5

npix = n_elements(img0[0,*])
axis = (findgen( npix ) - npix/2)*pix

img0[ where(img0 lt 3) ] = 0
img1[ where(img1 lt 3) ] = 0
img2[ where(img2 lt 3) ] = 0
img3[ where(img3 lt 3) ] = 0
img4[ where(img4 lt 3) ] = 0
img5[ where(img5 lt 3) ] = 0
img6[ where(img6 lt 3) ] = 0

map_xymoments, img0, axis, axis, centr0, stddev0
map_xymoments, img1, axis, axis, centr1, stddev1
map_xymoments, img2, axis, axis, centr2, stddev2
map_xymoments, img3, axis, axis, centr3, stddev3
map_xymoments, img4, axis, axis, centr4, stddev4
map_xymoments, img5, axis, axis, centr5, stddev5
map_xymoments, img6, axis, axis, centr6, stddev6

map_xymoments, img0corr, axis, axis, centr0corr, stddev0corr
map_xymoments, img1corr, axis, axis, centr1corr, stddev1corr
map_xymoments, img2corr, axis, axis, centr2corr, stddev2corr
map_xymoments, img3corr, axis, axis, centr3corr, stddev3corr
map_xymoments, img4corr, axis, axis, centr4corr, stddev4corr
map_xymoments, img5corr, axis, axis, centr5corr, stddev5corr
map_xymoments, img6corr, axis, axis, centr6corr, stddev6corr

window, 0, xsize=1200, ysize=600
!p.multi=[0,4,2]
plot_map, map0, cen=[1030,-300], fov=6
oplot, [centr0[0]], [centr0[1]], color=0, /psym, symsize=2, thick=2
plot_map, map1, cen=[1030,-300], fov=6
oplot, [centr1[0]], [centr1[1]], color=0, /psym, symsize=2, thick=2
plot_map, map2, cen=[1030,-300], fov=6
oplot, [centr2[0]], [centr2[1]], color=0, /psym, symsize=2, thick=2
plot_map, map3, cen=[1030,-300], fov=6
oplot, [centr3[0]], [centr3[1]], color=0, /psym, symsize=2, thick=2
plot_map, map4, cen=[1030,-300], fov=6
oplot, [centr4[0]], [centr4[1]], color=0, /psym, symsize=2, thick=2
plot_map, map5, cen=[1030,-300], fov=6
oplot, [centr5[0]], [centr5[1]], color=0, /psym, symsize=2, thick=2
plot_map, map6, cen=[1030,-300], fov=6, /limb
oplot, [centr6[0]], [centr6[1]], color=0, /psym, symsize=2, thick=2


restore,'data_2012/rhessi_imaging_foxsi_flare_march2013.sav',/ver

loadct2,3
center=[960,-205]
fov=1.5
!p.multi=[0,4,1]
;RHESSI
loadct2,5
plot_map,c3n,/limb,center=center,fov=fov,bot=8,lcolor=255,gcolor=255,grid=2
plot_map,vff,/over,/per,levels=[50],color=255,thick=2
plot_map,njmap,/limb,center=center,fov=fov,bot=8,lcolor=255,gcolor=255,grid=2
plot_map,vff,/over,/per,levels=[50],color=255,thick=2
plot_map,vff,/limb,center=center,fov=fov,bot=8,lcolor=255,gcolor=255,grid=2
plot_map,vff,/over,/per,levels=[50],color=255,thick=2
plot_map,pmap,/limb,center=center,fov=fov,bot=8,lcolor=255,gcolor=255,grid=2
plot_map,vff,/over,/per,levels=[50],color=255,thick=2
