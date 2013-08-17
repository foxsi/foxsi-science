; FOXSI software paths for simulated count spec and instrument response
add_path,'spec'
add_path,'resp'

; set up the temperature array, from log(T) = {5.5, 7.5}
logT = findgen(21)/10. + 5.5

; Choose values from one of the two examples below.

; Case 1: 1x1 pixel (4"x4")
area = 4.^2 * (0.725d8)^2
; dem values from Ishikawa
dem = [ 10., 5.7615336e+09, 3.6089325e+16, 9.6696061e+20, 3.5377804e+22, 8.7783289e+21, $
		4.0188885e+20, 7.9382189e+19, 2.3459946e+20, 1.9350063e+21, 6.9564576e+21, $
		2.8403134e+21, 2.9826793e+20, 2.9016692e+19, 8.4066512e+18, 7.3720743e+18, $
		9.8257205e+18, 1.0305182e+19, 6.1854576e+18, 2.5750783e+18, 9.1455790e+17 ]
title = '4"x4" Hinode AR'
file  = 'hinode-ar-1pix'

; Case 2: 25x25 pixels (100"x100")
area = 100.^2 * (0.725d8)^2
dem = [ 9.2702526e+20, 7.7229808e+17, 6.7899155e+15, 1.1811620e+15, 8.3469140e+15, $
		8.3893852e+17, 1.3764897e+20, 4.4214144e+21, 1.0777911e+22, 4.7550073e+21, $
		9.2400217e+20, 1.6420199e+20, 3.9138261e+19, 1.7319996e+19, 1.9518247e+19, $
		3.8958065e+19, 6.1678387e+19, 3.3981301e+19, 4.3694079e+18, 1.7278429e+17, $
		2.6657822e+15 ]
title = '100"x100" Hinode AR'
file  = 'hinode-ar-25pix'
		
; Calculate EM in cm^-3 for each bin.
T = 10.^logt
dT = get_edges(T, /edges_2)
em = dem*dt*area

; energy arrays for simulated thermal fluxes
en1 = findgen(500)/20 + 1.
en2 = get_edges(en1, /edges_2)
en  = get_edges(en1, /mean)
n = n_elements(t)

; calculate thermal X-ray fluxes for each temperature/EM pair.
flux = dblarr( n_elements(en), n )
for i=0, 20 do flux[*,i] = f_vth( en2, [em[i]/1.d49, t[i]/11.8/1.d6, 1.] )

; The next routine calculates the expected FOXSI count spectrum for given thermal params.
; This includes contributions from the optics, detectors, and nominal blanketing.
; The extra blanketing isn't included.
; Off-axis angle is assumed 0.
; For simplicity, I only use D8's efficiency file. (The others are very similar.)

; Sample sim to set up arrays.
simA = foxsi_count_spectrum(em[10]/1.d49, t[10]/1.d6, $
	data_dir='detector_data/', let_file='efficiency_det108_asic2.sav' )
; Now do it for all temperature bins.
sim = dblarr( n_elements(simA.energy_keV), n_elements(logt) )
.run
for i=0, 20 do begin sim2 = foxsi_count_spectrum(em[i]/1.d49, t[i]/1.d6, $
	data_dir='detector_data/', let_file='efficiency_det108_asic2.sav' )
	sim[*,i] = sim2.counts
endfor
end



; display results

loadct, 5
colors = 220-findgen(n)*10+20
popen, file, xsi=7, ysi=5
plot, en, flux[*,15], psym=10, /xlo, /ylo, xr=[1.,30.], yr=[1.e-2, 1.e5], /xsty, /ysty, $
	xtit='Energy [keV]', ytit='Phot s!U-1!N cm!U-2!N keV!U-1!N', charsi=1.1, $
	tit='Photon flux, '+title
for i=0, n_elements(logt)-1 do $
	oplot, en, flux[*,i], psym=10, thick=3, col=colors[i]
legend, strtrim( logt ,2), textcolor=colors, box=0, thick=th, $
	/right, charth=2, charsi=1.1

plot, simA.energy_kev, sim[*,15], psym=10, /xlo, /ylo, xr=[1.,30], /xsty, $
	yr=[1.e-3, 1.e3], /ysty, xtit='Energy [keV]', ytit='Counts s!U-1!N keV!U-1!N', $
	tit='Simulated FOXSI flux, '+title
for i=0, n_elements(logt)-1 do oplot, simA.energy_kev, sim[*,i], psym=10, thick=3, col=colors[i]
legend, strtrim( logt ,2), textcolor=colors, box=0, thick=th
pclose

