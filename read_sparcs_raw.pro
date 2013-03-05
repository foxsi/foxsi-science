FUNCTION read_sparcs_raw, PLOT = plot, pitch_root_index, yaw_root_index

filename = 'data_2012/SPARCS255.txt'

; Pitch Polynomial Parameters; these change with each mission
pitch_polyparams = [1.016380e-3, 1.172772e-1, 2.656168e-4, 4.540818e-5, -6.476478e-7]
yaw_polyparams = [3.931802e-3, -1.166711e-1, -1.609558e-4, -4.759035e-5, 4.003557e-7]

IF NOT keyword_set(pitch_root_index) THEN pitch_root_index = 1
IF NOT keyword_set(yaw_root_index) THEN yaw_root_index = 2

;data = rd_tfile(filename, /auto, /convert)
;data = rd_ascii(filename)


s = size(data)

dim = s[2]

result = create_struct('time', strarr(1), 'pitch', 0.0, 'yaw', 0.0)
result = replicate(result, dim)

;pitch_root_index = 1
;yaw_root_index = 2

pitch_data_index = 10
yaw_data_index = 9

FOR i = 0, s[2]-1 DO BEGIN
    
    result[i].time = data[0,i]
    ; calculate yaw
    IF (data[yaw_data_index,i] LE 32767) THEN BEGIN
        volts = data[yaw_data_index,i] / 32767. * 3.68;       
        an = yaw_polyparams[0] - volts;
        vect = [an, yaw_polyparams[1], yaw_polyparams[2], yaw_polyparams[3], $
                yaw_polyparams[4]]
        roots = fz_roots(vect)
        sol = real_part(roots[yaw_root_index])
        result[i].yaw = 60.0 * sol;
    ENDIF ELSE BEGIN
        volts =  -((65535.-data[yaw_data_index,i])/32768.) * 3.68;
        an = yaw_polyparams[0] - volts;
        vect = [an, yaw_polyparams[1], yaw_polyparams[2], yaw_polyparams[3], $
                yaw_polyparams[4]]
        roots = fz_roots(vect)
        sol = real_part(roots[yaw_root_index]) 
        result[i].yaw = 60.0 * sol;
    ENDELSE
    
    ; calculate pitch
    IF (data[pitch_data_index,i] LE 32767.0) THEN BEGIN
        volts = data[pitch_data_index, i] / 32767. * 3.68;
        an = pitch_polyparams[0] - volts
        vect = [an, pitch_polyparams[1], pitch_polyparams[2], pitch_polyparams[3], $
                pitch_polyparams[4]]
        roots = fz_roots(vect)
        roots = roots[sort(roots)]
        sol = real_part(roots[pitch_root_index])
        result[i].pitch = 60.0 * sol;
        
    ENDIF ELSE BEGIN
        volts = -((65535.-data[pitch_data_index, i]) / 32768.) * 3.68;
        an = pitch_polyparams[0] - volts
        vect = [an, pitch_polyparams[1], pitch_polyparams[2], pitch_polyparams[3], $
                pitch_polyparams[4]]
        roots = fz_roots(vect)
        roots = roots[sort(roots)]
        sol = real_part(roots[pitch_root_index]) 
        result[i].pitch = 60.0 * sol;
        
    ENDELSE 

ENDFOR

IF keyword_set(PLOT) THEN BEGIN
    title = '36.255/Krucker';
    xtitle = 'Time since launch(Secs)';
    xrange = [100, 500]
    ;!P.MULTI = [0,1,2]
    ;plot, result.time, result.yaw, xtitle = xtitle, title = title, $
    ;    ytitle = 'Yaw [arcsec]', xrange = xrange, /xstyle
    plot, result.time, result.pitch, xtitle = xtitle, title = title, $
        ytitle = 'Pitch [arcsec]', xrange = xrange, /xstyle
ENDIF
stop
RETURN, result

END