FUNCTION	FOXSI_DEM_LOCI, LOGTE, ENERGY_BIN, AREA, TARGET=TARGET, DINDEX=DINDEX, $
			D0=D0, D1=D1, D2=D2, D3=D3, D4=D4, D5=D5, D6=D6, BLANKET_FACTOR=BLANKET_FACTOR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;												;;
;;	NO ADDITIONAL BLANKETING IS INCLUDED YET  	;;
;;												;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; INPUTS
;
;	LOGTE	Temperature bin array in log(T).  These should be the bin centers.
;	AREA	Area on the Sun from which the emission comes.
;	ENERGY_BIN	2-element array defining a single energy bin.
;
; KEYWORDS
;
;	TARGET	Value 1-6; which target data to include.  
;			(First target is 1; flare is 4 and 6.)	Default first target.
;	DINDEX	Detector mask; which detectors to include.  Default D4 only, in which
;			case resulting sensitivity curve is for one optic only.
;	DX		Flight data for a given detector.  If this is not provided, the
;			function will open the flight data file and restore the data.
;			Since it's time consuming to read in data, it's better to pass the data
;			from the calling script if multiple calls are performed.
;	BLANKET_FACTOR	Ad-hoc blanketing factor to include in the loci curve.
;			Should be % transmission through extra blanketing.  (Ex. 0.05)
;
; HISTORY
;	Created 10/22/2013	Linz
;

default, target, 1
default, dindex, [0,0,0,0,1,0,0]
default, blanket_factor, 1.

; Calculate temperature bin widths.
T = 10.^logte
dT=get_edges( T[1:*], /mean)-get_edges( T[0:n_elements(T)-2], /mean)
dT=[dT[0],dT,dT[n_elements(dT)-1]]

;
; Retrieve flight data for the target and detector(s) specified.
;

get_target_data, target, d0_targ, d1_targ, d2_targ, d3_targ, d4_targ, d5_targ, d6_targ, $
	d0_in=d0, d1_in=d1, d2_in=d2, d3_in=d3, d4_in=d4, d5_in=d5, d6_in=d6, $
	eband=energy_bin, /good, delta_t=delta_t

n_det = total(dindex)

if dindex[0] then data = d0_targ
if dindex[1] then if exist(data) eq 0 then data=d1_targ else data=[data,d1_targ]
if dindex[2] then if exist(data) eq 0 then data=d2_targ else data=[data,d2_targ]
if dindex[3] then if exist(data) eq 0 then data=d3_targ else data=[data,d3_targ]
if dindex[4] then if exist(data) eq 0 then data=d4_targ else data=[data,d4_targ]
if dindex[5] then if exist(data) eq 0 then data=d5_targ else data=[data,d5_targ]
if dindex[6] then if exist(data) eq 0 then data=d6_targ else data=[data,d6_targ]

if exist(data) eq 0 then begin
	print, 'No detectors selected.'
	return, -1
endif

; Count the hits in the desired energy bin.
; Divide by time on target to get cts / sec.
i = where( data.hit_energy[1] gt energy_bin[0] and $
		   data.hit_energy[1] le energy_bin[1], cts_meas)
cts_meas = double(cts_meas) / delta_t

; Revive this code later.
;; If desired, subtract a background.
;bkgd = [0.,0.,0., bkgd_off, fltarr(87)] * delta_t * 16.4^2
;spec_sum.spec_p -= bkgd

;; If desired, assume no detection and use 3-sigma of background as a limit.
;spec_sum.spec_p = bkgd + 3*sqrt(bkgd)

; Simulate FOXSI expected counts for each temperature bin.
; Use a 1.d49 EM -- this will be scaled to the correct value later in the procedure.
; Use freakishly small energy bins so that you can later add them to get the bin
; you want.

n_te = n_elements( logte )
cts_sim = dblarr( n_te )	; array to hold the simulated counts for each temperature bin.
spec_sim = foxsi_count_spectrum(1., 10./1.d6, binsize=0.05, time=1., /single)
i_en = where( spec_sim.energy_kev gt energy_bin[0] and spec_sim.energy_kev le energy_bin[1] )

; The simulation is done for a single optic (keyword /SINGLE).  cts_sim holds the # hits
; in the desired energy range, times the number of detectors we included in the measurement
; ( total(dindex) ).
for i=0, n_te-1 do begin
	spec_sim = foxsi_count_spectrum(1., T[i]/1.d6, binsize=0.05, time=1., /single)
	cts_sim[i] = total( spec_sim.counts[i_en] ) * total(dindex)
endfor

; Calculate dEM.  Earlier we assumed an EM of 1.d49 cm^-5 for the simulations.
; The ratio of measured to simulated counts tells us how much to adjust the EM 
; to match well for a particular energy bin.
; Divide by area and temperature width to get dEM in units of cm^-5.

dem = dblarr( n_te )
for i=0, n_te-1 do begin
	dem[i] = cts_meas / cts_sim[i] *1.d49 / area
endfor

; Correct for blanketing absorption, if desired.
dem = dem / blanket_factor

return, dem

END