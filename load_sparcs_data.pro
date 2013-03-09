FUNCTION load_sparcs_data, PLOT = plot

;FUNCTION: Loads and returns SPARCS/LISS pitch and yaw data in arcsec from txt files 
;           LISS_pitch.txt and LISS_yaw.txt in data_2012. These files were processed using MATLAB 
;           from original raw data file SPARCS255.txt
;
;KEYWORDS:      PLOT - created a nice plot of pitch and yaw
;
;RETURNS: Structure
;
;WRITTEN: Steven Christe (9-mar-2012)

launch_time = '2012/11/02 11:55:00'

dir = './data_2012/'
pitch_fname = dir + 'LISS_pitch.txt'
yaw_fname = dir + 'LISS_yaw.txt'

r = read_ascii(pitch_fname, delimiter = ',', data_start = 1)
time = r.field1[0,*]
pitch_asec = r.field1[1,*]

r = read_ascii(yaw_fname, delimiter = ',', data_start = 1)
yaw_asec = r.field1[1,*]

time = anytim(anytim(launch_time) + double(time), /yoh)

IF keyword_set(PLOT) THEN BEGIN
    utplot, time, pitch_asec, /nodata, xtitle = 'Time (s)', ytitle = 'LISS offset [arcsec]', $
        title = '36.255/Krucker 2012 Flight'
    outplot, time, pitch_asec, linestyle = 1
    outplot, time, yaw_asec, linestyle = 2
    ssw_legend, ['pitch axis', 'yaw axis'], linestyle = [1,2]
ENDIF

result = create_struct('time', time, 'pitch_asec', pitch_asec, 'yaw_asec', yaw_asec)
stop
RETURN, result

END