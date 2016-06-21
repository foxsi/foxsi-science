FUNCTION assess_params, n_bla, offset, spec, delta_t, stop=stop, info=info, $
	ch_t=ch_t, ch_em=ch_em, t=t, em=em, phottot=totphot, quiet=quiet, module=module, $
	plot=plot

COMMON FOXSI_PARAM
; Produce photon spex from count spex.
inverse = inverse_resp( spec.energy_kev, offaxis=7.3, n_bla=n_bla, offset=offset, /quiet,$
												/foxsi1, module=module )
phot = spec.spec_p * inverse.per_cm2 / delta_t
totphot = total(phot[where(finite(phot) eq 1)])

; Choose an energy range to isolate.
; nominal is between 5 and 9 keV.
i=where( (inverse.energy_kev ge 5.0 and inverse.energy_kev lt 6.5) or $
				 (inverse.energy_kev ge 7.0 and inverse.energy_kev le 9.0 ) )
e1 = inverse.energy_kev[i[0]-1]
e2 = inverse.energy_kev[i]
f1 = spec.spec_p[i[0]-1] * inverse.per_cm2[i[0]-1] / delta_t	; reference flux at lowest value
f2 = spec.spec_p[i] * inverse.per_cm2[i] / delta_t				; fluxes above that.

; Calculate temperature based on ratio.
k = 8.6d-8
t_calc = (e2-e1)/k/alog(f1*e1/f2/e2)	; calculated temperatures

; Throw out any values where the calculated temperatures are zero or bad statistics.
zero = where( t_calc gt 0. )
e2 = e2[ zero ]
t_calc = t_calc[ zero ]
f2 = f2[ zero ]
goodstat = where( spec.spec_p[i]*(e2[1]-e2[0]) ge 9. )
e2 = e2[ goodstat ]
t_calc = t_calc[ goodstat ]
f2 = f2[ goodstat ]


t_exp = average(t_calc)* (fltarr(n_elements(t_calc))+1.)		; "expected" T = average.
em = fltarr( n_elements(t_calc ) )
for j=0, n_elements(t_calc)-1 do $		; calculated EMs
	EM[j] = phot[i[j]] / brem_49( inverse.energy_kev[i[j]], t_calc[j]*k)
	; should probably change that last line to use F_VTH instead.
em_exp = average(em[where(em gt 0.)])*(fltarr(n_elements(em))+1.)			; "expected" EM

; do a linear fit.
; First, throw out the most extreme values.
;ind = where( t_calc gt min(t_calc) and t_calc lt max(t_calc) )
;x = e2[ind]
;y = t_calc[ind]
x=e2
y=t_calc
result = poly_fit( x, y, 1, yfit=yfit, sig=err )

if keyword_set( plot ) then begin
	plot, e2, t_calc, /psy, xtit='Energy [keV]', ytit='Temperature [MK]', tit='Module '+strtrim(module,2)
	oplot, e2, t_exp
	plot, e2, em, /psy, xtit='Energy [keV]', ytit='EM [x10!U29!N cm!U-3!N]', tit='Module '+strtrim(module,2)
	oplot, e2, em_exp
endif

if keyword_set(stop) then stop

; choose the "goodness of fit" statistic.
; this could be the slope normalized to the uncertainty.
; or it could be the residual.
; or some combination!

chisq = abs( result[1] / err[1] )
ch_t =  abs( result[1] / err[1] )
;if ch_t gt 1. then ch_t = 100. else $
;ch_t = total( (t_exp - t_calc)^2 / (t_exp)^2 )
ch_t = abs( correlate( e2, t_calc ) )

; Repeat for EM.
ind = where( em gt min(em) and em lt max(em) )
x = e2;[ind]
y = em;[ind]
result = poly_fit( x, y, 1, yfit=yfit, sig=err )
ch_em = result[1] / err[1]
ch_em = abs( correlate( e2, em ) )
;if ch_t gt 1. then ch_t = 100. else ch_em = total( (em - em_exp)^2 / em_exp^2 )

struct = create_struct( 'energy_kev', e2, 'phot', phot[i], 'temperature', t_calc, 'em',em)

if n_bla mod 1 eq 0 then begin
	;print, n_bla, offset
endif

t = average(t_calc[where(t_calc gt 1.e6)])
em = average(em[where(em gt 0.)])
	
if keyword_set(info) then begin
	print, 'Blanketing factors: ', n_bla, offset
	print, 'Temperature = ', t
	print, 'EM = ', em
endif
	
return, chisq

END


FUNCTION	BEST_PARAMS, MODULE, SPEC, stop=stop

nbla = findgen(80)/10.+2.
off  = findgen(10)/500.+0.01
nnbla = n_elements(nbla)
noff = n_elements(off)
chi_t  = fltarr( nnbla, noff )
chi_em  = fltarr( nnbla, noff )
t  = fltarr( nnbla, noff )
em  = fltarr( nnbla, noff )

for i=0, nnbla-1 do begin &$
	for j=0, noff-1 do begin &$
		temp = assess_params( nbla[i], off[j], spec, 80., ch_t=x, ch_em=y, t=z, em=a,/qu, module=module ) &$
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
test=assess_params( nbla[ind2_t[0]], off[ind2_t[1]], spec, 80., /info, module=module )
test=assess_params( nbla[ind2_em[0]], off[ind2_em[1]], spec, 80., /info, module=module )

test1 = chi_t / min(chi_t)
test2 = chi_em / min(chi_em)
test3 = test1*test2
;plot_map, make_map(test3), /cbar
min = min(test3,ind)
ind2 = array_indices(test3,ind)
test=assess_params( nbla[ind2[0]], off[ind2[1]], spec, 80., /info, module=module, $
	t=result_t, em=result_em, stop=stop, /plot )

return, [ nbla[ind2[0]], off[ind2[1]], result_t, result_em ]

END


PRO	CYCLE_MODULES

	get_target_data, 4, d0,d1,d2,d3,d4,d5,d6, year=2012
	t1 = t4_start
	t2 = t6_end
	delta_t = t2 - t1
	bin = 0.5
	spec_d0 = make_spectrum( d0, bin=bin, /correct )
	spec_d1 = make_spectrum( d1, bin=bin, /correct )
	spec_d2 = make_spectrum( d2, bin=bin, /correct )
	spec_d3 = make_spectrum( d3, bin=bin, /correct )
	spec_d4 = make_spectrum( d4, bin=bin, /correct )
	spec_d5 = make_spectrum( d5, bin=bin, /correct )
	spec_d6 = make_spectrum( d6, bin=bin, /correct )

	factor = fltarr(7)
	offset = fltarr(7)
	temperature = fltarr(7)
	em = fltarr(7)

	popen, 'latest-self-calib', xsi=8, ysi=11
	!p.multi=[0,2,4]

	for module = 0, 6 do begin
	
		print, 'Starting fit for Module ', module
	
		case module of
			0: spec = spec_d0
			1: spec = spec_d1
			2: spec = spec_d2
			3: spec = spec_d3
			4: spec = spec_d4
			5: spec = spec_d5
			6: spec = spec_d6
		endcase

		params = best_params( module, spec )
		
		factor[module] = params[0]
		offset[module] = params[1]
		temperature[module] = params[2]
		em[module] = params[3]
		
	endfor
	
	pclose
	!p.multi=0
	
	for module=0, 6 do begin
	
		print, 'Module '+ strtrim(module,2)+': ', factor[module], offset[module], temperature[module], em[module]
		
	endfor
	
end 