FUNCTION foxsi_structure_for_fits, level2_data, year=year, no_data = no_data

  ;+
  ; PROJECT
  ;   FOXSI sounding rocket
  ;
  ; PURPOSE
  ;   This function takes a classic level2 data structure from FOXSi and 
  ;   creates a structure that is easier to feed to the routine that creates a
  ;   fits data file
  ;
  ; INPUTS
  ;   level2_data: structure containing the level2 data for a detector
  ;
  ; OUTPUTS
  ;   none
  ;
  ; KEYWORDS
  ;   no_data: if set, returns an empty structure
  ;   year: year of the flight (can be 2012, 2014, or 2018)
  ;   
  ; CALLS
  ;
  ; EXAMPLE
  ;   restore, 'foxsi_level2_data.sav'
  ;   str = foxsi_structure_for_fits(data_lvl2_d0)
  ;
  ; HISTORY
  ;   2019/10/03 SMusset (UMN): initial release.
  ;   2019/10/15 SMusset (UMN): added test "tag_exist" to make sure we can process older level 2 data files
  ;   
  ; NOTE
  ;   The difference between this "fits structure" and the original foxsi level2 structures are:
  ;   - the frame time is not present in the fits structure
  ;   - the date of the flight is added in the fits structure
  ;
  ;-
  
  DEFAULT, no_data, 0
  
  ; prepare the data structure and make an array with one element for each frame.
  print, '  Creating data structure.'
  data_struct = {foxsi_level2_ffits,  $
    frame_counter:long(0), $ ; formatter frame counter value, 32 bits
    flight_date:string(0), $ ; date of the flight, yyyy/mm/dd
    wsmr_time:double(0.),  $ ; WSMR ground station time, to milliseconds
    det_num:fix(0),        $ ; same for all frames; from input keyword
    trigger_time:fix(0),   $ ; raw trigger time value, 16 bits
    livetime:double(0),    $ ; Livetime in microsec since previous event
    hit_asic:intarr(2)-1,  $ ; which ASIC is likely hit, [p,n]
    hit_strip:intarr(2),   $ ; strip with highest ADC value, [p,n]
    hit_energy:fltarr(2),  $ ; Energy value for hit strip, [n,p]
    hit_xy_det:fltarr(2),  $ ; Hit position in detector coordinates [strips]
    hit_xy_pay:fltarr(2),  $ ; Hit position in payload coordinates [arcsec]
    hit_xy_solar:fltarr(2),     $ ; Hit position in heliographic coordinates [arcsec]
    assoc_energy:fltarr(3,3,2), $  ; "associated" energies, including hit.
    assoc_xy_pay:fltarr(3,3,2), $ ; "associated" locations, in payload coordinates [pixels]
    assoc_xy_solar:fltarr(3,3,2), $ ; "associated" locations, in solar coordinates [pixels]
    HV:fix(0),             $ ; detector bias voltage value [volts]
    temperature:double(0), $ ; thermistor value [deg C] if temperature exists for this det.
    inflight:fix(0),       $ ; '1' if frame occurred post-launch (for flight data only!)
    altitude:float(0),     $ ; altitude data, interpolated betw 0.5 sec cadence
    pitch:float(0),        $ ; SPARCS pitch
    yaw:float(0),          $ ; SPARCS yaw
    error_flag:fix(0),     $ ; '1' if obvious error is noticed in that frame's data
    date_creation:string(0),   $ ; Date and time of level2 structure creation, from OS (local time)
    calib_filename:string(0)   $ ; name of the calibration file used to calculate the level2 data
  }
  
  IF no_data EQ 1 THEN BEGIN
    RETURN, data_struct
    
  ENDIF ELSE BEGIN
    ; read year and create flightdate
    flightdate = ' '
    IF year EQ 2012 THEN flightdate = '2012/11/02'
    IF year EQ 2014 THEN flightdate = '2014/12/11'
    IF year EQ 2018 THEN flightdate = '2018/09/07'
    
    ; read number of events
    nEvts = n_elements(level2_data)
    data_struct = replicate(data_struct, nEvts)

    flidate = strarr(nEvts) + flightdate

    nodata = 0 ; this will be set to 1 if the final structure cannot be created
    
    ; Fill in values that are identical to previous versions.
    ; make the change of type when possible
    IF max(level2_data.frame_counter) LE 2d^32/2 THEN data_struct.frame_counter   = LONG(level2_data.frame_counter) ELSE BEGIN
      print, 'Frame counter goes to high for type conversion'
      nodata = 1
    ENDELSE
    data_struct.flight_date     = flidate
    data_struct.wsmr_time       = level2_data.wsmr_time
    data_struct.det_num         = FIX(level2_data.det_num)
    IF max(level2_data.trigger_time) LE 2d^32/2  THEN data_struct.trigger_time    = LONG(level2_data.trigger_time) ELSE BEGIN
      print, 'Trigger time goes to high for type conversion'
      nodata = 1
    ENDELSE
    data_struct.livetime        = level2_data.livetime
    IF tag_exist(level2_data, 'hit_asic') THEN data_struct.hit_asic = level2_data.hit_asic $
      ELSE data_struct.hit_asic = FLTARR(nEvts)
    IF tag_exist(level2_data, 'hit_strip') THEN data_struct.hit_strip = FIX(level2_data.hit_strip) $
      ELSE data_struct.hit_strip = FLTARR(nEvts)
    data_struct.hit_energy      = level2_data.hit_energy
    data_struct.hit_xy_det      = level2_data.hit_xy_det
    data_struct.hit_xy_pay      = level2_data.hit_xy_pay
    data_struct.hit_xy_solar    = level2_data.hit_xy_solar
    data_struct.assoc_energy    = level2_data.assoc_energy
    data_struct.assoc_xy_pay    = level2_data.assoc_xy_pay
    data_struct.assoc_xy_solar  = level2_data.assoc_xy_solar
    data_struct.hv              = FIX(level2_data.hv)
    data_struct.temperature     = level2_data.temperature
    data_struct.inflight        = level2_data.inflight
    data_struct.altitude        = level2_data.altitude
    data_struct.pitch           = level2_data.pitch
    data_struct.yaw             = level2_data.yaw
    IF max(level2_data.error_flag) LE 2d^16/2 THEN data_struct.error_flag  = FIX(level2_data.error_flag) ELSE BEGIN
      print, 'Error flag goes to high for type conversion'
      nodata = 1
    ENDELSE
    IF tag_exist(level2_data, 'date_creation') THEN data_struct.date_creation = level2_data.date_creation $
      ELSE data_struct.date_creation = ''
    IF tag_exist(level2_data, 'calib_filename') THEN data_struct.calib_filename = level2_data.calib_filename $
      ELSE data_struct.calib_filename = ''

    IF nodata EQ 0 THEN RETURN, data_struct ELSE RETURN, 0
  ENDELSE
END