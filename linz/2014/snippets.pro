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


module = 6

case module of			&$
	0: spec = spec_d0			&$
	1: spec = spec_d1			&$
	2: spec = spec_d2			&$
	3: spec = spec_d3			&$
	4: spec = spec_d4			&$
	5: spec = spec_d5			&$
	6: spec = spec_d6			&$
endcase

nbla = findgen(80)/10.+2.
off  = findgen(20)/200.
nnbla = n_elements(nbla)
noff = n_elements(off)
chi_t  = fltarr( nnbla, noff )
chi_em  = fltarr( nnbla, noff )
t  = fltarr( nnbla, noff )
em  = fltarr( nnbla, noff )

for i=0, nnbla-1 do begin &$
	for j=0, noff-1 do begin &$
		temp = tempfun8( nbla[i], off[j], spec, 80., ch_t=x, ch_em=y, t=z, em=a,/qu, module=module ) &$
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
test=tempfun8( nbla[ind2_t[0]], off[ind2_t[1]], spec, 80., /info, module=module )
test=tempfun8( nbla[ind2_em[0]], off[ind2_em[1]], spec, 80., /info, module=module )

test1 = chi_t / min(chi_t)
test2 = chi_em / min(chi_em)
test3 = test1*test2
plot_map, make_map(test3), /cbar
min = min(test3,ind)
ind2 = array_indices(test3,ind)
test=tempfun8( nbla[ind2[0]], off[ind2[1]], spec, 80., /info, module=module )
