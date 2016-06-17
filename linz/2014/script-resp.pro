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

foxsi,2014

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

;
; Example producing the photon spectrum using the "inverse response" routine.
; This includes the optics effective area, the blanketing transmission, the 
; detector low-energy cutoff, and the detector material efficiency.
;
; Still to do: make sure the blanketing parameters are correct and include livetime.
;

foxsi,2014

; This example gets the count spectra for Target 1.  spec_targ1 is a structure containing
; a count spectrum for each detector (0-6).
spec_targ1 = get_target_spectra( 1, year=2014, /good, binwidth=1.0 )

get_target_data, 1, dat0,dat1,dat2,dat3,dat4,dat5,dat6

dat0 = area_cut( dat0, flare1, 200, /xy)
dat1 = area_cut( dat1, flare1, 200, /xy)
dat4 = area_cut( dat4, flare1, 200, /xy)
dat5 = area_cut( dat5, flare1, 200, /xy)
dat6 = area_cut( dat6, flare1, 200, /xy)

bin = 0.2

spec0 = make_spectrum( dat0, /correct, bin=bin )
spec1 = make_spectrum( dat1, /correct, bin=bin )
spec4 = make_spectrum( dat4, /correct, bin=bin )
spec5 = make_spectrum( dat5, /correct, bin=bin )
spec6 = make_spectrum( dat6, /correct, bin=bin )

spec_targ1 = [spec0, spec1, spec1, spec1, spec4, spec5, spec6]

; Get an energy array from the spectrum.
en_array = spec_targ1[6].energy_kev

; Compute the inverse response for each Si detector/module.
inv0 = inverse_resp( en_array, module=0, let='efficiency_det108_asic2.sav' )
inv1 = inverse_resp( en_array, module=1, let='efficiency_det101_asic3.sav' )
inv4 = inverse_resp( en_array, module=4, let='efficiency_det104_asic2.sav' )
inv5 = inverse_resp( en_array, module=5, let='efficiency_det105_asic3.sav' )
inv6 = inverse_resp( en_array, module=6, let='efficiency_det102_asic2.sav' )

; Use the count spectra and inverse response to compute a photon spectrum.
phot0 = spec_targ1[0].spec_p * inv0.per_cm2
phot1 = spec_targ1[1].spec_p * inv1.per_cm2
phot4 = spec_targ1[4].spec_p * inv4.per_cm2
phot5 = spec_targ1[5].spec_p * inv5.per_cm2
phot6 = spec_targ1[6].spec_p * inv6.per_cm2

err0 = spec_targ1[0].spec_p_err * inv0.per_cm2
err1 = spec_targ1[1].spec_p_err * inv1.per_cm2
err4 = spec_targ1[4].spec_p_err * inv4.per_cm2
err5 = spec_targ1[5].spec_p_err * inv5.per_cm2
err6 = spec_targ1[6].spec_p_err * inv6.per_cm2

; Plot it!
;popen, 'photon-spex-orig-calib', xsi=7, ysi=5
hsi_linecolors
plot, spec_targ1[6].energy_kev, phot6, /xlo, /ylo, /nodata, $
	xr=[3.,15.], yr=[1.e-3,1.e2], charsi=1.2, charth=2, xth=5, yth=5, /xsty, $
	xtit='Energy [keV]', ytit='Photons cm!U-2!N s!U-1!N keV!U-1!N', $
	title='Target 1 photon spectra'
oplot_err, spec_targ1[0].energy_kev, phot0, yerr=err0, thick=5, psym=10, col=6
oplot_err, spec_targ1[1].energy_kev, phot1, yerr=err1, thick=5, psym=10, col=7
oplot_err, spec_targ1[4].energy_kev, phot4, yerr=err4, thick=5, psym=10, col=10
oplot_err, spec_targ1[5].energy_kev, phot5, yerr=err5, thick=5, psym=10, col=12
oplot_err, spec_targ1[6].energy_kev, phot6, yerr=err6, thick=5, psym=10, col=2
al_legend, ['D0','D1','D4','D5','D6'], line=0, col=[6,7,10,12,2], thick=5, /rig, box=0
oplot, [4.,4.], [1.e-3,1.e2], line=2, thick=3
oplot, [5.,5.], [1.e-3,1.e2], line=1, thick=3
pclose

; examine level of agreement.
; Try using standard deviation
stdev = stddev( [[phot0],[phot1],[phot4],[phot5],[phot6]], 2)
plot, spec_targ1[0].energy_kev, stdev, /psy, yr=[0.001,1.],/xlo,/ylo

; Try using chi squre
chi = fltarr(499)
stdev = stddev( [[phot0],[phot1],[phot4],[phot5],[phot6]], 2)
.run
for i=0,199 do begin
		exp = mean( [phot0[i],phot1[i],phot4[i],phot5[i],phot6[i]] )
		chi[i] = ( [phot0[i],phot1[i],phot4[i],phot5[i],phot6[i]] - exp )^2 / stdev[i]^2
endfor
end
plot, spec_targ1[0].energy_kev, chi, /psy, xr=[0,20]



;
; determine which ASIC we need.
;

t1 = tlaunch+t1_pos2_start
t2 = tlaunch+t1_pos2_end

d0 = data_lvl0_d0[where(data_lvl0_d0.inflight eq 1 and data_lvl0_d0.wsmr_time gt t1 and data_lvl0_d0.wsmr_time lt t2)]
d1 = data_lvl0_d1[where(data_lvl0_d1.inflight eq 1 and data_lvl0_d1.wsmr_time gt t1 and data_lvl0_d1.wsmr_time lt t2)]
d4 = data_lvl0_d4[where(data_lvl0_d4.inflight eq 1 and data_lvl0_d4.wsmr_time gt t1 and data_lvl0_d4.wsmr_time lt t2)]
d5 = data_lvl0_d5[where(data_lvl0_d5.inflight eq 1 and data_lvl0_d5.wsmr_time gt t1 and data_lvl0_d5.wsmr_time lt t2)]
d6 = data_lvl0_d6[where(data_lvl0_d6.inflight eq 1 and data_lvl0_d6.wsmr_time gt t1 and data_lvl0_d6.wsmr_time lt t2)]

hist = histogram( d0.hit_asic[1], loc=loc )
plot, loc, hist, psym=10
print, hist

Results:  D0:  ASIC 2: 472, ASIC 3: 636				; det108 ASIC 2
					D1:  ASIC 2: 462, ASIC 3: 593				; det101 ASIC 3
					D4:  ASIC 2: 404, ASIC 3: 304				; det104 ASIC 2
					D5:  ASIC 2: 222, ASIC 3: 396				; det105 ASIC 3
					D6:  ASIC 2: 1215, ASIC 3: 346			; det102 ASIC 2
					


D0:  ASIC