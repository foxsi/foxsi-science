; FOXSI software paths for simulated count spec and instrument response
add_path,'spec'
add_path,'resp'

restore, 'linz/dem-template.sav'

; Choose one of the cases.  [1]->HF heating, [2]->LF heating
choice = 2

data1 = read_ascii( 'linz/dem_hf.dem', temp=template )
i1 = where( finite( data1.logte ) and data1.logte gt 0 )
data1 = create_struct( ['logTe','EM'], data1.logte[i1], data1.em[i1] )
data2 = read_ascii( 'linz/dem_lf.dem', temp=template )
i2 = where( finite( data2.logte ) and data2.logte gt 0 )
data2 = create_struct( ['logTe','EM'], data2.logte[i2], data2.em[i2] )

; if desired, restrict to non-noisy values:
data1 = create_struct( ['logTe','EM'], data1.logte[5:39], data1.em[5:39] )
data2 = create_struct( ['logTe','EM'], data2.logte[5:47], data2.em[5:47] )

if choice eq 1 then data=data1 else data=data2

; if desired, restrict to temperatures above 1 MK.
n=n_elements(data.logte)
data = create_struct( ['logTe','EM'], data.logte[15:n-1], data.em[15:n-1] )

area = (10.*0.725d8)^2	;  1 10-arcsec pixel
		
; Calculate EM in cm^-3 for each bin.
T = 10.^data.logte
dT = get_edges(T, /width)
dt = [dt, dt[n_elements(dt)-1]]
em = 10.^(data.em)*dt*area

; energy arrays for simulated thermal fluxes
en1 = findgen(500)/20 + 1.
en2 = get_edges(en1, /edges_2)
en  = get_edges(en1, /mean)
n = n_elements(t)

; calculate thermal X-ray fluxes for each temperature/EM pair.
flux = dblarr( n_elements(en), n )
for i=0, n-1 do flux[*,i] = f_vth( en2, [em[i]/1.d49, t[i]/11.8/1.d6, 1.] )

; The next routine calculates the expected FOXSI count spectrum for given thermal params.
; This includes contributions from the optics, detectors, and nominal blanketing.
; The extra blanketing isn't included.
; Off-axis angle is assumed 0.

; Sample sim to set up arrays.
simA = foxsi_count_spectrum(em[10]/1.d49, t[10]/1.d6, time=1. )
; Now do it for all temperature bins.
sim = dblarr( n_elements(simA.energy_keV), n_elements(t) )
for i=0, n-1 do begin &$
	sim2 = foxsi_count_spectrum(em[i]/1.d49, t[i]/1.d6, time=1. ) &$
	sim[*,i] = sim2.counts &$
endfor

; FOXSI_COUNT_SPECTRUM produces counts / keV, but we have run the simulation with a time value of
; 1 sec, so it's actually counts / sec / keV.


; display plots and results

popen, file, xsi=8, ysi=5

loadct, 0
plot, data1.logte, data1.em, psym=10, thick=4, yr=[17,23], charsi=1.2, $
	xr=[5.,7.5], xtit='Log T', ytit='dEM [cm!U-5]', tit='dEMs from Amy'
oplot, data2.logte, data2.em, psym=10, thick=4, color=150
legend, ['High freq','Low freq'], color=[0,150], line=0, thick=4, /left, charsi=1.1, box=0

!p.multi=[0,2,1]
loadct, 5
colors = 32+findgen(n)*8

TVLCT, r, g, b, /Get
r2=reverse(r)
r2[0]=0
g2=reverse(g)
g2[0]=0
b2=reverse(b)
b2[0]=0
TVLCT, r2,g2,b2

if choice eq 2 then title_suffix = 'Low-freq' else title_suffix='High-freq'
   
plot, en, flux[*,15], psym=10, /xlo, /ylo, xr=[4.,20.], yr=[1.e-4, 1.e2], /xsty, /ysty, $
	xtit='Energy [keV]', ytit='Phot s!U-1!N cm!U-2!N keV!U-1!N', charsi=1.1, $
	tit='Photon flux, '+title_suffix, xticks=7, xtickv=[findgen(7)+4,20]
for i=0, n_elements(t)-1 do $
	oplot, en, flux[*,i], psym=10, thick=3, col=colors[i]
legend, strtrim( data.logte[0:9] ,2), textcolor=colors[0:9], box=0, thick=th, $
	/right, charth=2, charsi=0.75, pos=[0.33,0.92], /norm
legend, strtrim( data.logte[10:19] ,2), textcolor=colors[10:19], box=0, thick=th, $
	/right, charth=2, charsi=0.75, pos=[0.40,0.92], /norm
if choice eq 2 then $
	legend, strtrim( data.logte[20:27] ,2), textcolor=colors[20:27], box=0, thick=th, $
	/right, charth=2, charsi=0.75, pos=[0.47,0.92], /norm

cts_tot =  long( total( sim[where(finite(sim))] ) )

plot, simA.energy_kev, sim[*,15], psym=10, /xlo, /ylo, xr=[2.,20], /xsty, $
	yr=[1.e-3, 1.e4], /ysty, xtit='Energy [keV]', ytit='Counts s!U-1!N keV!U-1!N', $
	tit='Sim FOXSI counts, '+title_suffix, xticks=9, xtickv=[findgen(9)+2,20]
for i=0, n-1 do oplot, simA.energy_kev, sim[*,i], psym=10, thick=3, col=colors[i]
oplot, simA.energy_kev, total(sim, 2), psym=10, thick=8, line=1
legend, strtrim( data.logte[0:19] ,2), textcolor=colors[0:19], box=0, thick=th, $
	/right, charth=2, charsi=0.75, pos=[0.7,0.94], /norm
if choice eq 2 then $
	legend, strtrim( data.logte[20:27] ,2), textcolor=colors[20:27], box=0, thick=th, $
	/right, charth=2, charsi=0.75, pos=[0.77,0.94], /norm
legend, ['Total'], charsize=1.0, /right, box=0, line=1
xyouts, 0.8, 0.84, strtrim(cts_tot,2)+' cts s!U-1!N pix!U-1!N', /norm
pclose

!p.multi=0
