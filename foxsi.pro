; June 2016
; STARTUP FOXSI
; Description: 
;
;

PRO FOXSI, YEAR

COMMON FOXSI

if not keyword_set(year) then begin 
	print,'Please provide the year of the FOXSI flight (2012 or 2014).'
	print,'       Example: foxsi,2014'
endif else begin

	if ((year eq 2012) OR (year eq 2014)) then begin
		; add directory paths
		add_path, FOXSIPKG+'/fermi'
		add_path, FOXSIPKG+'/img'
		add_path, FOXSIPKG+'/resp'
		add_path, FOXSIPKG+'/psf'
		add_path, FOXSIPKG+'/proc'
		add_path, FOXSIPKG+'/spec'
		add_path, FOXSIPKG+'/util'

		if year eq 2014 then begin
			; load the Level 2 data.
			restore, FOXSIDB+'/data_2014/foxsi_level2_data.sav', /v
			print, 'You just load all the parameters and data needed' 
			print, 'to do the analysis of the FOXSI 2014 observations.'
			print, ''
			print, 'Type help if you want to check the 2014-parameters.'		
		endif

		if year eq 2012 then begin
			; load the Level 2 data.
			restore, FOXSIDB+'/data_2012/foxsi_level2_data.sav', /v
			restore,FOXSIDB+'/data_2012/flight2012-parameters.sav', /v
			print, 'You just load all the parameters and data needed' 
			print, 'to do the analysis of the FOXSI 2012 observations.'
			print, ''
			print, 'Type help if you want to check the 2012-parameters.'
		endif		

	endif else begin
		print, 'FOXSI did not fly that year.'
		print, 'Please use one of the next years:'
		print, '       - 2012'
		print, '       - 2014'
		print, 'Example: foxsi,2014'
	endelse
endelse
END
