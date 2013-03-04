FUNCTION get_foxsi_offaxis_resp, ENERGY_ARR = energy_arr, offaxis_angle = offaxis_angle, PLOT = plot, _EXTRA = _extra, SMOOTH_PARAM = smooth_param

;PURPOSE: Get the FOXSI off axis response as a percent change from the on axis response
;
;KEYWORD:
;           OFFAXIS_ANGLE - Set the off angle axis to calculate the response (NOTE the
;                           response is based on data at 0, 2, 5, 10. Going beyond 10
;                           arcmin is therefore dangerous!)
;           PLOT - Create a plot on the screen
;           ENERGY_ARR - choose the energies at which you want data at                            
;
;WRITTEN: Steven Christe (4-Mar-13)

IF NOT keyword_set(offaxis_angle) THEN offaxis_angle = 7
IF NOT keyword_set(smooth_param) THEN smooth_param = 10

data_dir = "./calibration_data/"
restore, data_dir + "optics_calibration_template.dat"
data = read_ascii(data_dir + 'optics_calibration.csv', template = temp)

off_axis_angles = [0, 2, 5, 10]

;energy_calibration
;y = 0.1073x - 0.4849
a = [0.1073, 0.4849]

dim_channels = n_elements(data.channel)
dim_angles = n_elements(off_axis_angles)

energy = data.channel * a[0] + a[1]
base_spectrum = data.spec_0arcmin

spec_array = fltarr(dim_channels, dim_angles)
spec_array[*,0] = data.spec_0arcmin
spec_array[*,1] = data.spec_2arcmin
spec_array[*,2] = data.spec_5arcmin
spec_array[*,3] = data.spec_10arcmin

result_spec_array = fltarr(dim_channels)

FOR i = 0, dim_channels-1 DO $
    result_spec_array[i] = interpol( spec_array[i,*], off_axis_angles, offaxis_angle)

factor =  result_spec_array/base_spectrum
factor = smooth(factor, smooth_param, /nan)

IF keyword_set(energy_arr) THEN BEGIN 
    factor_orig = interpol(factor, energy, energy_arr)
    factor = factor_orig
ENDIF ELSE BEGIN 
	energy_arr = energy
ENDELSE

IF keyword_set(PLOT) THEN BEGIN
    plot, energy, factor, ytitle = '%', xtitle = 'Energy [keV]', /nodata
    oplot, energy, factor
ENDIF

res = create_struct("energy_keV", energy_arr, "factor", factor)

RETURN, res

END
