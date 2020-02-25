FUNCTION foxsi_level2_fxbh, level2_data, Max_string_length=max_string_length

;+
; PROJECT
;   FOXSI sounding rocket
; 
; PURPOSE
;   This function creates a fits header for a level2 fits file
; 
; INPUTS
;   level2_data: structure containing the level2 data for a detector
; 
; OUTPUTS
;   none
; 
; KEYWORDS
;   max_string_length = all strings are set to this length
;                     the default is 80
;   
; CALLS
; 
; EXAMPLE
;   restore, 'foxsi_level2_data.sav' 
;   h = foxsi_level2_fxbh(data_lvl2_d0)
; 
; HISTORY
;   2019/10/03 SMusset (UMN): initial release. This function is an adaptation of the hsi_obs_summ_fxbh routine.
;   
;-

  ; define tag labels for FOXSI level2 data
  tag_labels = ['FRAME NUMBER', 'DATE', 'WSMR TIME in seconds of the day', 'DETECTOR NUMBER', 'TRIGGER TIME', 'LIVETIME',$
    'HIT ASIC NUMBER', 'HIT STRIP NUMBER', 'HIT ENERGY IN ADC', 'HIT POSITION IN DETECTOR CCORDINATES', 'HIT POSITION IN PAYLOAD COORDINATES',$
    'HIT POSITION IN SOLAR COORDINATES', 'ENERGY OF THE ASSOCIATED COUNTS', 'PAYLOAD COORDINATES OF THE ASSOCIATED COUNTS',$
     'SOLAR COORDINATES OF THE ASSOCIATED COUNT', 'HIGH VOLTAGE IN VOLTS', 'TEMPERATURE IN CELSIUS', 'INFLIGHT FLAG', 'ALTITUDE', $
     'PITCH SPARCS COORDINATE', 'YAW SPARCS COORDINATE', 'ERROR FLAG', 'DATE OF DATA REDUCTION', 'CALIBRATION FILE USED']
  
  ; read the title of the structure, to be used as the title of the table
  title = strupcase(tag_names(level2_data, /struct))
  ; the following lines could be useful, but if they are still commented when I release this, they should be deleted
  ;    vtest = strpos(title, '_V') ;can't include version numbers
  ;    IF(vtest[0] NE -1) THEN title = strmid(title, 0, vtest[0])

  ; take care of strings
  IF(KEYWORD_SET(max_string_length)) THEN lll = max_string_length $
  ELSE lll = 80
  fmmt = '(a'+strcompress(string(lll), /remove_all)+')'

  nrows = N_ELEMENTS(level2_data) ;number of rows
  aa = level2_data[0]             ;Only one element for the header
  
  tags = tag_names(level2_data)
  ncolumns = N_ELEMENTS(tags)
  use_labels = 1b
   
   ; delete the following if still commented
   ;IF(KEYWORD_SET(max_string_length)) THEN lll = max_string_length $
   ;  ELSE lll = 80
   ;fmmt = '(a'+strcompress(string(lll), /remove_all)+')'

   ; initialize the header   
   fxbhmake, h0, nrows, title
   ; populate the header using the tags of the data structure
   FOR i = 0, ncolumns-1 DO BEGIN
      ; find out the data type
      dtyp = datatype(aa.(i))
      ; insert here some explanation about what is this manip on strings
      IF(dtyp EQ 'STR') THEN BEGIN
         nn = N_ELEMENTS(aa.(i))
         temp = strarr(nn)
         FOR k = 0, nn-1 DO BEGIN
            tempk = string(' ', format = fmmt)         
            strput, tempk, aa.(i)[k]
            temp[k] = tempk
         ENDFOR
      ; if the data is not a string then simply take the data value
      ENDIF ELSE temp = aa.(i)
      IF(N_ELEMENTS(temp) EQ 1) THEN temp = temp[0]
      IF(use_labels) THEN BEGIN
         ;strip actual tag_names from string,
         tli = tag_labels[i]
         strpi = strpos(tli, ':')
         IF(strpi[0] Ne -1) THEN BEGIN
            tli1 = strtrim(strmid(tli, strpi[0]+1),2)
         ENDIF ELSE tli1 = tli
         fxbaddcol, i+1, h0, temp, tags[i], tli1
      ENDIF ELSE fxbaddcol, i+1, h0, temp, tags[i]
   ENDFOR

   RETURN, h0

END