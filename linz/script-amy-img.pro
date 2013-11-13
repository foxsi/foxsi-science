; FOXSI software paths for simulated count spec and instrument response
add_path,'spec'
add_path,'resp'

restore, 'linz/dem-template.sav'

; Choose one of the cases.  [1]->HF heating, [2]->LF heating
choice = 2

;f1 = file_search( 'linz/dem_amy/dem_hf*' )
;f2 = file_search( 'linz/dem_amy/dem_lf*' )
;n1 = n_elements(f1)
;n2 = n_elements(f2)

; set up the grand count spectrum array.  40 energy bins,
; 64x64 pixels.

en1 = findgen(500)/20 + 1.		; energy arrays
en2 = get_edges(en1, /edges_2)	; energy arrays
en  = get_edges(en1, /mean)		; energy arrays

nPix = 64

sim_img = dblarr( 40, nPix, nPix )

.run
for col=0, nPix-1 do begin
	for row=0, nPix-1 do begin
	
	if row mod 10 eq 0 then print, 'Col ', col, ', row ', row

; set up file search string
dir = 'linz/dem_amy/'
if choice eq 2 then name0 = 'dem_lf_' else name0 = 'dem_hf_'
if col lt 10 then name1 = '0'+strtrim(col,2) else name1 = strtrim(col,2)
if row lt 10 then name2 = '0'+strtrim(row,2) else name2 = strtrim(row,2)
name = dir + name0 + name1 + '_' + name2 + '*'
file = file_search( name )

if file eq '' then continue

data = read_ascii( file, template=template )
i = where( finite( data.logte ) and data.logte gt 0 )
data = create_struct( ['logTe','EM'], data.logte[i1], data.em[i1] )

; if desired, restrict to temperatures above 1 MK.
n=n_elements(data.logte)
if n gt 15 then data = create_struct( ['logTe','EM'], data.logte[15:n-1], data.em[15:n-1] )

area = (5.*0.725d8)^2	;  5-arcsec pixel
		
; Calculate EM in cm^-3 for each bin.
T = 10.^data.logte
dT = get_edges(T, /width)
dt = [dt, dt[n_elements(dt)-1]]
em = 10.^(data.em)*dt*area

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

sim_img[ *, col, row] = total( sim, 2 )

endfor
endfor
end

energy_kev = simA.energy_kev
if choice eq 2 then save, energy_kev, sim_img, file='linz/sim-foxsi-img-lf.sav $
	else save, energy_kev, sim_img, file='linz/sim-foxsi-img-hf.sav'


restore, 'linz/sim-foxsi-img-hf.sav', /v
sim_img_hf = sim_img
map_hi = make_map( total( sim_img, 1 ), dx=5., dy=5. )
map_5_hi = make_map( total( sim_img[8:11,*,*], 1 ), dx=5., dy=5. )
map_7_hi = make_map( total( sim_img[12:15,*,*], 1 ), dx=5., dy=5. )
map_9_hi  = make_map( total( sim_img[16:19,*,*], 1 ), dx=5., dy=5. )
; map_11_hi = make_map( total( sim_img[20:23,*,*], 1 ), dx=5., dy=5. )

foxsi_maps_hifreq = [map_hi, map_5_hi, map_7_hi, map_9_hi]
foxsi_maps_hifreq.id = 'FOXSI '+['4-15','4-6','6-8','8-10']+' keV'

restore, 'linz/sim-foxsi-img-lf.sav', /v
sim_img_lf = sim_img
map_lo = make_map( total( sim_img, 1 ), dx=5., dy=5. )
map_5_lo = make_map( total( sim_img[8:11,*,*], 1 ), dx=5., dy=5. )
map_7_lo = make_map( total( sim_img[12:15,*,*], 1 ), dx=5., dy=5. )
map_9_lo = make_map( total( sim_img[16:19,*,*], 1 ), dx=5., dy=5. )
map_11_lo = make_map( total( sim_img[20:23,*,*], 1 ), dx=5., dy=5. )

foxsi_maps_lofreq = [map_lo, map_5_lo, map_7_lo, map_9_lo]
foxsi_maps_lofreq.id = 'FOXSI '+['4-15','4-6','6-8','8-10']+' keV'

!p.multi=[0,4,2]
loadct,3
window, xsi=1000, ysi=400

;popen, 'sim-foxsi-img-nosc', /land  

plot_map, map_hi, /log, dmax=max(sim_img_hf)
plot_map, map_5_hi, /log, dmax=max(2*sim_img_hf)
plot_map, map_7_hi, /log, dmax=max(2*sim_img_hf)
plot_map, map_9_hi, /log, dmax=max(2*sim_img_hf)
;plot_map, mHF4, /log, dmax=max(2*sim_img_hf)

plot_map, map_lo, /log, dmax=max(sim_img_lf)
plot_map, map_5_lo, /log, dmax=max(2*sim_img_lf)
plot_map, map_7_lo, /log, dmax=max(2*sim_img_lf)
plot_map, map_9_lo, /log, dmax=max(2*sim_img_lf)
;plot_map, mLF4, /log, dmax=max(2*sim_img_lf)


;
; Old plotting
;

;; display plots and results

;;popen, file, xsi=8, ysi=5

;loadct, 0
;plot, data1.logte, data1.em, psym=10, thick=4, yr=[17,23], charsi=1.2, $
;	xr=[5.,7.5], xtit='Log T', ytit='dEM [cm!U-5]', tit='dEMs from Amy'
;oplot, data2.logte, data2.em, psym=10, thick=4, color=150
;legend, ['High freq','Low freq'], color=[0,150], line=0, thick=4, /left, charsi=1.1, box=0

;!p.multi=[0,2,1]
;loadct, 5
;colors = 32+findgen(n)*8

;TVLCT, r, g, b, /Get
;r2=reverse(r)
;r2[0]=0
;g2=reverse(g)
;g2[0]=0
;b2=reverse(b)
;b2[0]=0
;TVLCT, r2,g2,b2

;if choice eq 2 then title_suffix = 'Low-freq' else title_suffix='High-freq'
   
;plot, en, flux[*,15], psym=10, /xlo, /ylo, xr=[4.,20.], yr=[1.e-4, 1.e2], /xsty, /ysty, $
;	xtit='Energy [keV]', ytit='Phot s!U-1!N cm!U-2!N keV!U-1!N', charsi=1.1, $
;	tit='Photon flux, '+title_suffix, xticks=7, xtickv=[findgen(7)+4,20]
;for i=0, n_elements(t)-1 do $
;	oplot, en, flux[*,i], psym=10, thick=3, col=colors[i]
;legend, strtrim( data.logte[0:9] ,2), textcolor=colors[0:9], box=0, thick=th, $
;	/right, charth=2, charsi=0.75, pos=[0.33,0.92], /norm
;legend, strtrim( data.logte[10:19] ,2), textcolor=colors[10:19], box=0, thick=th, $
;	/right, charth=2, charsi=0.75, pos=[0.40,0.92], /norm
;if choice eq 2 then $
;	legend, strtrim( data.logte[20:27] ,2), textcolor=colors[20:27], box=0, thick=th, $
;	/right, charth=2, charsi=0.75, pos=[0.47,0.92], /norm
;
;cts_tot =  long( total( sim[where(finite(sim))] ) )

;plot, simA.energy_kev, sim[*,15], psym=10, /xlo, /ylo, xr=[2.,20], /xsty, $
;	yr=[1.e-3, 1.e4], /ysty, xtit='Energy [keV]', ytit='Counts s!U-1!N keV!U-1!N', $
;	tit='Sim FOXSI counts, '+title_suffix, xticks=9, xtickv=[findgen(9)+2,20]
;for i=0, n-1 do oplot, simA.energy_kev, sim[*,i], psym=10, thick=3, col=colors[i]
;oplot, simA.energy_kev, total(sim, 2), psym=10, thick=8, line=1
;legend, strtrim( data.logte[0:19] ,2), textcolor=colors[0:19], box=0, thick=th, $
;	/right, charth=2, charsi=0.75, pos=[0.7,0.94], /norm
;if choice eq 2 then $
;	legend, strtrim( data.logte[20:27] ,2), textcolor=colors[20:27], box=0, thick=th, $
;	/right, charth=2, charsi=0.75, pos=[0.77,0.94], /norm
;legend, ['Total'], charsize=1.0, /right, box=0, line=1
;xyouts, 0.8, 0.84, strtrim(cts_tot,2)+' cts s!U-1!N pix!U-1!N', /norm
;;pclose

;!p.multi=0
