FUNCTION get_foxsi_resp, det = det, bin = bin, erange = erange, fwhm = fwhm, $
	offaxis_arcmin=offaxis_arcmin, save_idl = save_idl, save_fits = save_fits, $ 
	type = type, year=year, _extra = _extra 

;
; PURPOSE: Produce FOXSI instrument response for single detector-optic pairing which 
;          incorporates finite energy resolution of the detectors.
;
; KEYWORDS: 
;	DET:		set detector number to use (0-6)
;	BIN: 		energy bin size (keV)
;	ERANGE: 	energy range, include start and end values (keV)
;	FWHM:		energy resolution of detector (0.5 keV for Si, 1.0 keV for CdTe)
;	OFFAXIS_ARCMIN:	offaxis position of source (arcmin) 
;	SAVE_IDL: 	set this keyword to save the response in an IDL .sav file
;	SAVE_FITS:	set this keyword to save the response to a FITS file
;	TYPE: 		set detector type ('si' or 'cdte')
;	YEAR:		year of FOXSI launch (2012, 2014, or 2018)
;
; OUTPUT: 
;	Structure with nondiagonal response (cm^2) and corresponsing energy array (keV).
;

default, offaxis_arcmin,0.0
default, bin, 0.1
default, erange, [2.0,21.9]
default, det, 6
default, fwhm, 0.5
default, type, 'si'
default, year, 2014

; create energy array based on set energy range and bin size
elements = ((erange[1]-erange[0])/bin)+1.
energy = findgen(elements, increment=bin, start=erange[0])

; If YEAR is not set then COMMON DATE will be used to know which FOXSI flight the user is working with.

if not keyword_set(year) then begin

        COMMON FOXSI_PARAM ; allows access to the FOXSI COMMON variables.

        datefoxsi1 = anytim('2012-nov-02') ; FOXSI1 Launch Date
        datefoxsi2 = anytim('2014-dec-11') ; FOXSI2 Launch Date
        datefoxsi3 = anytim('2018-sep-7') ; FOXSI3 Launch Date

        if typename(date) eq 'UNDEFINED' then begin
                print,'ERROR: Please set the YEAR keyword or run foxsi.pro to load parameters for the appropriate year (2012, 2014, or 2018)'
                return, -1
        endif

        if date eq datefoxsi1 then year=2012
        if date eq datefoxsi2 then year=2014
        if date eq datefoxsi3 then year=2018

        if (date ne datefoxsi1) and (date ne datefoxsi2) and (date ne datefoxsi3) then begin
                print,'ERROR: Date does not match any FOXSI flight!'
                print,'Please set the YEAR keyword or run foxsi.pro to load parameters for the appropriate year (2012, 2014, or 2018)'
                return, -1
        endif

endif

; compute diagonal response
resp_diag = get_foxsi_effarea( energy_arr=energy, module=det, type = type, $
	offaxis_angle=offaxis_arcmin,year=year, _extra=_extra )
diag = resp_diag.eff_area_cm2
ndiag = n_elements( diag )
nondiag = fltarr(ndiag,ndiag)	; create 2D array for nondiagonal response

for j=0, ndiag-1 do nondiag[j,j]=diag[j]	;set diagonal of nondiag to the diagonal response (cm^2)
sigma = fwhm / 2.355	; convert FWHM to sigma for Gaussian function
toty = total(gaussian(findgen(ndiag),[0.3989*bin/sigma,round(elements/2.),sigma/bin] ))
	; toty is a sum of the values of a normalized Gaussian function binned according to the set 'bin' keyword.
        ; The standard deviation for the Gaussian is normalized to the bin size (sigma/bin).
        ; toty should be equal to one, but is slightly off due to rounding.

; compute the nondiagonal response by convolving diagonal response with a Gaussian

for j=0, ndiag-1 do begin
        y = diag[j]*gaussian( findgen(ndiag), [0.3989*bin/sigma,j,sigma/bin] )/toty
		; y is the convolution of the diagonal response value diag[j] with a
		; Gaussian function of standard deviation sigma/bin. 
		; The values are normalized using toty (described above).
        nondiag[*,j] = y
endfor

; create structure with energy array and nondiagonal response
resp = create_struct('energy_keV', energy, 'nondiag', nondiag)

; convert parameters to strings for filename
det2 = strtrim(det,2)

e0 = string(erange[0],format='(f20.1)')
e1 = string(erange[1],format='(f20.1)')
e0 = strtrim(e0,2)
e1 = strtrim(e1,2)

bin2 = string(bin, format='(f20.1)')
bin2 = strtrim(bin2,2)

oa = string(offaxis_arcmin,format='(f20.1)')
oa = strtrim(oa,2)

case year of 
	2012: flight = 'foxsi1'
	2014: flight = 'foxsi2'
	2018: flight = 'foxsi3'
endcase

filename = flight+'_det'+det2+'_E'+e0+'-'+e1+'_b'+bin2+'_offaxis'+oa+'_resp'

; save response to an IDL .sav file
if keyword_set(save_idl) then begin
	save, resp, filename = filename+'.sav'
endif

; save response to a FITS file
if keyword_set(save_fits) then begin
	foxsi_resp_fxbw, filename+'.fits', resp
endif

return, resp

end
