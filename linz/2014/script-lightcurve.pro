@foxsi-setup-script-2014

dt = 5.
lc0 = foxsi_lc( data_lvl2_d0, year=2014, dt=dt)
lc1 = foxsi_lc( data_lvl2_d1, year=2014, dt=dt)
lc2 = foxsi_lc( data_lvl2_d2, year=2014, dt=dt)
lc3 = foxsi_lc( data_lvl2_d3, year=2014, dt=dt)
lc4 = foxsi_lc( data_lvl2_d4, year=2014, dt=dt)
lc5 = foxsi_lc( data_lvl2_d5, year=2014, dt=dt)
lc6 = foxsi_lc( data_lvl2_d6, year=2014, dt=dt)

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

;
; Lightcurves at different energies
;

@foxsi-setup-script-2014

lca=foxsi_lc(data_lvl2_d6,dt=4,energy=[4,7], /good)
lcb=foxsi_lc(data_lvl2_d6,dt=4,energy=[7,15], /good)
lcc=foxsi_lc(data_lvl2_d6,dt=4);, /good)

maxN = min([n_elements(lca),n_elements(lcb),n_elements(lcc)])
lcadd = lcc
lcadd[0:maxn-1].persec = lca[0:maxn-1].persec + lcb[0:maxn-1].persec

hsi_linecolors
utplot, anytim(lcc.time,/yo), lcc.persec, timer='2014-12-11 19:'+['12','20'], psym=10, /nodata
;outplot, anytim(lca.time,/yo), lca.persec, col=2, thick=4, psym=10
;outplot, anytim(lcb.time,/yo), lcb.persec, col=3, thick=4, psym=10
outplot, anytim(lcc.time,/yo), lcc.persec, col=6, thick=4, psym=10
outplot, anytim(lcadd.time,/yo), lcadd.persec, col=7, thick=4, psym=10


;
; Make a spectrogram.
;

; Set these parameters.
start = t1_pos0_start+tlaunch	; Start time.
finish = t5_end+tlaunch		; End time
dt = 5.					; Time bin width
eBin = 0.4				; Energy bin width

d6 = time_cut( data_lvl2_d6, start, start+10. )
spec6 = make_spectrum( d6, binwidth=eBin )

duration = finish - start
nTime = duration/dt
time = anytim('2014-dec-11') + start + findgen(nTime)*dt
gram = fltarr( nTime, n_elements(spec6.energy_kev) )

.run
for i=0, nTime-1 do begin
	d0 = time_cut( data_lvl2_d0, start+i*dt, start+dt+i*dt, /good )
	d4 = time_cut( data_lvl2_d4, start+i*dt, start+dt+i*dt, /good )
	d5 = time_cut( data_lvl2_d5, start+i*dt, start+dt+i*dt, /good )
	d6 = time_cut( data_lvl2_d6, start+i*dt, start+dt+i*dt, /good )
	spec = make_spectrum( [d0,d4,d5,d6], binwidth=eBin )
;	spec = make_spectrum( [d6], binwidth=eBin )
	gram[i,*] = spec.spec_p*eBin
endfor
end

popen, 'plots/foxsi2/spectrogram', xsi=8, ysi=4, /land
loadct,5
spectro_plot, gram, time, spec.energy_kev, yr=[0,15], /cbar, charsi=1.5, xth=5, yth=5, $
	title='D0,4,5,6'
;	ytit='Energy [keV]', xr='2014-dec-11 '+['19:13:00','19:20:00']
;	ytit='Energy [keV]', xr='2014-dec-11 '+['19:13:00','19:17:00']
; add time bars.
outplot, anytim(t1_pos0_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t1_pos0_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t1_pos1_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t1_pos1_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t1_pos2_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t1_pos2_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t2_pos0_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t2_pos0_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t2_pos1_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t2_pos1_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t3_pos0_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t3_pos0_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t3_pos1_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t3_pos1_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t3_pos2_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t3_pos2_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t4_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t4_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t_shtr_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t_shtr_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t5_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
outplot, anytim(t5_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),[0,15]
pclose


;
; Natalie's code
;

; initial sizes and energy definitions
;
all_e = [4.,15.]
low_e = [4.,7.]
high_e = [7.,15.]

sm_reg = [-125,50]
sm_rad = 75
lg_reg = [0,-300]
lg_rad = 200

dt=5

; cutting out the active regions
; by solar coordinates
;
sm_cut = area_cut(data_lvl2_d6, sm_reg, sm_rad, /xy)
lg_cut = area_cut(data_lvl2_d6, lg_reg, lg_rad, /xy)


; light curve over the entire detector
; 
all_d6 = foxsi_lc(data_lvl2_d6, year=2014, dt=dt, energy=all_e)
d6_lo = foxsi_lc(data_lvl2_d6, year=2014, dt=dt, energy=low_e)
d6_hi = foxsi_lc(data_lvl2_d6, year=2014, dt=dt, energy=high_e)

; small active region photon counts
; by energy range
;
sm_all = foxsi_lc(sm_cut, year=2014, dt=dt, energy=all_e, start_time=t1_pos0_start, end_time=t5_end)
sm_lo = foxsi_lc(sm_cut, year=2014, dt=dt, energy=low_e, start_time=t1_pos0_start, end_time=t5_end)
sm_hi = foxsi_lc(sm_cut, year=2014, dt=dt, energy=high_e, start_time=t1_pos0_start, end_time=t5_end)

; large active region photon counts
; by energy range
;
lg_all = foxsi_lc(lg_cut, year=2014, dt=dt, energy=all_e, /good, start_time=t1_pos0_start, end_time=t5_end)
lg_lo = foxsi_lc(lg_cut, year=2014, dt=dt, energy=low_e, /good, start_time=t1_pos0_start, end_time=t5_end)
lg_hi = foxsi_lc(lg_cut, year=2014, dt=dt, energy=high_e, /good, start_time=t1_pos0_start, end_time=t5_end)

; adding together the low and high energies
; should be the same as total (sm_all, lg_all)
;
sm_add = sm_lo.persec + sm_hi.persec
lg_add = lg_lo.persec + lg_hi.persec
d6_add = d6_lo.persec + d6_hi.persec

; example of plotting one of the regions
; 
loadct, 15
utplot, sm_all.time, sm_all.persec, /nodata, color=255, charsi=1.2, $
title= 'Photon flux differences based on different energy ranges'

outplot, sm_all.time, sm_all.persec, color=15, th=2.5, psym=10	; red

outplot, sm_all.time, sm_add, color=120, th=2.5, psym=10	; blue


; example of plotting one of the regions
; 
loadct, 15
utplot, lg_all.time, lg_all.persec, /nodata, color=255, charsi=1.2, $
title= 'Photon flux differences based on different energy ranges'

outplot, lg_all.time, lg_all.persec, color=15, th=2.5, psym=10	; red

outplot, lg_all.time, lg_add, color=120, th=2.5, psym=10	; blue

;
; Based on this, try to look at lightcurve from all Si det, large AR
;

en1 = [4.,6]
en2 = [6,8.]
en3 = [4.,15.]
lg_reg = [0,-300]
lg_rad = 200

dt=2.

dat = [data_lvl2_d0, data_lvl2_d1, data_lvl2_d4, data_lvl2_d5, data_lvl2_d6]

lg_cut = area_cut(dat, lg_reg, lg_rad, /xy)
lg_cut = dat
;lc1 = foxsi_lc(lg_cut, year=2014, dt=dt, energy=all_e, /good, start_time=t1_pos0_start, end_time=t5_end)
lc1 = foxsi_lc(lg_cut, year=2014, dt=dt, energy=en1, /good, start_time=t1_pos0_start, end_time=t5_end)
lc2 = foxsi_lc(lg_cut, year=2014, dt=dt, energy=en2, /good, start_time=t1_pos0_start, end_time=t5_end)
lc3 = foxsi_lc(lg_cut, year=2014, dt=dt, energy=en3, /good, start_time=t1_pos0_start, end_time=t5_end)

popen, xsi=8, ysi=4
hsi_linecolors
utplot, lc3.time, lc3.persec, /nodata, charsi=1.4, charth=2, xth=5, yth=5, $
	title= 'FOXSI 4-15 keV, all Si', ytit='Counts s!U-1!N'
;outplot, lc1.time, lc1.persec, color=6, th=2, psym=10
;outplot, lc2.time, lc2.persec, color=7, th=2, psym=10
outplot, lc3.time, lc3.persec, th=6, psym=10
draw_target_change_times, thick=4
al_legend, ['Target start','Target end','Shutter motion'], col=[6,7,4], thick=6, line=0, $
	charsi=1.3, charth=2, /top, /right, back=1
pclose	


;
; July 21 2015
;
; Making lightcurves with different assumptions for where the on-axis position is.
; Using AR 12230 as example.
; 


en = [4.,12]

; First, get some rough ideas of the coordinates for the ARs.
map_t1pos0 = foxsi_image_map( data_lvl2_d6, cen1_pos0, erange=en, tra=[t1_pos0_start, t1_pos0_end] )
map_t1pos1 = foxsi_image_map( data_lvl2_d6, cen1_pos1, erange=en, tra=[t1_pos1_start, t1_pos1_end] )
map_t1pos2 = foxsi_image_map( data_lvl2_d6, cen1_pos2, erange=en, tra=[t1_pos2_start, t1_pos2_end] )
map_t2pos0 = foxsi_image_map( data_lvl2_d6, cen2_pos0, erange=en, tra=[t2_pos0_start, t2_pos0_end] )
map_t2pos1 = foxsi_image_map( data_lvl2_d6, cen2_pos1, erange=en, tra=[t2_pos1_start, t2_pos1_end] )

print, map_centroid( map_t1pos0, thr=0.5*max(map_t1pos0.data) ) - cen1_pos0
print, map_centroid( map_t1pos1, thr=0.5*max(map_t1pos1.data) ) - cen1_pos1
print, map_centroid( map_t1pos2, thr=0.5*max(map_t1pos2.data) ) - cen1_pos2
print, map_centroid( map_t2pos0, thr=0.5*max(map_t2pos0.data) ) - cen2_pos0
print, map_centroid( map_t2pos1, thr=0.5*max(map_t2pos1.data) ) - cen2_pos1

; Here, select the version you want.
; Either on-axis position is the FOXSI center.
; Or on-axis position is the reverse of the FOXSI-SPARCS misalignment.
;off_t1pos0 = map_centroid( map_t1pos0, thr=0.5*max(map_t1pos0.data) ) - cen1_pos0
;off_t1pos1 = map_centroid( map_t1pos1, thr=0.5*max(map_t1pos1.data) ) - cen1_pos1
;off_t1pos2 = map_centroid( map_t1pos2, thr=0.5*max(map_t1pos2.data) ) - cen1_pos2
;off_t2pos0 = map_centroid( map_t2pos0, thr=0.5*max(map_t2pos0.data) ) - cen2_pos0
;off_t2pos1 = map_centroid( map_t2pos1, thr=0.5*max(map_t2pos1.data) ) - cen2_pos1
off_t1pos0 = (map_centroid( map_t1pos0, thr=0.5*max(map_t1pos0.data) )-cen1_pos0) - [-332,147]
off_t1pos1 = (map_centroid( map_t1pos1, thr=0.5*max(map_t1pos1.data) )-cen1_pos1) - [-332,147]
off_t1pos2 = (map_centroid( map_t1pos2, thr=0.5*max(map_t1pos2.data) )-cen1_pos2) - [-332,147]
off_t2pos0 = (map_centroid( map_t2pos0, thr=0.5*max(map_t2pos0.data) )-cen2_pos0) - [-332,147]
off_t2pos1 = (map_centroid( map_t2pos1, thr=0.5*max(map_t2pos1.data) )-cen2_pos1) - [-332,147]

off_t1pos0 = sqrt(off_t1pos0[0]^2 + off_t1pos0[1]^2 ) / 60.
off_t1pos1 = sqrt(off_t1pos1[0]^2 + off_t1pos1[1]^2 ) / 60.
off_t1pos2 = sqrt(off_t1pos2[0]^2 + off_t1pos2[1]^2 ) / 60.
off_t2pos0 = sqrt(off_t2pos0[0]^2 + off_t2pos0[1]^2 ) / 60.
off_t2pos1 = sqrt(off_t2pos1[0]^2 + off_t2pos1[1]^2 ) / 60.

; Get vignetting at ~5.9 keV for that off-axis angle.
vig_t1pos0 = (get_foxsi_offaxis_resp( off=off_t1pos0 )).factor[50]
vig_t1pos1 = (get_foxsi_offaxis_resp( off=off_t1pos1 )).factor[50]
vig_t1pos2 = (get_foxsi_offaxis_resp( off=off_t1pos2 )).factor[50]
vig_t2pos0 = (get_foxsi_offaxis_resp( off=off_t2pos0 )).factor[50]
vig_t2pos1 = (get_foxsi_offaxis_resp( off=off_t2pos1 )).factor[50]

print, off_t1pos0, vig_t1pos0
print, off_t1pos1, vig_t1pos1
print, off_t1pos2, vig_t1pos2
print, off_t2pos0, vig_t2pos0
print, off_t2pos1, vig_t2pos1

lg_reg = [0,-300]
lg_rad = 200
dt=5.

dat = [data_lvl2_d0, data_lvl2_d1, data_lvl2_d4, data_lvl2_d5, data_lvl2_d6]
dat = [data_lvl2_d6]
lg_cut = area_cut(dat, lg_reg, lg_rad, /xy)

lc_t1pos0 = foxsi_lc(lg_cut, year=2014, dt=dt, energy=en, /good, start_time=t1_pos0_start, end_time=t1_pos0_end)
lc_t1pos1 = foxsi_lc(lg_cut, year=2014, dt=dt, energy=en, /good, start_time=t1_pos1_start, end_time=t1_pos1_end)
lc_t1pos2 = foxsi_lc(lg_cut, year=2014, dt=dt, energy=en, /good, start_time=t1_pos2_start, end_time=t1_pos2_end)
lc_t2pos0 = foxsi_lc(lg_cut, year=2014, dt=dt, energy=en, /good, start_time=t2_pos0_start, end_time=t2_pos0_end)
lc_t2pos1 = foxsi_lc(lg_cut, year=2014, dt=dt, energy=en, /good, start_time=t2_pos1_start, end_time=t2_pos1_end)

lc_t1pos0.persec /= vig_t1pos0
lc_t1pos1.persec /= vig_t1pos1
lc_t1pos2.persec /= vig_t1pos2
lc_t2pos0.persec /= vig_t2pos0
lc_t2pos1.persec /= vig_t2pos1

lc = [lc_t1pos0,lc_t1pos1,lc_t1pos2,lc_t2pos0,lc_t2pos1]

;popen, xsi=8, ysi=4
hsi_linecolors
utplot, lc.time, lc.persec, /nodata, charsi=1.4, charth=2, xth=5, yth=5, $
	title= 'FOXSI 4-12 keV, Det6, assume on-axis is AR in first target', ytit='Counts s!U-1!N'
;outplot, lc1.time, lc1.persec, color=6, th=2, psym=10
;outplot, lc2.time, lc2.persec, color=7, th=2, psym=10
outplot, lc.time, lc.persec, th=6, psym=10
outplot, lc.time, lc.persec, th=6, psym=10
draw_target_change_times, thick=4
;al_legend, ['Target start','Target end','Shutter motion'], col=[6,7,4], thick=6, line=0, $
;	charsi=1.3, charth=2, /top, /right, back=1
;pclose	

