; Check your t_calc formula using the RHESSI-derived spectrum.

e2 = abins[6:15]
e1 = abins[5]
f2 = s_sum[6:15]
f1 = s_sum[5]

t_calc = (e2-e1)/k/alog(f1*e1/f2/e2)

IDL> print, t_calc
  1.90968e+07  2.32264e+07  9.35025e+06  9.40611e+06  9.39303e+06  9.36451e+06  9.36529e+06
  9.37008e+06  9.37522e+06  9.38021e+06

; This gives very consistent values for the RHESSI photon spectrum!  Function is good.
; Now use it for FOXSI.  For FOXSI the ratio is also a function of amount of 
; blanketing material.  Also need to insert the FOXSI response (because we need FLUX
; not COUNTS).

; Plot derived temperature vs energy for various blanketing factors.
;	-- for a given n, go from counts to flux.
;	-- calculate the temperature using the ratio.
;	-- make a plot of temperature vs n.
;	-- choose the pair that gives the best residual & compare with RHESSI.

; Get inverse response.
inverse = inverse_resp( spec_d6.energy_kev, offaxis=7.3, n_bla=8., offset=0.01 )
phot = spec_d6.spec_p * inverse.per_cm2 / delta_t

plot, spec_d6.energy_kev, phot, /xlo, /ylo, xr=[4.5,7.], /xsty, yr=[1.e-2,1.e4]
oplot, abins, s_sum, line=1

; actually, n_bla=2 works really well if we divide the RHESSI spectrum by 30...
; the n=4.3 that we get from the other analysis seems like overkill.  also seems to
; make a systematic error with energy...

; Anyways, moving on.

; Calculate a temperature vs energy.  use 5 keV as the benchmark.
n_bla = 1.5
offset = 0.0
inverse = inverse_resp( spec_d6.energy_kev, offaxis=7.3, n_bla=n_bla, offset=offset )
phot = spec_d6.spec_p * inverse.per_cm2 / delta_t
i=where( inverse.energy_kev gt 5. and inverse.energy_kev lt 10. )
e1 = inverse.energy_kev[i[0]-1]
e2 = inverse.energy_kev[i]
f1 = spec_d6.spec_p[i[0]-1] * inverse.per_cm2[i[0]-1] / delta_t
f2 = spec_d6.spec_p[i] * inverse.per_cm2[i] / delta_t
t_calc = (e2-e1)/k/alog(f1*e1/f2/e2)
plot, e2, t_calc
print, 'Temperature = ', average(t_calc), ' +/- ', stdev(t_calc), ' MK'

temppro, 1.5, 0., spec_d6, 80.

for i=1.,2., 0.1 do temp = temppro(i, 0., spec_d6, 80.)

n = findgen(90)/10.+1.
n_n = n_elements(n)
t0 = fltarr(n_n)
t1 = fltarr(n_n)
t2 = fltarr(n_n)
t4 = fltarr(n_n)
t5 = fltarr(n_n)
t6 = fltarr(n_n)
em0 = fltarr(n_n)
em1 = fltarr(n_n)
em2 = fltarr(n_n)
em4 = fltarr(n_n)
em5 = fltarr(n_n)
em6 = fltarr(n_n)
for i=0, n_n-1 do begin & $
	temp = temppro( n[i], 0., spec_d6, 80. ) & $
	t6[i]  = average(temp.temperature) & $
	em6[i] = average(temp.em) & $
	temp = temppro( n[i], 0., spec_d5, 80. ) & $
	t5[i]  = average(temp.temperature) & $
	em5[i] = average(temp.em) & $
	temp = temppro( n[i], 0., spec_d4, 80. ) & $
	t4[i]  = average(temp.temperature) & $
	em4[i] = average(temp.em) & $
	temp = temppro( n[i], 0., spec_d2, 80. ) & $
	t2[i]  = average(temp.temperature) & $
	em2[i] = average(temp.em) & $
	temp = temppro( n[i], 0., spec_d1, 80. ) & $
	t1[i]  = average(temp.temperature) & $
	em1[i] = average(temp.em) & $
	temp = temppro( n[i], 0., spec_d0, 80. ) & $
	t0[i]  = average(temp.temperature) & $
	em0[i] = average(temp.em) & $
endfor


; examine a larger parameter space.
get_target_data, 4, d0,d1,d2,d3,d4,d5,d6
t1 = t4_start
t2 = t4_end
delta_t = t2 - t1
bin = 0.3
spec_d0 = make_spectrum( d0, bin=bin, /correct )
spec_d1 = make_spectrum( d1, bin=bin, /correct )
spec_d2 = make_spectrum( d2, bin=bin, /correct )
spec_d3 = make_spectrum( d3, bin=bin, /correct )
spec_d4 = make_spectrum( d4, bin=bin, /correct )
spec_d5 = make_spectrum( d5, bin=bin, /correct )
spec_d6 = make_spectrum( d6, bin=bin, /correct )

nbla = findgen(90)/10.+1.
off  = findgen(100)/200.
nnbla = n_elements(nbla)
noff = n_elements(off)
chi  = fltarr( nnbla, noff )
for i=0, nnbla-1 do for j=0, noff-1 do chi[ i, j ] = tempfun2( nbla[i], off[j], spec_d5, 80. )
min = min(chi,ind)
ind2 = array_indices(chi,ind)
print, nbla[ind2[0]], off[ind2[1]]
; This works!  Use it!!!

; for plotting results.  return value is different now.

a1=tempfun2( 1., 0.0, spec_d5, 80. )
a2=tempfun2( 4.6, 0.05, spec_d5, 80. )

;
; Trying again, with more constraints.
;

nbla = findgen(60)/10.+2.
off  = findgen(50)/200.
nnbla = n_elements(nbla)
noff = n_elements(off)
chi  = fltarr( nnbla, noff )
for i=0, nnbla-1 do for j=0, noff-1 do chi[ i, j ] = tempfun4( nbla[i], off[j], spec_d0, 80. )
min = min(chi,ind)
ind2 = array_indices(chi,ind)
tempfun4( nbla[ind2[0]], off[ind2[1]], spec_d0, 80., /info, temp=t0, em=em0 )
for i=0, nnbla-1 do for j=0, noff-1 do chi[ i, j ] = tempfun4( nbla[i], off[j], spec_d1, 80. )
min = min(chi,ind)
ind2 = array_indices(chi,ind)
tempfun4( nbla[ind2[0]], off[ind2[1]], spec_d1, 80., /info, temp=t1, em=em1 )
for i=0, nnbla-1 do for j=0, noff-1 do chi[ i, j ] = tempfun4( nbla[i], off[j], spec_d2, 80. )
min = min(chi,ind)
ind2 = array_indices(chi,ind)
tempfun4( nbla[ind2[0]], off[ind2[1]], spec_d2, 80., /info, temp=t2, em=em2 )
for i=0, nnbla-1 do for j=0, noff-1 do chi[ i, j ] = tempfun4( nbla[i], off[j], spec_d4, 80. )
min = min(chi,ind)
ind2 = array_indices(chi,ind)
tempfun4( nbla[ind2[0]], off[ind2[1]], spec_d4, 80., /info, temp=t4, em=em4 )
for i=0, nnbla-1 do for j=0, noff-1 do chi[ i, j ] = tempfun4( nbla[i], off[j], spec_d5, 80. )
min = min(chi,ind)
ind2 = array_indices(chi,ind)
tempfun4( nbla[ind2[0]], off[ind2[1]], spec_d5, 80., /info, temp=t5, em=em5 )
for i=0, nnbla-1 do for j=0, noff-1 do chi[ i, j ] = tempfun4( nbla[i], off[j], spec_d6, 80. )
min = min(chi,ind)
ind2 = array_indices(chi,ind)
tempfun4( nbla[ind2[0]], off[ind2[1]], spec_d6, 80., /info, temp=t6, em=em6 )
print, t0,t1,t2,t4,t5,t6

print, nbla[ind2[0]], off[ind2[1]]


;good = [0,1,2,3,7,10,11,12,13]
result1 = poly_fit( a1.energy_kev[good], a1.temperature[good], 1, yfit=yfit1 )
result2 = poly_fit( a1.energy_kev[good], a2.temperature[good], 1, yfit=yfit2 )

loadct, 5
hsi_linecolors
popen, 'fig/nblankets', xsi=7, ysi=5
plot, a1.energy_kev, a1.temperature/1.e6, charsi=1.3, xr=[5.,9.], $
	xtit='Energy [keV]', ytit='Derived temperature [MK]', /nodata
oplot, a1.energy_kev, a1.temperature/1.e6, psy=2, symsize=1.1, color=6
oplot, a1.energy_kev[good], yfit1/1.e6, thick=5, color=6
oplot, a2.energy_kev, a2.temperature/1.e6, psy=2, symsize=1.1, color=7
oplot, a2.energy_kev[good], yfit2/1.e6, thick=5, color=7
al_legend, ['No blanketing correction','Best blanketing correction for D6'], $
	color=[6,7], thick=4, /bot, /right, box=0, line=0, charsi=1.3
pclose


;
; August work
;

get_target_data, 4, d0,d1,d2,d3,d4,d5,d6
t1 = t4_start
t2 = t4_end
delta_t = t2 - t1
bin = 0.3
spec_d0 = make_spectrum( d0, bin=bin, /correct )
spec_d1 = make_spectrum( d1, bin=bin, /correct )
spec_d2 = make_spectrum( d2, bin=bin, /correct )
spec_d3 = make_spectrum( d3, bin=bin, /correct )
spec_d4 = make_spectrum( d4, bin=bin, /correct )
spec_d5 = make_spectrum( d5, bin=bin, /correct )
spec_d6 = make_spectrum( d6, bin=bin, /correct )

; New plan:
; 1- make a chisq map using the temperature constraint.
; 2- make a chisq map using the EM constraint.
; 3- choose the map index with the best TOTAL chisq, including both.

nbla = findgen(60)/10.+0.5
off  = findgen(50)/200.
nnbla = n_elements(nbla)
noff = n_elements(off)
chi_t  = fltarr( nnbla, noff )
chi_em  = fltarr( nnbla, noff )
t  = fltarr( nnbla, noff )
em  = fltarr( nnbla, noff )

for i=0, nnbla-1 do begin &$
	for j=0, noff-1 do begin &$
		temp = tempfun5( nbla[i], off[j], spec_d4, 80., ch_t=x, ch_em=y, t=z, em=a ) &$
		chi_t[i,j] = x &$
		chi_em[i,j] = y &$
		t[i,j] = z &$
		em[i,j] = a &$
	endfor &$
endfor
min = min(chi_t,ind_t)
ind2_t = array_indices(chi_t,ind_t)
min = min(chi_em,ind_em)
ind2_em = array_indices(chi_em,ind_em)
test=tempfun5( nbla[ind2_t[0]], off[ind2_t[1]], spec_d4, 80., /info )
test=tempfun5( nbla[ind2_em[0]], off[ind2_em[1]], spec_d4, 80., /info )

test1 = chi_t / min(chi_t)
test2 = chi_em / min(chi_em)
test3 = test1*test2
plot_map, make_map(test3), /cbar
plot_map, make_map(test3), /cbar,/log
min = min(test3,ind)
ind2 = array_indices(test3,ind)
test=tempfun5( nbla[ind2[0]], off[ind2[1]], spec_d4, 80., /info )

; Good results (best so far) were obtained with TEMPFUN5 and above code.
; DON'T CHANGE THIS ROUTINE!!!
; Renaming it to tempfun6 for next changes...

nbla = findgen(60)/10.+2.
off  = findgen(20)/200.
nnbla = n_elements(nbla)
noff = n_elements(off)
chi_t0  = fltarr( nnbla, noff )
chi_t1  = fltarr( nnbla, noff )
chi_t2  = fltarr( nnbla, noff )
chi_t4  = fltarr( nnbla, noff )
chi_t5  = fltarr( nnbla, noff )
chi_t6  = fltarr( nnbla, noff )
chi_em0  = fltarr( nnbla, noff )
chi_em1  = fltarr( nnbla, noff )
chi_em2  = fltarr( nnbla, noff )
chi_em4  = fltarr( nnbla, noff )
chi_em5  = fltarr( nnbla, noff )
chi_em6  = fltarr( nnbla, noff )
t0  = fltarr( nnbla, noff )
t1  = fltarr( nnbla, noff )
t2  = fltarr( nnbla, noff )
t4  = fltarr( nnbla, noff )
t5  = fltarr( nnbla, noff )
t6  = fltarr( nnbla, noff )
em0  = fltarr( nnbla, noff )
em1  = fltarr( nnbla, noff )
em2  = fltarr( nnbla, noff )
em4  = fltarr( nnbla, noff )
em5  = fltarr( nnbla, noff )
em6  = fltarr( nnbla, noff )
nphot0 = fltarr( nnbla, noff )
nphot1 = fltarr( nnbla, noff )
nphot2 = fltarr( nnbla, noff )
nphot4 = fltarr( nnbla, noff )
nphot5 = fltarr( nnbla, noff )
nphot6 = fltarr( nnbla, noff )

for i=0, nnbla-1 do begin &$
	for j=0, noff-1 do begin &$
		temp0 = tempfun6( nbla[i], off[j], spec_d0, 80., ch_t=x0, ch_em=y0, t=z0, em=a0, $
						  phottot=totphot0 ) &$
		temp1 = tempfun6( nbla[i], off[j], spec_d1, 80., ch_t=x1, ch_em=y1, t=z1, em=a1, $
						  phottot=totphot1 ) &$
		temp2 = tempfun6( nbla[i], off[j], spec_d2, 80., ch_t=x2, ch_em=y2, t=z2, em=a2, $
						  phottot=totphot2 ) &$
		temp4 = tempfun6( nbla[i], off[j], spec_d4, 80., ch_t=x4, ch_em=y4, t=z4, em=a4, $
						  phottot=totphot4 ) &$
		temp5 = tempfun6( nbla[i], off[j], spec_d5, 80., ch_t=x5, ch_em=y5, t=z5, em=a5, $
						  phottot=totphot5 ) &$
		temp6 = tempfun6( nbla[i], off[j], spec_d6, 80., ch_t=x6, ch_em=y6, t=z6, em=a6, $
						  phottot=totphot6 ) &$
		chi_t0[i,j] = abs(x0) &$
		chi_t1[i,j] = abs(x1) &$
		chi_t2[i,j] = abs(x2) &$
		chi_t4[i,j] = abs(x4) &$
		chi_t5[i,j] = abs(x5) &$
		chi_t6[i,j] = abs(x6) &$
		chi_em0[i,j] = abs(y0) &$
		chi_em1[i,j] = abs(y1) &$
		chi_em2[i,j] = abs(y2) &$
		chi_em4[i,j] = abs(y4) &$
		chi_em5[i,j] = abs(y5) &$
		chi_em6[i,j] = abs(y6) &$
		t0[i,j] = z0 &$
		t1[i,j] = z1 &$
		t2[i,j] = z2 &$
		t4[i,j] = z4 &$
		t5[i,j] = z5 &$
		t6[i,j] = z6 &$
		em0[i,j] = a0 &$
		em1[i,j] = a1 &$
		em2[i,j] = a2 &$
		em4[i,j] = a4 &$
		em5[i,j] = a5 &$
		em6[i,j] = a6 &$
		nphot0[i,j] = totphot0 &$
		nphot1[i,j] = totphot1 &$
		nphot2[i,j] = totphot2 &$
		nphot4[i,j] = totphot4 &$
		nphot5[i,j] = totphot5 &$
		nphot6[i,j] = totphot6 &$
	endfor &$
endfor
test10 = chi_t0 / min(chi_t0)
test11 = chi_t1 / min(chi_t1)
test12 = chi_t2 / min(chi_t2)
test14 = chi_t4 / min(chi_t4)
test15 = chi_t5 / min(chi_t5)
test16 = chi_t6 / min(chi_t6)
test20 = chi_em0 / min(chi_em0)
test21 = chi_em1 / min(chi_em1)
test22 = chi_em2 / min(chi_em2)
test24 = chi_em4 / min(chi_em4)
test25 = chi_em5 / min(chi_em5)
test26 = chi_em6 / min(chi_em6)
test30 = double(test10)*double(test20)
test31 = double(test11)*double(test21)
test32 = double(test12)*double(test22)
test34 = double(test14)*double(test24)
test35 = double(test15)*double(test25)
test36 = double(test16)*double(test26)
min0 = min(test30,ind0)
min1 = min(test31,ind1)
min2 = min(test32,ind2)
min4 = min(test34,ind4)
min5 = min(test35,ind5)
min6 = min(test36,ind6)
ind20 = array_indices(test30,ind0)
ind21 = array_indices(test31,ind1)
ind22 = array_indices(test32,ind2)
ind24 = array_indices(test34,ind4)
ind25 = array_indices(test35,ind5)
ind26 = array_indices(test36,ind6)
test0=tempfun6( nbla[ind20[0]], off[ind20[1]], spec_d0, 80., /info, t=temperature0 )
test1=tempfun6( nbla[ind21[0]], off[ind21[1]], spec_d1, 80., /info, t=temperature1 )
test2=tempfun6( nbla[ind22[0]], off[ind22[1]], spec_d2, 80., /info, t=temperature2 )
test4=tempfun6( nbla[ind24[0]], off[ind24[1]], spec_d4, 80., /info, t=temperature4 )
test5=tempfun6( nbla[ind25[0]], off[ind25[1]], spec_d5, 80., /info, t=temperature5 )
test6=tempfun6( nbla[ind26[0]], off[ind26[1]], spec_d6, 80., /info, t=temperature6 )



temp = tempfun6( 4.6, 0.02, spec_d6, 80., ch_t=x, ch_em=y, t=z, em=a, /stop )

loadct,5
map = make_map( test25, dx=0.1, dy=0.05, xcen=average(nbla), ycen=average(off)*10. )
plot_map, map, /cbar

test1 = chi_t / min(chi_t)
test2 = chi_em / min(chi_em)
test3 = test1*test2
test3[ where(em gt 0.01) ] = 10000.
plot_map, make_map(test3), /cbar
plot_map, make_map(test3), /cbar,/log
min = min(test3,ind)
ind2 = array_indices(test3,ind)
test=tempfun6( nbla[ind2[0]], off[ind2[1]], spec_d6, 80., /info )

