PRO BLANKETS, PARAM, STOP=STOP, ALL=ALL, $
	DET0=DET0, DET1=DET1, DET2=DET2, DET3=DET3, DET4=DET4, DET5=DET5, DET6=DET6

; PARAM is parameter array with % effarea blocked by 2, 4, or 6 sets of blankets.
; Total of these percents should be < 1.  The difference from 1 will be
; modeled as effarea with no absorbtion.

if keyword_set(det0) then title = 'Detector 0'
if keyword_set(det1) then title = 'Detector 1'
if keyword_set(det2) then title = 'Detector 2'
if keyword_set(det3) then title = 'Detector 3'
if keyword_set(det4) then title = 'Detector 4'
if keyword_set(det5) then title = 'Detector 5'
if keyword_set(det6) then title = 'Detector 6'

if keyword_set(all) then begin
	det0 = 1
	det1 = 1
	det2 = 1
	det3 = 1
	det4 = 1
	det5 = 1
	det6 = 1
	title = 'All detectors'
endif

if total(param) gt 1 then error, 'Total area % > 100'

;title = title + ': ' + strtrim(extra_sets,2) + ' extra Kapton layers, ' + $
;	strtrim(fix(100*const),2) + ' percent unobstructed'

T = 9.4  ; temperature in MK
EM = 4.8e-3  ; emission measure in units of 10^49
bin=0.3

time_int = 60.

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

;
; correct by an attenuation factor
;

; nominal blanketing thicknesses (total in path)
mylar=82.55
al=2.6
kapton=203.2
;factor = (1+extra_sets)

; attenuation factors due to excess blankets
area_control = get_foxsi_effarea(energy_arr=sim_det0.energy_kev, /nodet, /noshut, data_dir='detector_data/')
area_2X = get_foxsi_effarea(energy_arr=sim_det0.energy_kev, /nodet, /noshut, data_dir='detector_data/', $
			mylar=2*mylar, al=2*al, kap=2*kapton)
area_4X = get_foxsi_effarea(energy_arr=sim_det0.energy_kev, /nodet, /noshut, data_dir='detector_data/', $
			mylar=3*mylar, al=3*al, kap=3*kapton)
area_6X = get_foxsi_effarea(energy_arr=sim_det0.energy_kev, /nodet, /noshut, data_dir='detector_data/', $
			mylar=4*mylar, al=4*al, kap=4*kapton)

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

if keyword_set(stop) then stop

restore,'spec.sav'

plot, sim_det0.energy_kev, spec_d0.spec_p / sim_det0.counts, xr=[2,10], $
	yr=[0.,2.], $
	thick=4, charsize=1.5, xtitle='Energy [keV]', $
	ytitle='ratio of measured to simulated counts', $
	title=title, $
	psym=10, /nodata

psym=1
line=1
thick=4

if keyword_set(det0) then begin
	oplot_err, sim_det0.energy_kev, spec_d0.spec_p /sim_det0.counts, psym=psym, $
	  yerr = spec_d0.spec_p_err/sim_det0.counts, line=line, color=6, thick=thick
	i=where( sim_det0.energy_kev gt 4. and sim_det0.energy_kev lt 8.)
	xyouts, 5, 0.1, $
		'Chisq = '+ strtrim( sqrt( total( (spec_d0.spec_p[i] /sim_det0.counts[i]-1)^2/(n_elements(i)-1) )) )
endif
if keyword_set(det1) then begin
	oplot_err, sim_det1.energy_kev, spec_d1.spec_p /sim_det1.counts, psym=psym, $
	  yerr = spec_d1.spec_p_err/sim_det1.counts, line=line, color=7, thick=thick
	i=where( sim_det1.energy_kev gt 4. and sim_det1.energy_kev lt 8.)
	xyouts, 5, 0.1, $
		'Chisq = '+ strtrim( sqrt( total( (spec_d1.spec_p[i] /sim_det1.counts[i]-1)^2/(n_elements(i)-1) )) )
endif
if keyword_set(det2) then begin
	oplot_err, sim_det2.energy_kev, spec_d2.spec_p /sim_det2.counts, psym=psym, $
	  yerr = spec_d2.spec_p_err/sim_det2.counts, line=line, color=8, thick=thick
	i=where( sim_det2.energy_kev gt 4. and sim_det2.energy_kev lt 8.)
	xyouts, 5, 0.1, $
		'Chisq = '+ strtrim( sqrt( total( (spec_d2.spec_p[i] /sim_det2.counts[i]-1)^2/(n_elements(i)-1) )) )
endif
if keyword_set(det3) then begin
	oplot_err, sim_det3.energy_kev, spec_d3.spec_p /sim_det3.counts*2, psym=psym, $
	  yerr = spec_d3.spec_p_err/sim_det3.counts, line=line, color=9, thick=thick
	i=where( sim_det3.energy_kev gt 4. and sim_det3.energy_kev lt 8.)
	xyouts, 5, 0.1, $
		'Chisq = '+ strtrim( sqrt( total( (spec_d3.spec_p[i] /sim_det3.counts[i]-1)^2/(n_elements(i)-1) )) )
endif
if keyword_set(det4) then begin
	oplot_err, sim_det4.energy_kev, spec_d4.spec_p /sim_det4.counts, psym=psym, $
	  yerr = spec_d4.spec_p_err/sim_det4.counts, line=line, color=10, thick=thick
	i=where( sim_det4.energy_kev gt 4. and sim_det4.energy_kev lt 8.)
	xyouts, 5, 0.1, $
		'Chisq = '+ strtrim( sqrt( total( (spec_d4.spec_p[i] /sim_det4.counts[i]-1)^2/(n_elements(i)-1) )) )
endif
if keyword_set(det5) then begin
	oplot_err, sim_det5.energy_kev, spec_d5.spec_p /sim_det5.counts, psym=psym, $
	  yerr = spec_d5.spec_p_err/sim_det5.counts, line=line, color=12, thick=thick
	i=where( sim_det5.energy_kev gt 4. and sim_det5.energy_kev lt 8.)
	xyouts, 5, 0.1, $
		'Chisq = '+ strtrim( sqrt( total( (spec_d5.spec_p[i] /sim_det5.counts[i]-1)^2/(n_elements(i)-1) )) )
endif
if keyword_set(det6) then begin
	oplot_err, spec_d6.energy_kev, spec_d6.spec_p /sim_det6.counts, psym=psym, $
	  yerr = spec_d6.spec_p_err/sim_det6.counts, line=line, color=2, thick=thick
	i=where( sim_det6.energy_kev gt 4. and sim_det6.energy_kev lt 8.)
	xyouts, 5, 0.1, $
		'Chisq = '+ strtrim( sqrt( total( (spec_d6.spec_p[i] /sim_det6.counts[i]-1)^2/(n_elements(i)-1) )) )
endif
if keyword_set(all) then begin
	legend, ['Det0','Det1','Det2','Det3','Det4','Det5','Det6'], $
		 thick=4, line=[0,0,0,0,0,0,0], color=[6,7,8,9,10,12,2]
endif

oplot, [2,10], [1.,1.], line=1
xyouts, 5., 0.3, strtrim( extra_sets, 2) + ' extra blanket sets
xyouts, 5., 0.2, strtrim( fix(100*const), 2) + ' percent flux unobstructed


END