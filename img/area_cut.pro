FUNCTION	AREA_CUT, DATA, CENTER, RADIUS, GOOD=GOOD, STOP=STOP, YEAR=YEAR, $
					XYCORR = XYCORR

	; This function takes in FOXSI level 2 data and returns a clipped version
	; corresponding only to the specified heliographic area in arcsec.  
	; /GOOD returns only the data with no error flags.
	; /XYCORR corrects the center position using the "known" xy offset.
	
	default, year, 2014
	
	case year of
		2012:	restore, 'data_2012/flight2012-parameters.sav'
		2014:	restore, 'data_2014/flight2014-parameters.sav'
		else: begin
			print, 'Year can only be 2012 or 2014.'
			return, -1
		end
	endcase
	
	if keyword_set(good) then data_mod = data[ where(data.error_flag eq 0) ] $
		else data_mod = data
		
	if keyword_set(xycorr) then cen = center - offset_xy else cen = center

	xy = data_mod.hit_xy_solar
	dist = sqrt( (xy[0,*]-cen[0])^2 + (xy[1,*]-cen[1])^2 )

	i = where( dist lt radius )
	
	if keyword_set(stop) then stop
	
	return, data_mod[i]
	
END
	
	