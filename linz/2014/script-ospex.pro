;
; Instructions from OSPEX documentation.
;

1.  Using OSPEX to fit a user array

To set data directly into OSPEX, you must use the command line to select the 'SPEX_USER_DATA' input strategy and input your data with commands like the following: 

o -> set, spex_data_source = 'SPEX_USER_DATA'
o -> set, spectrum = spectrum_array,  $
    spex_ct_edges = energy_edges, $
    spex_ut_edges = ut_edges, $
    errors = error_array, $
    livetime = livetime_array

where
spectrum_array - the spectrum or spectra you want to fit in counts, dimensioned n_energy, or n_energy x n_time.
energy_edges - energy edges of spectrum_array, dimensioned 2 x n_energy.
ut_edges - time edges of spectrum_array
   Only necessary if spectrum_array has a time dimension.  Dimensioned 2 x n_time.
error_array - array must match spectrum_array dimensions. If not set, defaults to all zeros.
livetime_array - array must match spectrum_array dimensions.  If not set, defaults to all ones.

You must supply at least the spectrum array and the energy edges.  The other inputs are optional.   By default, the DRM is set to a 1-D array dimensioned n_energy of 1s, the area is set to 1., and the detector is set to 'unknown'.  To change them, use commands like the following:

o -> set, spex_respinfo=2.    ; sets all elements of 1-D DRM (dimensioned by the same n_energy as above) to  2.
o -> set, spex_respinfo=fltarr(100,100)+.5    ; sets all elements of a  2-D DRM to .5
o -> set, spex_area=2.
o -> set, spex_detectors='mydetector'

Then you may continue with the widget interface, or with the command line interface.

NOTE 1:  If you had selected a DRM file previously, but don't want to use it, you must set spex_drm to a null string (i.e.,  o->set,spex_drm='' ).  If you do want to use the DRM from that file, it MUST match the data you input.

NOTE 2: The default value for spex_error_use_expected is 1, which means that the errors used in the fit are computed by combining the expected count rates with the background count rates and the systematic error, i.e. the errors on the data array are not used.  If you want to use the error you set into the object (they will still be combined with the systematic error), set this parameter to 0 (i.e.  o->set, spex_error_use_expected=0 )

; Additional note from Albert: At minimum, you'll need a 1D array for the spectrum
; (in counts) and a 2D array for the response matrix (in to-be-determined units).
;


;
; Based on this, my code for fitting FOXSI data with OSPEX!
; This is what I used to do the spectral fitting in summary made Sept 10 2015
;

det = 6

.run
case det of
	0: data = data_lvl2_d0
	1: data = data_lvl2_d1
	4: data = data_lvl2_d4
	5: data = data_lvl2_d5
	6: data = data_lvl2_d6
endcase
end

bin = 1.0
;spec1 = get_target_spectra( 1, year=2014, /good, bin=bin )
dat = area_cut(data, flare1, 150., /xy)
;t1 = t1_pos0_start + t_launch
;t2 = t1_pos0_end + t_launch
t1 = t1_pos2_start + t_launch
t2 = t1_pos2_end + t_launch
i6 = where(dat.wsmr_time gt t1 and dat.wsmr_time lt t2 and dat.error_flag eq 0)
spec = make_spectrum( dat[i6], bin=bin, /corr )

; if desired, correct for low-T plasma
; spec.spec_p[6] *= 2./3

i = where( spec.energy_kev gt 3. and spec.energy_kev lt 15. )
;enm = spec.energy_kev[i]+0.5
enm = spec.energy_kev[i]
;; adjust gain by hand.
;factor = 1.2
;enm = (enm - 5.9)*factor + 6.
en_lo = enm - deriv(enm)*0.5
en_hi = enm + deriv(enm)*0.5
en2 = transpose( [[en_lo],[en_hi]] )
spec_array = spec.spec_p[i]/38.5*3
resp = get_foxsi_effarea( energy_arr=enm, module=det )
diag = resp.eff_area_cm2 / max(resp.eff_area_cm2[where(resp.eff_area_cm2 ge 0.)])
ndiag = n_elements( diag )
nondiag = fltarr(ndiag,ndiag)
for j=0, ndiag-1 do nondiag[j,j]=diag[j]

.run
for j=0, ndiag-1 do begin
;	y = gaussian( findgen(ndiag), [diag[j],j,2.3*0.2/bin] )
	y = gaussian( findgen(ndiag), [diag[j],j,2.*0.2/bin] )
	;;;;;;; THIS NORMALIZATION IS WRONG!  NEEDS TO BE FIXED! ;;;;;;;;
	; ; if you fix the normalization it should take care of the factor of 2 in resolution! ; ;
	;y = y / total(y) * diag[j]
	nondiag[*,j] = y
endfor
end
;nondiag = transpose( nondiag )

;fwhm  = 0.5			; energy resolution
;sigma = fwhm / 2.355
;.run
;for j=0, ndiag-1 do begin
;	y = nondiag[*,j]*gaussian( findgen(ndiag), [0.3989*bin/sigma,j,sigma/bin] )
;	nondiag[*,j] = y
;endfor
;end



o = ospex()
o -> set, spex_data_source = 'SPEX_USER_DATA'
o -> set, spectrum = spec_array, spex_ct_edges = en2, errors = sqrt(spec_array/bin)
o -> set, spex_respinfo = nondiag
o -> set, spex_area = max(resp.eff_area_cm2[where(resp.eff_area_cm2 ge 0.)])

o-> set, fit_function= 'vth'
o-> set, fit_comp_params= [0.003, 1.0, 1.00000]                                
o-> set, fit_comp_free_mask= [1B, 1B, 0B]
o-> set, fit_comp_spectrum= ['full', '']
o-> set, fit_comp_model= ['chianti', '']
o-> set, spex_erange = [5.,12.]
o-> set, spex_fit_time_interval = [0.,3600.]

o->dofit


; plot results

save, p0, file='fit_flare1_t1_pos0.sav'
;P0 = spex_read_fit_results('ospex_results_northAR_t1_pos2.fits')
;save, p0, file='fit_northAR_t1_pos2.sav'

;ospex_plot_simple_vth, 'fit_flare1_t1_pos0.sav'

popen, 'ospex', xsi=7, ysi=8
ch=1.2
!p.multi=[0,1,2]
P0 = spex_read_fit_results('ospex_results_flare1_t1_pos0.fits')
en = get_edges( p0.spex_summ_energy, /mean )
conv = p0.spex_summ_conv*p0.spex_summ_area
counts = p0.spex_summ_ct_rate     ; / conv * nondiag
counterr = sqrt(counts/38.5)
big = where(counterr gt counts)
counterr[big] = counts[big]*0.9
fit = p0.spex_summ_ph_model
linecolors
plot, en, counts, psym=10, /xlo, /ylo, xr=[4.,15], yra=[1.e-2,1.e2], thick=8, /xsty, xth=2, yth=2, $
	xtit='Energy [keV]', ytit='Counts s!U-1!N keV!U-1!N', tit='Flaring AR', charsi=ch, charth=2
oplot_err, en, counts, yerr=counterr, psym=10, thick=8
oplot, en, fit*conv, psym=10, col=3, thick=8
oplot, [5,5,10,10], [1.e-2,1.e2,1.e2,1.e-2], line=1
al_legend, ['T = 10.7 MK', 'EM = 4.2x10!U44!N cm!U-3!N'], /right, box=0, charsi=1.3

P0 = spex_read_fit_results('ospex_results_northAR_t1_pos2.fits')
en = get_edges( p0.spex_summ_energy, /mean )
conv = p0.spex_summ_conv*p0.spex_summ_area
counts = p0.spex_summ_ct_rate     ; / conv * nondiag
counterr = sqrt(counts/38.5)
big = where(counterr gt counts)
counterr[big] = counts[big]*0.9
fit = p0.spex_summ_ph_model
counts[9]=0.
linecolors
plot, en, counts, psym=10, /xlo, /ylo, xr=[4.,15], yra=[1.e-2,1.e2], thick=8, /xsty, xth=2, yth=2, $
	xtit='Energy [keV]', ytit='Counts s!U-1!N keV!U-1!N', tit='Nonflaring AR', charsi=ch, charth=2
oplot_err, en, counts, yerr=counterr, psym=10, thick=8
oplot, en, fit*conv, psym=10, col=3, thick=8
oplot, [5,5,10,10], [1.e-2,1.e2,1.e2,1.e-2], line=1
al_legend, ['T = 10.2 MK', 'EM = 5.4x10!U43!N cm!U-3!N'], /right, box=0, charsi=1.3
pclose

IDL> help, p0
** Structure <2105008>, 31 tags, length=664, data length=650, refs=1:
   SPEX_SUMM_FIT_FUNCTION
                   STRING    'vth'
   SPEX_SUMM_AREA  FLOAT           21.8880
   SPEX_SUMM_ENERGY
                   FLOAT     Array[2, 12]
   SPEX_SUMM_TIME_INTERVAL
                   DOUBLE    Array[2]
   SPEX_SUMM_FILTER
                   INT       Array[1]
   SPEX_SUMM_FIT_DONE
                   BYTE      Array[1]
   SPEX_SUMM_EMASK BYTE      Array[12]
   SPEX_SUMM_CT_RATE
                   FLOAT     Array[12]
   SPEX_SUMM_CT_ERROR
                   FLOAT     Array[12]
   SPEX_SUMM_BK_RATE
                   FLOAT     Array[12]
   SPEX_SUMM_BK_ERROR
                   FLOAT     Array[12]                       
   SPEX_SUMM_PH_MODEL
                   FLOAT     Array[12]
   SPEX_SUMM_CONV  FLOAT     Array[12]
   SPEX_SUMM_RESID FLOAT     Array[12]
   SPEX_SUMM_STARTING_PARAMS
                   FLOAT     Array[3]
   SPEX_SUMM_PARAMS
                   FLOAT     Array[3]
   SPEX_SUMM_SIGMAS
                   FLOAT     Array[3]
   SPEX_SUMM_MINIMA
                   FLOAT     Array[3]
   SPEX_SUMM_MAXIMA
                   FLOAT     Array[3]
   SPEX_SUMM_FREE_MASK
                   BYTE      Array[3]
   SPEX_SUMM_FUNC_SPECTRUM
                   STRING    Array[1]
   SPEX_SUMM_FUNC_MODEL
                   < Press Spacebar to continue, ? for help >
