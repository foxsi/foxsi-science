FUNCTION	AREA_LIMIT, DATA, CENTER, RADIUS, GOOD=GOOD, STOP=STOP, YEAR=YEAR, $
					XYCORR = XYCORR, INDEX=INDEX, left=left, $
					right = right, top=top, bottom=bottom

	; This function takes in FOXSI level 2 data and returns a clipped version
	; corresponding only to the specified heliographic area in arcsec.  
	; /GOOD returns only the data with no error flags.
	; /XYCORR corrects the center position using the "known" xy offset.

	COMMON FOXSI_PARAM
	default, year, 2014
	
	detnum = data[0].det_num
	
	if keyword_set(good) then data_mod = data[ where(data.error_flag eq 0) ] $
		else data_mod = data
		
	case detnum of
		0: shift = shift0
		1: shift = shift1
		2: shift = shift2
		3: shift = shift3
		4: shift = shift4
		5: shift = shift5
		6: shift = shift6
		else: begin
			print, 'Incorrect detector number; bad data!'
			return, -1
		end
	endcase

;	if keyword_set(xycorr) then cen = center - offset_xy else cen = center
	if keyword_set(xycorr) then cen = center - (offset_xy+shift) else cen = center

	xy = data_mod.hit_xy_solar
	dist = sqrt( (xy[0,*]-cen[0])^2 + (xy[1,*]-cen[1])^2 )
	distx = xy[0,*]-cen[0]
        disty = xy[1,*]-cen[1]

	; This is to handle an encountered bug. Should be transparent for anyone who hasn't 
	; encountered array problems, and should fix it for those who have.
	if isarray( RADIUS ) then radius = radius[0]
	
;	case side of
;		left: i = where( reform(dist) lt radius and distx lt 0. )
;		right: i = where( reform(dist) lt radius and distx gt 0. )
;		top: i = where( reform(dist) lt radius and disty gt 0. )
;		bottom: i = where( reform(dist) lt radius and disty lt 0. )
;		else: i = where( reform(dist) lt radius )
;	endcase

	if keyword_set(left) then i = where( reform(dist) lt radius and distx lt 0. ) $
		else i = where( reform(dist) lt radius )

	if keyword_set(right) then i = where( reform(dist) lt radius and distx gt 0. ) $
		else i = i

	if keyword_set(top) then i = where( reform(dist) lt radius and disty gt 0. ) $
                else i = i

	if keyword_set(bottom) then i = where( reform(dist) lt radius and disty lt 0. ) $
                else i = i

	if keyword_set(stop) then stop
	
	if keyword_set( INDEX ) then begin	

	endif
	
	return, data_mod[i]
	
END
	
	
