;
; Make a plot of effective area for ghost rays and focused rays using Ron's data.
; Do it for all shells combined and don't differentiate between
; hyper and para.  Show double-bounce in another color.
;

; First, the double-bounce rays.
f=file_search( 'ghost-rays/zero*' )
dat_2 = read_ascii( f[0] )	; double bounce
dat_h = read_ascii( f[1] )	; hyperbola section
dat_p = read_ascii( f[2] )	; parabola section

; add up the contributions from all 10 shells.
data = dat_2.field01[1:10,1:16]
x = reform( dat_2.field01[0,1:16])	; this is theta (off-axis angle).
y = 7*total(data,1)					; scale up to 10 modules.
y[1] = average([y[0],y[2]])	; this is to get rid of one data point that seems weird.

; Next, ghost rays with no collimator.  Same steps as for double bounce.
data0 = dat_h.field01[1:10,1:16] + dat_p.field01[1:10,1:16]		; Add hyperbola and parabola together.
x0 = reform( dat_h.field01[0,1:16])
y0 = 7*total(data0,1)/1.e4

; Next up, the case with a 3-inch collimator.
f=file_search( 'ghost-rays/three*' )
dat_h = read_ascii( f[0] )
dat_p = read_ascii( f[1] )
data3 = dat_h.field01[1:10,1:16] + dat_p.field01[1:10,1:16]
x3 = reform( dat_h.field01[0,1:16])
y3 = 7*total(data3,1)/1.e4

; Six inch
f=file_search( 'ghost-rays/six*' )
dat_h = read_ascii( f[0] )
dat_p = read_ascii( f[1] )
data6 = dat_h.field01[1:10,1:16] + dat_p.field01[1:10,1:16]
x6 = reform( dat_h.field01[0,1:16])
y6 = 7*total(data6,1)/1.e4

; Nine inch
f=file_search( 'ghost-rays/nine*' )
dat_h = read_ascii( f[0] )
dat_p = read_ascii( f[1] )
data9 = dat_h.field01[1:10,1:16] + dat_p.field01[1:10,1:16]
x9 = reform( dat_h.field01[0,1:16])
y9 = 7*total(data9,1)/1.e4

; Twelve inch
f=file_search( 'ghost-rays/twelve*' )
dat_h = read_ascii( f[0] )
dat_p = read_ascii( f[1] )
data12 = dat_h.field01[1:10,1:16] + dat_p.field01[1:10,1:16]
x12 = reform( dat_h.field01[0,1:16])
y12 = 7*total(data12,1)/1.e4

; Plot it all.
popen, 'like-ron', xsi=7, ysi=5
hsi_linecolors
yra=[1.e-1,1.e3]
plot, x, y, psy=-1, symsi=2, /ylog, yra=yra, xtit='Off-axis angle [arcmin]', ytit='Effective area [cm!U2!N] at 5 keV', $
	charsi=1.4, thick=6
xyouts, 2, 0.15, 'Detector edge'
xyouts, 11.5, 0.15, 'Detector diagonal'
oplot, x0, y0, psy=-1, symsi=2, col=2, thick=6
oplot, x3, y3, psy=-1, symsi=2, col=3, thick=6
oplot, x6, y6, psy=-1, symsi=2, col=6, thick=6
oplot, x9, y9, psy=-1, symsi=2, col=7, thick=6
oplot, x12, y12, psy=-1, symsi=2, col=8, thick=6
oplot, [11.3,11.3], yra, line=1, thick=4
oplot, [8,8], yra, line=1, thick=4
al_legend, ['Focused rays','No collimator','3 inch','6 inch','9 inch','12 inch'], col=[0,2,3,6,7,8], thick=6, $
	/right, /top, box=0, line=0, charsi=1.2
pclose
spawn, 'open like-ron.ps'

