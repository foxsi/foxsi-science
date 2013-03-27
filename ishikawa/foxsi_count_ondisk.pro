;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FUNCTION FOXSI_COUNT_ONDISK, DATA, DETECTOR, ERANGE=ERANGE, TRANGE=TRANGE, POS_ERROR=POS_ERROR, XYCOR=XYCOR, THR_N=THR_N
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  r_solar = (get_rb0p('02-Nov-2013'))[0]   ; solar radius on the launch date
  if not keyword_set(erange) then erange=[4.,15.]   ; energy range in keV
  if not keyword_set(trange) then trange=[108.3,498.3]   ; time range in seconds (from the launch)
  if not keyword_set(pos_error) then pos_error=50.0   ;maximum position uncertainty supposed in arcseconds
  if not keyword_set(thr_n) then thr_n =3.0   ; threshold for n-side energy to include in counts

  tlaunch=long(64500.)
  xerr=[55.4700,      81.4900,      96.3600,      87.8900,      48.2700,      49.5500,      63.4500]
  yerr=[-135.977,     -131.124,     -130.241,     -92.7310,     -95.3080,     -120.276,     -106.360]

  istart=long(0)
  istart=(where(data.wsmr_time ge trange[0]+tlaunch))[0]
  iend=(where(data.wsmr_time gt trange[1]+tlaunch))[0]
  count=fltarr(2)

  xyerr = fltarr(2)
  if keyword_set(xycor) then xyerr = [xerr[detector], yerr[detector]]


  for i=istart, iend-1 do begin

          position = data[i].hit_xy_solar - xyerr
          rr = sqrt(total(position^2))
          
          if data[i].error_flag eq 0 and data[i].hit_energy[1] ge erange[0] and $
            data[i].hit_energy[1] le erange[1] and data[i].hit_energy[0] gt thr_n then begin
            if rr gt r_solar + pos_error then count[0] +=1
            if rr lt r_solar - pos_error then count[1] +=1
          endif

  endfor

return, count

END
