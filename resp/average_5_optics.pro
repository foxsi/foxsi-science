FUNCTION	AVERAGE_5_OPTICS, _EXTRA = _extra
	; quick fix useful because this function is called only for FOXSI1 in get_foxsi_effarea
	foxsi1_optic_modules = [6,1,2,3,4,5,0]

	for i=0, 5 do begin
		if i eq 2 then continue

		area = get_foxsi_optics_effarea( module_number=foxsi1_optic_modules[i], _extra=_extra )
		if i eq 0 then energy = area.energy_kev
		if i eq 0 then eff_area = area.eff_area_cm2
		if i gt 0 then eff_area += area.eff_area_cm2
	endfor
	
	return, eff_area / 5.

END
