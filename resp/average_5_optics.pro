FUNCTION	AVERAGE_5_OPTICS, _EXTRA = _extra

	for i=0, 5 do begin
		if i eq 2 then continue

		area = get_foxsi_optics_effarea( module_number=i, _extra=_extra )
		if i eq 0 then energy = area.energy_kev
		if i eq 0 then eff_area = area.eff_area_cm2
		if i gt 0 then eff_area += area.eff_area_cm2
	endfor
	
	return, eff_area / 5.

END