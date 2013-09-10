
;
; Redoing time profile
;

add_path,'img'
restore, 'data_2012/foxsi_level2_data.sav', /v

e1=5.
e2=10.

i0 = where( data_lvl2_d0.error_flag eq 0 and data_lvl2_d0.hit_energy[1] gt e1 and data_lvl2_d0.hit_energy[1] lt e2 )
i1 = where( data_lvl2_d1.error_flag eq 0 and data_lvl2_d1.hit_energy[1] gt e1 and data_lvl2_d1.hit_energy[1] lt e2 )
i2 = where( data_lvl2_d2.error_flag eq 0 and data_lvl2_d2.hit_energy[1] gt e1 and data_lvl2_d2.hit_energy[1] lt e2 )
i3 = where( data_lvl2_d3.error_flag eq 0 and data_lvl2_d3.hit_energy[1] gt e1 and data_lvl2_d3.hit_energy[1] lt e2 )
i4 = where( data_lvl2_d4.error_flag eq 0 and data_lvl2_d4.hit_energy[1] gt e1 and data_lvl2_d4.hit_energy[1] lt e2 )
i5 = where( data_lvl2_d5.error_flag eq 0 and data_lvl2_d5.hit_energy[1] gt e1 and data_lvl2_d5.hit_energy[1] lt e2 )
i6 = where( data_lvl2_d6.error_flag eq 0 and data_lvl2_d6.hit_energy[1] gt e1 and data_lvl2_d6.hit_energy[1] lt e2 )
j0 = where( data_lvl2_d0.inflight eq 1 and data_lvl2_d0.hit_energy[1] gt e1 and data_lvl2_d0.hit_energy[1] lt e2 )
j1 = where( data_lvl2_d1.inflight eq 1 and data_lvl2_d1.hit_energy[1] gt e1 and data_lvl2_d1.hit_energy[1] lt e2 )
j2 = where( data_lvl2_d2.inflight eq 1 and data_lvl2_d2.hit_energy[1] gt e1 and data_lvl2_d2.hit_energy[1] lt e2 )
j3 = where( data_lvl2_d3.inflight eq 1 and data_lvl2_d3.hit_energy[1] gt e1 and data_lvl2_d3.hit_energy[1] lt e2 )
j4 = where( data_lvl2_d4.inflight eq 1 and data_lvl2_d4.hit_energy[1] gt e1 and data_lvl2_d4.hit_energy[1] lt e2 )
j5 = where( data_lvl2_d5.inflight eq 1 and data_lvl2_d5.hit_energy[1] gt e1 and data_lvl2_d5.hit_energy[1] lt e2 )
j6 = where( data_lvl2_d6.inflight eq 1 and data_lvl2_d6.hit_energy[1] gt e1 and data_lvl2_d6.hit_energy[1] lt e2 )

t_launch = 64500
t1_start = t_launch + 108.3		; Target 1 (AR)
t1_end = t_launch + 151.8
t2_start = t_launch + 154.8		; Target 2 (AR)
t2_end = t_launch + 244.7
t3_start = t_launch + 247		; Target 3 (quiet Sun)
t3_end = t_launch + 337.3
t4_start = t_launch + 340		; Target 4 (flare)
t4_end = t_launch + 421.2
t5_start = t_launch + 423.5		; Target 5 (off-pointing)
t5_end = t_launch + 435.9
t6_start = t_launch + 438.5		; Target 6 (flare)
t6_end = t_launch + 498.3
t1 = t1_start
t2 = t6_end

tbin = 3.
nbins = (t2-t1)/tbin

lc0 = histogram( data_lvl2_d0[i0].wsmr_time, min=t1, max=t2, nbins=nbins )
lc1 = histogram( data_lvl2_d1[i1].wsmr_time, min=t1, max=t2, nbins=nbins )
lc2 = histogram( data_lvl2_d2[i2].wsmr_time, min=t1, max=t2, nbins=nbins )
lc3 = histogram( data_lvl2_d3[i3].wsmr_time, min=t1, max=t2, nbins=nbins )
lc4 = histogram( data_lvl2_d4[i4].wsmr_time, min=t1, max=t2, nbins=nbins )
lc5 = histogram( data_lvl2_d5[i5].wsmr_time, min=t1, max=t2, nbins=nbins )
lc6 = histogram( data_lvl2_d6[i6].wsmr_time, min=t1, max=t2, nbins=nbins )
lctot = lc0+lc1+lc2+lc3+lc4+lc5+lc6

lc0a = histogram( data_lvl2_d0[j0].wsmr_time, min=t1, max=t2, nbins=nbins )
lc1a = histogram( data_lvl2_d1[j1].wsmr_time, min=t1, max=t2, nbins=nbins )
lc2a = histogram( data_lvl2_d2[j2].wsmr_time, min=t1, max=t2, nbins=nbins )
lc3a = histogram( data_lvl2_d3[j3].wsmr_time, min=t1, max=t2, nbins=nbins )
lc4a = histogram( data_lvl2_d4[j4].wsmr_time, min=t1, max=t2, nbins=nbins )
lc5a = histogram( data_lvl2_d5[j5].wsmr_time, min=t1, max=t2, nbins=nbins )
lc6a = histogram( data_lvl2_d6[j6].wsmr_time, min=t1, max=t2, nbins=nbins )

lc0err = sqrt(lc0)/tbin
lc1err = sqrt(lc0)/tbin
lc2err = sqrt(lc0)/tbin
lc3err = sqrt(lc0)/tbin
lc4err = sqrt(lc0)/tbin
lc5err = sqrt(lc0)/tbin
lc6err = sqrt(lc0)/tbin
lctoterr = sqrt(lctot)/tbin
lc0aerr = sqrt(lc0a)/tbin
lc1aerr = sqrt(lc0a)/tbin
lc2aerr = sqrt(lc0a)/tbin
lc3aerr = sqrt(lc0a)/tbin
lc4aerr = sqrt(lc0a)/tbin
lc5aerr = sqrt(lc0a)/tbin
lc6aerr = sqrt(lc0a)/tbin

lc0 = lc0/tbin
lc1 = lc1/tbin
lc2 = lc2/tbin
lc3 = lc3/tbin
lc4 = lc4/tbin
lc5 = lc5/tbin
lc6 = lc6/tbin
lctot = lctot/tbin
lc0a = lc0a/tbin
lc1a = lc1a/tbin
lc2a = lc2a/tbin
lc3a = lc3a/tbin
lc4a = lc4a/tbin
lc5a = lc5a/tbin
lc6a = lc6a/tbin

loadct,0
hsi_linecolors
th=3
ymin=0.1
ymax=1.e2
times = (findgen(nbins)+1)*tbin

window, 0
plot, times, lc0, psym=10, yr=[ymin,ymax], /ylog
oplot, times, lc0, psym=10, color=6, thick=th
oplot, times, lc1, psym=10, color=7, thick=th
oplot, times, lc2, psym=10, color=8, thick=th
oplot, times, lc3, psym=10, color=9, thick=th
oplot, times, lc4, psym=10, color=10, thick=th
oplot, times, lc5, psym=10, color=12, thick=th
oplot, times, lc6, psym=10, color=2, thick=th
oplot, [t1_start-t1_start,t1_start-t1_start], [ymin,ymax], thick=5
oplot, [t2_start-t1_start,t2_start-t1_start], [ymin,ymax], thick=5
oplot, [t3_start-t1_start,t3_start-t1_start], [ymin,ymax], thick=5
oplot, [t4_start-t1_start,t4_start-t1_start], [ymin,ymax], thick=5
oplot, [t5_start-t1_start,t5_start-t1_start], [ymin,ymax], thick=5
oplot, [t6_start-t1_start,t6_start-t1_start], [ymin,ymax], thick=5

window, 0
ymin=0.1
ymax=1.e3
plot, times, lctot, psym=10, yr=[ymin,ymax], /ylog, thick=3, charsi=1.2, $
;plot, times, lctot, psym=10, yr=[0,20], thick=3, charsi=1.2, $
;plot, times, lctot, psym=10, yr=[50,150], thick=3, charsi=1.2, $
	xtit='time since Target 1 acquired [s]', ytit='cts/sec', tit='Lightcurve, all detectors summmed, 5-10keV'
oplot, [t1_start-t1_start,t1_start-t1_start], [ymin,ymax], thick=5
oplot, [t2_start-t1_start,t2_start-t1_start], [ymin,ymax], thick=5
oplot, [t3_start-t1_start,t3_start-t1_start], [ymin,ymax], thick=5
oplot, [t4_start-t1_start,t4_start-t1_start], [ymin,ymax], thick=5
oplot, [t5_start-t1_start,t5_start-t1_start], [ymin,ymax], thick=5
oplot, [t6_start-t1_start,t6_start-t1_start], [ymin,ymax], thick=5

window, 0
plot, times, lc0, psym=10, yr=[ymin,ymax], /ylog, charsize=1.2
oplot_err, times, lc0, yerr=lc0err, psym=10, color=6, thick=th
oplot_err, times, lc1, yerr=lc1err, psym=10, color=7, thick=th
oplot_err, times, lc2, yerr=lc2err, psym=10, color=8, thick=th
oplot_err, times, lc3, yerr=lc3err, psym=10, color=9, thick=th
oplot_err, times, lc4, yerr=lc4err, psym=10, color=10, thick=th
oplot_err, times, lc5, yerr=lc5err, psym=10, color=12, thick=th
oplot_err, times, lc6, yerr=lc6err, psym=10, color=2, thick=th
oplot, [t1_start-t1_start,t1_start-t1_start], [ymin,ymax], thick=5
oplot, [t2_start-t1_start,t2_start-t1_start], [ymin,ymax], thick=5
oplot, [t3_start-t1_start,t3_start-t1_start], [ymin,ymax], thick=5
oplot, [t4_start-t1_start,t4_start-t1_start], [ymin,ymax], thick=5
oplot, [t5_start-t1_start,t5_start-t1_start], [ymin,ymax], thick=5
oplot, [t6_start-t1_start,t6_start-t1_start], [ymin,ymax], thick=5
legend, ['D0','D1','D2','D3','D4','D5','D6'], textcolor=[6,7,8,9,10,12,2], charsize=1.5

window, 1
plot, lc0a, psym=10, yr=[0.1, 1.e2], /ylog
oplot, lc0a, psym=10, color=6, thick=th
oplot, lc1a, psym=10, color=7, thick=th
oplot, lc2a, psym=10, color=8, thick=th
oplot, lc3a, psym=10, color=9, thick=th
oplot, lc4a, psym=10, color=10, thick=th
oplot, lc5a, psym=10, color=12, thick=th
oplot, lc6a, psym=10, color=2, thick=th

; Result: "error free" and "all inflight" data curves look the same except for scaling, 
; so from here on out only look at error-free data.
