FUNCTION get_sparcs_pointing, time

;FUNCTION: Returns the pointing information from SPARCS for a given time(s) (interpolated).
;
;
;RETURNS: [pitch, yaw]
;
;WRITTEN: Steven Christe (22-Mar-2014)

COMMON foxsi, t0, data, data_dir, calibration_data_path, data_file, name, sparcs

this_time = anytim(time)

pitch = interpol(sparcs.pitch_asec, sparcs.time, time)
yaw = interpol(sparcs.yaw_asec, sparcs.time, time)

RETURN, create_struct('pitch', pitch, 'yaw', yaw]

END