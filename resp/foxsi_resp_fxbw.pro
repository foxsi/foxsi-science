PRO foxsi_resp_fxbw, filename, resp

;
; PURPOSE:
;	Write FOXSI response and corresponding energy array to a FITS file. 
;
; INPUT: 
;	FILENAME:	name of FITS file to be written (string)
;	RESP: 		structure with FOXSI response
;
; NOTES:
;	This procedure was based on hsi_obs_summ_fxbw.pro. 
;
; HISTORY:
;	Oct 2019	Created by Julie Vievering
;

; check if resp is a structure
   ttt = datatype(resp)

   if (ttt ne 'STC') then begin
      message, /info, 'not a structure input, no extension written'
      return
   endif

   nrows = N_ELEMENTS(resp) ;number of rows in the table
   ncolumns = N_ELEMENTS(tag_names(resp)) ;number of columns in the table

fxhmake, header, /extend, /initialize	;create basic fits header
fxwrite, filename, header		;write a fits file

; make the fits table header array for the response structure
   h0 = foxsi_resp_fxbh(resp)

; open the file and insert the header
   	fxbcreate, unit, filename, h0

;Fill in the table, for each row, for each column
   FOR j = 0l, nrows-1l DO BEGIN
      rowno = j+1
      FOR i = 0l, ncolumns-1l DO BEGIN
 	 temp = resp[j].(i)
         fxbwrite, unit, temp, i+1, rowno
      ENDFOR
   ENDFOR

   fxbfinish, unit

   RETURN

END
