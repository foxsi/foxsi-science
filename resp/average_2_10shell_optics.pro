FUNCTION  AVERAGE_2_10SHELL_OPTICS, _EXTRA = _extra

  ; this function is useful for appxmation of the 10-shell modules X7 andX8 on FOXSI3
  
  foxsi1_optic_modules = [6,1,2,3,4,5,0]

  area = get_foxsi_optics_effarea( module_number=foxsi1_optic_modules[2], _extra=_extra )
  energy = area.energy_kev
  eff_area = area.eff_area_cm2
  
  area = get_foxsi_optics_effarea( module_number=foxsi1_optic_modules[6], _extra=_extra )
  eff_area += area.eff_area_cm2
  
  return, eff_area / 2.

END