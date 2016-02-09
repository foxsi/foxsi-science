;@milo/scripts/flux
;
; scripts to estimate quiet Sun HXR limits
;

; Tasks:
; 1. examine flux from FOXSI data.
;
;
; Task 1:
; Get the count flux per area on Target 1 and Detector 6.

; Get counts in the "background" area of target 1/D6.
@foxsi-setup-script-2014
get_target_data, 1, d0,d1,d2,d3,d4,d5,d6
;; To do:  Check how to select an area from this routine (get_target)

d6 = d6[ where( d6.error_flag eq 0 ) ]
spec_bkgd = make_spectrum( d6, bin=2. )

; put it all into counts per second per keV, in 4-12 keV range.
; Also correct for area.

int1 = t1_pos0_end - t1_pos0_start
rate = total( spec_bkgd.spec_p[2:5] ) / int1
print,rate




