
;
; PSF simulations -- Ron Elsner's data / routines
;

add_path, 'psf'
.compile plot_psf_linz

file = 'psf/plot_psf_linear_better_offax15'
plot_psf, 15, thresh=0.3, file=file
spawn, 'ps2pdf '+file+'.ps '+file+'.pdf'

; Plot the FWHM vs off-axis angle, in each direction.

angle = [0., 3., 6., 9., 12., 15. ]
x = [7.4, 10.4, 18.0, 20.7, 21.3, 24.6 ]
y = [7.4, 10.3, 16.9, 18.7, 18.2, 16.9 ]

popen, 'psf/fwhm', xsize=7, ysize=5
!p.multi=0
plot, angle, x, psym=-7, line=0, thick=4, charsize=1.2, $
	xtit='Off-axis angle [arcmin]', ytit='PSF FWHM', $
	title='Results from PSF simulations'
oplot, angle, y, psym=-7, line=0, thick=4
pclose

