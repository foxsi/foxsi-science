PRO foxsi_level2_fxbr, filename, level2_data, read_error = read_error
  
  ;+
  ; PROJECT
  ;   FOXSI sounding rocket
  ;
  ; PURPOSE
  ;   This function reads a FOXSI level2 fits file into an appropriate structure
  ;
  ; INPUTS
  ;   filename: string containing path to the file to read
  ;
  ; OUTPUTS
  ;   level2_data: structure containing level2 data (previously formatted to the fits)
  ;
  ; KEYWORDS
  ;   read_error
  ;
  ; CALLS
  ;   foxsi_structure_for_fits
  ;   
  ; EXAMPLE
  ;   foxsi_level2_fxbr, 'test_foxsi_string.fits', data
  ;   
  ; HISTORY
  ;   2019/10/03 SMusset (UMN): initial release. This function is an adaptation of the hsi_obs_summ_fxbr routine.
  ;
  ;-
  
  ; inialisation error code
  read_error = 0
  
  ; input structure 
  inp_struct = foxsi_structure_for_fits(0,/no_data)
  
  struct_typ = strupcase(tag_names(inp_struct, /struct))
  
  ; the following is probably not needed
  ;vtest = strpos(struct_typ, '_V') ;can't include version numbers
  ;IF(vtest[0] NE -1) THEN struct_typ = strmid(struct_typ, 0, vtest[0])

  ;Open the file, and read the header
  err = ' '
  fxbopen, unit, filename, struct_typ, h0, err = err
  ;Check to see if the extension was found, if not, return
  err = strupcase(strtrim(err, 2))

  IF(err EQ 'REQUESTED EXTENSION NOT FOUND') THEN BEGIN
    message, /info, 'File: '+filename+' Has no extension, returning'
    print, 'struct_typ:', struct_typ
    read_error = 2
    fxbclose, unit
    level2_data = -1
    RETURN
  ENDIF

  ;Number of rows, and columns
  nrows0 = fxpar(h0, 'NAXIS2')
  ncolumns = N_ELEMENTS(tag_names(inp_struct))

  ;Start and end rows
  IF(KEYWORD_SET(st_row)) THEN st_row0 = long(st_row) ELSE st_row0 = 0l
  IF(KEYWORD_SET(en_row)) THEN en_row0 = long(en_row) $
  ELSE en_row0 = nrows0-1l
  IF(st_row0 GT nrows0-1 OR en_row0 GT nrows0-1) $
    OR (st_row0 LT 0 OR en_row0 LT 0) $
    OR (st_row0 GT en_row0) THEN BEGIN
    message, /info, 'row number out of range'
    read_error = 1
    level2_data = -1
    RETURN
  ENDIF

  ;create the structure
  nrows_new = en_row0-st_row0+1
  level2_data = replicate(inp_struct[0], nrows_new)

  ;Find out which are strings
  yes_string = bytarr(ncolumns)
  FOR i = 0l, ncolumns-1l DO BEGIN
    dtyp = datatype(inp_struct[0].(i))
    IF(dtyp EQ 'STR') THEN yes_string[i] = 1
  ENDFOR

  ;Read in the data
  FOR j = 0l, nrows_new-1l DO BEGIN
    rowno = (j+st_row0)+1
    FOR i = 0l, ncolumns-1l DO BEGIN
      errmsg = ''
      fxbread, unit, temp, i+1, rowno, errmsg = errmsg
      IF ERRMSG NE '' THEN BEGIN
        read_error = 1
        level2_data = -1
        return
      ENDIF
      IF(yes_string[i] EQ 1) THEN level2_data[j].(i) = strtrim(temp, 2) $
      ELSE level2_data[j].(i) = temp
    ENDFOR
  ENDFOR
  fxbclose, unit

  RETURN
END