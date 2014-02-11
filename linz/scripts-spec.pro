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
dir = 'detector_data/'
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

