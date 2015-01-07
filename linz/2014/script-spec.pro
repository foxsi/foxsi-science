@foxsi-setup-script-2014

spec1 = get_target_spectra( 1, /good, year=2014 )
spec2 = get_target_spectra( 2, /good, year=2014 )
spec3 = get_target_spectra( 3, /good, year=2014 )
spec4 = get_target_spectra( 4, /good, year=2014 )
spec5 = get_target_spectra( 5, /good, year=2014 )

spec=spec5
hsi_linecolors
plot, spec[6].energy_kev, spec[6].spec_p, /xlo, /ylo, /nodata, $
	xr=[1.,100.], yr=[1.e-2,1.e2]
oplot, spec[0].energy_kev, spec[0].spec_p, thick=5, psym=10, col=6
oplot, spec[1].energy_kev, spec[1].spec_p, thick=5, psym=10, col=7
oplot, spec[4].energy_kev, spec[4].spec_p, thick=5, psym=10, col=10
oplot, spec[5].energy_kev, spec[5].spec_p, thick=5, psym=10, col=12
oplot, spec[6].energy_kev, spec[6].spec_p, thick=5, psym=10, col=2

