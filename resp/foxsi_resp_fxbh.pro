FUNCTION foxsi_resp_fxbh, resp

;
; PURPOSE: 
;	Create fits header for the FOXSI response.
;
; INPUT:
;	RESP: structure with FOXSI response and corresponding energy array
;
; OUTPUT:
;	Header for FOXSI response file.
;
; NOTES: 
;	This function was based on hsi_obs_summ_fxbh.pro.
;
; HISTORY: 
;	Oct 2019	Created by Julie Vievering
;

; define tag labels for FOXSI response
tag_labels = ['ENERGY (keV)','RESPONSE (cm^2)']

title = strupcase(tag_names(resp,/struct))

nrows = n_elements(resp)	;number of rows
aa = resp[0]			;only one element for the header

tags = tag_names(resp)	
ncolumns = n_elements(tags)
use_labels = 1b

; initialize the header
fxbhmake, h0, nrows, title

; populate the header using the tags of the data structure
for i=0, ncolumns-1 do begin
	; determine the data type
	dtype = datatype(aa.(i))
	temp = aa.(i)
	if (n_elements(temp) eq 1) then temp=temp[0]
	if use_labels then begin
		; strip actual tag names from string
		tli = tag_labels[i]
		strpi = strpos(tli,':')
		if (strpi[0] ne -1) then begin
			tli1 = strtrim(strmid(tli, strpi[0]+1),2)
		endif else tli1 = tli
		fxbaddcol, i+1, h0, temp, tags[i], tli1
	endif else fxbaddcol, i+1, h0, temp, tags[i]
endfor

return, h0

end
