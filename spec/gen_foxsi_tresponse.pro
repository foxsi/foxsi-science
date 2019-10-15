; IDL procedure by Athiray
; Copyright (c) 2017, FOXSI Mission University of Minnesota.  All rights reserved.
;       Unauthorized reproduction is allowed.


; Start		: 11 Feb 2019 23:37
; Last Mod 	: 11 Mar 2019 15:37

;-------------------  Details of the program --------------------------;
; General procedure to compute temperature response for FOXSI-2 Si detectors
; over a wide range  of temperatures
; Note : T response for CdTe detectors are not included here. padded  with zeros
; Use  foxsi2_count_spectrum with smear keyword to include detector's resolution (0.5 keV)
; Use  foxsi2_count_spectrum with averagects keyword to get average counts  in  each energy bin

PRO gen_foxsi_tresponse

logte = findgen( 37 )*0.05+5.7

em = 1.
te = 10.^logte/1.e6
n_te = n_elements( te )
n_energy = 6
min = where(te gt 1.)	; Only do temperatures above 1 MK.

dem_resp = fltarr( 7, n_energy, n_te )

for i_det = 0, 6 do begin
	print, i_det
	if i_det eq 2 then continue
	if i_det eq 3 then continue
for i_te = fix(min[0]), n_te-1 do begin
	print, i_te
	;The  following function computes expected AVERAGE foxsi2 counts in 1 keV energy bands
	;including smear in detector (0.5 keV fwhm)
	f=foxsi2_count_spectrum( em,te[i_te],time=1.,binsize=1.,module=i_det,offaxis=0,/smear,/averagects)
	dem_resp[i_det, *, i_te ] = f.counts[4:9] ;counts/s/(10^49cm-3)
endfor
endfor

energy = f.energy_kev[4:9]		; midpoint of energy bin (E range  4 to 10 keV)


alt_dem_resp = dem_resp*1d-49 ;Counts (10^-49) cm3 /s
side=1*1. ; in  arcsec^2
area=side*(0.725d8)^2 ;arcsec^2 to cm^2 conversion
foxsi_n_pixels=(side)/(7.7*7.7);this is for Si detector which has 7.7 arcsec/pixel
dem_resp_overarea = alt_dem_resp*area ;Counts cm5/s
dem_resp_overarea_ppixel=dem_resp_overarea/foxsi_n_pixels ; Counts  cm5/s/pix


;Plot FOXSI temperature response for Si Detector 6

plot, logte, dem_resp_overarea_ppixel[6,5,*], /psy, /ylo, charsi=1.2, xth=5, yth=5, $
	xtit='Log[ T(MK) ]', ytit='FOXSI D6 counts cm!U5!N s!U-1!N pix!U-1!N', /nodata
for i=0, 5 do oplot, logte, dem_resp_overarea_ppixel[6,i,*],  color=i+2, thick=1, symsi=1.5
al_legend, ['4.5 keV','5.5 keV','6.5 keV','7.5 keV','8.5 keV','9.5 keV'], $
	textcol=[2,3,4,5,6,7], thick=6, charsi=1.2, box=0, /bottom, /right

data_dir = '/calibration_data/'
save,logte,dem_resp_overarea_ppixel,filename='$FOXSIPKG' +data_dir+'foxsi_Si_temperature_response.sav'

END
