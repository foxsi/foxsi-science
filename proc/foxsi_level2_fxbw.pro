PRO foxsi_level2_fxbw, filename, level2_data, year=year, max_string_length=max_string_length

  ;+
  ; PROJECT
  ;   FOXSI sounding rocket
  ;
  ; PURPOSE
  ;   This procedure creates a FOXSI level2 fits file
  ;
  ; INPUTS
  ;   filename: string containing the fits filename
  ;   level2_data: structure containing the level2 data for a detector
  ;
  ; OUTPUTS
  ;   none
  ;
  ; KEYWORDS
  ;   year: year of the flight. Can be 2012, 2014, 2018
  ;   max_string_length: all strings are set to this length, the default is 80
  ;
  ; CALLS
  ;   foxsi_level2_fxbh
  ;   foxsi_structure_for_fits
  ;   
  ; EXAMPLE
  ;   restore, 'foxsi_level2_data.sav'
  ;   fxhmake, h0, /extend, /initialize
  ;   fxwrite, 'test_foxsi.fits', h0
  ;   foxsi_level2_fxbw, 'test_foxsi.fits', data_lvl2_d0, year=2014
  ;
  ; HISTORY
  ;   2019/10/03 SMusset (UMN): initial release. This procedure is an adaptation of the hsi_obs_summ_fxbw routine
  ;
  ;-
  
  
  ;Check if the data is in a structure
  ttt = datatype(level2_data)
  IF(ttt NE 'STC') THEN BEGIN
    message, /info, 'not a structure input, no extension written'
    RETURN
  ENDIF
  
  ; transform in a fits friendly structure - we will loose the frame_time
  data_str = foxsi_structure_for_fits(level2_data, year=year) 
  
  ; assign number of rows and columns in variables
  nrows = N_ELEMENTS(data_str) ;number of rows in the table
  ncolumns = N_ELEMENTS(tag_names(data_str)) ;number of columns in the table

  ;First make the Fits table header array
  h0 = foxsi_level2_fxbh(data_str)

  ;Open the file, and insert the header
  fxbcreate, unit, filename, h0

  ;Deal with strings
  IF(KEYWORD_SET(max_string_length)) THEN lll = max_string_length $
  ELSE lll = 80
  fmmt = '(a'+strcompress(string(lll), /remove_all)+')'
  yes_string = bytarr(ncolumns)
  FOR i = 0l, ncolumns-1l DO BEGIN
    dtyp = datatype(data_str.(i))
    IF(dtyp EQ 'STR') THEN yes_string[i] = 1
  ENDFOR

  ;Fill in the table, for each row, for each column
  FOR j = 0, nrows-1 DO BEGIN
    rowno = j+1
    FOR i = 0, ncolumns-1l DO BEGIN
      IF(yes_string[i] EQ 1) THEN BEGIN ;string ?
        nn = N_ELEMENTS(data_str[j].(i))
        temp = strarr(nn)
        FOR k = 0, nn-1 DO BEGIN
          tempk = string(' ', format = fmmt)
          strput, tempk, data_str[j].(i)[k]
          temp[k] = tempk
        ENDFOR
      ENDIF ELSE temp = data_str[j].(i)
      fxbwrite, unit, temp, i+1, rowno
    ENDFOR
  ENDFOR

  fxbfinish, unit

  RETURN

END
