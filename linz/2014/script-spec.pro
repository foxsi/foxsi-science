foxsi,2014

spec1 = get_target_spectra( 1, year=2014, /good )
spec2 = get_target_spectra( 2, year=2014, /good )
spec3 = get_target_spectra( 3, year=2014, /good )
spec4 = get_target_spectra( 4, year=2014, /good )
spec5 = get_target_spectra( 5, year=2014, /good )

popen, 'spectra', xsi=7, ysi=5
spec=spec1
hsi_linecolors
plot, spec[6].energy_kev, spec[6].spec_p, /xlo, /ylo, /nodata, $
	xr=[1.,100.], yr=[1.e-2,1.e2], charsi=1.2, charth=2, xth=5, yth=5, $
	xtit='Energy [keV]', ytit='Cts s!U-1!N keV!U-1!N', $
	title='Target 1 spectra'
oplot, spec[0].energy_kev, spec[0].spec_p, thick=5, psym=10, col=6
oplot, spec[1].energy_kev, spec[1].spec_p, thick=5, psym=10, col=7
oplot, spec[4].energy_kev, spec[4].spec_p, thick=5, psym=10, col=10
oplot, spec[5].energy_kev, spec[5].spec_p, thick=5, psym=10, col=12
oplot, spec[6].energy_kev, spec[6].spec_p, thick=5, psym=10, col=2
al_legend, ['D0','D1','D4','D5','D6'], line=0, col=[6,7,10,12,2], thick=5, /rig, box=0

spec=spec2
hsi_linecolors
plot, spec[6].energy_kev, spec[6].spec_p, /xlo, /ylo, /nodata, $
	xr=[1.,100.], yr=[1.e-2,1.e2], charsi=1.2, charth=2, xth=5, yth=5, $
	xtit='Energy [keV]', ytit='Cts s!U-1!N keV!U-1!N', $
	title='Target 2 spectra'
oplot, spec[0].energy_kev, spec[0].spec_p, thick=5, psym=10, col=6
oplot, spec[1].energy_kev, spec[1].spec_p, thick=5, psym=10, col=7
oplot, spec[4].energy_kev, spec[4].spec_p, thick=5, psym=10, col=10
oplot, spec[5].energy_kev, spec[5].spec_p, thick=5, psym=10, col=12
oplot, spec[6].energy_kev, spec[6].spec_p, thick=5, psym=10, col=2
al_legend, ['D0','D1','D4','D5','D6'], line=0, col=[6,7,10,12,2], thick=5, /rig, box=0

spec=spec3
hsi_linecolors
plot, spec[6].energy_kev, spec[6].spec_p, /xlo, /ylo, /nodata, $
	xr=[1.,100.], yr=[1.e-2,1.e2], charsi=1.2, charth=2, xth=5, yth=5, $
	xtit='Energy [keV]', ytit='Cts s!U-1!N keV!U-1!N', $
	title='Target 3 spectra'
oplot, spec[0].energy_kev, spec[0].spec_p, thick=5, psym=10, col=6
oplot, spec[1].energy_kev, spec[1].spec_p, thick=5, psym=10, col=7
oplot, spec[4].energy_kev, spec[4].spec_p, thick=5, psym=10, col=10
oplot, spec[5].energy_kev, spec[5].spec_p, thick=5, psym=10, col=12
oplot, spec[6].energy_kev, spec[6].spec_p, thick=5, psym=10, col=2
al_legend, ['D0','D1','D4','D5','D6'], line=0, col=[6,7,10,12,2], thick=5, /rig, box=0

spec=spec4
hsi_linecolors
plot, spec[6].energy_kev, spec[6].spec_p, /xlo, /ylo, /nodata, $
	xr=[1.,100.], yr=[1.e-2,1.e2], charsi=1.2, charth=2, xth=5, yth=5, $
	xtit='Energy [keV]', ytit='Cts s!U-1!N keV!U-1!N', $
	title='Target 4 spectra'
oplot, spec[0].energy_kev, spec[0].spec_p, thick=5, psym=10, col=6
oplot, spec[1].energy_kev, spec[1].spec_p, thick=5, psym=10, col=7
oplot, spec[4].energy_kev, spec[4].spec_p, thick=5, psym=10, col=10
oplot, spec[5].energy_kev, spec[5].spec_p, thick=5, psym=10, col=12
oplot, spec[6].energy_kev, spec[6].spec_p, thick=5, psym=10, col=2
al_legend, ['D0','D1','D4','D5','D6'], line=0, col=[6,7,10,12,2], thick=5, /rig, box=0

spec=spec5
hsi_linecolors
plot, spec[6].energy_kev, spec[6].spec_p, /xlo, /ylo, /nodata, $
	xr=[1.,100.], yr=[1.e-2,1.e2], charsi=1.2, charth=2, xth=5, yth=5, $
	xtit='Energy [keV]', ytit='Cts s!U-1!N keV!U-1!N', $
	title='Target 5 spectra'
oplot, spec[0].energy_kev, spec[0].spec_p, thick=5, psym=10, col=6
oplot, spec[1].energy_kev, spec[1].spec_p, thick=5, psym=10, col=7
oplot, spec[4].energy_kev, spec[4].spec_p, thick=5, psym=10, col=10
oplot, spec[5].energy_kev, spec[5].spec_p, thick=5, psym=10, col=12
oplot, spec[6].energy_kev, spec[6].spec_p, thick=5, psym=10, col=2
al_legend, ['D0','D1','D4','D5','D6'], line=0, col=[6,7,10,12,2], thick=5, /rig, box=0

pclose


;
; Look at the high-energy emission from nonflaring region.
;

foxsi,2014

trange=[t5_start, t5_end]
cen = cen5
m = foxsi_image_map( data_lvl2_d1, cen, erange=[4.,100], trange=trange, thr_n=4., /xycorr, smooth=2 )

get_target_data, 5, d0,d1,d2,d3,d4,d5,d6, center = flare1-offset_xy, rad=200

s = make_spectrum( [d0,d1,d4,d5], bin=1., /corr )
err = sqrt( s.spec_p/0.5 ) / 32.7

spec=s
hsi_linecolors
plot, spec.energy_kev, spec.spec_p/32.7, /xlo, /ylo, /nodata, $
	xr=[3.,15.], yr=[1.e-2,100.], charsi=1.3, charth=2, xth=5, yth=5, /xsty, $
	xtit='Energy [keV]', ytit='Counts s!U-1!N keV!U-1!N', $
	title='Target 5, nonflaring region, 4 Si det w/shutter'
oplot_err, spec.energy_kev, spec.spec_p/32.7, yerr=err, thick=8, psym=10, col=12
;al_legend, ['D0','D1','D4','D5','D6'], line=0, col=[6,7,10,12,2], thick=5, /rig, box=0

popen, 'plots/foxsi2/target5-count-spex', xsi=7, ysi=5
hsi_linecolors
plot, spec_targ5[6].energy_kev, phot6, /xlo, /ylo, /nodata, $
	xr=[3.,15.], yr=[1.e-2,100.], charsi=1.3, charth=2, xth=5, yth=5, /xsty, $
	xtit='Energy [keV]', ytit='Counts s!U-1!N keV!U-1!N', $
	title='Target 5 count spectra'
oplot, spec_targ5[6].energy_kev, spec_targ5[6].spec_p, thick=5, psym=10, col=2
oplot_err, spec_targ5[0].energy_kev, spec_targ5[0].spec_p, yerr=err0, thick=5, psym=10, col=6
oplot_err, spec_targ5[1].energy_kev, spec_targ5[1].spec_p, yerr=err1, thick=5, psym=10, col=7
oplot_err, spec_targ5[4].energy_kev, spec_targ5[4].spec_p, yerr=err4, thick=5, psym=10, col=10
oplot_err, spec_targ5[5].energy_kev, spec_targ5[5].spec_p, yerr=err5, thick=5, psym=10, col=12
;oplot, en_array, cts0, thick=8, psym=10, col=6, line=1
;oplot, en_array, cts1, thick=8, psym=10, col=7, line=1
;oplot, en_array, cts4, thick=8, psym=10, col=10, line=1
;oplot, en_array, cts5, thick=8, psym=10, col=12, line=1
al_legend, ['D0','D1','D4','D5','D6'], line=0, col=[6,7,10,12,2], thick=5, /rig, box=0
oplot, [4.,4.], [1.e-4,1.e2], line=1, thick=5
avg = average( [[cts0],[cts1],[cts4],[cts5]], 2 )
avg[ where( finite(avg) eq 0 ) ] = 0.
smooth = smooth( avg, 2 )
oplot, en_array[8:20], smooth[8:20], thick=8
pclose

;
; Get photon spectrum from Det6
;

spec_targ5 = get_target_spectra( 5, year=2014, /good )
dt = t5_end - t5_start

en_array = spec_targ5[6].energy_kev

inv0 = inverse_resp( en_array, module=0 )
inv1 = inverse_resp( en_array, module=1 )
inv4 = inverse_resp( en_array, module=4 )
inv5 = inverse_resp( en_array, module=5 )
inv6 = inverse_resp( en_array, module=6 )

phot0 = spec_targ5[0].spec_p * inv0.per_cm2
phot1 = spec_targ5[1].spec_p * inv1.per_cm2
phot4 = spec_targ5[4].spec_p * inv4.per_cm2
phot5 = spec_targ5[5].spec_p * inv5.per_cm2
phot6 = spec_targ5[6].spec_p * inv6.per_cm2

;popen, 'plots/foxsi2/photon-spex', xsi=7, ysi=5
hsi_linecolors
plot, spec_targ5[6].energy_kev, phot6, /xlo, /ylo, /nodata, $
	xr=[3.,15.], yr=[1.e-3,1.e2], charsi=1.2, charth=2, xth=5, yth=5, /xsty, $
	xtit='Energy [keV]', ytit='Photons cm!U-2!N s!U-1!N keV!U-1!N', $
	title='Target 1 photon spectra'
oplot, spec_targ5[0].energy_kev, phot0, thick=5, psym=10, col=6
oplot, spec_targ5[1].energy_kev, phot1, thick=5, psym=10, col=7
oplot, spec_targ5[4].energy_kev, phot4, thick=5, psym=10, col=10
oplot, spec_targ5[5].energy_kev, phot5, thick=5, psym=10, col=12
oplot, spec_targ5[6].energy_kev, phot6, thick=5, psym=10, col=2
al_legend, ['D0','D1','D4','D5','D6'], line=0, col=[6,7,10,12,2], thick=5, /rig, box=0
oplot, [4.,4.], [1.e-3,1.e2], line=1, thick=3
;pclose

; check for agreement.

area0 = get_foxsi_effarea( energy=en_array, module=0, al_um=100 )
area1 = get_foxsi_effarea( energy=en_array, module=1, al_um=100 )
area4 = get_foxsi_effarea( energy=en_array, module=4, al_um=100 )
area5 = get_foxsi_effarea( energy=en_array, module=5, al_um=100 )
cts0 = area0.eff_area_cm2*phot6
cts1 = area1.eff_area_cm2*phot6
cts4 = area4.eff_area_cm2*phot6
cts5 = area5.eff_area_cm2*phot6

err0 = sqrt( spec_targ5[0].spec_p/32.7 )
err1 = sqrt( spec_targ5[1].spec_p/32.7 )
err4 = sqrt( spec_targ5[4].spec_p/32.7 )
err5 = sqrt( spec_targ5[5].spec_p/32.7 )

popen, 'plots/foxsi2/target5-count-spex', xsi=7, ysi=5
hsi_linecolors
plot, spec_targ5[6].energy_kev, phot6, /xlo, /ylo, /nodata, $
	xr=[3.,15.], yr=[1.e-2,100.], charsi=1.3, charth=2, xth=5, yth=5, /xsty, $
	xtit='Energy [keV]', ytit='Counts s!U-1!N keV!U-1!N', $
	title='Target 5 count spectra'
oplot, spec_targ5[6].energy_kev, spec_targ5[6].spec_p, thick=5, psym=10, col=2
oplot_err, spec_targ5[0].energy_kev, spec_targ5[0].spec_p, yerr=err0, thick=5, psym=10, col=6
oplot_err, spec_targ5[1].energy_kev, spec_targ5[1].spec_p, yerr=err1, thick=5, psym=10, col=7
oplot_err, spec_targ5[4].energy_kev, spec_targ5[4].spec_p, yerr=err4, thick=5, psym=10, col=10
oplot_err, spec_targ5[5].energy_kev, spec_targ5[5].spec_p, yerr=err5, thick=5, psym=10, col=12
;oplot, en_array, cts0, thick=8, psym=10, col=6, line=1
;oplot, en_array, cts1, thick=8, psym=10, col=7, line=1
;oplot, en_array, cts4, thick=8, psym=10, col=10, line=1
;oplot, en_array, cts5, thick=8, psym=10, col=12, line=1
al_legend, ['D0','D1','D4','D5','D6'], line=0, col=[6,7,10,12,2], thick=5, /rig, box=0
oplot, [4.,4.], [1.e-4,1.e2], line=1, thick=5
avg = average( [[cts0],[cts1],[cts4],[cts5]], 2 )
avg[ where( finite(avg) eq 0 ) ] = 0.
smooth = smooth( avg, 2 )
oplot, en_array[8:20], smooth[8:20], thick=8
pclose

;
; Spectra from several FOXSI ARs
;

get_target_data, 2, d0,d1,d2,d3,d4,d5,d6, delta_t=dt1, /good
;d6_cut = area_cut(d6, ar30, 120, /xy)
spec30 = make_spectrum( area_cut(d6, ar30-[60.,0.], 150, /xy), bin=0.3, /log )
spec34 = make_spectrum( area_cut(d6, ar34, 150, /xy), bin=0.3, /log )
im30 = foxsi_image_map( area_cut(d6, ar30-[60.,0.], 150, /xy), cen2_pos1, /xycor )
im34 = foxsi_image_map( area_cut(d6, ar34-[0.,0.], 150, /xy), cen2_pos1, /xycor )
plot_map, im30
circle= circle( ar30[0]-60.,ar30[1], 120)
oplot, circle[0,*], circle[1,*] 

get_target_data, 2, d0,d1,d2,d3,d4,d5,d6, delta_t=dt2, /good
spec35 = make_spectrum( area_cut(d6, ar35, 150, /xy), bin=0.3, /log )
im35 = foxsi_image_map( area_cut(d6, ar35-[0.,0.], 150, /xy), cen2_pos1, /xycor )
circle= circle( ar35[0]-0.,ar35[1], 120)
oplot, circle[0,*], circle[1,*] 

plot, spec35.energy_kev, spec35.spec_p, psym=10, /xlo, /ylo, xr=[3.,10.], /xsty, yra=minmax(spec35.spec_p[where(spec35.spec_p gt 0.)])
plot, spec34.energy_kev, spec34.spec_p, psym=10, /xlo, /ylo, xr=[3.,10.], /xsty, yra=minmax(spec34.spec_p[where(spec34.spec_p gt 0.)])

popen, 'spec-3AR', xsi=7, ysi=6
th=8
hsi_linecolors
plot_err, spec30.energy_kev, spec30.spec_p, yerr=spec30.spec_p_err, psym=10, /xlo, /ylo, $
	xr=[4.,15.], /xsty, yra=minmax(spec30.spec_p[where(spec30.spec_p gt 0.)])*[1.,1.], $
	charsi=1.4, charth=2, xth=4, yth=4, thick=th, $
	xtit='Energy [keV]', ytit='Counts s!U-1!N keV!U-1!N', tit='FOXSI Detector 6, 53 seconds'
oplot_err, spec34.energy_kev, spec34.spec_p, yerr=spec34.spec_p_err, psym=10, $
	thick=th, col=6
oplot_err, spec35.energy_kev, spec35.spec_p, yerr=spec35.spec_p_err, psym=10, $
	thick=th, col=7
al_legend, ['AR 12230 (decaying flare): 687 cts','AR 12234: 233 cts','AR 12235:  30 cts'], $
	textcol=[0,6,7], charsi=1.2, charth=2, /right, /top, box=0
pclose

;
; Spectrum for Ishikawa's AR.
;

rad = 150		; radius around location to include

data = data_lvl2_d6			; D6 only
;data = [data_lvl2_d0, data_lvl2_d1, data_lvl2_d4, data_lvl2_d5, data_lvl2_d6]		; all Si dets

north_cut = area_cut(data, flare2, rad, /xy)
i=where( north_cut.wsmr_time gt t1_pos2_start+tlaunch and north_cut.wsmr_time lt t1_pos2_end+tlaunch )
north_cut = north_cut[i]

spec = make_spectrum( north_cut, bin=0.5, /corr )
dt = t1_pos2_end - t1_pos2_start


plot, spec.energy_kev, spec.spec_p, psym=10, /xlo, /ylo, xr=[3.,10.], yr=[1.,1.e2], /xsty, $
	xtit='Energy[keV]', ytit='Counts keV!U-1!N', tit='FOXSI DET6 38.5 sec'
oplot_err, spec.energy_kev, spec.spec_p, yerr=spec.spec_p_err, psym=10


;
; Predicted AR counts for NuSTAR occulted AR source (for Matej)
;

1.7x10^46
3.8 MK

em = 1.7e-3
t = 3.8

f = foxsi2_count_spectrum( em, t, time=1., binsize=1., module=6, offaxis=0 )

plot, f.energy_kev, f.counts, psym=10


;;;;; March 22 2016 (Ishikawa's visit to UMN) ;;;;;;

;
; Checking response for 2nd AR pixels by looking at later flare in that region.
; Using both old and new calibration to check the calibration.
;

rad = 150		; radius around location to include

restore, 'data_2014/foxsi_level2_data.sav', /v		; new calibration
data = data_lvl2_d6			; D6 only
north_cut = area_cut(data, flare2, rad, /xy)
i=where( north_cut.wsmr_time gt t5_start+tlaunch and north_cut.wsmr_time lt t5_end+tlaunch )
north_cut = north_cut[i]
north_cut_new = north_cut

restore, 'data_2014/old-calib-march2015/foxsi_level2_data.sav', /v		; old calibration
data = data_lvl2_d6			; D6 only
north_cut = area_cut(data, flare2, rad, /xy)
i=where( north_cut.wsmr_time gt t5_start+tlaunch and north_cut.wsmr_time lt t5_end+tlaunch )
north_cut = north_cut[i]
north_cut_old = north_cut

spec_new = make_spectrum( north_cut_new, bin=0.5, /log, /corr )
spec_old = make_spectrum( north_cut_old, bin=0.5, /log, /corr )
dt = t5_end - t5_start


plot, spec_new.energy_kev, spec_new.spec_p, psym=10, /xlo, /ylo, xr=[3.,10.], yr=[1.,1.e4], $
	/xsty, xtit='Energy[keV]', ytit='Counts keV!U-1!N', tit='FOXSI DET6 Flare2'
oplot_err, spec_new.energy_kev, spec_new.spec_p, yerr=spec_new.spec_p_err, psym=10
oplot_err, spec_old.energy_kev, spec_old.spec_p, yerr=spec_old.spec_p_err, psym=10, col=6



; Go back to Ishikawa's time interval, and examine the photon list directly.

rad = 150		; radius around location to include

restore, 'data_2014/old-calib-march2015/foxsi_level2_data.sav', /v		; old calibration
north_cut = area_cut(data_lvl2_d6, flare2, rad, /xy)
i=where( north_cut.wsmr_time gt t1_pos2_start+tlaunch and north_cut.wsmr_time lt t1_pos2_end+tlaunch and $
					north_cut.hit_energy[1] gt 4. )
north_cut = north_cut[i]
list_old = north_cut

restore, 'data_2014/foxsi_level2_data.sav', /v		; new calibration
list_new = data_lvl2_d6[north_cut[i]]

;;list_new = data_lvl2_d6[i]


