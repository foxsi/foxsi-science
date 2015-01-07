;
; Make a spectrogram.
;

; Set these parameters.
start = t4_start-60.	; Start time.
finish = t6_end+60.		; End time
dt = 6.					; Time bin width
eBin = 0.5				; Energy bin width

d6 = time_cut( data_lvl2_d6, t4_start, t4_start+10., /good )
spec6 = make_spectrum( d6, binwidth=eBin )

duration = finish - start
nTime = duration/dt
time = anytim('2012-nov-02') + start + findgen(nTime)*dt
gram = fltarr( nTime, n_elements(spec6.energy_kev) )

.run
for i=0, nTime-1 do begin
	d4 = time_cut( data_lvl2_d4, start+i*dt, start+dt+i*dt, /good )
	d5 = time_cut( data_lvl2_d5, start+i*dt, start+dt+i*dt, /good )
	d6 = time_cut( data_lvl2_d6, start+i*dt, start+dt+i*dt, /good )
	spec = make_spectrum( [d4,d5,d6], binwidth=eBin )
	gram[i,*] = spec.spec_p
endfor
end

popen, 'fig/fxi-spectro', xsi=8, ysi=4
spectro_plot, gram, time, spec.energy_kev, yr=[0,15], /cbar, charsi=2.5, xth=5, yth=5, $
	ytit='Energy [keV]', xr='2012-nov-2 '+['18:00:00','18:04:00']
pclose
