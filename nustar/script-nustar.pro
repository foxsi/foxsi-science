; NuSTAR image example for 2014-dec-11 observation.


; Produce an image for any given time.
; To use this, you need NuSTAR data and routines; ask Linz if you don't have them.

date = '2014-dec-11'
time = '19:11:00'	; choose a starting time.
;dur = 600.			; choose an integration time (in seconds)
dur = 25.*60.
evt_file = 'solar_mosaic_obs3.evt'
nu_map = nustar_solar_image( date, time, dur, evt_file, /smooth )
plot_map, nu_map, /limb, cen=[1100,-400], fov=10


; Make a movie of NuSTAR data

date = '2014-dec-11'
dur=300.
undefine, movie
.r
for i=40, 69, 5 do begin
	if i lt 60 then time = '18:'+strtrim(i,2)+':00' $
		else time = '19:0'+strtrim(i-60,2)+':00'
	evt_file = 'solar_mosaic_obs3.evt'
	nu_map = nustar_solar_image( date, time, dur, evt_file, /smooth )
	push, movie, nu_map
endfor
end

;
; FOXSI and NuSTAR together
;

m0=foxsi_image_map( data_lvl2_d0, cen4, thr_n=4, /xycor, tra=[t4_start,t_shtr_start] )
m1=foxsi_image_map( data_lvl2_d1, cen4, thr_n=4, /xycor, tra=[t4_start,t_shtr_start] )
m4=foxsi_image_map( data_lvl2_d4, cen4, thr_n=4, /xycor, tra=[t4_start,t_shtr_start] )
m5=foxsi_image_map( data_lvl2_d5, cen4, thr_n=4, /xycor, tra=[t4_start,t_shtr_start] )
m6=foxsi_image_map( data_lvl2_d6, cen4, thr_n=4, /xycor, tra=[t4_start,t_shtr_start] )

m = m6
m.data = m0.data+m1.data+m4.data+m5.data+m6.data

restore,'nustar/nustar-obs3-npA.sav',/v

fxi_title = 'FOXSI Si det 11-Dec-2014 19:17:13-19:19:19'
nu_title  = 'NuSTAR FPMA 11-Dec-2014 19:11-19:36'

cen = [250,950]
fov=10
ch=0.8

popen, xsi=8, ysi=6, /land
!p.multi=[0,2,1]
loadct, 7
reverse_ct
plot_map, m, /limb, xth=5, yth=5, charsi=ch, charth=2, lth=3, lcol=255, col=255, tit=fxi_title, cen=[250,800], fov=16
loadct, 1
reverse_ct
plot_map, nust, /limb, xth=5, yth=5, charsi=ch, charth=2, lth=3, lcol=255, col=255, tit=nu_title, cen=cen, fov=9
pclose

