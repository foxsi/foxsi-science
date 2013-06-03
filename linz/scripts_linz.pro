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
sim_1det.counts = sim_tot.counts; / 7.
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
t1 = t3_start
t2 = t3_end
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

sim = foxsi_live_correct( sim_1det, 60 )
spec_sum = spec_d0.spec_p + spec_d2.spec_p + spec_d3.spec_p + $
	spec_d4.spec_p + spec_d5.spec_p + spec_d6.spec_p


popen, xsize=7, ysize=5
plot,  spec_d6.energy_kev, spec_sum/delta_t, xr=[2,12], thick=4, psym=10, /xlog, /ylog, $
  xtitle='Energy [keV]', ytitle='FOXSI counts s!U-1!N keV!U-1!N', xstyle=1, line=0, $
  title = 'FOXSI count spectra, Flare', charsize=1.2, yr=[1.,1.e4], /ysty
oplot, sim_1det.energy_kev, sim_1det.counts/60., psym=10, thick=6, line=1
legend, ['Simulated','Observed'], line=[1,0], thick=4, /right, box=0
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

add_path,'img'
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

cen1 = [-480,-350]
cen2 = [-850, 150]
cen3 = [ 600, 400]
cen4 = [ 700,-600]
cen5 = [1000,-900]
cen6 = [ 700,-600]

pix=20.
xr=[-1300,1300]
yr=[-1300,1300]
img=foxsi_image_solar(data_lvl2_d6, 6,psize=pix)
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix )
plot_map, map, /limb, dmax=5, xr=xr, yr=yr

loadct, 4
TVLCT, r, g, b, /Get
r[0]=255
g[0]=255
b[0]=255

pix=100.
erange=[4,15]
cen=[600,600]
cen=[-200,-200]
cen=[960,-200]
tr = [t1_start, t1_end]
ind = [1,0,1,0,1,1,1]
img=foxsi_image_solar_int( data_lvl2_d0[i0], data_lvl2_d1[i1], data_lvl2_d2[i2], $
		data_lvl2_d3[i3], data_lvl2_d4[i4], data_lvl2_d5[i5], data_lvl2_d6[i6], $
		psize=pix, erange=erange, trange=tr, index=ind, /xycor, thr_n=4., /nowin )
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, id='', $
	time=anytim( anytim(t0)+tr[0], /yo) )
;popen, 'plots/target1-pix80', xsize=7, ysize=7
;plot_map, map, /limb, /cbar, cen=[900,250], fov=25, color=1, $
;	lcolor=200, lthick=6, charsize=1.2, charthick=2
;pclose
;plot_map, map, /limb, /cbar, cen=cen, fov=25
plot_map, map, /limb, /cbar, cen=cen, fov=5


loadct, 1
TVLCT, r, g, b, /get
;r[254:255]=[255,0]
;g[254:255]=[0,0]
;b[254:255]=[255,0]
TVLCT, reverse(r), reverse(g), reverse(b)
pix=100.
erange=[4,10]
tr = [t2_start, t2_end]
ind = [1,0,1,0,1,1,1]
img=foxsi_image_solar_int( data_lvl2_d0[i0], data_lvl2_d1[i1], data_lvl2_d2[i2], $
		data_lvl2_d3[i3], data_lvl2_d4[i4], data_lvl2_d5[i5], data_lvl2_d6[i6], $
		psize=pix, erange=erange, trange=tr, index=ind, /xycor, thr_n=4., /nowin )
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, id='FOXSI', $
	time=anytim( anytim(t0)+tr[0], /yo) )
popen, 'plots/target1-pix100', xsize=7, ysize=7
plot_map, map, /limb, /cbar, cen=[-900,250], fov=25, color=255, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, top=200, thick=3
xyouts, -1600, 900, '90 sec integration', color=255, size=1.2
xyouts, -1600, 800, '4-10 keV', color=255, size=1.2
pclose

;plot_map, map, /limb, /cbar, lthick=2,cen=[960,-200],fov=2
plot_map, map, /limb, /cbar, cen=[-900,250], fov=25

c=map_centroid(map, thresh=10)
oplot, [c[0]], [c[1]], /psy, symsize=5, color=255

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

i0 = where( data_lvl2_d0.error_flag eq 0 )
i1 = where( data_lvl2_d1.error_flag eq 0 )
i2 = where( data_lvl2_d2.error_flag eq 0 )
i3 = where( data_lvl2_d3.error_flag eq 0 )
i4 = where( data_lvl2_d4.error_flag eq 0 )
i5 = where( data_lvl2_d5.error_flag eq 0 )
i6 = where( data_lvl2_d6.error_flag eq 0 )

;i0 = where( data_lvl2_d0.inflight eq 1 )
;i1 = where( data_lvl2_d1.inflight eq 1 )
;i2 = where( data_lvl2_d2.inflight eq 1 )
;i3 = where( data_lvl2_d3.inflight eq 1 )
;i4 = where( data_lvl2_d4.inflight eq 1 )
;i5 = where( data_lvl2_d5.inflight eq 1 )
;i6 = where( data_lvl2_d6.inflight eq 1 )

;
; Plot flare centroid positions with and without Ishikawa's correction.
;

pix=80.
erange=[4,15]
tr = [t2_start, t2_end]

img0=foxsi_image_solar(data_lvl2_d0[i0],0,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img1=foxsi_image_solar(data_lvl2_d1[i1],1,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img2=foxsi_image_solar(data_lvl2_d2[i2],2,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img3=foxsi_image_solar(data_lvl2_d3[i3],3,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img4=foxsi_image_solar(data_lvl2_d4[i4],4,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img5=foxsi_image_solar(data_lvl2_d5[i5],5,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img6=foxsi_image_solar(data_lvl2_d6[i6],6,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor)
img=foxsi_image_solar_int( data_lvl2_d0[i0], data_lvl2_d1[i1], data_lvl2_d2[i2], $
		data_lvl2_d3[i3], data_lvl2_d4[i4], data_lvl2_d5[i5], data_lvl2_d6[i6], $
		psize=pix, erange=erange, trange=tr, index=ind, thr_n=4., /nowin, /xycor )

map0 = make_map( img0, xcen=0., ycen=0., dx=pix, dy=pix, id='D0',time=anytim( anytim(t0)+tr[0], /yo))
map1 = make_map( img1, xcen=0., ycen=0., dx=pix, dy=pix, id='D1',time=anytim( anytim(t0)+tr[0], /yo))
map2 = make_map( img2, xcen=0., ycen=0., dx=pix, dy=pix, id='D2',time=anytim( anytim(t0)+tr[0], /yo))
map3 = make_map( img3, xcen=0., ycen=0., dx=pix, dy=pix, id='D3',time=anytim( anytim(t0)+tr[0], /yo))
map4 = make_map( img4, xcen=0., ycen=0., dx=pix, dy=pix, id='D4',time=anytim( anytim(t0)+tr[0], /yo))
map5 = make_map( img5, xcen=0., ycen=0., dx=pix, dy=pix, id='D5',time=anytim( anytim(t0)+tr[0], /yo))
map6 = make_map( img6, xcen=0., ycen=0., dx=pix, dy=pix, id='D6',time=anytim( anytim(t0)+tr[0], /yo))
map  = make_map( img,  xcen=0., ycen=0., dx=pix, dy=pix, id='5dets',time=anytim( anytim(t0)+tr[0], /yo))

!p.multi=[0,2,4]
loadct,5
TVLCT, r, g, b, /get
TVLCT, reverse(r), reverse(g), reverse(b)
mx=5
cen=cen2
targ=2
popen, xsi=5, ysi=10
plot_map, map0, /limb, /cbar, cen=cen, fov=22, color=255, dmax=mx, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=0, target=targ, col=255
plot_map, map1, /limb, /cbar, cen=cen, fov=22, color=255, dmax=mx, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=1, target=targ, col=255
plot_map, map2, /limb, /cbar, cen=cen, fov=22, color=255, dmax=mx, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=2, target=targ, col=255
plot_map, map3, /limb, /cbar, cen=cen, fov=22, color=255, dmax=mx, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=3, target=targ, col=255
plot_map, map4, /limb, /cbar, cen=cen, fov=22, color=255, dmax=mx, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=4, target=targ, col=255
plot_map, map5, /limb, /cbar, cen=cen, fov=22, color=255, dmax=mx, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=5, target=targ, col=255
plot_map, map6, /limb, /cbar, cen=cen, fov=22, color=255, dmax=mx, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, det=6, target=targ, col=255
plot_map, map, /limb, /cbar, cen=cen, fov=22, color=255, dmax=mx, $
	lcolor=255, lthick=4, charsize=1.2, charthick=8, thick=3
draw_fov, /all, target=targ, col=255
pclose

plot_map, aia_maps[0], /log, fov=50, /limb, charthick=2, thick=2
draw_fov, det=4, targ=1, thick=2
draw_fov, det=4, targ=2, thick=2
draw_fov, det=4, targ=3, thick=2
draw_fov, det=4, targ=4, thick=2
xyouts, -950, -750, '0', size=2
xyouts, -1300, -200, '1', size=2
xyouts, 975, 675, '2', size=2
xyouts, 1000, -1000, '3', size=2
hsi_linecolors
oplot, [965],[-200], psym=1, symsize=5, thick=5, color=12

mapRaw = [map0, map1, map2, map3, map4, map5, map6]
centroidRaw = fltarr(2,7)
for i=0, 6 do centroidRaw[*,i] = map_centroid( mapRaw[i], thresh=10 )

popen, xsi=5, ysi=10
!p.multi=[0,2,4]
loadct, 1
TVLCT, r, g, b, /get
r[254:255]=[255,0]
g[254:255]=[0,0]
b[254:255]=[255,0]
TVLCT, reverse(r), reverse(g), reverse(b)
plot_map, map0, cen=[1000,-300], fov=5, bot=2, tit='Det 0, Target 3, No coalign'
oplot, [centr0[0]], [centr0[1]], /psy, symsize=3, thick=4, color=1
xyouts,875,-425,'Centroid: '+ string(fix(centr0[0]))+ string(fix(centr0[1])) +' arcsec',$
	size=0.7
plot_map, map1, cen=[1000,-300], fov=5, bot=2, tit='Det 1, Target 3, No coalign'
oplot, [centr1[0]], [centr1[1]], /psy, symsize=3, thick=4, color=1
xyouts,875,-425,'Centroid: '+ string(fix(centr1[0]))+ string(fix(centr1[1])) +' arcsec',$
	size=0.7
plot_map, map2, cen=[1000,-300], fov=5, bot=2, tit='Det 2, Target 3, No coalign'
oplot, [centr2[0]], [centr2[1]], /psy, symsize=3, thick=4, color=1
xyouts,875,-425,'Centroid: '+ string(fix(centr2[0]))+ string(fix(centr2[1])) +' arcsec',$
	size=0.7
plot_map, map3, cen=[1000,-300], fov=5, bot=2, tit='Det 3, Target 3, No coalign'
oplot, [centr3[0]], [centr3[1]], /psy, symsize=3, thick=4, color=1
xyouts,875,-425,'Centroid: '+ string(fix(centr3[0]))+ string(fix(centr3[1])) +' arcsec',$
	size=0.7
plot_map, map4, cen=[1000,-300], fov=5, bot=2, tit='Det 4, Target 3, No coalign'
oplot, [centr4[0]], [centr4[1]], /psy, symsize=3, thick=4, color=1
xyouts,875,-425,'Centroid: '+ string(fix(centr4[0]))+ string(fix(centr4[1])) +' arcsec',$
	size=0.7
plot_map, map5, cen=[1000,-300], fov=5, bot=2, tit='Det 5, Target 3, No coalign'
oplot, [centr5[0]], [centr5[1]], /psy, symsize=3, thick=4, color=1
xyouts,875,-425,'Centroid: '+ string(fix(centr5[0]))+ string(fix(centr5[1])) +' arcsec',$
	size=0.7
plot_map, map6, cen=[1000,-300], fov=5, bot=2, tit='Det 6, Target 3, No coalign'
oplot, [centr6[0]], [centr6[1]], /psy, symsize=3, thick=4, color=1
xyouts,875,-425,'Centroid: '+ string(fix(centr6[0]))+ string(fix(centr6[1])) +' arcsec',$
	size=0.7
pclose

img0corr=foxsi_image_solar(data_lvl2_d0[i0],0,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img1corr=foxsi_image_solar(data_lvl2_d1[i1],1,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img2corr=foxsi_image_solar(data_lvl2_d2[i2],2,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img3corr=foxsi_image_solar(data_lvl2_d3[i3],3,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img4corr=foxsi_image_solar(data_lvl2_d4[i4],4,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img5corr=foxsi_image_solar(data_lvl2_d5[i5],5,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)
img6corr=foxsi_image_solar(data_lvl2_d6[i6],6,psize=pix,erange=erange,trange=tr,/xycor,thr_n=4.)

map0corr = make_map( img0corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D0 target3 w/alignment')
map1corr = make_map( img1corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D1 target3 w/alignment')
map2corr = make_map( img2corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D2 target3 w/alignment')
map3corr = make_map( img3corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D3 target3 w/alignment')
map4corr = make_map( img4corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D4 target3 w/alignment')
map5corr = make_map( img5corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D5 target3 w/alignment')
map6corr = make_map( img6corr, xcen=0., ycen=0., dx=pix, dy=pix, id='D6 target3 w/alignment')

mapCorr = [map0corr, map1corr, map2corr, map3corr, map4corr, map5corr, map6corr]
centroidCorr = fltarr(2,7)
for i=0, 6 do centroidCorr[*,i] = map_centroid( mapCorr[i], thresh=10 )

popen, xsi=5, ysi=10
!p.multi=[0,2,4]
loadct, 1
TVLCT, r, g, b, /get
r[254:255]=[255,0]
g[254:255]=[0,0]
b[254:255]=[255,0]
TVLCT, reverse(r), reverse(g), reverse(b)
cen=[975,-175]
cen=[1000,-300]
plot_map, map0corr, cen=cen, fov=5, bot=2, tit='Det 0, Target 3, Ishikawa coalign'
oplot, [centr0corr[0]], [centr0corr[1]], /psy, symsize=3, thick=4, color=1
xyouts,850,-300,'Centroid: '+ string(fix(centr0corr[0]))+ string(fix(centr0corr[1])) +' arcsec',$
	size=0.7
plot_map, map1corr, cen=cen, fov=5, bot=2, tit='Det 1, Target 3, Ishikawa coalign'
oplot, [centr1corr[0]], [centr1corr[1]], /psy, symsize=3, thick=4, color=1
xyouts,850,-300,'Centroid: '+ string(fix(centr1corr[0]))+ string(fix(centr1corr[1])) +' arcsec',$
	size=0.7
plot_map, map2corr, cen=cen, fov=5, bot=2, tit='Det 2, Target 3, Ishikawa coalign'
oplot, [centr2corr[0]], [centr2corr[1]], /psy, symsize=3, thick=4, color=1
xyouts,850,-300,'Centroid: '+ string(fix(centr2corr[0]))+ string(fix(centr2corr[1])) +' arcsec',$
	size=0.7
plot_map, map3corr, cen=cen, fov=5, bot=2, tit='Det 3, Target 3, Ishikawa coalign'
oplot, [centr3corr[0]], [centr3corr[1]], /psy, symsize=3, thick=4, color=1
xyouts,850,-300,'Centroid: '+ string(fix(centr3corr[0]))+ string(fix(centr3corr[1])) +' arcsec',$
	size=0.7
plot_map, map4corr, cen=cen, fov=5, bot=2, tit='Det 4, Target 3, Ishikawa coalign'
oplot, [centr4corr[0]], [centr4corr[1]], /psy, symsize=3, thick=4, color=1
xyouts,850,-300,'Centroid: '+ string(fix(centr4corr[0]))+ string(fix(centr4corr[1])) +' arcsec',$
	size=0.7
plot_map, map5corr, cen=cen, fov=5, bot=2, tit='Det 5, Target 3, Ishikawa coalign'
oplot, [centr5corr[0]], [centr5corr[1]], /psy, symsize=3, thick=4, color=1
xyouts,850,-300,'Centroid: '+ string(fix(centr5corr[0]))+ string(fix(centr5corr[1])) +' arcsec',$
	size=0.7
plot_map, map6corr, cen=cen, fov=5, bot=2, tit='Det 6, Target 3, Ishikawa coalign'
oplot, [centr6corr[0]], [centr6corr[1]], /psy, symsize=3, thick=4, color=1
xyouts,850,-300,'Centroid: '+ string(fix(centr6corr[0]))+ string(fix(centr6corr[1])) +' arcsec',$
	size=0.7
pclose

;
; Fix the roll!  Start from the uncorrected images.
; Fix it all to D6.
;

rhessi_cen = [963.3,-203.5]

for i=0, 6 do centroidRaw[*,i] = map_centroid( mapRaw[i], thresh=8 )  
cenFOV = [700,-600]
theta = fltarr(7)
for i=0, 6 do $
	theta[i] = atan( (centroidRaw[1,i]-cenFOV[1])/(centroidRaw[0,i]-cenFOV[0]) ) $
			 - atan( (centroidRaw[1,6]-cenFOV[1])/(centroidRaw[0,6]-cenFOV[0]) )
print,theta

for i=0, 6 do mapCorr[i] = rot_map( mapRaw[i], 180/!pi*theta[i], cen=cenFOV )
for i=0, 6 do centroidCorr[*,i] = map_centroid( mapCorr[i], thresh=8 )  
plot, centroidRaw[0,*], centroidRaw[1,*], psym=1,color=2,xr=[900,1200],yr=[-400,-200]
oplot, centroidCorr[0,*], centroidCorr[1,*], psym=1, color=1

;
; Next correction: translate to RHESSI position
;

offsetXY = fltarr(2,7)
for i=0, 6 do offsetXY[*,i] = rhessi_cen - centroidCorr[*,i]
plot, centroidRaw[0,*], centroidRaw[1,*], psym=1,color=2,xr=[800,1200],yr=[-400,-100]
oplot, centroidCorr[0,*], centroidCorr[1,*], psym=1, color=1
oplot, centroidCorr[0,*]+offsetXY[0,*], centroidCorr[1,*]+offsetXY[1,*], psym=1, color=64

;
; Now we have the corrections; apply them to an image.
;

pix=40.
erange=[4,15]
tr = [t2_start, t2_end]
cenFOV = [-850,150]
;ind = [1,0,1,0,1,1,1]
img=foxsi_image_solar(data_lvl2_d0[i0], 0, psize=pix, eran=erange, tran=tr, thr=4.)
map0 = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, id='')
img=foxsi_image_solar(data_lvl2_d2[i2], 2, psize=pix, eran=erange, tran=tr, thr=4.)
map2 = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, id='')
img=foxsi_image_solar(data_lvl2_d4[i4], 4, psize=pix, eran=erange, tran=tr, thr=4.)
map4 = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, id='')
img=foxsi_image_solar(data_lvl2_d5[i5], 5, psize=pix, eran=erange, tran=tr, thr=4.)
map5 = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, id='')
img=foxsi_image_solar(data_lvl2_d6[i6], 6, psize=pix, eran=erange, tran=tr, thr=4.)
map6 = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix, id='')
;map0 = rot_map( map0, theta[0]*180/!pi, cen=cenFOV )
;map2 = rot_map( map2, theta[2]*180/!pi, cen=cenFOV )
;map4 = rot_map( map4, theta[4]*180/!pi, cen=cenFOV )
;map5 = rot_map( map5, theta[5]*180/!pi, cen=cenFOV )
;map6 = rot_map( map6, theta[6]*180/!pi, cen=cenFOV )
map0.xc += offsetXY[0,0]
map2.xc += offsetXY[0,2]
map4.xc += offsetXY[0,4]
map5.xc += offsetXY[0,5]
map6.xc += offsetXY[0,6]
map0.yc += offsetXY[1,0]
map2.yc += offsetXY[1,2]
map4.yc += offsetXY[1,4]
map5.yc += offsetXY[1,5]
map6.yc += offsetXY[1,6]
plot_map, map0, /limb, /cbar, cen=[-900,250], fov=25
plot_map, map2, /limb, /cbar, cen=[-900,250], fov=25
plot_map, map4, /limb, /cbar, cen=[-900,250], fov=25
plot_map, map5, /limb, /cbar, cen=[-900,250], fov=25
plot_map, map6, /limb, /cbar, cen=[-900,250], fov=25
map = map0
map.data = map0.data+map2.data+map4.data+map5.data+map6.data
plot_map, map, /limb, /cbar, cen=[-900,250], fov=25



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

;
; PSF simulations -- Ron Elsner's data / routines
;

add_path, 'psf'
.compile plot_psf_linz

file = 'psf/plot_psf_linear_better_offax15'
plot_psf, 15, thresh=0.3, file=file
spawn, 'ps2pdf '+file+'.ps '+file+'.pdf'

; Plot the FWHM vs off-axis angle, in each direction.

angle = [0., 3., 6., 9., 12., 15. ]
x = [7.4, 10.4, 18.0, 20.7, 21.3, 24.6 ]
y = [7.4, 10.3, 16.9, 18.7, 18.2, 16.9 ]

popen, 'psf/fwhm', xsize=7, ysize=5
!p.multi=0
plot, angle, x, psym=-7, line=0, thick=4, charsize=1.2, $
	xtit='Off-axis angle [arcmin]', ytit='PSF FWHM', $
	title='Results from PSF simulations'
oplot, angle, y, psym=-7, line=0, thick=4
pclose

;
; look at spectra on and off the disk for the second target.
;

f1map094=map_rflag_cube(dmap094,r=1000,/out)

add_path,'img'
restore, 'data_2012/foxsi_level2_data.sav', /v

t_launch = 64500
t2_start = t_launch + 154.8		; Target 2 (AR)
t2_end = t_launch + 244.7
t1 = t2_start
t2 = t2_end
t0 = '2-Nov-2012 17:55:00.000'
binwidth=1.0

d0 = data_lvl2_d0
d1 = data_lvl2_d1
d2 = data_lvl2_d2
d3 = data_lvl2_d3
d4 = data_lvl2_d4
d5 = data_lvl2_d5
d6 = data_lvl2_d6
i0a = where( d0.error_flag eq 0 and sqrt(d0.hit_xy_solar[0]^2+d0.hit_xy_solar[1]^2) lt 917$
	 		and d0.wsmr_time gt t1 and d0.wsmr_time lt t2 $
	 		and d0.hit_energy[1] gt 4 and d0.hit_energy[1] lt 15)
i0b = where( d0.error_flag eq 0 and sqrt(d0.hit_xy_solar[0]^2+d0.hit_xy_solar[1]^2) gt 1017$
	 		and d0.wsmr_time gt t1 and d0.wsmr_time lt t2 $
	 		and d0.hit_energy[1] gt 4 and d0.hit_energy[1] lt 15)
i1a = where( d1.error_flag eq 0 and sqrt(d1.hit_xy_solar[0]^2+d1.hit_xy_solar[1]^2) lt 917$ 
			and d1.wsmr_time gt t1 and d1.wsmr_time lt t2 $
			and d1.hit_energy[1] gt 4 and d1.hit_energy[1] lt 15)
i1b = where( d1.error_flag eq 0 and sqrt(d1.hit_xy_solar[0]^2+d1.hit_xy_solar[1]^2) gt 1017$ 
			and d1.wsmr_time gt t1 and d1.wsmr_time lt t2 $
			and d1.hit_energy[1] gt 4 and d1.hit_energy[1] lt 15)
i2a = where( d2.error_flag eq 0 and sqrt(d2.hit_xy_solar[0]^2+d2.hit_xy_solar[1]^2) lt 917$ 
			and d2.wsmr_time gt t1 and d2.wsmr_time lt t2 $
			and d2.hit_energy[1] gt 4 and d2.hit_energy[1] lt 15)
i2b = where( d2.error_flag eq 0 and sqrt(d2.hit_xy_solar[0]^2+d2.hit_xy_solar[1]^2) gt 1017$ 
			and d2.wsmr_time gt t1 and d2.wsmr_time lt t2 $
			and d2.hit_energy[1] gt 4 and d2.hit_energy[1] lt 15)
i3a = where( d3.error_flag eq 0 and sqrt(d3.hit_xy_solar[0]^2+d3.hit_xy_solar[1]^2) lt 917$ 
			and d3.wsmr_time gt t1 and d3.wsmr_time lt t2 $
			and d3.hit_energy[1] gt 4 and d3.hit_energy[1] lt 15)
i3b = where( d3.error_flag eq 0 and sqrt(d3.hit_xy_solar[0]^2+d3.hit_xy_solar[1]^2) gt 1017$ 
			and d3.wsmr_time gt t1 and d3.wsmr_time lt t2 $
			and d3.hit_energy[1] gt 4 and d3.hit_energy[1] lt 15)
i4a = where( d4.error_flag eq 0 and sqrt(d4.hit_xy_solar[0]^2+d4.hit_xy_solar[1]^2) lt 917$ 
			and d4.wsmr_time gt t1 and d4.wsmr_time lt t2 $
			and d4.hit_energy[1] gt 4 and d4.hit_energy[1] lt 15)
i4b = where( d4.error_flag eq 0 and sqrt(d4.hit_xy_solar[0]^2+d4.hit_xy_solar[1]^2) gt 1017$ 
			and d4.wsmr_time gt t1 and d4.wsmr_time lt t2 $
			and d4.hit_energy[1] gt 4 and d4.hit_energy[1] lt 15)
i5a = where( d5.error_flag eq 0 and sqrt(d5.hit_xy_solar[0]^2+d5.hit_xy_solar[1]^2) lt 917$ 
			and d5.wsmr_time gt t1 and d5.wsmr_time lt t2 $
			and d5.hit_energy[1] gt 4 and d5.hit_energy[1] lt 15)
i5b = where( d5.error_flag eq 0 and sqrt(d5.hit_xy_solar[0]^2+d5.hit_xy_solar[1]^2) gt 1017$ 
			and d5.wsmr_time gt t1 and d5.wsmr_time lt t2 $
			and d5.hit_energy[1] gt 4 and d5.hit_energy[1] lt 15)
i6a = where( d6.error_flag eq 0 and sqrt(d6.hit_xy_solar[0]^2+d6.hit_xy_solar[1]^2) lt 917$
			and d6.wsmr_time gt t1 and d6.wsmr_time lt t2 $
			and d6.hit_energy[1] gt 4 and d6.hit_energy[1] lt 15)
i6b = where( d6.error_flag eq 0 and sqrt(d6.hit_xy_solar[0]^2+d6.hit_xy_solar[1]^2) gt 1017$
			and d6.wsmr_time gt t1 and d6.wsmr_time lt t2 $
			and d6.hit_energy[1] gt 4 and d6.hit_energy[1] lt 15)

bin=1.0
spex0a = make_spectrum( data_lvl2_d0[i0a], bin=bin)
spex0b = make_spectrum( data_lvl2_d0[i0b], bin=bin);, /corr )
spex1a = make_spectrum( data_lvl2_d1[i1a], bin=bin);, /corr )
spex1b = make_spectrum( data_lvl2_d1[i1b], bin=bin);, /corr )
spex2a = make_spectrum( data_lvl2_d2[i2a], bin=bin);, /corr )
spex2b = make_spectrum( data_lvl2_d2[i2b], bin=bin);, /corr )
spex3a = make_spectrum( data_lvl2_d3[i3a], bin=bin);, /corr )
spex3b = make_spectrum( data_lvl2_d3[i3b], bin=bin);, /corr )
spex4a = make_spectrum( data_lvl2_d4[i4a], bin=bin);, /corr )
spex4b = make_spectrum( data_lvl2_d4[i4b], bin=bin);, /corr )
spex5a = make_spectrum( data_lvl2_d5[i5a], bin=bin);, /corr )
spex5b = make_spectrum( data_lvl2_d5[i5b], bin=bin);, /corr )
spex6a = make_spectrum( data_lvl2_d6[i6a], bin=bin)
spex6b = make_spectrum( data_lvl2_d6[i6b], bin=bin)

spexa = spex6a
spexb = spex6b
spexa.spec_n = spex0a.spec_n + spex2a.spec_n + spex4a.spec_n + spex5a.spec_n + spex6a.spec_n
spexa.spec_p = spex0a.spec_p + spex2a.spec_p + spex4a.spec_p + spex5a.spec_p + spex6a.spec_p
spexb.spec_n = spex0b.spec_n + spex2b.spec_n + spex4b.spec_n + spex5b.spec_n + spex6b.spec_n
spexb.spec_p = spex0b.spec_p + spex2b.spec_p + spex4b.spec_p + spex5b.spec_p + spex6b.spec_p

plot, spexa.energy_kev, spexa.spec_p, /xlo, /ylo, psym=10, xr=[3.,13.], /xsty, $
	yr=[1.e-1,100.], /ysty, thick=4, charsize=1.2, $
	xtit='Energy [keV]', ytit='Counts/keV', $
	title='On- and off-disk count spectra for second target, D0,2,4,5,6'
oplot, spexa.energy_kev, spexa.spec_p, psym=10, color=7, thick=4
oplot_err, spexa.energy_kev, spexa.spec_p, yerr=sqrt(spexa.spec_p*bin)/bin, color=7, thick=4
oplot, spexb.energy_kev, spexb.spec_p, psym=10, color=6, thick=4
oplot_err, spexb.energy_kev, spexb.spec_p, yerr=sqrt(spexb.spec_p*bin)/bin, color=6, thick=4
legend,['on-disk','off-disk'],color=[7,6],line=0

plot, spexa.energy_kev, spexa.spec_p/spexb.spec_p, /xlo, psym=10, xr=[3.,13.], /xsty, $
	;yr=[1.e-1,100.], /ysty, 
	thick=4, charsize=1.2, $
	xtit='Energy [keV]', ytit='Counts/keV', $
	title='Ratio of on- to off-disk count spectra for second target, D0,2,4,5,6'


t1=t4_start
t2=t4_end
i0 = where( d0.error_flag eq 0 and d0.wsmr_time gt t1 and d0.wsmr_time lt t2 $
	 		and d0.hit_energy[1] gt 4 and d0.hit_energy[1] lt 15)
i1 = where( d1.error_flag eq 0 and d1.wsmr_time gt t1 and d1.wsmr_time lt t2 $
			and d1.hit_energy[1] gt 4 and d1.hit_energy[1] lt 15)
i2 = where( d2.error_flag eq 0 and d2.wsmr_time gt t1 and d2.wsmr_time lt t2 $
			and d2.hit_energy[1] gt 4 and d2.hit_energy[1] lt 15)
i3 = where( d3.error_flag eq 0 and d3.wsmr_time gt t1 and d3.wsmr_time lt t2 $
			and d3.hit_energy[1] gt 4 and d3.hit_energy[1] lt 15)
i4 = where( d4.error_flag eq 0 and d4.wsmr_time gt t1 and d4.wsmr_time lt t2 $
			and d4.hit_energy[1] gt 4 and d4.hit_energy[1] lt 15)
i5 = where( d5.error_flag eq 0 and d5.wsmr_time gt t1 and d5.wsmr_time lt t2 $
			and d5.hit_energy[1] gt 4 and d5.hit_energy[1] lt 15)
i6 = where( d6.error_flag eq 0 and d6.wsmr_time gt t1 and d6.wsmr_time lt t2 $
			and d6.hit_energy[1] gt 4 and d6.hit_energy[1] lt 15)

spex0flare = make_spectrum( data_lvl2_d0[i0], bin=bin)
spex1flare = make_spectrum( data_lvl2_d1[i1], bin=bin)
spex2flare = make_spectrum( data_lvl2_d2[i2], bin=bin)
spex3flare = make_spectrum( data_lvl2_d3[i3], bin=bin)
spex4flare = make_spectrum( data_lvl2_d4[i4], bin=bin)
spex5flare = make_spectrum( data_lvl2_d5[i5], bin=bin)
spex6flare = make_spectrum( data_lvl2_d6[i6], bin=bin)

spexflare = spex6flare
spexflare.spec_n = spex0flare.spec_n + spex2flare.spec_n + spex4flare.spec_n + spex5flare.spec_n + spex6flare.spec_n
spexflare.spec_p = spex0flare.spec_p + spex2flare.spec_p + spex4flare.spec_p + spex5flare.spec_p + spex6flare.spec_p

en=8
plot, spexflare.energy_kev, spexflare.spec_p/spexflare.spec_p[2*en], /xlo, /ylo, psym=10, xr=[3.,13.], /xsty, $
	yr=[1.e-1,10.], /ysty, thick=4, charsize=1.2, $
	xtit='Energy [keV]', ytit='Ratio cts[E]/cts['+strtrim(en,2)+' keV]', $
	title='Spectra normalized to '+strtrim(en,2)+' keV counts, D0,2,4,5,6'
oplot, spexa.energy_kev, spexa.spec_p/spexa.spec_p[2*en], line=2, psym=10, thick=4
legend, ['Flare','2nd target on-disk'], line=[0,2], /right

;
; Use Markus's code to get temperature of flare
;

add_path,'~/Documents/rhessi/event2010nov3/aia/teem/'

f1=file_search('~/data/aia/20121102/*18_01_0*')
f2=file_search('~/data/aia/20121102/*18_01_1*')
aia_prep, f1[0], -1, ind, dat
index2map, ind, dat, m131
aia_prep, f2[0], -1, ind, dat
index2map, ind, dat, m171
aia_prep, f2[1], -1, ind, dat
index2map, ind, dat, m193
aia_prep, f2[2], -1, ind, dat
index2map, ind, dat, m211
aia_prep, f2[3], -1, ind, dat
index2map, ind, dat, m335
aia_prep, f2[4], -1, ind, dat
index2map, ind, dat, m94

; reference images
f1=file_search('~/data/aia/20121102/*17_55_0*')
f2=file_search('~/data/aia/20121102/*17_55_1*')
aia_prep, f1[0], -1, ind, dat
index2map, ind, dat, r131
aia_prep, f2[0], -1, ind, dat
index2map, ind, dat, r171
aia_prep, f2[1], -1, ind, dat
index2map, ind, dat, r193
aia_prep, f2[2], -1, ind, dat
index2map, ind, dat, r211
aia_prep, f2[3], -1, ind, dat
index2map, ind, dat, r335
aia_prep, f2[4], -1, ind, dat
index2map, ind, dat, r94

d131 = diff_map( m131, r131 )
d171 = diff_map( m171, r171 )
d193 = diff_map( m193, r193 )
d211 = diff_map( m211, r211 )
d94 = diff_map( m94, r94 )
d335 = diff_map( m335, r335 )

;aia_sub = make_submap( aia, center=center, fov=3 )

wave_ = ['94','131','193','211','335','171']  ; 94 must go first!
te_range = [0.5, 50]*1.e6
tsig = 0.1*(1+findgen(10))
q94 = 6.7

x_arcsec =  700 + [-480, 480]
y_arcsec = -600 + [-480, 480]
;x_arcsec =  0 + [-1000, 1000]
;y_arcsec =  0 + [-1000, 1000]
fov = [ x_arcsec[0], y_arcsec[0], x_arcsec[1], y_arcsec[1] ] / 967.

npix=4
vers=''
teem_table = 'teem_table.sav'

;aia_teem_table, wave_, tsig, te_range, q94, f1[0], teem_table

maps = [d94, d131, d193, d211, d335, d171]
;maps = [m94, m131, m193, m211, m335, m171]
aia_teem_map_from_map, f1[0], maps, fov, wave_, npix, teem_table, vers
restore,'teem_map.sav',/v
plot_map, temperature_map, /cbar
temperature_map.data=10.^temperature_map.data
plot_map, temperature_map, /cbar, cen=[950,-200], fov=5

popen, xsize=6, ysize=6
plot_map, temperature_map, /cbar, cen=[950,-200], fov=5, dmax=10.e6, tit='log(T[MK])' 
plot_map, temperature_map, /cbar, cen=[950,-200], fov=5, dmin=5.e6, dmax=10.e6, tit='log(T[MK])' 
pclose
