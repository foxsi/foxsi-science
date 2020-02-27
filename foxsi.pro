;+
; :description:
;   STARTUP FOXSI
;   This procedure load the FOXSI parameters and level2 data of the specified year.
;
; :categories:
;
; :params:
;   year : in, required, type=INT, year of fligth data to be analyzed
;
; :keywords:
;    READ_FITS: set to 1 to read fits files instead of looking for a save file. Default is 0
;    FITS_DIR: give the path to the directory containing the fits files if different from default.
;	default is foxsidb/data_xxxx where xxxx is the year of the flight.
;
; :returns:
;
; :examples:
;   foxsi,2014
;   foxsi, 2014, /read_fits
;   foxsi, 2014, /read_fits, fits_dir = 'mydirectory'
;
; :history:
;   June 2016 - Milo (SSL): initial release
;   2018-02-23 - Sophie Musset (UMN): replace '$FOXSIDB' by GETENV('FOXSIDB') when calling the foxsi level 2 data (because the previous command does not work on windows)
;   2019-10-15 - Sophie Musset (UMN): add the call to 'undefine_previous_param' at the beginning to avoid having parameters from another flight that stay defined
;   2019-12-04 - Sophie Musset (UMN): add the possibility to read fits files instead of the IDL .sav files
;-

PRO FOXSI, YEAR, READ_FITS = READ_FITS, FITS_DIR=FITS_DIR
COMMON FOXSI_PARAM

; in case some parameters are already defined from another flight, erase them
@undefine_previous_param

if not keyword_set(year) then begin 
	print,'Please provide the year of the FOXSI flight (2012, 2014 or 2018).'
	print,'       Example: foxsi,2014'
endif else begin
	if ((year eq 2012) OR (year eq 2014) OR (year EQ 2018)) then begin
		IF NOT keyword_set(read_fits) THEN read_fits = 0
		
		IF read_fits EQ 1 THEN BEGIN
	
			; if directory is not provided for the fits file, choose the foxsidb directory
			IF NOT keyword_set(fits_dir) THEN BEGIN
				IF year EQ 2012 THEN fits_dir = GETENV('FOXSIDB')+'/data_2012/'
				IF year EQ 2014 THEN fits_dir = GETENV('FOXSIDB')+'/data_2014/'
				IF year EQ 2018 THEN fits_dir = GETENV('FOXSIDB')+'/data_2018/'
			ENDIF
			
			; read the fits files for that year found in the provided directory
			case year of
				2012: begin
					foxsistr = 'foxsi1'
					@param2012_20200226
				end
				2014: begin
					foxsistr = 'foxsi2'
					@param2014_20160620
				end
				2018: begin
					foxsistr = 'foxsi3'
					@param2018_20191015
				end
			endcase
			FOR det=0, 6 DO BEGIN
				detstr = strtrim(string(det),2)
				file = file_search(fits_dir, foxsistr+'_level2_det'+detstr+'.fits')
				IF n_elements(file) GT 1 THEN BEGIN
				  PRINT,'More than one file found, selecting the first one:'
				  file=file[0]
				ENDIF
				IF file NE '' THEN BEGIN
					print, 'loading file ', file[0]
					IF det EQ 0 THEN foxsi_level2_fxbr, file[0], DATA_LVL2_D0
					IF det EQ 1 THEN foxsi_level2_fxbr, file[0], DATA_LVL2_D1
					IF det EQ 2 THEN foxsi_level2_fxbr, file[0], DATA_LVL2_D2
					IF det EQ 3 THEN foxsi_level2_fxbr, file[0], DATA_LVL2_D3
					IF det EQ 4 THEN foxsi_level2_fxbr, file[0], DATA_LVL2_D4
					IF det EQ 5 THEN foxsi_level2_fxbr, file[0], DATA_LVL2_D5
					IF det EQ 6 THEN foxsi_level2_fxbr, file[0], DATA_LVL2_D6
				ENDIF
			ENDFOR
			
			print, 'You just load all the parameters and data needed'
			print, 'to do the analysis of the FOXSI '+strtrim(string(year),2)+' observations.'
			print
			print, 'Type help if you want to check the '+strtrim(string(year),2)+'-parameters.'
			
		ENDIF ELSE BEGIN

	 		if year eq 2018 then begin
	  	  	@param2018_20191015
         	   	restore, GETENV('FOXSIDB')+'/data_2018/foxsi_level2_data.sav', /v
	 	   	DATA_LVL2_D0=DATA_LVL2_D0
	 	   	DATA_LVL2_D2=DATA_LVL2_D2
	  	  	DATA_LVL2_D3=DATA_LVL2_D3
	  	  	DATA_LVL2_D4=DATA_LVL2_D4
	  		DATA_LVL2_D5=DATA_LVL2_D5
	    		DATA_LVL2_D6=DATA_LVL2_D6
			print, 'You just load all the parameters and data needed' 
			print, 'to do the analysis of the FOXSI 2018 observations.'
			print
			print, 'Type help if you want to check the 2018-parameters.'
			return	
	 		endif
	  		if year eq 2014 then begin
			; load the Level 2 data.
			@param2014_20160620
			restore, GETENV('FOXSIDB')+'/data_2014/foxsi_level2_data.sav', /v
			DATA_LVL2_D0=DATA_LVL2_D0
			DATA_LVL2_D1=DATA_LVL2_D1
			DATA_LVL2_D2=DATA_LVL2_D2
			DATA_LVL2_D3=DATA_LVL2_D3
			DATA_LVL2_D4=DATA_LVL2_D4
			DATA_LVL2_D5=DATA_LVL2_D5
			DATA_LVL2_D6=DATA_LVL2_D6
			print, 'You just load all the parameters and data needed' 
			print, 'to do the analysis of the FOXSI 2014 observations.'
			print
			print, 'Type help if you want to check the 2014-parameters.'
			return	
			endif
			if year eq 2012 then begin
			; load the Level 2 data.
			@param2012_20200226
			restore, GETENV('FOXSIDB')+'/data_2012/foxsi_level2_data.sav', /v
			DATA_LVL2_D0=DATA_LVL2_D0
			DATA_LVL2_D1=DATA_LVL2_D1
			DATA_LVL2_D2=DATA_LVL2_D2
			DATA_LVL2_D3=DATA_LVL2_D3
			DATA_LVL2_D4=DATA_LVL2_D4
			DATA_LVL2_D5=DATA_LVL2_D5
			DATA_LVL2_D6=DATA_LVL2_D6
			print, 'You just load all the parameters and data needed' 
			print, 'to do the analysis of the FOXSI 2012 observations.'
			print
			print, 'Type help if you want to check the 2012-parameters.'
			return
			endif		

		ENDELSE
	endif else begin
		print, 'FOXSI did not fly that year.'
		print, 'Please use one of the next years:'
		print, '       - 2012'
		print, '       - 2014'
		print, '       - 2018'
		print, 'Example: foxsi,2014'
	endelse
endelse
END
