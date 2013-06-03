PRO		DRAW_FOV, DET=DET, ALL=ALL, GOOD=GOOD, TARGET=TARGET, XYCOR=XYCOR, _EXTRA=_EXTRA

; This procedure draws the detector FOV on a previously plotted FOXSI map.
; DET keyword can take two forms:
;		-- Single number; in this case the FOV for the stated detector is drawn.
;		-- Index array; in this case FOVs for the indexed det's are drawn.
;		-- There is no default.
;
; Other keywords (shortcuts):
;	ALL:	same as setting DET=[1,1,1,1,1,1,1]
;	GOOD:	same as setting DET=[1,0,1,0,1,1,1]
;
; The TARGET keyword can take the values 1-6 and refers to a numbered target during
; the FOXSI flight.  The first target is Target 1.  The flare is on Targets 4 and 6.
; ***If the TARGET keyword is not set, the values are returned in PAYLOAD COORDINATES***

; figure out which det(s) we're dealing with
det_arr = bytarr(7)
if keyword_set(all)  then det_arr = [1,1,1,1,1,1,1]
if keyword_set(good) then det_arr = [1,0,1,0,1,1,1]
if not keyword_set(all) and not keyword_set(good) then begin
	case n_elements(det) of
		1: det_arr[det]=1
		7: det_arr = det
		else: begin
			print, 'Detector keyword must have 1 or 7 elements'
			return
		endelse
	endcase
endif
if total(det_arr) eq 0 then begin
	print, 'No detector selected.'
	return
endif
if total(det_arr) gt 7 then begin
	print, 'Unacceptable detector input'
	return
endif

if not keyword_set(target) then print, 'NO TARGET SET, DRAWING FOV IN PAYLOAD COORDS!'

; set up array of pixels (4 corners of the detector)
x = [0,0,127,127,0]
y = [0,127,127,0,0]

if keyword_set(xycor) then xerr=$
	[  55.4700,  81.490,   96.360,  87.8900,  48.2700,   49.550,   63.450] $
	else xerr = [0.,0.,0.,0.,0.,0.,0.]
if keyword_set(xycor) then yerr=$
	[-135.977, -131.124, -130.241, -92.7310, -95.3080, -120.276, -106.360] $
	else yerr = [0.,0.,0.,0.,0.,0.,0.]

target_centers = [[-480,-350], [-850,150], [600,400], [700,-600], [1000,-900], [700,-600]]

for i=0, 6 do begin
	if det_arr[i] eq 0 then continue
	coords = get_payload_coords( transpose([[x],[y]]), i )
	if keyword_set(target) then begin
		coords[0,*] += target_centers[0,target-1]
		coords[1,*] += target_centers[1,target-1]
	endif
	oplot, coords[0,*]-xerr[i], coords[1,*]-yerr[i], _extra=_extra
endfor

END