; Sample script to generate a FOXSI lightcurve

; Set parameters for 2014 flight (from foxsi-science directory)
foxsi,2014

dt = 5.	; time interval over which to integrate
lc0 = foxsi_lc( data_lvl2_d0, year=2014, dt=dt)
lc1 = foxsi_lc( data_lvl2_d1, year=2014, dt=dt)
lc2 = foxsi_lc( data_lvl2_d2, year=2014, dt=dt)
lc3 = foxsi_lc( data_lvl2_d3, year=2014, dt=dt)
lc4 = foxsi_lc( data_lvl2_d4, year=2014, dt=dt)
lc5 = foxsi_lc( data_lvl2_d5, year=2014, dt=dt)
lc6 = foxsi_lc( data_lvl2_d6, year=2014, dt=dt)

lc0.time -= 36	; this corrects for the 36-sec offset in WSMR data.
lc1.time -= 36	; source of this offset is still being investigated.
lc2.time -= 36
lc3.time -= 36
lc4.time -= 36
lc5.time -= 36
lc6.time -= 36

; Plot the lightcurves.
loadct,5
hsi_linecolors
utplot,  lc6.time, lc6.persec, /nodata, yr=[0,100], $
	charsi=1.2, charth=2, xth=5, yth=5, ytit='Counts s!U-1!N', title='FOXSI 2014'
outplot, lc0.time, lc0.persec, psym=10, col=6, th=4
outplot, lc1.time, lc1.persec, psym=10, col=7, th=4
;outplot, lc2.time, lc2.persec, psym=10, col=8, th=4
outplot, lc3.time, lc3.persec, psym=10, col=9, th=4
outplot, lc4.time, lc4.persec, psym=10, col=10, th=4
outplot, lc5.time, lc5.persec, psym=10, col=12, th=4
outplot, lc6.time, lc6.persec, psym=10, col=2, th=4
al_legend, ['D0','D1','D3','D4','D5','D6'], /right, /top, box=0, $
	textcol=[6,7,9,10,12,2]
