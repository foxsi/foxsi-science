@foxsi-setup-script-2014

spec1 = get_target_spectra( 1, year=2014, /good )
spec2 = get_target_spectra( 2, year=2014, /good )
spec3 = get_target_spectra( 3, year=2014, /good )
spec4 = get_target_spectra( 4, year=2014, /good )
spec5 = get_target_spectra( 5, year=2014, /good )

popen, 'plots/foxsi2/spectra', xsi=7, ysi=5
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

@foxsi-setup-script-2014

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

