@foxsi-setup-script

; Plot basic spectra (integrated over whole flight)
spex0=make_spectrum( data_lvl2_d0, bin=0.1, /corr )
spex1=make_spectrum( data_lvl2_d1, bin=0.1, /corr )
spex2=make_spectrum( data_lvl2_d2, bin=0.1, /corr )
spex3=make_spectrum( data_lvl2_d3, bin=0.1, /corr )
spex4=make_spectrum( data_lvl2_d4, bin=0.1, /corr )
spex5=make_spectrum( data_lvl2_d5, bin=0.1, /corr )
spex6=make_spectrum( data_lvl2_d6, bin=0.1, /corr )

;popen, 'plots/integrated-spectra', xsize=7, ysize=5
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
;pclose


;;;;;;;;;;;;;;;;;;;;
;;; March 4 2013 ;;;
;;;;;;;;;;;;;;;;;;;;

; Using simulation scripts and FOXSI response routines to calculate  expected counts for
; our microflare.

;T = 9.0  ; temperature in MK
T = 9.4  ; temperature in MK
EM = 4.8e-3  ; emission measure in units of 10^49
;EM = 3.8e-3  ; emission measure in units of 10^49

; Simulate a FOXSI spectrum for the thermal plasma, 1 detector only.
; units will be cts / keV / sec
sim_1det = foxsi_count_spectrum( em, t, time=1., binsize=0.5, /single )

; sim = foxsi_live_correct( sim_1det, 60 )	; don't use this for now.

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

; Select only events w/o errors and in desired time range.
; Use /corr keyword to correct the spectrum for the thrown-out counts.
binwidth=0.5

T = 9.4  ; temperature in MK
EM = 4.8e-3  ; emission measure in units of 10^49

; Simulate a FOXSI spectrum for the thermal plasma, 1 detector only.
; units are cts / keV / sec
sim_1det = foxsi_count_spectrum( em, t, time=1., binsize=0.5, /single )

; Get flare spectrum, alll detectors (use 4th target)
flare = get_target_spectra( 4, /correct, bin=binwidth )

; Use 2nd target as background.
bkgd = get_target_spectra( 2, /correct, bin=binwidth )

plot,  flare[6].energy_kev, flare[6].spec_p, xr=[2,15], thick=4, psym=10, /xlog, /ylog, $
  xtitle='Energy [keV]', ytitle='FOXSI counts s!U-1!N keV!U-1!N', xstyle=1, line=1, $
  title = 'FOXSI count spectra, Flare', charsize=1.2, yr=[1.E-2,1.e3], /ysty, /nodata
oplot, flare[0].energy_kev, flare[0].spec_p, psym=10, thick=4, color=6
oplot, flare[1].energy_kev, flare[1].spec_p, psym=10, thick=4, color=7 
oplot, flare[2].energy_kev, flare[2].spec_p, psym=10, thick=4, color=8 
oplot, flare[3].energy_kev, flare[3].spec_p, psym=10, thick=4, color=9 
oplot, flare[4].energy_kev, flare[4].spec_p, psym=10, thick=4, color=10 
oplot, flare[5].energy_kev, flare[5].spec_p, psym=10, thick=4, color=12 
oplot, flare[6].energy_kev, flare[6].spec_p, psym=10, thick=4, color=2 
oplot, flare[0].energy_kev, bkgd[0].spec_p, psym=10, thick=1, color=6
oplot, flare[1].energy_kev, bkgd[1].spec_p, psym=10, thick=1, color=7 
oplot, flare[2].energy_kev, bkgd[2].spec_p, psym=10, thick=1, color=8 
oplot, flare[3].energy_kev, bkgd[3].spec_p, psym=10, thick=1, color=9 
oplot, flare[4].energy_kev, bkgd[4].spec_p, psym=10, thick=1, color=10 
oplot, flare[5].energy_kev, bkgd[5].spec_p, psym=10, thick=1, color=12 
oplot, flare[6].energy_kev, bkgd[6].spec_p, psym=10, thick=1, color=2 
legend, ['Simulated','Observed D0','D1','D2','D3','D4','D5','D6'], $
	line=[1,0,0,0,0,0,0,0], colors=[0,6,7,8,9,10,12,2], thick=4, /right, box=0

window, 0
plot,  sim_1det.energy_kev, sim_1det.counts, xr=[2,15], thick=4, psym=10, /xlog, /ylog, $
  xtitle='Energy [keV]', ytitle='FOXSI counts s!U-1!N keV!U-1!N', xstyle=1, line=1, $
  title = 'FOXSI count spectra, Flare', charsize=1.2, yr=[1.E-2,1.e3], /ysty
;oplot, flare[0].energy_kev, flare[0].spec_p, psym=10, thick=6, color=6
;oplot, flare[0].energy_kev, flare[0].spec_p - bkgd[0].spec_p, psym=10, thick=3, color=6
;oplot, flare[1].energy_kev, flare[1].spec_p, psym=10, thick=6, color=7 
;oplot, flare[1].energy_kev, flare[1].spec_p - bkgd[1].spec_p, psym=10, thick=3, color=7 
;oplot, flare[2].energy_kev, flare[2].spec_p, psym=10, thick=6, color=8 
;oplot, flare[2].energy_kev, flare[2].spec_p - bkgd[2].spec_p, psym=10, thick=3, color=8 
;oplot, flare[3].energy_kev, flare[3].spec_p, psym=10, thick=6, color=9 
;oplot, flare[3].energy_kev, flare[3].spec_p - bkgd[3].spec_p, psym=10, thick=3, color=9 
oplot, flare[4].energy_kev, flare[4].spec_p, psym=10, thick=6, color=10 
oplot, flare[4].energy_kev, flare[4].spec_p - bkgd[4].spec_p, psym=10, thick=3, color=10 
oplot, flare[5].energy_kev, flare[5].spec_p, psym=10, thick=6, color=12 
oplot, flare[5].energy_kev, flare[5].spec_p - bkgd[5].spec_p, psym=10, thick=3, color=12 
oplot, flare[6].energy_kev, flare[6].spec_p, psym=10, thick=6, color=2 
oplot, flare[6].energy_kev, flare[6].spec_p - bkgd[6].spec_p, psym=10, thick=3, color=2 
legend, ['Simulated','Observed D0','D1','D2','D3','D4','D5','D6'], $
	line=[1,0,0,0,0,0,0,0], colors=[0,6,7,8,9,10,12,2], thick=4, /right, box=0

window, 1
plot,  sim_1det.energy_kev, sim_1det.counts, xr=[2,15], thick=4, psym=10, /xlog, /ylog, $
  xtitle='Energy [keV]', ytitle='FOXSI counts s!U-1!N keV!U-1!N', xstyle=1, line=1, $
  title = 'FOXSI count spectra, Flare', charsize=1.2, yr=[1.E-2,1.e3], /ysty
legend, ['Simulated','Observed D0','D1','D2','D3','D4','D5','D6'], $
	line=[1,0,0,0,0,0,0,0], colors=[0,6,7,8,9,10,12,2], thick=4, /right, box=0


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
; plot effective area, including what we think ours was.
;

e1 = dindgen(1200)/100+3
e2 = get_edges(e1,/edges_2)
emid = get_edges(e1,/mean)

rhessi = rhessi_eff_area(e1, 0.25, 0)
area = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='calibration_data/')

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
; Simple plots of FOXSI's effective area (FOXSI-1 and FOXSI-2), compared with RHESSI's
;

add_path, 'resp'
restore, 'data_2012/foxsi_level2_data.sav', /v

en1 = findgen(2000)/100.
en_mid = get_edges(en1, /mean)
en2 = get_edges(en1, /edges_2)
dir = 'calibration_data/'
let_file = 'efficiency_averaged.sav'
i=where(en1 ge 3.)

area1 = get_foxsi_effarea( energy=en_mid, data_dir=dir, let_file=let_file)
area2 = get_foxsi_effarea( energy=en_mid, data_dir=dir, let_file=let_file, /foxsi2)
area1_opt = get_foxsi_effarea( energy=en_mid, data_dir=dir, /noshut, /nopath, /nodet)
area2_opt = get_foxsi_effarea( energy=en_mid, data_dir=dir, /noshut, /nopath, /nodet, /foxsi2)
rhessi = rhessi_eff_area(en1[i], 0.25, 0)

loadct,0
hsi_linecolors

popen, 'effarea', xsize=7, ysize=4.5
plot, area2_opt.energy_kev, area2_opt.eff_area_cm2, xr=[0,20], yr=[0,205], /ysty, $
  xtitle = 'Energy [keV]', ytitle = 'Area [cm!U2!N]',$
  charsize=1.4, /nodata
oplot, area1_opt.energy_kev, area1_opt.eff_area_cm2, thick=6, color=7, line=2
oplot, area2_opt.energy_kev, area2_opt.eff_area_cm2, thick=6, color=6, line=2
oplot, area1.energy_kev, area1.eff_area_cm2, thick=6, color=7
oplot, area2.energy_kev, area2.eff_area_cm2, thick=6, color=6
oplot, get_edges(en1[i],/mean), rhessi, thick=6
legend, ['FOXSI-1','FOXSI-2','RHESSI'], textcolor=[7,6,0], charsize=1.4, /right, box=0
pclose

;
; working on a better counts-to-photon conversion for the flare.
;

flare_xy = [1020.,-320.]
rad = 120.

get_target_data, 4, d0,d1,d2,d3,d4,d5,d6, rad=rad, center=flare_xy

spec = make_spectrum( [d0,d2,d4,d5,d6], /three, /corr, bin=0.3 )

plot, spec.energy_kev, spec.spec_p, /xlo, /ylo, xr=[2.,15.], /xsty, yr=[1.e1,1.e4], psym=10
oplot_err, spec.energy_kev, spec.spec_p, yerr=spec.spec_p_err, psym=10

;
; imaging spectroscopy of flare using D6
;

flare_xy = [1020.,-320.]

get_target_data, 4, d0,d1,d2,d3,d4,d5,d6
get_target_data, 6, d0a,d1a,d2a,d3a,d4a,d5a,d6a

d6 = [d6,d6a]

pix=13.
er=[4,15]
img=foxsi_image_solar(d6, 6, ps=pix, er=erange, thr_n=5. )
map = make_map( img, xcen=0., ycen=0., dx=pix, dy=pix )
plot_map, map, /limb, cen=flare_xy, fov=2, /cb

n = (1080-960)/pix
xbins = 960 + findgen(n+1)*pix
ybins = -270 - findgen(n+1)*pix

spec = make_spectrum( d6, bin=2.0 )
spec = replicate( spec, n_elements(xbins)-1,n_elements(ybins)-1 )
spec.spec_n = 0.
spec.spec_p = 0.
spec.spec_p_err = 0.

.r
for i=0, n_elements(xbins)-2 do begin
	for j=0, n_elements(ybins)-2 do begin
		k=where(d6.hit_xy_solar[0] ge xbins[i] and d6.hit_xy_solar[0] le xbins[i+1] and $
				d6.hit_xy_solar[1] le ybins[j] and d6.hit_xy_solar[1] ge ybins[j+1] )
		if n_elements(k) lt 20 then continue
		temp = make_spectrum( d6[k], bin=2. )
		spec[i,j] = temp
	endfor
endfor
end

ratio = spec.spec_p[3] / spec.spec_p[2]
x = get_edges( xbins, /mean )
y = get_edges( ybins, /mean )
nx=n_elements(x)
ny=n_elements(y)
x = rebin( x, nx, ny)
y = rebin( transpose(y), nx, ny)
dist = sqrt( (x-flare_xy[0])^2 + (y-flare_xy[1])^2 )
plot, dist, ratio, /psy
plot_map, make_map( ratio ), /cb


plot, spec[0,0].energy_kev, spec[0,0].spec_p, /xlo, /ylo, xr=[2.,15.], /xsty, yr=[1.e-2,1.], /nodata
for i=0, n_elements(xbins)-1 do $
  for j=0, n_elements(ybins)-1 do $
    oplot, spec[i,j].energy_kev, spec[i,j].spec_p/max(spec[i,j].spec_p), psym=10

pix=10.
er=[4,6]
imgL=foxsi_image_solar(d6, 6, ps=pix, er=er, thr_n=5. )
mapL = make_map( imgL, xcen=0., ycen=0., dx=pix, dy=pix )
plot_map, mapL, /limb, cen=flare_xy, fov=2, /cb
er=[6,8]
imgH=foxsi_image_solar(d6, 6, ps=pix, er=er, thr_n=5. )
mapH = make_map( imgH, xcen=0., ycen=0., dx=pix, dy=pix )
plot_map, mapH, /limb, cen=flare_xy, fov=2, /cb

maph.data[ where(maph.data lt 10.) ] = 0.
mapl.data[ where(mapl.data lt 10.) ] = 0.
ratio = mapH
ratio.data = maph.data / mapl.data
plot_map, ratio, /limb, cen=flare_xy, fov=2, /cb, dmax=10.

;
; Look at first target again.
;

;binwidth=1.

@foxsi-setup-script
get_target_data, 1, d0,d1,d2,d3,d4,d5,d6
get_target_data, 2, d0_good2,d1_good2,d2_good2,d3_good2,d4_good2,d5_good2,d6_good2, /good

i0=where(d0.hit_energy[1] gt 4 and d0.hit_energy[1] lt 15)
i1=where(d1.hit_energy[1] gt 4 and d1.hit_energy[1] lt 15)
i2=where(d2.hit_energy[1] gt 4 and d2.hit_energy[1] lt 15)
i3=where(d3.hit_energy[1] gt 4 and d3.hit_energy[1] lt 15)
i4=where(d4.hit_energy[1] gt 4 and d4.hit_energy[1] lt 15)
i5=where(d5.hit_energy[1] gt 4 and d5.hit_energy[1] lt 15)
i6=where(d6.hit_energy[1] gt 4 and d6.hit_energy[1] lt 15)
i0g=where(d0_good.hit_energy[1] gt 4 and d0_good.hit_energy[1] lt 15)
i1g=where(d1_good.hit_energy[1] gt 4 and d1_good.hit_energy[1] lt 15)
i2g=where(d2_good.hit_energy[1] gt 4 and d2_good.hit_energy[1] lt 15)
i3g=where(d3_good.hit_energy[1] gt 4 and d3_good.hit_energy[1] lt 15)
i4g=where(d4_good.hit_energy[1] gt 4 and d4_good.hit_energy[1] lt 15)
i5g=where(d5_good.hit_energy[1] gt 4 and d5_good.hit_energy[1] lt 15)
i6g=where(d6_good.hit_energy[1] gt 4 and d6_good.hit_energy[1] lt 15)

j0=where(d0.error_flag eq 4)
j1=where(d1.error_flag eq 4)
j2=where(d2.error_flag eq 4)
j3=where(d3.error_flag eq 4)
j4=where(d4.error_flag eq 4)
j5=where(d5.error_flag eq 4)
j6=where(d6.error_flag eq 4)

n0=n_elements(d0)
n1=n_elements(d1)
n2=n_elements(d2)
n3=n_elements(d3)
n4=n_elements(d4)
n5=n_elements(d5)
n6=n_elements(d6)
n0g2=n_elements(d0_good2)
n1g2=n_elements(d1_good2)
n2g2=n_elements(d2_good2)
n3g2=n_elements(d3_good2)
n4g2=n_elements(d4_good2)
n5g2=n_elements(d5_good2)
n6g2=n_elements(d6_good2)

ratio = [float(n0g)/n0,float(n1g)/n1,float(n2g)/n2,float(n3g)/n3,float(n4g)/n4,float(n5g)/n5,float(n6g)/n6]

pix=10.
er=[4,15]
tr = [t2_start, t2_end]

i = where(d4.error_flag eq 4)
img4err=foxsi_image_solar( d4[i], 4, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img4=foxsi_image_solar( d4, 4, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img4good=foxsi_image_solar( d4_good2, 4, ps=pix, er=er, tr=tr-t_launch, thr_n=4., /xy)
map4err = make_map( img4err, xcen=0., ycen=0., dx=pix, dy=pix, id='D4',time=anytim( anytim(t0)+tr[0], /yo))
map4 = make_map( img4, xcen=0., ycen=0., dx=pix, dy=pix, id='D4',time=anytim( anytim(t0)+tr[0], /yo))
map4good = make_map( img4good, xcen=0., ycen=0., dx=pix, dy=pix, id='D4',time=anytim( anytim(t0)+tr[0], /yo))

plot_map, map4, cen=cen1, fov=20, /limb


img0=foxsi_image_solar( d0, 0, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img1=foxsi_image_solar( d1, 1, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img2=foxsi_image_solar( d2, 2, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img3=foxsi_image_solar( d3, 3, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img4=foxsi_image_solar( d4, 4, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img5=foxsi_image_solar( d5, 5, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img6=foxsi_image_solar( d6, 6, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img =foxsi_image_solar_int( d0,d1,d2,d3,d4,d5,d6, $
		psize=pix, erange=er, trange=tr-t_launch, thr_n=4.);, /xycor )
img0g=foxsi_image_solar( d0_good, 0, ps=pix, er=er, tr=tr-t_launch, thr_n=4., /xy)
img1g=foxsi_image_solar( d1_good, 1, ps=pix, er=er, tr=tr-t_launch, thr_n=4., /xy)
img2g=foxsi_image_solar( d2_good, 2, ps=pix, er=er, tr=tr-t_launch, thr_n=4., /xy)
img3g=foxsi_image_solar( d3_good, 3, ps=pix, er=er, tr=tr-t_launch, thr_n=4., /xy)
img4g=foxsi_image_solar( d4_good, 4, ps=pix, er=er, tr=tr-t_launch, thr_n=4., /xy)
img5g=foxsi_image_solar( d5_good, 5, ps=pix, er=er, tr=tr-t_launch, thr_n=4., /xy)
img6g=foxsi_image_solar( d6_good, 6, ps=pix, er=er, tr=tr-t_launch, thr_n=4., /xy)
imgg =foxsi_image_solar_int( d0_good,d1_good,d2_good,d3_good,d4_good,d5_good,d6_good, $
		psize=pix, erange=er, trange=tr-t_launch, thr_n=4., /xycor )
img0e=foxsi_image_solar( d0[where(d0.error_flag eq 4)], 0, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img1e=foxsi_image_solar( d1[where(d1.error_flag eq 4)], 1, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img2e=foxsi_image_solar( d2[where(d2.error_flag eq 4)], 2, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img3e=foxsi_image_solar( d3[where(d3.error_flag eq 4)], 3, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img4e=foxsi_image_solar( d4[where(d4.error_flag eq 4)], 4, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img5e=foxsi_image_solar( d5[where(d5.error_flag eq 4)], 5, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
img6e=foxsi_image_solar( d6[where(d6.error_flag eq 4)], 6, ps=pix, er=er, tr=tr-t_launch, thr_n=4.);, /xy)
imge =foxsi_image_solar_int( d0[where(d0.error_flag eq 4)],d1[where(d1.error_flag eq 4)],d2[where(d2.error_flag eq 4)],d3[where(d3.error_flag eq 4)],d4[where(d4.error_flag eq 4)],d5[where(d5.error_flag eq 4)],d6[where(d6.error_flag eq 4)], $
		psize=pix, erange=er, trange=tr-t_launch, thr_n=4.);, /xycor )

map0 = make_map( img0, xcen=0., ycen=0., dx=pix, dy=pix, id='D0',time=anytim( anytim(t0)+tr[0], /yo))
map1 = make_map( img1, xcen=0., ycen=0., dx=pix, dy=pix, id='D1',time=anytim( anytim(t0)+tr[0], /yo))
map2 = make_map( img2, xcen=0., ycen=0., dx=pix, dy=pix, id='D2',time=anytim( anytim(t0)+tr[0], /yo))
map3 = make_map( img3, xcen=0., ycen=0., dx=pix, dy=pix, id='D3',time=anytim( anytim(t0)+tr[0], /yo))
map4 = make_map( img4, xcen=0., ycen=0., dx=pix, dy=pix, id='D4',time=anytim( anytim(t0)+tr[0], /yo))
map5 = make_map( img5, xcen=0., ycen=0., dx=pix, dy=pix, id='D5',time=anytim( anytim(t0)+tr[0], /yo))
map6 = make_map( img6, xcen=0., ycen=0., dx=pix, dy=pix, id='D6',time=anytim( anytim(t0)+tr[0], /yo))
map  = make_map( img,  xcen=0., ycen=0., dx=pix, dy=pix, id='5dets',time=anytim( anytim(t0)+tr[0], /yo))
map0g = make_map( img0g, xcen=0., ycen=0., dx=pix, dy=pix, id='D0',time=anytim( anytim(t0)+tr[0], /yo))
map1g = make_map( img1g, xcen=0., ycen=0., dx=pix, dy=pix, id='D1',time=anytim( anytim(t0)+tr[0], /yo))
map2g = make_map( img2g, xcen=0., ycen=0., dx=pix, dy=pix, id='D2',time=anytim( anytim(t0)+tr[0], /yo))
map3g = make_map( img3g, xcen=0., ycen=0., dx=pix, dy=pix, id='D3',time=anytim( anytim(t0)+tr[0], /yo))
map4g = make_map( img4g, xcen=0., ycen=0., dx=pix, dy=pix, id='D4',time=anytim( anytim(t0)+tr[0], /yo))
map5g = make_map( img5g, xcen=0., ycen=0., dx=pix, dy=pix, id='D5',time=anytim( anytim(t0)+tr[0], /yo))
map6g = make_map( img6g, xcen=0., ycen=0., dx=pix, dy=pix, id='D6',time=anytim( anytim(t0)+tr[0], /yo))
mapg  = make_map( imgg,  xcen=0., ycen=0., dx=pix, dy=pix, id='5dets',time=anytim( anytim(t0)+tr[0], /yo))
map0e = make_map( img0e, xcen=0., ycen=0., dx=pix, dy=pix, id='D0',time=anytim( anytim(t0)+tr[0], /yo))
map1e = make_map( img1e, xcen=0., ycen=0., dx=pix, dy=pix, id='D1',time=anytim( anytim(t0)+tr[0], /yo))
map2e = make_map( img2e, xcen=0., ycen=0., dx=pix, dy=pix, id='D2',time=anytim( anytim(t0)+tr[0], /yo))
map3e = make_map( img3e, xcen=0., ycen=0., dx=pix, dy=pix, id='D3',time=anytim( anytim(t0)+tr[0], /yo))
map4e = make_map( img4e, xcen=0., ycen=0., dx=pix, dy=pix, id='D4',time=anytim( anytim(t0)+tr[0], /yo))
map5e = make_map( img5e, xcen=0., ycen=0., dx=pix, dy=pix, id='D5',time=anytim( anytim(t0)+tr[0], /yo))
map6e = make_map( img6e, xcen=0., ycen=0., dx=pix, dy=pix, id='D6',time=anytim( anytim(t0)+tr[0], /yo))
mape  = make_map( imge,  xcen=0., ycen=0., dx=pix, dy=pix, id='5dets',time=anytim( anytim(t0)+tr[0], /yo))


plot_map, map, cen=cen1, fov=20, /limb

plot_map, aia_maps[0], cen=cen1, fov=20, /limb
plot_map, map, /over

shift = [-200, -45]
plot_map, aia_maps[0], cen=[-300,-200], fov=7, /limb, /log
;plot_map, aia_maps[9], cen=[cen1[0]+180,cen1[1]-50], fov=7, /limb, /log
plot_map, shift_map(map, shift[0], shift[1]), /over

;
; Basic count spectrum of flare using D6
;

get_target_data, 4, d0_t4,d1_t4,d2_t4,d3_t4,d4_t4,d5_t4,d6_t4
get_target_data, 6, d0_t6,d1_t6,d2_t6,d3_t6,d4_t6,d5_t6,d6_t6
;get_target_data, 2, d0b,d1b,d2b,d3b,d4b,d5b,d6b

d6_t4 = d6_t4[ where( d6_t4.error_flag eq 0 ) ]
d6_t6 = d6_t6[ where( d6_t6.error_flag eq 0 ) ]
;d6b = d6b[ where( d6b.error_flag eq 0 ) ]

d6 = [d6_t4,d6_t6]

spec = make_spectrum( d6, bin=0.5 )
spec_t4 = make_spectrum( d6_t4, bin=0.5 )
spec_t6 = make_spectrum( d6_t6, bin=0.5 )
;specb = make_spectrum( d6b, bin=1. )
; values are counts per keV.

time4 = t4_end - t4_start
time6 = t6_end - t6_start

time_int = time4 + time6
time_intb = t2_end - t2_start

popen, xsi=7, ysi=7
ploterr, spec.energy_kev, spec.spec_p/time_int, spec.energy_kev*0., spec.spec_p_err/time_int, $
	/xlo, /ylo, charsi=1.2, $
	xr=[3.,20.], yr=[1.e-3,1.e2], /xsty, /ysty, psym=10, thick=4, errthick=4, nohat=0, $
	xtit='Energy [keV]', ytit='Counts s!U-1!N keV!U-1!N detector!U-1!N'
oploterr, specb.energy_kev, specb.spec_p/time_intb, specb.energy_kev*0., specb.spec_p_err/time_intb, $
	psym=10, thick=4, line=1
legend, ['Flare, detector 6','Second target, detector 6'], line=[0,1], thick=4, charsi=1.2, box=0.
pclose

ploterr, spec_t4.energy_kev, spec_t4.spec_p/time4, spec_t4.energy_kev*0., $
	spec_t4.spec_p_err/time4, /xlo, /ylo, charsi=1.2, $
	xr=[3.,20.], yr=[1.e-3,1.e2], /xsty, /ysty, psym=10, thick=1, errthick=1, nohat=0, $
	xtit='Energy [keV]', ytit='Counts s!U-1!N keV!U-1!N detector!U-1!N'
oploterr, spec_t6.energy_kev, spec_t6.spec_p/time6, spec_t6.energy_kev*0., $
	spec_t6.spec_p_err/time6, psym=10, thick=1, color=6, errcolor=6


;
; Lightcurve
;

data = data_lvl2_d6[ where(data_lvl2_d6.error_flag eq 0) ]
hist = histogram( data.wsmr_time, min=min(data.wsmr_time), max=max(data.wsmr_time),bin=5.)
int = max(data.wsmr_time) - min(data.wsmr_time)
time = anytim( anytim('2012-nov-02') + data[0].wsmr_time + findgen(78)*5., /yo)

popen, xsi=7, ysi=7
utplot, time, hist/5., psym=10, thick=4, ytit='Counts s!U-1!N detector!U-1!N', charsi=1.2
pclose

;
; Make a spectrogram
;

time = d6.wsmr_time
en = d6.hit_energy[1]
n1 = 49
n2 = 81
time_axis = fltarr(n1)
spectro = fltarr(n1, n2)

.run
for i=0, n1-1 do begin
	j = where( time ge time[0]+2.5*i and time lt time[0]+2.5*(i+1) )
	if j[0] eq -1 then continue
	hist = histogram( en[j], min=0, max=20, bin=0.25 )
	spectro[i,*] = hist
	time_axis[i] = time[0]+2.5*i
endfor
end

time_axis = anytim('2012-nov-02')+time_axis 
spectro_plot, spectro, time_axis, findgen(16), /cbar
spectro_plot, spectro, /cbar


pix=4.
er=[6,15]
m0a = foxsi_image_solar(d0, 0, ps=pix, er=erange, thr_n=erange[0] )
m1a = foxsi_image_solar(d1, 1, ps=pix, er=erange, thr_n=erange[0] )
m2a = foxsi_image_solar(d2, 2, ps=pix, er=erange, thr_n=erange[0] )
m3a = foxsi_image_solar(d3, 3, ps=pix, er=erange, thr_n=erange[0] )
m4a = foxsi_image_solar(d4, 4, ps=pix, er=erange, thr_n=erange[0] )
m5a = foxsi_image_solar(d5, 5, ps=pix, er=erange, thr_n=erange[0] )
m6a = foxsi_image_solar(d6, 6, ps=pix, er=erange, thr_n=erange[0] )
m0b = foxsi_image_solar(d0a, 0, ps=pix, er=erange, thr_n=erange[0] )
m1b = foxsi_image_solar(d1a, 1, ps=pix, er=erange, thr_n=erange[0] )
m2b = foxsi_image_solar(d2a, 2, ps=pix, er=erange, thr_n=erange[0] )
m3b = foxsi_image_solar(d3a, 3, ps=pix, er=erange, thr_n=erange[0] )
m4b = foxsi_image_solar(d4a, 4, ps=pix, er=erange, thr_n=erange[0] )
m5b = foxsi_image_solar(d5a, 5, ps=pix, er=erange, thr_n=erange[0] )
m6b = foxsi_image_solar(d6a, 6, ps=pix, er=erange, thr_n=erange[0] )

m6a = foxsi_image_solar(d6a, 6, ps=pix, er=erange, thr_n=erange[0], trange=t6_start-t_launch+[ 0,10] )
m6b = foxsi_image_solar(d6a, 6, ps=pix, er=erange, thr_n=erange[0], trange=t6_start-t_launch+[10,20] )
m6c = foxsi_image_solar(d6a, 6, ps=pix, er=erange, thr_n=erange[0], trange=t6_start-t_launch+[20,30] )
m6d = foxsi_image_solar(d6a, 6, ps=pix, er=erange, thr_n=erange[0], trange=t6_start-t_launch+[30,40] )
m6e = foxsi_image_solar(d6a, 6, ps=pix, er=erange, thr_n=erange[0], trange=t6_start-t_launch+[40,50] )
m6f = foxsi_image_solar(d6a, 6, ps=pix, er=erange, thr_n=erange[0], trange=t6_start-t_launch+[50,60] )
m6g = foxsi_image_solar(d6a, 6, ps=pix, er=erange, thr_n=erange[0], trange=t6_start-t_launch+[60,70] )
m6h = foxsi_image_solar(d6a, 6, ps=pix, er=erange, thr_n=erange[0], trange=t6_start-t_launch+[70,80] )

m6_targ4=m6
m6_targ6 = [m6a,m6b,m6c,m6d,m6e,m6f]

movie_map, m6_targ6, cen=flare, fov=2, /cbar

plot_map, map, /limb, cen=flare, fov=2, /cb

n = (1080-960)/pix
xbins = 960 + findgen(n+1)*pix
ybins = -270 - findgen(n+1)*pix

spec = make_spectrum( d6, bin=2.0 )
spec = replicate( spec, n_elements(xbins)-1,n_elements(ybins)-1 )
spec.spec_n = 0.
spec.spec_p = 0.
spec.spec_p_err = 0.


;
; more imaging spectroscopy
;

@foxsi-setup-script

flare_xy = [1020.,-320.]
get_target_data, 4, d0,d1,d2,d3,d4,d5,d6_t4_flare, cen=flare_xy, rad=50.
get_target_data, 6, d0,d1,d2,d3,d4,d5,d6_t6_flare, cen=flare_xy, rad=50.
get_target_data, 4, d0,d1,d2,d3,d4,d5,d6_t4_near, cen=flare_xy, rad=100.
get_target_data, 6, d0,d1,d2,d3,d4,d5,d6_t6_near, cen=flare_xy, rad=100.
get_target_data, 4, d0,d1,d2,d3,d4,d5,d6_t4_bkgd, cen=[500,-700],rad=200.
get_target_data, 6, d0,d1,d2,d3,d4,d5,d6_t6_bkgd, cen=[500,-700],rad=200.

d6src  = [d6_t4_flare, d6_t6_flare]
d6near = [d6_t4_near, d6_t6_near]
d6bkgd = [d6_t4_bkgd, d6_t6_bkgd]
d6src  = d6src [ where( d6src.error_flag eq 0 ) ]
d6near = d6near[ where( d6near.error_flag eq 0 ) ]
d6bkgd = d6bkgd[ where( d6bkgd.error_flag eq 0 ) ]

spec_src  = make_spectrum( d6src,  bin=0.5 )
spec_near = make_spectrum( d6near, bin=0.5 )
spec_bkgd = make_spectrum( d6bkgd, bin=2. )

; subtract spec_src from spec_near to get an annulus
; then scale all the counts to the area used for the flare spectrum.
spec_bkgd.spec_n /= 16.
spec_bkgd.spec_p /= 16.
spec_bkgd.spec_p_err /= 16.
spec_near.spec_n = (spec_near.spec_n - spec_src.spec_n) / 3.
spec_near.spec_p = (spec_near.spec_p - spec_src.spec_p) / 3.
spec_near.spec_p_err = sqrt( spec_near.spec_p_err^2 + spec_src.spec_p_err^2 ) / 3.

; values are counts per keV.
time_int = t4_end + t6_end - t4_start - t6_start

;; manual rebinning of the histograms.
;energy = spec.energy_kev
;counts = spec.spec_p/time_int
;yerr   = spec.spec_p_err/time_int
;n = n_elements(energy)
;i_low = where( energy le 8. )
;i_hi  = where( energy gt 8. and findgen(n-2) mod 2 eq 0 )
;counts_low = counts[i_low]
;counts_hi = counts[i_hi] + counts[i_hi+1]
;new_en = [energy[i_low],energy[i_hi]]
;new_counts = [counts_low,counts_hi]

popen, xsi=7, ysi=6
ploterr, spec_src.energy_kev, spec_src.spec_p/time_int, spec_src.energy_kev*0., $
	spec_src.spec_p_err/time_int, /xlo, /ylo, charsi=1.3, $
	xr=[3.,15.], yr=[1.e-4,1.e2], /xsty, /ysty, psym=10, thick=4, errthick=4, nohat=0, $
	xtit='Energy [keV]', ytit='Counts s!U-1!N keV!U-1!N'
oploterr, spec_near.energy_kev, spec_near.spec_p/time_int, spec_near.energy_kev*0., $
	spec_near.spec_p_err/time_int, psym=10, thick=4, line=2
oploterr, spec_bkgd.energy_kev, spec_bkgd.spec_p/time_int, spec_bkgd.energy_kev*0., $
	spec_bkgd.spec_p_err/time_int, psym=10, thick=4, line=1
legend, ['Flare','50" annulus','Background'], line=[0,2,1], thick=4, charsi=1.2, box=0., /right
pclose

;ploterr, new_en, new_counts, spec.energy_kev*0., $
;	spec.spec_p_err/time_int, /xlo, /ylo, charsi=1.2, $
;	xr=[3.,20.], yr=[1.e-5,1.e2], /xsty, /ysty, psym=10, thick=4, errthick=4, nohat=0, $
;	xtit='Energy [keV]', ytit='Counts s!U-1!N keV!U-1!N detector!U-1!N'

;
; imaging spectroscopy using a 50% contour level...
;

@foxsi-setup-script

flare_xy = [1020.,-320.]
pix=3.
er=[4,15]
tr = [t4_start, t4_end]

; reference map to select the core pixels.
img6=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[3.,15.], tr=tr-t_launch, thr_n=4.)
;core = hsi_select_box(img6.data)
;save, core, file='core.sav'
restore,'core.sav'

; create the image cube for Target 4
tr = [t4_start, t4_end]
m4 = replicate( img6, 21 )
m4.data = 0.
m4[0]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[3.,3.5], tr=tr-t_launch, thr_n=4.)
m4[1]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[3.5,4.], tr=tr-t_launch, thr_n=4.)
m4[2]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[4.,4.5], tr=tr-t_launch, thr_n=4.)
m4[3]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[4.5,5.], tr=tr-t_launch, thr_n=4.)
m4[4]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[5.,5.5], tr=tr-t_launch, thr_n=4.)
m4[5]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[5.5,6.], tr=tr-t_launch, thr_n=4.)
m4[6]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[6.,6.5], tr=tr-t_launch, thr_n=4.)
m4[7]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[6.5,7.], tr=tr-t_launch, thr_n=4.)
m4[8]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[7.,7.5], tr=tr-t_launch, thr_n=4.)
m4[9]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[7.5,8.], tr=tr-t_launch, thr_n=4.)
m4[10]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[8.,8.5], tr=tr-t_launch, thr_n=4.)
m4[11]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[8.5,9.], tr=tr-t_launch, thr_n=4.)
m4[12]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[9.,9.5], tr=tr-t_launch, thr_n=4.)
m4[13]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[9.5,10.], tr=tr-t_launch, thr_n=4.)
m4[14]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[10.,10.5], tr=tr-t_launch, thr_n=4.)
m4[15]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[10.5,11.], tr=tr-t_launch, thr_n=4.)
m4[16]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[11.,11.5], tr=tr-t_launch, thr_n=4.)
m4[17]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[11.5,12.], tr=tr-t_launch, thr_n=4.)
m4[18]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[12.,13.], tr=tr-t_launch, thr_n=4.)
m4[19]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[13.,14.], tr=tr-t_launch, thr_n=4.)
m4[20]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[14.,15.], tr=tr-t_launch, thr_n=4.)

; repeat for Target 6!
tr = [t6_start, t6_end]
m6 = replicate( img6, 21 )
m6.data = 0.
;m6[0]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[3.,3.5], tr=tr-t_launch, thr_n=4.)
m6[1]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[3.5,4.], tr=tr-t_launch, thr_n=4.)
m6[2]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[4.,4.5], tr=tr-t_launch, thr_n=4.)
m6[3]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[4.5,5.], tr=tr-t_launch, thr_n=4.)
m6[4]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[5.,5.5], tr=tr-t_launch, thr_n=4.)
m6[5]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[5.5,6.], tr=tr-t_launch, thr_n=4.)
m6[6]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[6.,6.5], tr=tr-t_launch, thr_n=4.)
m6[7]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[6.5,7.], tr=tr-t_launch, thr_n=4.)
m6[8]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[7.,7.5], tr=tr-t_launch, thr_n=4.)
m6[9]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[7.5,8.], tr=tr-t_launch, thr_n=4.)
m6[10]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[8.,8.5], tr=tr-t_launch, thr_n=4.)
m6[11]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[8.5,9.], tr=tr-t_launch, thr_n=4.)
m6[12]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[9.,9.5], tr=tr-t_launch, thr_n=4.)
m6[13]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[9.5,10.], tr=tr-t_launch, thr_n=4.)
m6[14]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[10.,10.5], tr=tr-t_launch, thr_n=4.)
m6[15]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[10.5,11.], tr=tr-t_launch, thr_n=4.)
m6[16]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[11.,11.5], tr=tr-t_launch, thr_n=4.)
m6[17]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[11.5,12.], tr=tr-t_launch, thr_n=4.)
;m6[18]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[12.,13.], tr=tr-t_launch, thr_n=4.)
;m6[19]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[13.,14.], tr=tr-t_launch, thr_n=4.)
;m6[20]=foxsi_image_solar( data_lvl2_d6, 6, ps=pix, er=[14.,15.], tr=tr-t_launch, thr_n=4.)

m4.data[ where(finite(m4.data) eq 0) ] = 0.
m6.data[ where(finite(m6.data) eq 0) ] = 0.

m = replicate( img6, 21 )
m.data = m4.data + m6.data

; values are counts.  Make it counts per keV per sec.
time_int = t4_end + t6_end - t4_start - t6_start
en  = [findgen(19)*0.5+3.,13.,14.,15.]
width = get_edges(en, /width)
cts = fltarr(21)
for i=0, 20 do cts[i]=total(m[i].data[core]) / time_int / width[i]
err = sqrt(cts) / time_int / width

; now get the background counts, using the earlier method.
;get_target_data, 4, d0,d1,d2,d3,d4,d5,d6_t4_bkgd, cen=[500,-700],rad=200.
;get_target_data, 6, d0,d1,d2,d3,d4,d5,d6_t6_bkgd, cen=[500,-700],rad=200.
get_target_data, 4, d0,d1,d2,d3,d4,d5,d6_t4_bkgd, cen=[350,-700],rad=200.
get_target_data, 6, d0,d1,d2,d3,d4,d5,d6_t6_bkgd, cen=[350,-700],rad=200.

d6bkgd = [d6_t4_bkgd, d6_t6_bkgd]
d6bkgd = d6bkgd[ where( d6bkgd.error_flag eq 0 ) ]
spec_bkgd = make_spectrum( d6bkgd, bin=2. )

; scale to same area as flare
flare_area = n_elements(core)*3.^2	; factor of 3 is because core pix were 3" wide.
bkgd_area  = !pi*200.^2
scale = flare_area / bkgd_area
spec_bkgd.spec_n *= scale
spec_bkgd.spec_p *= scale
spec_bkgd.spec_p_err *= scale
bkgd_err = spec_bkgd.spec_p_err
bkgd_err_lower = bkgd_err
i=where(bkgd_err eq spec_bkgd.spec_p)
bkgd_err_lower[i] /= 1.1

;ploterr, en, cts, en*0., err, /xlo, /ylo, xr=[3.,15.], /xsty, yr=[1.,1.e4], psym=10

;popen, xsi=7, ysi=5.5
plot_oo, en, cts, /xlo, /ylo, charsi=1.5, xr=[3.,15.], yr=[1.e-5,1.e1], /xsty, /ysty, /nodata, $
	xtit='Energy [keV]', ytit='Counts s!U-1!N keV!U-1!N', ytickformat='logticks_exp'
oploterr, en, cts, en*0.,err, $;, /xlo, /ylo, charsi=1.4, $
;	xr=[3.,15.], yr=[1.e-5,1.e1], /xsty, /ysty, 
	psym=10, thick=4, errthick=4, nohat=0
oploterr, spec_bkgd.energy_kev, spec_bkgd.spec_p/time_int, spec_bkgd.energy_kev*0., $
	bkgd_err/time_int, psym=10, thick=4, line=2, /HIBAR
oploterr, spec_bkgd.energy_kev, spec_bkgd.spec_p/time_int, spec_bkgd.energy_kev*0., $
	bkgd_err_lower/time_int, psym=10, thick=4, line=2, /LOBAR
legend, ['Flare','Background'], line=[0,2], thick=4, charsi=1.2, box=0., /right
;pclose

; qsum = SQRT( Total(stack^2, 3) )

;
; off-axis response
;

e1 = dindgen(1200)/100+3
e2 = get_edges(e1,/edges_2)
emid = get_edges(e1,/mean)

;rhessi = rhessi_eff_area(e1, 0.25, 0)
area = get_foxsi_offaxis_resp(energy_arr=emid, offaxis=7.3 )

spec = get_target_spectra(2, /corr, /good)

plot, spec[6].energy_kev, spec[6].spec_p, psym=10.; /xlo, /ylo, $
	psym=10, yr=[1.e-2,1.], xr=[3.,100], /xsty



