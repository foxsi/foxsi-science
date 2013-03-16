;----------------------------------------------------------------------------
	function closest, array, value
;+
; NAME:
;	CLOSEST
;
; PURPOSE:
;	Find the element of ARRAY that is the closest in value to VALUE
;
; CATEGORY:
;	utilities
;
; CALLING SEQUENCE:
;	index = CLOSEST(array,value)
;
; INPUTS:
;	ARRAY = the array to search
;	VALUE = the value we want to find the closest approach to
;
; OUTPUTS:
;	INDEX = the index into ARRAY which is the element closest to VALUE
;
;   OPTIONAL PARAMETERS:
;	none
;
; COMMON BLOCKS:
;	none.
; SIDE EFFECTS:
;	none.
; MODIFICATION HISTORY:
;	Written by: Trevor Harris, Physics Dept., University of Adelaide,
;		July, 1990.
;
;-

	if (n_elements(array) le 0) or (n_elements(value) le 0) then index=-1 $
	else if (n_elements(array) eq 1) then index=0 $
	else begin
		abdiff = abs(array-value)	 ;form absolute difference
		mindiff = min(abdiff,index)	 ;find smallest difference
	endelse

	return,index
	end

