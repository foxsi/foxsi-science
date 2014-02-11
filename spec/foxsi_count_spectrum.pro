FUNCTION FOXSI_COUNT_SPECTRUM, EM, T, TIME=TIME, BINSIZE=BINSIZE, STOP=STOP, $
	DATA_DIR = data_dir, LET_FILE = let_file, SINGLE = SINGLE, OFFAXIS=OFFAXIS, $
	FOXSI2 = FOXSI2

; General function for computing FOXSI expected count rates, no imaging.  
; Note that no field of view is taken into account here.  
; If the plasma is a whole-disk plasma, need to adjust for FOV.  
; If source area is smaller than FOV then no correction needed.  
; No energy resolution is considered in this simulation.
; Livetime is not considered.
; 
; Return value: Structure containing the energy vector, count vector, and count uncertainty vector.
;
;	EM: 	 emission measure in units of 10.^49 cm^-3
;	T:  	 temperature in MK (Yes, it's MK!  Sorry but can't be changed now.)
;	TIME:  	 time interval for observation, in seconds (Default 1 sec)
;	BINSIZE: width of energy bins (Default 0.5 keV)
;	LET_FILE:	detector efficiency file to use. (Default "average" LET.)
;	SINGLE:	scale counts for a single module only (as opposed to all 7)
;	OFFAXIS:	off-axis angle in arcmin.  (Default 0.0)
;
; History: 	
;			Linz	2/6/2014	Added FOXSI2 keyword
;			Linz	9/5/2013 	Updated
; 			Linz	Created summer 2012
;

default, time, 1.
default, binsize, 0.5
default, let_file, 'efficiency_averaged.sav'
default, data_dir, 'detector_data/'
default, offaxis, 0.

; Set up energy bins 0-20 keV. These bins are finer than those desired!!
e1 = dindgen(2000)/100
e2 = get_edges(e1,/edges_2)
emid = get_edges(e1,/mean)

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

; First, get area for individual factors (optics area, detector efficiency (inc. LET), 
; off-axis response, blanketing absorption).  These results are not used but these
; lines are easy to borrow for analyzing payload elements individually.

area_bare =    get_foxsi_effarea( $ 	; optics only
		energy=emid, data_dir=data_dir, /nodet, /noshut, /nopath)
area_blankets =get_foxsi_effarea( $ 	; optics + blankets
		energy=emid, data_dir=data_dir, /nodet, /noshut)
area_det = 	   get_foxsi_effarea( $ 	; optics + detectors
		energy=emid, data_dir=data_dir, /noshut, /nopath, let_file=let_file)
area_offaxis = get_foxsi_effarea( $		; optics + off-axis response factor
		energy=emid, data_dir=data_dir, /nodet, /noshut, /nopath, offaxis_angle=7.0)

; Now, the full response.  This is the one we'll use.
area = get_foxsi_effarea( $
		energy=emid, data_dir=data_dir, let_file=let_file , $
		offaxis_angle=offaxis, foxsi2=foxsi2 )

if keyword_set(stop) then stop

; fold flux with FOXSI response
counts = flux*area.eff_area_cm2  ; now the units are counts per second per keV
;counts = counts*binsize		 ; now the units are counts per second. DONT USE!

; use coarser, user-specified energy bins
e1_coarse = findgen(20./binsize+1)*binsize
emid_coarse = get_edges(e1_coarse, /mean)
counts_coarse = interpol(counts, emid, emid_coarse)	; units still in counts / sec / keV

if keyword_set(single) then n=1. else n=7.
counts_coarse = counts_coarse*time/7.*N		; Now units are counts / keV
y_err_raw = sqrt(counts_coarse)				; units also in counts / keV


; Leftover code.  This is up to the user to do herself.

;; if uncertainty is 100% or greater, kill it.
;i=where(y_err_raw gt counts_coarse)
;if i[0] gt -1 then begin
;	counts_coarse[i] = sqrt(-1)
;	y_err_raw[i] = sqrt(-1)
;endif

; Leftover code used for smearing to simulate imperfect energy resolution.
; Not used here.

;; smear with a Gaussian for imperfect energy resolution.
;i = where( counts_coarse gt 0 )
;if i[0] ne -1 then begin
;	print, total(counts_coarse[i])
;	print,i
;	i = i[1:n_elements(i)-2]
;	print,i
;	n = n_elements(counts_coarse)
;	adjust = fltarr(n)
;	adjust[i] = adjust[i] + 0.15*counts_coarse[i+1]
;	adjust[i] = adjust[i] + 0.15*counts_coarse[i-1]
;	adjust[i] = adjust[i] - 0.3*counts_coarse[i]
;	counts_coarse = counts_coarse + adjust
;	print, total(counts_coarse[i])
;endif else counts_coarse = fltarr(n_elements(counts_coarse))

result = create_struct("energy_keV", emid_coarse, $
			 		   "counts", counts_coarse, $
			 		   "count_error", y_err_raw)

return, result

END

; example of plotting
; f = foxsi_count_spectrum(3.e-5,7.,time=60)
; plot, f.energy_kev, f.counts, psym=10, /xlog, /ylog
; ploterr,f.energy_kev,f.counts,fltarr(20),f.count_error,psym=10,/xlog, $
;	/ylog,yr=[1.e-1,1.e3],xr=[1,20],xstyle=1
