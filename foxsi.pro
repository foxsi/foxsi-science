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
;
; :returns:
;
; :examples:
;   foxsi,2014
;
; :history:
;   June 2016 - Milo (SSL): initial release
;   2018-02-23 - Sophie Musset (UMN): replace '$FOXSIDB' by GETENV('FOXSIDB') when calling the foxsi level 2 data (because the previous command does not work on windows)
;   2019-10-15 - Sophie Musset (UMN): add the call to 'undefine_previous_param' at the beginning to avoid having parameters from another flight that stay defined
;-

PRO FOXSI, YEAR
COMMON FOXSI_PARAM

; in case some parameters are already defined from another flight, erase them
@undefine_previous_param

if not keyword_set(year) then begin 
	print,'Please provide the year of the FOXSI flight (2012, 2014 or 2018).'
	print,'       Example: foxsi,2014'
endif else begin

	if ((year eq 2012) OR (year eq 2014) OR (year EQ 2018)) then begin
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
			@param2012_20160620
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
