;;; Try to characterize blanket absorption
; Simulate a FOXSI spectrum for the thermal plasma.
T = 9.4  ; temperature in MK
EM = 4.8e-3  ; emission measure in units of 10^49
bin=0.3

;; new parameters after using drm_mod:
;T = 9.18
;EM = 3.77e-3

get_target_data, 4, d0,d1,d2,d3,d4,d5,d6

t1 = t4_start
t2 = t4_end
delta_t = t2 - t1
bin = 0.3

spec_d0 = make_spectrum( d0, bin=bin, /correct )
spec_d1 = make_spectrum( d1, bin=bin, /correct )
spec_d2 = make_spectrum( d2, bin=bin, /correct )
spec_d3 = make_spectrum( d3, bin=bin, /correct )
spec_d4 = make_spectrum( d4, bin=bin, /correct )
spec_d5 = make_spectrum( d5, bin=bin, /correct )
spec_d6 = make_spectrum( d6, bin=bin, /correct )
spec_sum = spec_d0.spec_p + spec_d2.spec_p + spec_d3.spec_p + $
	spec_d4.spec_p + spec_d5.spec_p + spec_d6.spec_p
	
; units on these are counts per keV.

;save, spec_d0, spec_d1, spec_d2, spec_d3, spec_d4, spec_d5, spec_d6, $
;	file = 'spec.sav'

;restore, 'spec.sav', /v

nbla=1.0001

sim_det0 = foxsi_count_spectrum(em, t, time=delta_t, binsize=bin, /single, /smear, $
	let_file='efficiency_det108_asic2.sav', n_bla=nbla, offaxis=7.3 )
sim_det1 = foxsi_count_spectrum(em, t, time=delta_t, binsize=bin, /single, /smear, $
	let_file='efficiency_det109_asic2.sav', n_bla=nbla, offaxis=7.3 )
sim_det2 = foxsi_count_spectrum(em, t, time=delta_t, binsize=bin, /single, /smear, $
	let_file='efficiency_det102_asic3.sav', n_bla=nbla, offaxis=7.3 )
sim_det3 = foxsi_count_spectrum(em, t, time=delta_t, binsize=bin, /single, /smear, $
	let_file='efficiency_det103_asic3.sav', n_bla=nbla, offaxis=7.3 )
sim_det4 = foxsi_count_spectrum(em, t, time=delta_t, binsize=bin, /single, /smear, $
	let_file='efficiency_det104_asic2.sav', n_bla=nbla, offaxis=7.3 )
sim_det5 = foxsi_count_spectrum(em, t, time=delta_t, binsize=bin, /single, /smear, $
	let_file='efficiency_det105_asic2.sav', n_bla=nbla, offaxis=7.3 )
sim_det6 = foxsi_count_spectrum(em, t, time=delta_t, binsize=bin, /single, /smear, $
	let_file='efficiency_det106_asic3.sav', n_bla=nbla, offaxis=7.3 )

; Note it would be better to use a measured livetime for correction.
; Quick estimation is that livetime is >90% even for the highest counting detector.
; Don't use this line below; just there for reference.
;; correct simulated spectra for livetime.
;sim_det0 = foxsi_live_correct( sim_det0, time_int )

popen, 'fig/foxsi-spex', xsi=7, ysi=6
plot, sim_det6.energy_kev, sim_det6.counts, xr=[4,12], /xlo, /ylo, /xsty, /ysty, $
	thick=8, charsize=1.3, xtitle='Energy [keV]', ytit='Counts keV!U-1!N', $
	psym=10, yr=[1.,1.e5];, $
	;title='Comparison of sim and measured counts for detector 6 (Target 4)'
oplot, spec_d6.energy_kev, spec_d6.spec_p, psym=10, color=2, thick=8
oplot_err, spec_d6.energy_kev, spec_d6.spec_p, yerr = spec_d6.spec_p_err, $
	psym=10, color=2, thick=8
al_legend, ['Expected D6 counts','Measured D6 counts'], color=[0,2], thick=8, line=0, $
	/right, /top, box=0, charsi=1.3
pclose

; Calculate absorption due to various multiples of the blanketing.
mylar=82.55
al=2.6
kapton=203.2

; plot ratio of two and compare to blanketing schemes.
area = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/')
areaX = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/', $
			mylar=5.8*mylar, al=5.8*al, kap=5.8*kapton)
			
plot, area.energy_kev, 0.025 + areax.eff_area_cm2 / area.eff_area_cm2, $
	xtit='Energy [keV]', ytit='Transmission through excess blankets', charsi=1.1, $
	thick=5


areaX2 = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/', $
			mylar=2.*mylar, al=2*al, kap=2*kapton)
areaX4 = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/', $
			mylar=4.*mylar, al=4*al, kap=4*kapton)
areaX6 = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/', $
			mylar=6.*mylar, al=6*al, kap=6*kapton)

;bkgd = get_target_spectra( 2, /correct )


plot, sim_det0.energy_kev, spec_d6.spec_p / sim_det6.counts, xr=[3,11], /xsty, $
	yr=[0.,1.], $
;	yr=[0.,0.5], $
	thick=4, charsize=1.2, xtitle='Energy [keV]', $
	ytitle='ratio of measured to simulated counts', $
	title='Comparison of sim and measured counts for detector 6 (1 minute)', $
	psym=10, /nodata
oplot, sim_det0.energy_kev, spec_d0.spec_p /sim_det0.counts, psym=-1, line=1, color=6
oplot, sim_det0.energy_kev, spec_d1.spec_p /sim_det1.counts, psym=-1, line=1, color=7
oplot, sim_det0.energy_kev, spec_d2.spec_p /sim_det2.counts, psym=-1, line=1, color=8
oplot, sim_det0.energy_kev, spec_d3.spec_p /sim_det3.counts, psym=-1, line=1, color=9
oplot, sim_det0.energy_kev, spec_d4.spec_p /sim_det4.counts, psym=-1, line=1, color=10
oplot, sim_det0.energy_kev, spec_d5.spec_p /sim_det5.counts, psym=-1, line=1, color=12
oplot, sim_det0.energy_kev, spec_d6.spec_p /sim_det6.counts, psym=-1, line=1, color=2

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

;
; Fit an exponential.
;

; Pick out an energy range to fit:
i = where(sim_det0.energy_kev gt 5. and sim_det0.energy_kev lt 9)
x = sim_det0.energy_kev[i]
y = spec_d4.spec_p[i] /sim_det4.counts[i]
yfit = inverse_exponential_fit( x, y )

; not working well. alternate method:  assume A0=1 and A2=0.  Then ln y = -A1/x.
; this can be fit linearly.
lny = alog(y)
invx = 1./x
plot, invx, lny
result = poly_fit( invx, lny, 1, yfit )
plot, invx, lny
oplot, invx, result[0] + result[1]*invx
plot, x, lny
oplot, x, result[1]/x + result[0]
plot, x, y
oplot, x, exp(result[1]/x+result[0])

plot, sim_det0.energy_kev, spec_d6.spec_p / sim_det6.counts, xr=[2,15], $
	yr=[0.,1.], $
	thick=4, charsize=1.2, xtitle='Energy [keV]', $
	ytitle='ratio of measured to simulated counts', $
	title='Comparison of sim and measured counts for detector 6 (1 minute)', $
	psym=10, /nodata
oplot, sim_det0.energy_kev, spec_d6.spec_p /sim_det6.counts, psym=-1, line=1, color=2
;oplot, sim_det0.energy_kev[i], yfit[0]*exp(-yfit[1]/sim_det0.energy_kev[i])
oplot, sim_det0.energy_kev[i], exp(-yfit[1]/sim_det0.energy_kev[i])

; Just fit an "n times nominal..."
i = where(sim_det0.energy_kev gt 5. and sim_det0.energy_kev lt 9)
x = sim_det0.energy_kev[i]
y = spec_d4.spec_p[i] /sim_det4.counts[i]
atten = get_blanket_atten( energy_arr = sim_det0.energy_kev[i] )

hsi_linecolors
plot, x, y-y[0]
oplot, atten.energy_kev, (atten.shut_eff)^5.5, col=2
n = alog(y-y[0]) / alog(atten.shut_eff)

; This works!  Do it for all the dets.
i = where(sim_det0.energy_kev gt 5. and sim_det0.energy_kev lt 8)
x = sim_det0.energy_kev[i]
atten = get_blanket_atten( energy_arr = sim_det0.energy_kev[i] )
y0 = spec_d0.spec_p[i] /sim_det0.counts[i]
y1 = spec_d1.spec_p[i] /sim_det1.counts[i]
y2 = spec_d2.spec_p[i] /sim_det2.counts[i]
y3 = spec_d3.spec_p[i] /sim_det3.counts[i]
y4 = spec_d4.spec_p[i] /sim_det4.counts[i]
y5 = spec_d5.spec_p[i] /sim_det5.counts[i]
y6 = spec_d6.spec_p[i] /sim_det6.counts[i]
n0 = alog(y0-y0[0]) / alog(atten.shut_eff)
n1 = alog(y1-y1[0]) / alog(atten.shut_eff)
n2 = alog(y2-y2[0]) / alog(atten.shut_eff)
n3 = alog(y3-y3[0]) / alog(atten.shut_eff)
n4 = alog(y4-y4[0]) / alog(atten.shut_eff)
n5 = alog(y5-y5[0]) / alog(atten.shut_eff)
n6 = alog(y6-y6[0]) / alog(atten.shut_eff)

;popen, xsi=7, ysi=4
plot, sim_det0.energy_kev[i], n0, charsize=1.1, xtitle='Energy [keV]', $
	ytitle='n times nominal blanketing', yr=[0,12], $
	title='Blanketing factors for FOXSI flare by detector', $
	psym=10, /nodata
oplot, sim_det0.energy_kev[i], n0, psym=1, thick=10, color=6
oplot, sim_det0.energy_kev[i], n1, psym=1, thick=10, color=7
oplot, sim_det0.energy_kev[i], n2, psym=1, thick=10, color=8
oplot, sim_det0.energy_kev[i], n3, psym=1, thick=10, color=9
oplot, sim_det0.energy_kev[i], n4, psym=1, thick=10, color=10
oplot, sim_det0.energy_kev[i], n5, psym=1, thick=10, color=12
oplot, sim_det0.energy_kev[i], n6, psym=1, thick=10, color=2
legend,['D0','D1','D2','D3','D4','D5','D6'], textcol=[6,7,8,9,10,12,2], $
	/bot, /left, box=0
;pclose

; Get an average from 5-8 keV for each.
; Before doing this, repeat this for 5-8 only.
print, mean(n0[where(finite(n0))])
print, mean(n1[where(finite(n1))])
print, mean(n2[where(finite(n2))])
print, mean(n3[where(finite(n3))])
print, mean(n4[where(finite(n4))])
print, mean(n5[where(finite(n5))])
print, mean(n6[where(finite(n6))])

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

get_target_data, 4, d0,d1,d2,d3,d4,d5,d6

t1 = t4_start
t2 = t4_start+60
delta_t = t2 - t1

bin = 0.3

spec_d0 = make_spectrum( d0, bin=bin, /correct )
spec_d1 = make_spectrum( d1, bin=bin, /correct )
spec_d2 = make_spectrum( d2, bin=bin, /correct )
spec_d3 = make_spectrum( d3, bin=bin, /correct )
spec_d4 = make_spectrum( d4, bin=bin, /correct )
spec_d5 = make_spectrum( d5, bin=bin, /correct )
spec_d6 = make_spectrum( d6, bin=bin, /correct )
spec_sum = spec_d0.spec_p + spec_d2.spec_p + spec_d3.spec_p + $
	spec_d4.spec_p + spec_d5.spec_p + spec_d6.spec_p

save, spec_d0, spec_d1, spec_d2, spec_d3, spec_d4, spec_d5, spec_d6, $
	file = 'spec.sav'

; Simulate a FOXSI spectrum for the thermal plasma.
T = 9.4  ; temperature in MK
EM = 4.8e-3  ; emission measure in units of 10^49

time_int = 60.
bin=0.3

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
		 
		 
		 
x = findgen(1000)/50. 
d=15.     
y = 1./d*sqrt(4*x^2*d^2+200.^2)      
plot, x, y, xr=[0,10], xtit='N folds', ytit='Blanketing thickness / nominal thickness', $
	charsi=1.5, thick=8
a=get_blanket_atten(factor=7) 
plot, a.energy_kev, a.shut_eff, xtit='Energy [keV]', ytit='Transmission', $
	tit='10 times nominal blanketing thickness', thick=10, charsi=1.4
	
	
;;
;;
;;	Do the self-calibration using only FOXSI data, not RHESSI.
;;
;;

; First, get data for the desired target (4 or 6 or both) and compute count spectra.
get_target_data, 4, d0,d1,d2,d3,d4,d5,d6
t1 = t4_start
t2 = t4_end
delta_t = t2 - t1
bin = 0.3
spec_d0 = make_spectrum( d0, bin=bin, /correct )
spec_d1 = make_spectrum( d1, bin=bin, /correct )
spec_d2 = make_spectrum( d2, bin=bin, /correct )
spec_d3 = make_spectrum( d3, bin=bin, /correct )
spec_d4 = make_spectrum( d4, bin=bin, /correct )
spec_d5 = make_spectrum( d5, bin=bin, /correct )
spec_d6 = make_spectrum( d6, bin=bin, /correct )
spec_sum = spec_d0.spec_p + spec_d2.spec_p + spec_d3.spec_p + $
	spec_d4.spec_p + spec_d5.spec_p + spec_d6.spec_p

; units on these are counts per keV.
;save, spec_d0, spec_d1, spec_d2, spec_d3, spec_d4, spec_d5, spec_d6, $
;	file = 'spec.sav'
;restore, 'spec.sav', /v

; Livetime is not yet accounted for!!!	

nbla = findgen(70)/10.+2.
off  = findgen(20)/200.
nnbla = n_elements(nbla)
noff = n_elements(off)
chi  = fltarr( nnbla, noff )
err  = fltarr( nnbla, noff )
temp = fltarr( nnbla, noff )
em   = fltarr( nnbla, noff )
for i=0, nnbla-1 do for j=0, noff-1 do begin &$
	a = temppro2( nbla[i], off[j], spec_d6, 80. ) &$
	chi[ i, j ] = a.chi_t &$
	err[i,j] = a.chi_em &$
	temp[i,j] = a.temperature &$
	em[i,j] = a.em &$	
endfor
min = min(abs(chi),ind)
ind2 = array_indices(chi,ind)
print, nbla[ind2[0]], off[ind2[1]]
result = temppro2( nbla[ind2[0]], off[ind2[1]], spec_d6, 80. )
print, average( result.temperature )
print, average( result.em )

; This works!  Use it!!!
