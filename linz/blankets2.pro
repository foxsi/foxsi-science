FUNCTION BLANKETS2, PARAM, FE_TH = FE_TH, CU_TH=CU_TH, NI_TH=NI_TH, STOP=STOP, ALL=ALL, $
	T = T, EM = EM, BIN = BIN, TIME_INT = TIME_INT, $
	DET = DET, OVER=OVER, $
	OFFSET = OFFSET

; PARAM is parameter array with % effarea blocked by 2, 4, or 6 extra sets of blankets.
; Total of these percents should be < 1.  The difference from 1 will be
; modeled as effarea with no absorbtion.

default, offset, 0.0
default, det, 6

if total(param) gt 1 then begin
	print, 'Total area % > 100'
	return, -1
endif

default, T, 9.4			; temperature in MK
default, EM, 4.8e-3		; emission measure in units of 10^49
default, bin, 1.0		; energy binning
default, time_int, 60.	; time interval over which to simulate

case det of
	0:	sim = foxsi_count_spectrum(em, t, time=time_int, bin=bin, /single, $
				data_dir='detector_data/', let_file='efficiency_det108_asic2.sav' )
	1:	sim = foxsi_count_spectrum(em, t, time=time_int, bin=bin, /single, $
				data_dir='detector_data/', let_file='efficiency_det109_asic2.sav' )
	2:	sim = foxsi_count_spectrum(em, t, time=time_int, bin=bin, /single, $
				data_dir='detector_data/', let_file='efficiency_det102_asic3.sav' )
	3:	sim = foxsi_count_spectrum(em, t, time=time_int, bin=bin, /single, $
				data_dir='detector_data/', let_file='efficiency_det103_asic3.sav' )
	4:	sim = foxsi_count_spectrum(em, t, time=time_int, bin=bin, /single, $
				data_dir='detector_data/', let_file='efficiency_det104_asic2.sav' )
	5:	sim = foxsi_count_spectrum(em, t, time=time_int, bin=bin, /single, $
				data_dir='detector_data/', let_file='efficiency_det105_asic2.sav' )
	6:	sim = foxsi_count_spectrum(em, t, time=time_int, bin=bin, /single, $
				data_dir='detector_data/', let_file='efficiency_det106_asic3.sav' )
endcase

if keyword_set( fe_th ) then begin
	a=read_ascii('detector_data/iron_data_NIST.txt')
	dens = 7.87
	en_Fe = 1000.*a.field1[0,*]
	atten_Fe = exp((-1)*fe_th*a.field1[1,*]*dens)
	atten_fe = interpol( atten_Fe[0:20], en_Fe[0:20], sim.energy_kev )
	sim.counts = sim.counts * atten_Fe
endif

if keyword_set( ni_th ) then begin
	a=read_ascii('detector_data/nickel_data_NIST.txt')
	dens = 8.91
	en_ni = 1000.*a.field1[0,*]
	atten_Ni = exp((-1)*ni_th*a.field1[1,*]*dens)
	atten_ni = interpol( atten_ni[0:20], en_ni[0:20], sim.energy_kev )
	sim.counts = sim.counts * atten_Ni
endif

if keyword_set( cu_th ) then begin
	a=read_ascii('detector_data/copper_data_NIST.txt')
	dens = 8.96
	en_cu = 1000.*a.field1[0,*]
	atten_Cu = exp((-1)*cu_th*a.field1[1,*]*dens)
	atten_cu = interpol( atten_cu[0:20], en_cu[0:20], sim.energy_kev )
	sim.counts = sim.counts * atten_Cu
endif

;
; correct for attenuation
;

; nominal blanketing thicknesses (total in path)
mylar=82.55
al=2.6
kapton=203.2

; attenuation factors due to excess blankets
area_control = get_foxsi_effarea( energy_arr=sim.energy_kev, /nodet, /noshut, $
				data_dir='detector_data/')
area_2X = get_foxsi_effarea( energy_arr=sim.energy_kev, /nodet, /noshut, $
				data_dir='detector_data/', mylar=2*mylar, al=al, kap=2*kapton)
area_3X = get_foxsi_effarea( energy_arr=sim.energy_kev, /nodet, /noshut, $
				data_dir='detector_data/', mylar=3*mylar, al=al, kap=3*kapton)
area_4X = get_foxsi_effarea( energy_arr=sim.energy_kev, /nodet, /noshut, $
				data_dir='detector_data/', mylar=4*mylar, al=4*al, kap=4*kapton)

ratio_2X = area_2X.eff_area_cm2 / area_control.eff_area_cm2
ratio_3X = area_3X.eff_area_cm2 / area_control.eff_area_cm2
ratio_4X = area_4X.eff_area_cm2 / area_control.eff_area_cm2

sim_2Xcts = sim.counts * ratio_2X
sim_3Xcts = sim.counts * ratio_3X
sim_4Xcts = sim.counts * ratio_4X

no_absorb_frac = 1. - total(param)

sim.counts = no_absorb_frac*sim.counts + param[0]*sim_2Xcts $
			  + param[1]*sim_3Xcts + param[2]*sim_4Xcts

;; correct simulated spectra for livetime.
;sim = foxsi_live_correct( sim, time_int )

restore,'spec.sav'

case det of
	0: spec = spec_d0
	1: spec = spec_d1
	2: spec = spec_d2
	3: spec = spec_d3
	4: spec = spec_d4
	5: spec = spec_d5
	6: spec = spec_d6
endcase

case det of
	0: color = 6
	1: color = 7
	2: color = 8
	3: color = 9
	4: color = 10
	5: color = 12
	6: color = 2
endcase

if keyword_set(stop) then stop

title = 'Discrepancy in flare spectra (due to blankets)'
if not keyword_set(over) then begin
	plot, sim.energy_kev, spec.spec_p / sim.counts, xr=[2,10], $
		yr=[1.e-2,1.5], /ysty, /ylog, $
		thick=4, charsize=1.5, xtitle='Energy [keV]', $
		ytitle='ratio of measured to simulated counts', $
		title=title, $
		psym=10, /nodata
endif

psym=1
line=1
thick=4

oplot_err, spec.energy_kev, spec.spec_p /sim.counts+offset, psym=psym, $
  yerr = spec.spec_p_err/sim.counts, line=line, color=color, thick=thick
	  
x = spec.spec_p
y = sim.counts
sigmaX = sqrt(x)
sigmaY = sqrt(y)
	
err = ( ( sigmaX/x )^2 + ( sigmaY/y )^2 ) * ( x/y )
	  
i=where( sim.energy_kev gt 4. and sim.energy_kev lt 8.)
chisq = sqrt( total( (spec.spec_p[i] /sim.counts[i]-1)^2/(n_elements(i)-1) ))
;xyouts, 5, 0.1, 'Chisq = '+ strtrim(chisq,2)

oplot, [2,10], [1.,1.], line=1
oplot, [4.,4.], [0.,2.]
oplot, [8.,8.], [0.,2.]

return, chisq

END