;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FUNCTION FOXSI_IMAGE_PAY, DATA, DETECTOR, ERANGE=ERANGE, TRANGE=TRANGE, $
                          CENTER = CENTER, PSIZE=PSIZE, SIZE=SIZE, THR_N = THR_N
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  if not keyword_set(erange) then erange=[4.,15.]   ; energy range in keV
  if not keyword_set(trange) then trange=[108.3,498.3]   ; time range in seconds (from the launch)
  if not keyword_set(center) then center=[0.0, 0.0]   ; image center position in arcseconds
  if not keyword_set(psize) then psize=7.735   ; image pixel size (arcseconds/imagepixel)
  if not keyword_set(size) then size=[128,128]   ; size in image pixel numbers
  if not keyword_set(thr_n) then thr_n =3.0   ; threshold for n-side energy to include in the image

  tlaunch=long(64500.)
  rnum=1

  istart=long(0)
  istart=(where(data.wsmr_time ge trange[0]+tlaunch))[0]
  iend=(where(data.wsmr_time gt trange[1]+tlaunch))[0]
  img=fltarr(size[0], size[1])


  for i=istart, iend-1 do begin

      for j=0, rnum-1 do begin
          err = get_payload_coords(randomu(seed, 2)+63.5,detector)
          position = data[i].hit_xy_pay+err
          position = (position - center)/psize + size/2.
          xpix = (long(position))[0]
          ypix = (long(position))[1]
          
;print, data[i].hit_xy_pay, payposition
          if xpix ge 0 and xpix lt size[0] and ypix ge 0 and ypix lt size[1] and $
            data[i].error_flag eq 0 and data[i].hit_energy[1] ge erange[0] and $
            data[i].hit_energy[1] le erange[1] and data[i].hit_energy[0] gt thr_n then begin
              img(xpix, ypix)+=1/float(rnum)
          endif

      endfor
  endfor

  ;wdef,600,600
  ;image_cont, alog(img+1)
  ;print, 'max count = ',max(img)
  ;print, 'max count rate = ', max(img)/(trange[1]-trange[0])
  ;return, img/(trange[1]-trange[0])

return, img

END
