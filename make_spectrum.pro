FUNCTION	MAKE_SPECTRUM, DATA, BINWIDTH=BINWIDTH, PLOT=PLOT, STOP=STOP, $
			CORRECT = CORRECT

;	This function takes a FOXSI level 2 data structure and returns an energy spectrum.
;	
;	Inputs:
;		DATA:		FOXSI Level 2 data structure
;		BINWIDTH:	width of energy bins for spectrum
;		PLOT:		Function will also generate a plot
;		CORRECT:	Only take known good events.  Adjust scale to account for those excluded.
;
;	Return value:
;		Returns a structure with tags energy, n-side spectrum, and p-side spectrum.
;		Spectral units are counts per keV.
;
;	Example 1:
;
;		restore, 'foxsi_level2_data.sav',/v
;		i=where( data_level2_D6.error flag eq 0 )
;		spex = make_spectrum( data_level2_D6[i], binwidth=0.5 )
;		plot, spex.energy_kev, spex.spec_p, psym=10, xr=[0,15]
;
;	Example 2: (probably most used)
;
;		restore, 'foxsi_level2_data.sav',/v
;		spex = make_spectrum( data_level2_D6, binwidth=0.5, /corr )
;		plot, spex.energy_kev, spex.spec_p, psym=10, xr=[0,15]
;



	default, binwidth, 0.1
	
	if keyword_set(correct) then begin
		i = where(data.error_flag eq 0)
		data_good = data[i]
		ratio_good = float(n_elements(i)) / n_elements( data[where(data.inflight eq 1)])
	endif else begin
		data_good = data
		ratio_good = 1.
	end

	if keyword_set(stop) then stop

	energy = findgen(100/binwidth)*binwidth; + binwidth/2.
	spec_n = histogram( data_good.hit_energy[0], nbins=n_elements(energy), $
						min=min(energy), max=max(energy) ) / ratio_good / binwidth
	spec_p = histogram( data_good.hit_energy[1], nbins=n_elements(energy), $
						min=min(energy), max=max(energy) ) / ratio_good / binwidth

	spex = create_struct( 'energy_kev', energy, 'spec_n', spec_n, 'spec_p', spec_p )

	if keyword_set(plot) then plot, spex.energy_kev, spex.spec_p, psym=10, xr=[0,15]
	
	return, spex
	
END