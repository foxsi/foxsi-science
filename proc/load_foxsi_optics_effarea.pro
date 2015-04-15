FUNCTION load_foxsi_optics_effarea, module_number

COMMON foxsi, t0, data, data_dir, calibration_data_path, data_file, name, sparcs, flight_data, $
    optic_effarea 

; Switch X0->D6 and X6->D0
if MODULE_NUMBER eq 0 then MODULE = 6 else if MODULE_NUMBER eq 6 then MODULE = 0 $
		else MODULE = MODULE_NUMBER

; todo: these need to be provided by the data files themselves
angles = [-9, -7, -5, -3, -1, 0, 1, 3, 5, 7, 9]

files = calibration_data_path + 'FOXSI2_' + ['ModuleX' + num2str(module) + '_EA_pan.csv', $
            'ModuleX' + num2str(module) + '_EA_tilt.csv']
print, files

FOR i = 0, n_elements(files)-1 DO BEGIN
    f = file_search(files[i])
IF f[0] NE '' THEN data = read_csv(f) ELSE BEGIN
    print, "File " + files[i] + " not found!"
    return, -1
ENDELSE

IF i EQ 0 THEN BEGIN
    eff_area = fltarr(n_elements(angles), n_elements(data.field01))
    eff_area_err = fltarr(n_elements(angles), n_elements(data.field01))
    result = create_struct('energy', data.field02, 'angles', angles, 'pan', eff_area, $
        'pan_error', eff_area, 'tilt', eff_area, 'tilt_error', eff_area)
ENDIF

eff_area[0, *] = data.field03
eff_area[1, *] = data.field05
eff_area[2, *] = data.field07
eff_area[3, *] = data.field09
eff_area[4, *] = data.field11
eff_area[5, *] = data.field13
eff_area[6, *] = data.field15
eff_area[7, *] = data.field17
eff_area[8, *] = data.field19
eff_area[9, *] = data.field21
eff_area[10, *] = data.field23

IF i EQ 0 THEN result.pan = eff_area
IF i EQ 1 THEN result.tilt = eff_area

eff_area_err[0, *] = data.field04
eff_area_err[1, *] = data.field06
eff_area_err[2, *] = data.field08
eff_area_err[3, *] = data.field10
eff_area_err[4, *] = data.field12
eff_area_err[5, *] = data.field14
eff_area_err[6, *] = data.field16
eff_area_err[7, *] = data.field18
eff_area_err[8, *] = data.field20
eff_area_err[9, *] = data.field22
eff_area_err[10, *] = data.field24

IF i EQ 0 THEN result.pan_error = eff_area_err
IF i EQ 1 THEN result.tilt_error = eff_area_err

ENDFOR

return, result

END