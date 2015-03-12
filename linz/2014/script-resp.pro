;
; Plot the efficiency for each FOXSI-2 Si detector around the LET.
;

restore, 'calibration_data/efficiency_det108_asic2.sav'
effic_108_2 = efficiency
restore, 'calibration_data/efficiency_det108_asic3.sav'
effic_108_3 = efficiency
restore, 'calibration_data/efficiency_det101_asic2.sav'
effic_101_2 = efficiency
restore, 'calibration_data/efficiency_det101_asic3.sav'
effic_101_3 = efficiency
restore, 'calibration_data/efficiency_det104_asic2.sav'
effic_104_2 = efficiency
restore, 'calibration_data/efficiency_det104_asic3.sav'
effic_104_3 = efficiency
restore, 'calibration_data/efficiency_det105_asic2.sav'
effic_105_2 = efficiency
restore, 'calibration_data/efficiency_det105_asic3.sav'
effic_105_3 = efficiency
restore, 'calibration_data/efficiency_det102_asic2.sav'
effic_102_2 = efficiency
restore, 'calibration_data/efficiency_det102_asic3.sav'
effic_102_3 = efficiency

th=8
;popen, xsi=7, ysi=5
plot, energy_kev, effic_108_2, /nodata, xth=5, yth=5, charsi=1.3, charth=2, $
	xtit='Energy [keV]', ytit='Efficiency', tit='Detector efficiency at low-energy cutoff'
oplot, energy_kev, effic_108_2, thick=th, col=6
oplot, energy_kev, effic_108_3, thick=th, col=6
oplot, energy_kev, effic_101_2, thick=th, col=7
oplot, energy_kev, effic_101_3, thick=th, col=7
oplot, energy_kev, effic_104_2, thick=th, col=10
oplot, energy_kev, effic_104_3, thick=th, col=10
oplot, energy_kev, effic_105_2, thick=th, col=12
oplot, energy_kev, effic_105_3, thick=th, col=12
oplot, energy_kev, effic_102_2, thick=th, col=2
oplot, energy_kev, effic_102_3, thick=th, col=2
al_legend, ['D0','D1','D4','D5','D6'], thick=th, col=[6,7,10,12,2], line=0, /rig, box=0
;pclose


;
; Next, fold the count spectra back through that efficiency curve to get a photon flux
; at the detectors.
;

@foxsi-setup-script-2014

spec1 = get_target_spectra( 1, year=2014, /good )
spec2 = get_target_spectra( 2, year=2014, /good )
spec3 = get_target_spectra( 3, year=2014, /good )
spec4 = get_target_spectra( 4, year=2014, /good )
spec5 = get_target_spectra( 5, year=2014, /good )

; tricky part -- it matters which ASIC it is!!  For now, just take an average.
effic_d0 = average( [[effic_108_2],[effic_108_3]], 2 )
effic_d1 = average( [[effic_101_2],[effic_101_3]], 2 )
effic_d4 = average( [[effic_104_2],[effic_104_3]], 2 )
effic_d5 = average( [[effic_105_2],[effic_105_3]], 2 )
effic_d6 = average( [[effic_102_2],[effic_102_3]], 2 )

; or, choose 1.
effic_d0 = effic_108_3
effic_d1 = effic_101_3
effic_d4 = effic_104_2
effic_d5 = effic_104_2
effic_d6 = average( [[effic_102_2],[effic_102_3]], 2 )

effic_d0_int = interpol( effic_d0, energy_kev, spec1[0].energy_kev )
effic_d1_int = interpol( effic_d1, energy_kev, spec1[1].energy_kev )
effic_d4_int = interpol( effic_d4, energy_kev, spec1[4].energy_kev )
effic_d5_int = interpol( effic_d5, energy_kev, spec1[5].energy_kev )
effic_d6_int = interpol( effic_d6, energy_kev, spec1[6].energy_kev )

flux0 = spec1[0].spec_p / effic_d0_int
flux1 = spec1[1].spec_p / effic_d1_int
flux4 = spec1[4].spec_p / effic_d4_int
flux5 = spec1[5].spec_p / effic_d5_int
flux6 = spec1[6].spec_p / effic_d6_int

;popen, 'plots/foxsi2/flux', xsi=7, ysi=5
hsi_linecolors
plot, spec1[6].energy_kev, flux6, /xlo, /ylo, /nodata, $
	xr=[1.,100.], yr=[1.e-2,1.e2], charsi=1.2, charth=2, xth=5, yth=5, $
	xtit='Energy [keV]', ytit='Cts s!U-1!N keV!U-1!N', $
	title='Target 1 spectra incident on detector'
oplot, spec1[0].energy_kev, flux0, thick=5, psym=10, col=6
oplot, spec1[1].energy_kev, flux1, thick=5, psym=10, col=7
oplot, spec1[4].energy_kev, flux4, thick=5, psym=10, col=10
oplot, spec1[5].energy_kev, flux5, thick=5, psym=10, col=12
oplot, spec1[6].energy_kev, flux6, thick=5, psym=10, col=2
al_legend, ['D0','D1','D4','D5','D6'], line=0, col=[6,7,10,12,2], thick=5, /rig, box=0

;
; Next step: fold it back through the optics eff area.
;

area0 = get_foxsi_effarea( energy_arr=spec1[0].energy_kev, module=0, /nodet )
area1 = get_foxsi_effarea( energy_arr=spec1[1].energy_kev, module=1, /nodet )
area4 = get_foxsi_effarea( energy_arr=spec1[4].energy_kev, module=4, /nodet )
area5 = get_foxsi_effarea( energy_arr=spec1[5].energy_kev, module=5, /nodet )
area6 = get_foxsi_effarea( energy_arr=spec1[6].energy_kev, module=6, /nodet )

phot0 = flux0 / area0.eff_area_cm2
phot1 = flux1 / area1.eff_area_cm2
phot4 = flux4 / area4.eff_area_cm2
phot5 = flux5 / area5.eff_area_cm2
phot6 = flux6 / area6.eff_area_cm2

popen, 'plots/foxsi2/photon-spex', xsi=7, ysi=5
hsi_linecolors
plot, spec1[6].energy_kev, phot6, /xlo, /ylo, /nodata, $
	xr=[3.,15.], yr=[1.e-3,1.e2], charsi=1.2, charth=2, xth=5, yth=5, /xsty, $
	xtit='Energy [keV]', ytit='Photons cm!U-2!N s!U-1!N keV!U-1!N', $
	title='Target 1 photon spectra'
oplot, spec1[0].energy_kev, phot0, thick=5, psym=10, col=6
oplot, spec1[1].energy_kev, phot1, thick=5, psym=10, col=7
oplot, spec1[4].energy_kev, phot4, thick=5, psym=10, col=10
oplot, spec1[5].energy_kev, phot5, thick=5, psym=10, col=12
oplot, spec1[6].energy_kev, phot6, thick=5, psym=10, col=2
al_legend, ['D0','D1','D4','D5','D6'], line=0, col=[6,7,10,12,2], thick=5, /rig, box=0
oplot, [4.,4.], [1.e-3,1.e2], line=1, thick=3
pclose


; Ok, it's bad in some places; not so bad in others.  How far off are we?

average = average( [[phot0],[phot1],[phot4],[phot5],[phot6]],2 )
dev = fltarr(200)
for i=0, 199 do begin &$ 
	array = [phot0[i],phot1[i],phot4[i],phot5[i],phot6[i]] &$
	dev[i] = sqrt(total((array-average(array))^2)/(n-1)) &$
endfor

