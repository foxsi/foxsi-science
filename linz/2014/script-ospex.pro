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

; Additional note from Albert: At minimum, you'll need a 1D array for the spectrum (in counts) and a 2D array for the response matrix (in to-be-determined units).
;


;
; Based on this, my code for fitting FOXSI data with OSPEX.
;

spec1 = get_target_spectra( 1, year=2014, /good )
enm = spec1[6].energy_kev[0:49]
en_lo = enm - deriv(enm)*0.5
en_hi = enm + deriv(enm)*0.5
en2 = transpose( [[en_lo],[en_hi]] )
spec_array = spec1[6].spec_p[0:49]
resp = get_foxsi_effarea( energy_arr=enm, module=6 )
diag = resp.eff_area_cm2 / max(resp.eff_area_cm2[where(resp.eff_area_cm2 ge 0.)])

o = ospex()
o -> set, spex_data_source = 'SPEX_USER_DATA'
o -> set, spectrum = spec_array, spex_ct_edges = en2
o -> set, spex_respinfo = diag
o -> set, spex_area = max(resp.eff_area_cm2[where(resp.eff_area_cm2 ge 0.)])

o-> set, fit_function= 'vth'
o-> set, fit_comp_params= [1., 1.0, 1.00000]                                
o-> set, fit_comp_free_mask= [1B, 1B, 0B]
o-> set, fit_comp_spectrum= ['full', '']				; Or maybe continuum only, 'cont'
o-> set, fit_comp_model= ['mewe', '']
o-> set, spex_erange = [4.,8.]
o-> set, spex_fit_time_interval = [0.,3600.]

o->xfit
