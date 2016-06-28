FUNCTION FOXSI2_COUNT_SPECTRUM, EM, T, TIME=TIME, BINSIZE=BINSIZE, STOP=STOP, $
	DATA_DIR = data_dir, MODULE_NUM= module_num, OFFAXIS=OFFAXIS, $
	SMEAR = SMEAR

; General function for computing FOXSI-2 expected count rates, no imaging.  
; Note that no field of view is taken into account here.  
; If the plasma is a whole-disk plasma, need to adjust for FOV.  
; If source area is smaller than FOV then no correction needed.  
; No energy resolution is considered in this simulation.
; Livetime is not considered.
; 
; Return value: Structure containing the energy vector, count vector, and count uncertainty vector.
;
; INPUTS:
;
;	EM: 	 	emission measure in units of 10.^49 cm^-3
;	T:  	 	temperature in MK (Yes, it's MK!  Sorry but can't be changed now.)
;	TIME:  	 	time interval for observation, in seconds (Default 1 sec)
;	BINSIZE: 	width of energy bins (Default 0.5 keV)
;	DATA_DIR: 	directory where calibration data is stored
;	MODULE_NUM: 	
;	OFFAXIS:	off-axis angle in arcmin.  (Default 0.0)
;	SMEAR:		if set, smear the counts to simulate imperfect energy resolution.
;
; History: 	
;			Linz 	8/31/2015	Created for FOXSI-2 (based on FOXSI-1 version)
;			Linz	2/6/2014	Added FOXSI2 keyword
;			Linz	9/5/2013 	Updated
;	 		Linz	Created summer 2012
;
; Example: 
;
; 	f = foxsi_count_spectrum(3.e-5,7.,time=60)
; 	plot, f.energy_kev, f.counts, psym=10, /xlog, /ylog
; 	ploterr,f.energy_kev,f.counts,fltarr(20),f.count_error,psym=10,/xlog, $
;       /ylog,yr=[1.e-1,1.e3],xr=[1,20],xstyle=1
;

default, time, 1.
default, binsize, 0.5
default, offaxis, 0.

; Set up energy bins 0-20 keV. These bins are finer than those desired!!
e1 = dindgen(2000)/100
e2 = get_edges(e1,/edges_2)
emid = get_edges(e1,/mean)
ewid = get_edges(e1,/width)

TEMP = T/11.6      ; switch temperature to units of keV

; f_vth won't work if you include energies below 1 keV.
; Only simulate above 2 keV.
i=where( emid gt 2. )
flux = dblarr( n_elements(emid) )
flux[i] = f_vth(e2[*,i], [EM, TEMP, 1.])		; compute thermal X-ray flux
flux[ where( emid le 2 ) ] = sqrt(-1)

; note to self: there's a peak above 2.5 keV for T=7MK. Should there be a line there at this temperature?

;
; Get FOXSI response
;

area = get_foxsi_effarea( $
		energy=emid, module_num = module_num, use_theoretical=use_theoretical, $
		offaxis_angle=offaxis, _extra=_extra )

if keyword_set(stop) then stop

; fold flux with FOXSI response
counts = flux*area.eff_area_cm2  ; now the units are counts per second per keV

; Smear to account for imperfect energy resolution (~0.5 keV).
if keyword_set(smear) then begin
	i=where( emid gt 3. and emid lt 30. )
	nbins = 0.5 / average(ewid)
	ni = n_elements(i)
	s = smooth( flux[i], nbins )
	if i[ni-1] gt (n_elements(flux)-1) then flux2 = [flux[0:i[0]-1],s] $
		else flux2 = [flux[0:i[0]-1],s,flux[ni+1:n_elements(flux)-1]]
endif


; use coarser, user-specified energy bins
e1_coarse = findgen(20./binsize+1)*binsize
emid_coarse = get_edges(e1_coarse, /mean)
counts_coarse = interpol(counts, emid, emid_coarse)	; units still in counts / sec / keV

counts_coarse = counts_coarse*time		; Now units are counts / keV
y_err_raw = sqrt(counts_coarse)				; units also in counts / keV


result = create_struct("energy_keV", emid_coarse, $
			 		   "counts", counts_coarse, $
			 		   "count_error", y_err_raw)

return, result

END
