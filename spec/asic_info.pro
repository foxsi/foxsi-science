;+
; ASIC_INFO
;
; This procedure examines a FOXSI Level 1 or 2 data file and prints information about
; which ASICs are returning the data.  For example, if the data handed to this procedure
; is from a flare, the procedure printout will tell you which p-side ASIC the flare hit.
; If the count flux is spread out across the detector (e.g. ghost rays), the counts will
; be more evenly split between the two ASICs.
;
; This procedure is useful in determining which detector efficiency file to use in
; reconstructing photon spectra.
;
; Should work for FOXSI-1 or FOXSI-2.  Silicon detectors only! 
;
; Inputs:	DATA	A FOXSI Level 1 or Level 2 data structure.
;
; History:
;			2015 June 16	Linz	Created routine
;-

PRO		ASIC_INFO, DATA, STOP=STOP

	n = n_elements(data)

	p_coord = data.hit_xy_det[0]
	n_coord = data.hit_xy_det[1]
	
	p_asic = intarr(n) + 3
	n_asic = intarr(n)
	
	p_asic[ where(p_coord lt 64) ] = 2
	n_asic[ where(n_coord lt 64) ] = 1

	num_0 = n_elements( where(n_asic eq 0) )
	num_1 = n_elements( where(n_asic eq 1) )
	num_2 = n_elements( where(p_asic eq 2) )
	num_3 = n_elements( where(p_asic eq 3) )
	
	print, 'P-side ASICs:'
	print, '   ', float(num_2)/n*100, '% ASIC 2
	print, '   ', float(num_3)/n*100, '% ASIC 3
	print, 'N-side ASICs:'
	print, '   ', float(num_0)/n*100, '% ASIC 0
	print, '   ', float(num_1)/n*100, '% ASIC 1
	
	if keyword_set( stop ) then stop

END