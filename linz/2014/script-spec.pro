@foxsi-setup-script-2014

spec1 = get_target_spectra( 1, /good, year=2014 )
spec2 = get_target_spectra( 2, /good, year=2014 )
spec3 = get_target_spectra( 3, /good, year=2014 )
spec4 = get_target_spectra( 4, /good, year=2014 )
spec5 = get_target_spectra( 5, /good, year=2014 )

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
