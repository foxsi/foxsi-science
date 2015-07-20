FUNCTION	MAKE_SPECTRUM, DATA, BINWIDTH=BINWIDTH, PLOT=PLOT, STOP=STOP, $
			CORRECT = CORRECT, THREE = THREE, SPLIT_LIMIT = SPLIT_LIMIT

;	This function takes a FOXSI level 2 data structure and returns an energy spectrum.
;	
;	Inputs:
;		DATA:		FOXSI Level 2 data structure
;		BINWIDTH:	width of energy bins for spectrum
;		PLOT:		Function will also generate a plot
;		CORRECT:	Only take known good events.  Adjust scale to account for those excluded.
;		THREE:		If set, return the summed energy from all three strips, 
;					not just the highest value (default 0)
;		SPLIT_LIMIT:	threshold on each strip for the three-strip case.
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
;	History
; 	2012-jul-19  LG		Fixed a bug in which energy array was 1 larger than spectrum array.
;-


	default, binwidth, 0.1
	default, split_limit, 3.
	
	if keyword_set(correct) then begin
		i = where(data.error_flag eq 0)
		data_good = data[i]
		ratio_good = float(n_elements(i)) / n_elements( data[where(data.inflight eq 1)])
	endif else begin
		data_good = data
		ratio_good = 1.
	end

	energy = findgen(100/binwidth)*binwidth

	spec_n = histogram( data_good.hit_energy[0], nbins=n_elements(energy)-1, $
						min=min(energy), max=max(energy), omin=omin, omax=omax )
	spec_p = histogram( data_good.hit_energy[1], nbins=n_elements(energy)-1, $
						min=min(energy), max=max(energy) )

	if keyword_set(stop) then stop
	
	if keyword_set(three) then begin

		i=where( data_good.assoc_energy[0,1,0] gt split_limit )
		spec_n = spec_n + histogram( data_good[i].assoc_energy[0,1,0], $
									 nbins=n_elements(energy), min=min(energy), $
									 max=max(energy) )
		i=where( data_good.assoc_energy[2,1,0] gt split_limit )
		spec_n = spec_n + histogram( data_good[i].assoc_energy[2,1,0], $
									 nbins=n_elements(energy), min=min(energy), $
									 max=max(energy) )
		i=where( data_good.assoc_energy[1,0,1] gt split_limit )
		spec_p = spec_p + histogram( data_good[i].assoc_energy[1,0,1], $
									 nbins=n_elements(energy), min=min(energy), $
									 max=max(energy) )
		i=where( data_good.assoc_energy[1,2,1] gt split_limit )
		spec_p = spec_p + histogram( data_good[i].assoc_energy[1,2,1], $
									 nbins=n_elements(energy), min=min(energy), $
									 max=max(energy) )
	endif

	p_error = sqrt( spec_p )

	; Correct for thrown-out events and bin width.
	spec_n = spec_n / ratio_good / binwidth
	spec_p = spec_p / ratio_good / binwidth
	p_error = p_error / ratio_good / binwidth

;	energy = energy + binwidth/2.
	energy = get_edges( energy, /mean )  ; make energy array the midpoints of the bins.

	spex = create_struct( 'energy_kev', energy, 'spec_n', spec_n, 'spec_p', spec_p, $
						  'spec_p_err', p_error )

	if keyword_set(plot) then plot, spex.energy_kev, spex.spec_p, psym=10, xr=[0,15]

	return, spex
	
END