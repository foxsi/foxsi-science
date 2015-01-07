restore, 'data_2014/foxsi_level2_data.sav', /v

dt = 5.
lc0 = foxsi_lc( data_lvl2_d0[ where( data_lvl2_d0.hv eq 200 ) ], energy=0., year=2014, dt=dt)
lc1 = foxsi_lc( data_lvl2_d1[ where( data_lvl2_d1.hv eq 200 ) ], energy=0., year=2014, dt=dt)
lc2 = foxsi_lc( data_lvl2_d2[ where( data_lvl2_d2.hv eq 200 ) ], energy=0., year=2014, dt=dt)
lc3 = foxsi_lc( data_lvl2_d3[ where( data_lvl2_d3.hv eq 200 ) ], energy=0., year=2014, dt=dt)
lc4 = foxsi_lc( data_lvl2_d4[ where( data_lvl2_d4.hv eq 200 ) ], energy=0., year=2014, dt=dt)
lc5 = foxsi_lc( data_lvl2_d5[ where( data_lvl2_d5.hv eq 200 ) ], energy=0., year=2014, dt=dt)
lc6 = foxsi_lc( data_lvl2_d6[ where( data_lvl2_d6.hv eq 200 ) ], energy=0., year=2014, dt=dt)

lc0.time -= 36
lc1.time -= 36
lc2.time -= 36
lc3.time -= 36
lc4.time -= 36
lc5.time -= 36
lc6.time -= 36

loadct,5
hsi_linecolors
;popen, 'foxsi2-lightcurves', xsi=7, ysi=5
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
;pclose


dbl = anytim('2014-12-11') + data_lvl2_d6.wsmr_time
str = anytim( dbl ,/yo )

; Definitely seems to be an offset of ~35 sec (late)
; Can we get the time instead from the frame counter counted up from start of
; data file?  (Use the data filename...)  Find the time at which our HV hits 200 and
; use this to bootstrap the time in the WSMR file.

; Our data file is 'data_141211_115911'

.compile cal_data_to_level0
data = formatter_data_to_level0( 'data_2014/data_141211_115911.dat', det=6 )
i=where( data.hv eq 25604)	; this is 200V
IDL> print, data[i[0]].frame_counter
      389987
IDL> print, data[0].frame_counter
         500

; Then time that HV first reaches 200V is (389987-500)*0.002 + anytim( '2014-12-11 11:59:11' )

IDL> time = (389987-500)*0.002 + anytim( '2014-12-11 11:59:11' )
IDL> ptim, time                                                 
11-Dec-2014 12:12:09.974

; This is consistent with a launch exactly at 12:11.
; Now use this to bootstrap the correct time on the WSMR file.
; Frame counter for first HV=200V is 389987.
i = where( data_lvl2_d6.frame_counter eq 389987 )
wsmrt = anytim( '2014-12-11' ) + data_lvl2_d6[i].wsmr_time
IDL> wsmrt = anytim( '2014-12-11' ) + data_lvl2_d6[i].wsmr_time
IDL> print, wsmrt
   1.1343284e+09
IDL> ptim, wsmrt
11-Dec-2014 19:12:45.797

; This should be '12:12:10', so we have a 36 second offset.
