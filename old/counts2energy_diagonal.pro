FUNCTION COUNTS2ENERGY_DIAGONAL, DATA, PEAKSFILE=PEAKSFILE, THRESH_P, THRESH_N, $
	BINWIDTH = BINWIDTH, NBIN = NBIN, BADCH = BADCH, NMAX = NMAX

; Function to convert FOXSI Level 0 flight data from count space to energy space.
; 
; Inputs:
;	DATA:		FOXSI level 0 data structure
;	PEAKSFILE:	File containing calibration data for a single detector
;	THRESH_P:	Skip data below this p-side threshold
;	THRESH_N:	Same for n-side
;	BINWIDTH:	Energy bin size
;	NBIN:		Number of energy bins
;	BADCH:		4x64 array flagging bad channels
;	NMAX:		If set, stop at this event.
;
; Example script:
;
;	restore, 'data_2012/foxsi_level0_data.sav'
;	lvl0 = data_D6
;	restore, 'data_2012/foxsi_level1_data.sav'
;	lvl1 = data_D6
;	i=where(lvl1.error_flag eq 0)
;	data = lvl0[i]
;	spec_D6 = counts2energy_diagonal( data, peaksfile='detector_data/peaks_det106.sav' )
;	save, spec_D6, file = 'basic_spectra.sav'
;

	default, peaksfile, 'peaks.sav'
	default, thresh_p, 3.0
	default, thresh_n, 4.0
	default, binwidth, 0.1
	default, nbin, 1000
	default, badch, intarr(4,64)

	if file_search(peaksfile) ne '' then restore, peaksfile else begin
		print, 'Peaks file not found.'
		return, -1
	endelse

	n_evts = n_elements(data)
  	print, n_evts, ' total events'

  	spec = fltarr(nbin, 4, 2)	; this will hold the final spectrum product

	cmn = data.common_mode + randomu(seed,[4,n_evts]) - 0.5

	for as=0, 3 do begin
    	for ch =0, 64 do spec[*, as, 0] = (findgen(nbin)+0.5)*binwidth   
	endfor

    if keyword_set(nmax) then n_evts = nmax
    ngood=long(0)

    for evt = long(0), n_evts-1 do begin
        
        if (evt mod 1000) eq 0 then print, 'Event  ', evt, ' / ', n_evts

		edep = fltarr(4)
        
        for as = 0, 3 do begin
            for ch = 0, 63 do begin
            	; if this channel isn't included in the data then skip it.
				j = where( data[evt].strips[as,*] eq ch )
				if j[0] eq -1 or n_elements(j) gt 1 then continue

				; do the energy calibration and record the energy deposited in this strip.
                edep[as] = edep[as] + spline( peaks[*,ch,as,0],peaks[*,ch,as,1],data[evt].adc[as,j] - cmn[as,evt] )                    

            endfor

			; Got the deposited energy -- now add it to the histogram.
			k = where( spec[*,as,0] gt edep[as] )
			if k[0] gt -1 then spec[k[0],as,1] = spec[k[0],as,1] + 1
;			if edep[as] lt 100 then stop

        endfor

    endfor

  window, xsize = 800, ysize = 600
  ;x_axis = indgen(1124)-100
 !p.multi = [0, 2, 2]
  mm = max(spec[1:nbin-1,*,1])
  plot, spec[*,0,0],spec[*,0,1], xrange = [0, 20], yrange = [0, mm], $
    xtitle = 'ASIC 0',ytitle='counts/keV', psym = 10
  plot, spec[*,1,0],spec[*,1,1], xrange = [0, 20], yrange = [0, mm], $
    xtitle = 'ASIC 1',ytitle='counts/keV', psym = 10
  plot, spec[*,2,0],spec[*,2,1], xrange = [0, 20], yrange = [0, mm], $
    xtitle = 'ASIC 2',ytitle='counts/keV', psym = 10
  plot, spec[*,3,0],spec[*,3,1], xrange = [0, 20], yrange = [0, mm], $
    xtitle = 'ASIC 3',ytitle='counts/keV', psym = 10

  
  return, spec
  
END
