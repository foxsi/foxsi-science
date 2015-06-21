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
