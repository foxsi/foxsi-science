;
; Natalie's code, slight mods by Linz
;

foxsi,2014

; initial sizes and energy definitions
;
e_band = [4.,12.]

; Flare locations (also included in foxsi-setup-script-2014
flare1 = [30,-220]		; gives location of southern AR.
flare2 = [-70,90]			; gives location of northern AR.

rad = 150		; radius around location to include
dt=10					; time bin

; use following lines to include whichever data you want.
;data = data_lvl2_d6			; D6 only
data = [data_lvl2_d0, data_lvl2_d1, data_lvl2_d4, data_lvl2_d5, data_lvl2_d6]		; all Si dets

; cutting out the active regions
; by solar coordinates
;
north_cut = area_cut(data, flare2, rad, /xy)
south_cut = area_cut(data, flare1, rad, /xy)

; plot images for one target just to check that positions are right.
im_north=foxsi_image_map( north_cut, cen1_pos2, /xycor, tra=[t1_pos2_start,t1_pos2_end]) 
im_south=foxsi_image_map( south_cut, cen1_pos2, /xycor, tra=[t1_pos2_start,t1_pos2_end]) 
plot_map, im_north, /log
plot_map, im_south, /log
; the smoothed version, in case you want it.
im_north.data = smooth( im_north.data, 3 )
im_south.data = smooth( im_south.data, 3 )
plot_map, im_south
plot_map, im_south, /over
plot_map, im_north, /over


; light curve over the entire detector
lc = foxsi_lc(data, year=2014, dt=dt, energy=e_band)
lc_err = sqrt(lc.persec/dt)

; northern active region lightcurve
north_lc = foxsi_lc(north_cut, year=2014, dt=dt, energy=e_band, start_time=t1_pos0_start, end_time=t5_end)
north_err = sqrt(north_lc.persec/dt)

; southern active region lightcurve
south_lc = foxsi_lc(south_cut, year=2014, dt=dt, energy=e_band, start_time=t1_pos0_start, end_time=t5_end)
south_err = sqrt(south_lc.persec/dt)


;popen, xsi=8, ysi=4
hsi_linecolors
utplot, south_lc.time, south_lc.persec, /nodata, charsi=1.4, charth=2, xth=5, yth=5, $
	title= 'FOXSI 4-12 keV, Det 6', ytit='Counts s!U-1!N'
outplot, north_lc.time, north_lc.persec, color=2, th=2, psym=10
outplot, south_lc.time, south_lc.persec, color=3, th=2, psym=10
eutplot, north_lc.time, north_lc.persec, yerr=north_err, color=2, errcol=2, th=2, psym=10
eutplot, south_lc.time, south_lc.persec, yerr=south_err, color=3, errcol=3, th=2, psym=10
draw_target_change_times, thick=4
al_legend, ['AR south', 'AR north'], textcol=[3,2], thick=6, charsi=1.3, charth=2, /left, back=1
al_legend, ['Target start','Target end','Shutter motion'], col=[6,7,4], thick=6, line=0, $
	charsi=1.3, charth=2, /right, back=1
;pclose	


restore, 'fxi-5det-total-lc.sav'
;popen, xsi=8, ysi=4
hsi_linecolors
utplot, lc.time, lc.persec, /nodata, charsi=1.4, charth=2, xth=5, yth=5, $
	title= 'FOXSI 4-12 keV', ytit='Counts s!U-1!N'
outplot, lc.time, lc.persec, color=2, th=2, psym=10
eutplot, lc.time, lc.persec, yerr=lc_err, color=2, errcol=2, th=2, psym=10
draw_target_change_times, thick=4
al_legend, ['Target start','Target end','Shutter motion'], col=[6,7,4], thick=6, line=0, $
	charsi=1.3, charth=2, /right, back=1
;pclose	

