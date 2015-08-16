;
; Make a spectrogram.
;

; Set these parameters.
start = t4_start-60.	; Start time.
finish = t6_end+60.		; End time
dt = 2.					; Time bin width.  dt=6. works well.
eBin = 0.5				; Energy bin width

; test
d6 = time_cut( data_lvl2_d6, t4_start, t4_start+30., /good )
spec6 = make_spectrum( d6, binwidth=0.5, /log )

duration = finish - start
nTime = duration/dt
time = anytim('2012-nov-02') + start + findgen(nTime)*dt
gram = fltarr( nTime, n_elements(spec6.spec_p) )

.run
for i=0, nTime-1 do begin
	d0 = time_cut( data_lvl2_d0, start+i*dt, start+dt+i*dt, /good )
	;d1 = time_cut( data_lvl2_d1, start+i*dt, start+dt+i*dt, /good )
	d2 = time_cut( data_lvl2_d2, start+i*dt, start+dt+i*dt, /good )
	d4 = time_cut( data_lvl2_d4, start+i*dt, start+dt+i*dt, /good )
	d5 = time_cut( data_lvl2_d5, start+i*dt, start+dt+i*dt, /good )
	d6 = time_cut( data_lvl2_d6, start+i*dt, start+dt+i*dt, /good )
	spec = make_spectrum( [d0,d2,d4,d5,d6], binwidth=0.5, /correct, /log )
	gram[i,*] = spec.spec_p
endfor
end

; switch to counts instead of cts/keV.
;gram = gram*ebin

popen, 'linz/fig/fxi-spectrogram', xsi=8, ysi=4
loadct, 13
spectro_plot, gram, time, spec.energy_kev, yr=[3,12], /ysty, charsi=1.5, xth=5, yth=5, $
	ytit='Energy [keV]', xr='2012-nov-2 '+['18:00','18:04'], /xsty
pclose
