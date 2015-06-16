restore, 'idlsave_goes.sav',/v

utplot, tarray, yclean[*,0],timerange='2014-dec-11 19:'+['00','25']

goes_flux = yclean[0:799,0]
goes_flux2 = yclean[0:799,1]
goes_time = tarray[0:799]+utbase

goes_title = 'GOES flux 1.8 keV'

utplot, anytim(goes_time,/yo), goes_flux, timerange='2014-dec-11 19:'+['12','19'], $
	yrange=[6.5e-7, 7.5e-7], charsi=1.2, title=goes_title

utplot, anytim(goes_time,/yo), goes_flux2, timerange='2014-dec-11 19:'+['12','19'];, $
	yrange=[6.5e-7, 7.5e-7], charsi=1.2, title=goes_title

save, goes_time, goes_flux, goes_title, file='goes-lc.sav'


time_range = '2014-Dec-11 ' + ['1900','1925']

obs_obj = hsi_obs_summary( obs_time_interval=time_range )
obs_obj->plotman, /ylog		; to check that this is what we want.

data = obs_obj->getdata()	; extract data from the observing summary.

rate3  = data.countrate[0,*]		; 3-6 keV
rate6  = data.countrate[1,*]		; 6-12 keV
rate12 = data.countrate[2,*]		; 12-25 keV
rate25 = data.countrate[3,*]		; 25-50 keV

interval = anytim(time_range[1]) - anytim(time_range[0])
times = anytim( time_range[0] ) + 4.*findgen( interval/4. )

rhessi_flux = reform(rate3) + reform(rate6)
rhessi_time = times
rhessi_title='RHESSI 3-12 keV'

	
save, rhessi_time, rhessi_flux, rhessi_title, file = 'rhessi-lc.sav'

restore, 'rhessi-lc.sav'

	utplot,  anytim( rhessi_time,/yo ), rhessi_flux, psym=10, thick=4, yr=[0,20], $
	ytitle='Count rate (s!U-1!N detector!U-1!N)', title=rhessi_title, $
	timerange='2014-dec-11 19:'+['12:40','19:40']


;
; zoom in on GOES flares
;

restore, 'goes-lc.sav'

utplot, anytim(goes_time,/yo), goes_flux, timerange='2014-dec-11 19:'+['05','25'], $
	yrange=[6.5e-7, 7.5e-7], charsi=1.2, title=goes_title


	
