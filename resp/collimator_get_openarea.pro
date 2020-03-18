FUNCTION collimator_get_openarea, MODULE_NUMBER = module_number, OFFAXIS_ANGLE = offaxis_angle, $
         _EXTRA = _extra, YEAR = year
;PURPOSE:   Get the Open Area ratio of a 3D printed collimator flown on FOXSI-3 (Sep-2018)
;           attached to optical modules X4 and X5 (both being 7-mirrors optics). This open area
;           is crucial when estimating the effective area for these two optics.
;           For more information about the 3D-printed collimators check this paper:
;           Buitrago-Casas,et al. SPIE 2017 proceddings Optics for EUV, X-Ray, and Gamma-Ray Astronomy 
;
;KEYWORD:   MODULE_NUMBER - the module number (0 through 8).  Optic number is used, this is DIFFERENT FROM THE DETECTOR NUMBER.
;           OFFAXIS_ANGLE - off-axis angle. if array then [pan, tilt] in arcmin
;           YEAR - year of the FOXSI launch. It can be: 2012, 2014 or 2018. If not set, COMMON DATE will be used instead.
;
;WRITTEN:   Milo Buitrago-Casas (Mar-2020)

  
  offaxisOA = 0.32 - 0.018*offaxis_angle ; 
  CollOpenArea = [1.0, 1.0, 1.0, offaxisOA, offaxisOA, offaxisOA]
  
  result = 1.0
  RETURN, result

END
  