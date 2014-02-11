;;; Try to characterize blanket absorption
; Simulate a FOXSI spectrum for the thermal plasma.
T = 9.4  ; temperature in MK
EM = 4.8e-3  ; emission measure in units of 10^49
bin=0.3

; new parameters after using drm_mod:
T = 9.18
EM = 3.77e-3

time_int = 1.
bin=0.3

spec = get_target_spectra( 4, /correct, binwidth=bin )
spec_d0 = spec[0]
spec_d1 = spec[1]
spec_d2 = spec[2]
spec_d3 = spec[3]
spec_d4 = spec[4]
spec_d5 = spec[5]
spec_d6 = spec[6]

sim_det0 = foxsi_count_spectrum(em, t, time=time_int, binsize=bin, /single, let_file='efficiency_det108_asic2.sav' )
sim_det1 = foxsi_count_spectrum(em, t, time=time_int, binsize=bin, /single, let_file='efficiency_det109_asic2.sav' )
sim_det2 = foxsi_count_spectrum(em, t, time=time_int, binsize=bin, /single, let_file='efficiency_det102_asic3.sav' )
sim_det3 = foxsi_count_spectrum(em, t, time=time_int, binsize=bin, /single, let_file='efficiency_det103_asic3.sav' )
sim_det4 = foxsi_count_spectrum(em, t, time=time_int, binsize=bin, /single, let_file='efficiency_det104_asic2.sav' )
sim_det5 = foxsi_count_spectrum(em, t, time=time_int, binsize=bin, /single, let_file='efficiency_det105_asic2.sav' )
sim_det6 = foxsi_count_spectrum(em, t, time=time_int, binsize=bin, /single, let_file='efficiency_det106_asic3.sav' )

; correct simulated spectra for livetime.
sim_det0 = foxsi_live_correct( sim_det0, time_int )
sim_det1 = foxsi_live_correct( sim_det1, time_int )
sim_det2 = foxsi_live_correct( sim_det2, time_int )
sim_det3 = foxsi_live_correct( sim_det3, time_int )
sim_det4 = foxsi_live_correct( sim_det4, time_int )
sim_det5 = foxsi_live_correct( sim_det5, time_int )
sim_det6 = foxsi_live_correct( sim_det6, time_int )

plot, sim_det6.energy_kev, sim_det6.counts, xr=[2,10], /xlo, /ylo, /xsty, /ysty, $
;plot, sim_det6.energy_kev, test.counts, xr=[2,10], /xlo, /ylo, /xsty, /ysty, $
;	yr=[0.,1.], $
	thick=4, charsize=1.2, xtitle='Energy [keV]', $
;	ytitle='ratio of measured to simulated counts', $
;	title='Comparison of sim and measured counts for detector 6 (1 minute)', $
	psym=10
oplot, spec_d6.energy_kev, spec_d6.spec_p, psym=10, color=2
oplot, sim.energy_kev, sim.counts/60., psym=10, color=2

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

bkgd = get_target_spectra( 2, /correct )


plot, sim_det0.energy_kev, spec_d6.spec_p / sim_det0.counts, xr=[2,15], $
	yr=[0.,1.], $
	thick=4, charsize=1.2, xtitle='Energy [keV]', $
	ytitle='ratio of measured to simulated counts', $
	title='Comparison of sim and measured counts for detector 6 (1 minute)', $
	psym=10, /nodata
oplot, sim_det0.energy_kev, (spec_d0.spec_p / delta_t ) /sim_det0.counts*time_int, psym=-1, line=1, color=6
oplot, sim_det0.energy_kev, (spec_d1.spec_p / delta_t ) /sim_det0.counts*time_int, psym=-1, line=1, color=7
oplot, sim_det0.energy_kev, (spec_d2.spec_p / delta_t ) /sim_det0.counts*time_int, psym=-1, line=1, color=8
oplot, sim_det0.energy_kev, (spec_d3.spec_p / delta_t ) /sim_det0.counts*time_int, psym=-1, line=1, color=9
oplot, sim_det0.energy_kev, (spec_d4.spec_p / delta_t ) /sim_det0.counts*time_int, psym=-1, line=1, color=10
oplot, sim_det0.energy_kev, (spec_d5.spec_p / delta_t ) /sim_det0.counts*time_int, psym=-1, line=1, color=12
oplot, sim_det0.energy_kev, (spec_d6.spec_p / delta_t ) /sim_det0.counts*time_int, psym=-1, line=1, color=2

plot, sim_det0.energy_kev, spec_d6.spec_p / sim_det0.counts, xr=[2,15], $
	yr=[0.,1.], $
	thick=4, charsize=1.2, xtitle='Energy [keV]', $
	ytitle='ratio of measured to simulated counts', $
	title='Comparison of sim and measured counts for detector 6 (1 minute)', $
	psym=10, /nodata
oplot, sim_det0.energy_kev, (spec_d0.spec_p / delta_t - bkgd[0].spec_p) / 0.9/sim_det0.counts, psym=-1, line=1, color=6
oplot, sim_det0.energy_kev, (spec_d1.spec_p / delta_t - bkgd[1].spec_p) / 0.9/sim_det0.counts, psym=-1, line=1, color=7
oplot, sim_det0.energy_kev, (spec_d2.spec_p / delta_t - bkgd[2].spec_p) / 0.9/sim_det0.counts, psym=-1, line=1, color=8
oplot, sim_det0.energy_kev, (spec_d3.spec_p / delta_t - bkgd[3].spec_p) / 0.9/sim_det0.counts, psym=-1, line=1, color=9
oplot, sim_det0.energy_kev, (spec_d4.spec_p / delta_t - bkgd[4].spec_p) / 0.9/sim_det0.counts, psym=-1, line=1, color=10
oplot, sim_det0.energy_kev, (spec_d5.spec_p / delta_t - bkgd[5].spec_p) / 0.9/sim_det0.counts, psym=-1, line=1, color=12
oplot, sim_det0.energy_kev, (spec_d6.spec_p / delta_t - bkgd[6].spec_p) / 0.9/sim_det0.counts, psym=-1, line=1, color=2

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

;;; Try to characterize blanket absorption

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


restore, 'data_2012/foxsi_level2_data.sav', /v
t1 = t4_start
t2 = t4_start+60
delta_t = t2 - t1

bin = 0.3

i0 = where(data_lvl2_d0.wsmr_time gt t1 and data_lvl2_d0.wsmr_time lt t2); and $
i1 = where(data_lvl2_d1.wsmr_time gt t1 and data_lvl2_d1.wsmr_time lt t2); and $
i2 = where(data_lvl2_d2.wsmr_time gt t1 and data_lvl2_d2.wsmr_time lt t2); and $
i3 = where(data_lvl2_d3.wsmr_time gt t1 and data_lvl2_d3.wsmr_time lt t2); and $
i4 = where(data_lvl2_d4.wsmr_time gt t1 and data_lvl2_d4.wsmr_time lt t2); and $
i5 = where(data_lvl2_d5.wsmr_time gt t1 and data_lvl2_d5.wsmr_time lt t2); and $
i6 = where(data_lvl2_d6.wsmr_time gt t1 and data_lvl2_d6.wsmr_time lt t2); and $
spec_d0 = make_spectrum( data_lvl2_d0[i0], bin=bin, /correct )
spec_d1 = make_spectrum( data_lvl2_d1[i1], bin=bin, /correct )
spec_d2 = make_spectrum( data_lvl2_d2[i2], bin=bin, /correct )
spec_d3 = make_spectrum( data_lvl2_d3[i3], bin=bin, /correct )
spec_d4 = make_spectrum( data_lvl2_d4[i4], bin=bin, /correct )
spec_d5 = make_spectrum( data_lvl2_d5[i5], bin=bin, /correct )
spec_d6 = make_spectrum( data_lvl2_d6[i6], bin=bin, /correct )
spec_sum = spec_d0.spec_p + spec_d2.spec_p + spec_d3.spec_p + $
	spec_d4.spec_p + spec_d5.spec_p + spec_d6.spec_p

save, spec_d0, spec_d1, spec_d2, spec_d3, spec_d4, spec_d5, spec_d6, $
	file = 'spec.sav'

; Simulate a FOXSI spectrum for the thermal plasma.
T = 9.4  ; temperature in MK
EM = 4.8e-3  ; emission measure in units of 10^49

time_int = 60.
bin=0.5

sim_det0 = foxsi_count_spectrum(em, t, time=time_int, bin=bin, data_dir='detector_data/',$
						 		let_file='efficiency_det108_asic2.sav', /single )
sim_det1 = foxsi_count_spectrum(em, t, time=time_int, bin=bin, data_dir='detector_data/',$
						 		let_file='efficiency_det109_asic2.sav', /single )
sim_det2 = foxsi_count_spectrum(em, t, time=time_int, bin=bin, data_dir='detector_data/',$
						 		let_file='efficiency_det102_asic3.sav', /single )
sim_det3 = foxsi_count_spectrum(em, t, time=time_int, bin=bin, data_dir='detector_data/',$
						 		let_file='efficiency_det103_asic3.sav', /single )
sim_det4 = foxsi_count_spectrum(em, t, time=time_int, bin=bin, data_dir='detector_data/',$
						 		let_file='efficiency_det104_asic2.sav', /single )
sim_det5 = foxsi_count_spectrum(em, t, time=time_int, bin=bin, data_dir='detector_data/',$
						 		let_file='efficiency_det105_asic2.sav', /single )
sim_det6 = foxsi_count_spectrum(em, t, time=time_int, bin=bin, data_dir='detector_data/',$
						 		let_file='efficiency_det106_asic3.sav', /single )

; correct by an attenuation factor
mylar=82.55
al=2.6
kapton=203.2
extra_sets = 4
const = 0.08
factor = (1+extra_sets)
area_control = get_foxsi_effarea(energy_arr=sim_det0.energy_kev, /nodet, /noshut, data_dir='detector_data/')
area_test = get_foxsi_effarea(energy_arr=sim_det0.energy_kev, /nodet, /noshut, data_dir='detector_data/', $
			mylar=factor*mylar, al=factor*al, kap=factor*kapton)
ratio = area_test.eff_area_cm2 / area_control.eff_area_cm2
sim_det0.counts = sim_det0.counts * (ratio + const)
sim_det1.counts = sim_det1.counts * (ratio + const)
sim_det2.counts = sim_det2.counts * (ratio + const)
sim_det3.counts = sim_det3.counts * (ratio + const)
sim_det4.counts = sim_det4.counts * (ratio + const)
sim_det5.counts = sim_det5.counts * (ratio + const)
sim_det6.counts = sim_det6.counts * (ratio + const)

; correct simulated spectra for livetime.
sim_det0 = foxsi_live_correct( sim_det0, time_int )
sim_det1 = foxsi_live_correct( sim_det1, time_int )
sim_det2 = foxsi_live_correct( sim_det2, time_int )
sim_det3 = foxsi_live_correct( sim_det3, time_int )
sim_det4 = foxsi_live_correct( sim_det4, time_int )
sim_det5 = foxsi_live_correct( sim_det5, time_int )
sim_det6 = foxsi_live_correct( sim_det6, time_int )

plot, sim_det6.energy_kev, sim_det6.counts, xr=[2,20], /xlo, /ylo, /xsty, /ysty, $
;	yr=[0.,1.], $
	thick=4, psym=10, charsize=1.2, xtitle='Energy [keV]'
oplot, spec_d6.energy_kev, spec_d6.spec_p, psym=10, color=2
oplot_err, spec_d6.energy_kev, spec_d6.spec_p, yerr = spec_d6.spec_p_err

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

density = [1.30, 2.7, 1.42]
mylar=82.55
al=2.6
kapton=203.2
test = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/', $
			mylar=mylar, al=al, kap=kapton)
test1 = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/', $
			mylar=mylar, al=al, kap=300.)
test2 = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/', $
			mylar=2*mylar, al=2*al, kap=300)
test3 = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/', $
			mylar=mylar, al=al, kap=2*kapton)

plot, test.eff_area_cm2
oplot, test1.eff_area_cm2, color=6
oplot, test2.eff_area_cm2, color=7
oplot, test3.eff_area_cm2, color=8

plot, sim_det0.energy_kev, spec_d6.spec_p / sim_det0.counts, xr=[2,10], $
	yr=[0.,2.], $
	thick=4, charsize=1.2, xtitle='Energy [keV]', $
	ytitle='ratio of measured to simulated counts', $
	title='With livetime correction', $
	/nodata
oplot, sim_det0.energy_kev, spec_d0.spec_p /sim_det0.counts, psym=-1, line=1, color=6
oplot, sim_det1.energy_kev, spec_d1.spec_p /sim_det1.counts, psym=-1, line=1, color=7
oplot, sim_det2.energy_kev, spec_d2.spec_p /sim_det2.counts, psym=-1, line=1, color=8
oplot, sim_det3.energy_kev, spec_d3.spec_p /sim_det3.counts, psym=-1, line=1, color=9
oplot, sim_det4.energy_kev, spec_d4.spec_p /sim_det4.counts, psym=-1, line=1, color=10
oplot, sim_det5.energy_kev, spec_d5.spec_p /sim_det5.counts, psym=-1, line=1, color=12
oplot, spec_d6.energy_kev, spec_d6.spec_p /sim_det6.counts, psym=-1, line=1, color=2

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

oplot_err, sim_det0.energy_kev, spec_d0.spec_p / sim_det0.counts, $
	yerr = spec_d0.spec_p_err / sim_det0.counts, psym=-1, line=1, color=6
oplot_err, sim_det1.energy_kev, spec_d1.spec_p / sim_det1.counts, $
	yerr = spec_d0.spec_p_err / sim_det1.counts, psym=-1, line=1, color=7
oplot_err, sim_det2.energy_kev, spec_d2.spec_p / sim_det2.counts, $
	yerr = spec_d0.spec_p_err / sim_det2.counts, psym=-1, line=1, color=8
oplot_err, sim_det3.energy_kev, spec_d3.spec_p / sim_det3.counts, $
	yerr = spec_d0.spec_p_err / sim_det3.counts, psym=-1, line=1, color=9
oplot_err, sim_det4.energy_kev, spec_d4.spec_p / sim_det4.counts, $
	yerr = spec_d0.spec_p_err / sim_det4.counts, psym=-1, line=1, color=10
oplot_err, sim_det5.energy_kev, spec_d5.spec_p / sim_det5.counts, $
	yerr = spec_d0.spec_p_err / sim_det5.counts, psym=-1, line=1, color=12
oplot_err, sim_det6.energy_kev, spec_d6.spec_p / sim_det6.counts, $
	yerr = spec_d0.spec_p_err / sim_det6.counts, psym=-1, line=1, color=2

oplot, area.energy_kev, areaX2.eff_area_cm2/area.eff_area_cm2, thick=4, line=1
oplot, area.energy_kev, areaX4.eff_area_cm2/area.eff_area_cm2, thick=4, line=2
oplot, area.energy_kev, areaX6.eff_area_cm2/area.eff_area_cm2, thick=4, line=3
legend, ['effect of 2X blanketing', '4X blanketing', '6X blanketing', $
		 'Det0','Det1','Det2','Det3','Det4','Det5','Det6'], $
		 thick=4, line=[1,2,3,0,0,0,0,0,0,0], color=[1,1,1,6,7,8,9,10,12,2]

popen, 'blankets_fit1', xsize=8, ysize=11
!p.multi=[0,2,3]
blankets, 6, 0.03, /det0
blankets, 6, 0.03, /det1
blankets, 8, 0.06, /det2
blankets, 4, 0.08, /det4
blankets, 4, 0.1, /det5
blankets, 4, 0.08, /det6
pclose

; second version of blankets routine
blankets, [0.,0.,0.], /det0

; Try to fit it.

counter = 0.
chi = dblarr(125000.)
i_arr = dblarr(125000.)
j_arr = dblarr(125000.)
k_arr = dblarr(125000.)
.r
for i=0., 1.0, 0.1 do begin
  for j=0., 1.-i, 0.1 do begin
    for k=0., 1.-i-j, 0.1 do begin
		print,i,j,k
		chi[ counter ] = blankets2( [i,j,k], /det6, bin=0.5 )
		i_arr[ counter ] = i
		j_arr[ counter ] = j
		k_arr[ counter ] = k
		counter++
	endfor
  endfor
endfor
end

ind = where( chi gt 0 )
print, min( chi[ind], min_ind )
print, i_arr[ind[min_ind]], j_arr[ind[min_ind]], k_arr[ind[min_ind]]

print, blankets2( [0.,0.,0.], bin=0.5, /det6 )
print, blankets2( [0.,0.,0.], bin=0.3, fe_th=0.000, off=-0.0, ni_th=0.000, det=6) 
oplot, area.energy_kev, areaX4.eff_area_cm2/area.eff_area_cm2, thick=4, line=2

;print, blankets2( [0.,0.,0.], bin=0.3, fe_th=0.000, off=-0.0, ni_th=0.000, det=0) 
;print, blankets2( [0.,0.,0.], bin=0.3, fe_th=0.000, off=-0.0, ni_th=0.000, det=1, /over) 
;print, blankets2( [0.,0.,0.], bin=0.3, fe_th=0.000, off=-0.0, ni_th=0.000, det=2, /over) 
;print, blankets2( [0.,0.,0.], bin=0.3, fe_th=0.000, off=-0.0, ni_th=0.000, det=3, /over) 
print, blankets2( [0.,0.,0.], bin=0.3, fe_th=0.000, off=-0.02, ni_th=0.000, det=4) 
print, blankets2( [0.,0.,0.], bin=0.3, fe_th=0.000, off=-0.05, ni_th=0.000, det=5, /over) 
print, blankets2( [0.,0.,0.], bin=0.3, fe_th=0.000, off=-0.04, ni_th=0.000, det=6, /over) 
oplot, area.energy_kev, areaX4.eff_area_cm2/area.eff_area_cm2, thick=4, line=2
legend, ['4X blanketing', $
		 'Det4','Det5','Det6'], $
		 thick=4, line=[2,0,0,0], color=[1,10,12,2]
