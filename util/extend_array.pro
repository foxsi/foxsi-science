; $Id: extend_array.pro, v 1.1 Jan 2000 e.d. $
;
;+
; NAME:
;	EXTEND_ARRAY
;
; PURPOSE:
;	Pad 2D array with 0s.
;
; CATEGORY:
;	Array manipulation.
;
; CALLING SEQUENCE:
;	Result = EXTEND_ARRAY(Array, S0, S1)
;
; INPUTS:
;	Array:	Array to be 0-padded
;
;	S0:	Size of extended array
;
; OPTIONAL INPUTS:
;	S1:	Second (y-) size of extended array. The default is S1 = S0
;
; KEYWORD PARAMETERS:
;	NO_OFF: 	Set this keyword to a nonzero value to indicate that the
;		input array must not be centered in the final frame. In this case
;		the element [0,0] of the output array coincides with the element
;		[0,0] of the input
;
;	POW2:	Set this keyword to a nonzero value to indicate that the array
;		size must be extended to the nearest power of 2. In this case, the
;		input values of S0 and S1 are overriden
;
; OUTPUTS:
;	Result:	0-padded array. If the keyword NO_OFF is not set, the original
;		array is centered in the final frame.
;		The input array is returned if the requested output size is smaller
;		than the input size
;
; OPTIONAL OUTPUTS:
;	OFFSET:	Use this output keyword to retrieve a 2-components vector with
;		the x- and y- offsets of the [0, 0] element of the input array
;		in the final frame
;
; SIDE EFFECTS:
;	If POW2 is set, the input values of S0 and S1 are overridden. If S0 and
;	S1 are named variables, their values are overwritten.
;
; RESTRICTIONS:
;	Apply only to 2D arrays.
;
; MODIFICATION HISTORY:
; 	Written by:	Emiliano Diolaiti, August 1999.
;	Updates:
;	1) Fixed bug on keyword POW2 (Emiliano Diolaiti, January 2000).
;-

FUNCTION extend_array, array, s0, s1, NO_OFF = no_off, POW2 = pow2, OFFSET = o

	on_error, 2
	if  size52(array, /N_DIM) ne 2  then  return, array
	if  n_params() eq 1 and not keyword_set(pow2)  then  return, array $
	else  if  n_params() eq 2  then  s1 = s0
	s = size52(array, /DIM)
	if  keyword_set(pow2)  then begin
	   l = log2(s0)  &  if  2^l ne s0  then  s0 = 2^(l + 1)
	   l = log2(s1)  &  if  2^l ne s1  then  s1 = 2^(l + 1)
	endif
	if  s0 eq s[0] and s1 eq s[1] or s0 lt s[0] or s1 lt s[1]  then begin
	   array1 = array  &  o = [0, 0]
	endif else begin
	   if  keyword_set(no_off)  then  o = [0, 0] $
	   else begin
	      o = [s0, s1] - s  &  o = (o + o mod 2) / 2
	   endelse
	   array1 = make_array(s0, s1, TYPE = size52(array, /TYPE))
	   array1[o[0],o[1]] = array
	endelse
	return, array1
end
