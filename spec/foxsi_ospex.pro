PRO foxsi_ospex, filename, det=det, bin=bin, erange=erange, $
		trange=trange, center=center, radius=radius, offaxis=offaxis, $
		cen_map=cen_map,fwhm=fwhm, let_file=let_file, type=type, $
		split_limit=split_limit, three=three, single=single, year=year, $
		stop=stop, _extra=_extra  

;
; PURPOSE: 
;	Perform spectral fitting on FOXSI data using an optically thin thermal plasma
;	model. This procedure produces two files: a FITS file with the ospex spectral 
;	fitting results and an IDL .sav file with the livetime and ratio of good events 
;	to all events.
;
;
; INPUT :
;
;	FILENAME : 	name for output files (string)
;
;
; KEYWORDS : 
;
;	DET :		detector number (0,1,3,4,5,6) 	
;	BIN : 		bin width (keV)
;	ERANGE :	energy range for spectral fit [e_start,e_end] (keV)
;	TRANGE : 	time range [t_start,t_end] (seconds since launch)
;	CENTER :	source center (heliospheric coordinates, arcsec)
;	RADIUS :	radius of circular region used for spectrum (arcsec)
;	OFFAXIS :	offaxis angle of source (arcmin) 
;	CEN_MAP :	map center for selected target
;	FWHM :		energy resolution (FWHM; keV)
;	LET_FILE : 	data file to use for low energy threshold efficiency
;	TYPE : 		detector type ('si' or 'cdte')
;	SPLIT_LIMIT : 	threshold on each strip for the three-strip case
;	THREE : 	if set, return the summed energy from all three strips, not just the highest value
;	YEAR :		year of FOXSI flight (2012, 2014, or 2018)
;	STOP : 		if set, stop procedure before exiting
;
;
; NOTES : 
;	
;	Not yet adapted for FOXSI-1 or FOXSI-3 data. 
;	Best used on data from FOXSI-2 flight.
;
; EXAMPLE :
;
;	foxsi_ospex, 'example_spectral_analysis', det=5, bin=0.5, erange = [5.,8.], $
;		trange = [t1_pos2_start, t1_pos2_end], center = flare1, radius = 100., $
;		offaxis = 0.4, cen_map = cen1_pos2, fwhm = 0.5, let_file = 'efficiency_averaged.sav', $
;		type = 'si'  
;	fit_results = spex_read_fit_results('example_spectral_analysis.fits') 	;read fit results 
;
;
; HISTORY :
;
;	July 2018	Edited by Julie Vievering to incorporate analysis of CdTe data
;	August 2017	Adapted by Julie Vievering from Lindsay Glesener's original code.
;

COMMON FOXSI_PARAM

; default values
default, det, 6
default, bin, 1.0
default, erange, [5.,8.]
default, trange, [t1_pos2_start,t1_pos2_end]
default, center, flare1
default, radius, 150.
default, offaxis, 0.
default, cen_map, cen1_pos2
default, fwhm, 0.5
default, type, 'si'
default, split_limit, 3.
default, year, 2014

;Check for incorrect entries 

if (det eq 2) and (year eq 2014) then begin
	print, 'ERROR: No usable data from detector 2 during the FOXSI-2 flight.'
	print, '       Please select a different detector (0,1,3,4,5,6).'
	return
endif

if (year eq 2012) or (year eq 2012) then begin
	print, 'ERROR: This code is not yet adapted for FOXSI-1 or FOXSI-3.'
	return
endif

if (year ne 2012) and (year ne 2014) and (year ne 2018) then begin
	print, 'ERROR: Invalid year.'
	return
endif 

if (type ne 'si') and (type ne 'cdte') then begin
	print, 'ERROR: Detector type is not allowed. Please select si or cdte.'
	return
endif

; select detector for analysis
case det of
	0: data = data_lvl2_d0
	1: data = data_lvl2_d1
	3: data = data_lvl2_d3
	4: data = data_lvl2_d4
	5: data = data_lvl2_d5
	6: data = data_lvl2_d6
endcase

;select region of interest
dat = area_cut(data, center, radius, /xy)

; time cuts
t1 = trange[0] + t_launch
t2 = trange[1] + t_launch
ltime = t2 - t1		;livetime 
i2 = where(dat.wsmr_time gt t1 and dat.wsmr_time lt t2)	;data in time range
i3 = where(dat.wsmr_time gt t1 and dat.wsmr_time lt t2 and dat.error_flag eq 0)	;good data

; create map
if type eq 'cdte' then begin
	map = foxsi_image_map(dat[i3],cen_map,/xy,/cdte)
endif else begin
	map = foxsi_image_map(dat[i3],cen_map,/xy)
endelse

; make energy spectrum (all events in time range)
spec_all = make_spectrum( dat[i2], bin=bin )

; only use good single-strip events
if keyword_set(single) then spec = make_spectrum( dat[i3], bin=bin,/single,split_limit=split_limit) $
        else spec = make_spectrum( dat[i3], bin=bin)

; sum signal over three strips for each good event
if keyword_set(three) then spec = make_spectrum( dat[i3], bin=bin,/three,split_limit=split_limit) $
        else spec = spec

; energy range for counts spectrum
i = where( spec.energy_kev gt 3. and spec.energy_kev lt 15. )
enm = spec.energy_kev[i]
en_lo = enm - deriv(enm)*0.5
en_hi = enm + deriv(enm)*0.5
en2 = transpose( [[en_lo],[en_hi]] )

eff = total(spec.spec_p[i])/total(spec_all.spec_p[i])   ;ratio of good events to all events in time range (p-side)
;eff_n = total(spec.spec_n[i])/total(spec_all.spec_n[i]) 	;ratio of good events to all events in time range (n-side) 

; create response matrix
resp = get_foxsi_effarea( energy_arr=enm, module=det, offaxis_angle=offaxis, $
	let_file=let_file, type=type, _extra = _extra )
max_EA = max(resp.eff_area_cm2[where(resp.eff_area_cm2 ge 0.)])	;determine maximum effective area
;normalize effective area and multiply by ratio of good to all events
diag = resp.eff_area_cm2 * eff / max_EA	
ndiag = n_elements( diag )	
nondiag = fltarr(ndiag,ndiag)	;create array for nondiagonal response

for j=0, ndiag-1 do nondiag[j,j]=diag[j]	;set diagonal of nondiag to the diagonal response (cm^2)
sigma = fwhm / 2.355		; energy resolution
toty = total(gaussian(findgen(ndiag),[0.3989*bin/sigma,round((12./(2*bin))-1.),sigma/bin] ))
        ; toty is a sum of the values of a normalized Gaussian function binned according to the set 'bin' keyword.
        ; The standard deviation for the Gaussian is normalized to the bin size (sigma/bin).
        ; toty should be equal to one, but is slightly off due to rounding.

; compute the nondiagonal response by convolving diagonal response with a Gaussian
for j=0, ndiag-1 do begin
	y = diag[j]*gaussian( findgen(ndiag), [0.3989*bin/sigma,j,sigma/bin] )/toty
                ; y is the convolution of the diagonal response value diag[j] with a
                ; Gaussian function of standard deviation sigma/bin.
                ; The values are normalized using toty (described above).
	nondiag[*,j] = y
endfor

;create livetime array
livetime_array = fltarr(ndiag)
livetime_array[*] = ltime  

; run ospex for spectral analysis
o = ospex(/no_gui)
o -> set, spex_data_source = 'SPEX_USER_DATA'
o -> set, spectrum = spec.spec_p[i]*bin, spex_ct_edges = en2, errors = spec.spec_p_err[i]*bin,livetime=livetime_array
o -> set, spex_respinfo = nondiag/bin
o -> set, spex_area = max_EA

; optically thin thermal plasma model (isothermal)
o-> set, fit_function= 'vth'	
o-> set, fit_comp_params= [0.003, 1.0, 1.00000]                                
o-> set, fit_comp_free_mask= [1B, 1B, 0B]
o-> set, fit_comp_spectrum= ['full', '']
o-> set, fit_comp_model= ['chianti', '']
o-> set, spex_erange = erange
o-> set, spex_fit_time_interval = [0.,3600.]

o-> set, spex_fit_manual=0
o-> set, spex_autoplot_enable=1

o-> dofit
o-> savefit, outfile = filename+'.fits'

save, eff, ltime, filename=filename+'.sav'

if keyword_set(stop) then stop

end
