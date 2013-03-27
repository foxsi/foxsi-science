;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FUNCTION FOXSI_IMAGE_PAY_INT,D0,D1,D2,D3,D4,D5,D6,ERANGE=ERANGE, TRANGE=TRANGE, $
                          CENTER = CENTER, PSIZE=PSIZE, SIZE=SIZE, INDEX=INDEX, THR_N=THR_N
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  if not keyword_set(erange) then erange=[4.,15.]   ; energy range in keV
  if not keyword_set(trange) then trange=[108.3,498.3]   ; time range in seconds (from the launch)
  if not keyword_set(center) then center=[0.0, 0.0]   ; image center position in arcseconds
  if not keyword_set(psize) then psize=7.735   ; image pixel size (arcseconds/imagepixel)
  if not keyword_set(size) then size=[128,128]   ; size in image pixel numbers
  if not keyword_set(index) then index=[1,1,1,1,1,1,1]

;  restore, 'foxsi_level2_data.sav', /v
  img=fltarr(size[0],size[1])

   if index[0] eq 1 then $
    img = img + foxsi_image_pay(d0, 0,erange=erange, trange=trange, center=center, psize=psize, size=size, thr_n=thr_n)  
   if index[1] eq 1 then $
    img = img + foxsi_image_pay(d1,1,erange=erange, trange=trange, center=center, psize=psize, size=size, thr_n=thr_n)  
   if index[2] eq 1 then $
    img = img+foxsi_image_pay(d2,2,erange=erange, trange=trange, center=center, psize=psize, size=size, thr_n=thr_n)  
   if index[3] eq 1 then $
    img = img+foxsi_image_pay(d3,3,erange=erange, trange=trange, center=center, psize=psize, size=size, thr_n=thr_n)  
   if index[4] eq 1 then $
    img = img+foxsi_image_pay(d4,4,erange=erange, trange=trange, center=center, psize=psize, size=size, thr_n=thr_n)  
   if index[5] eq 1 then $
    img = img+foxsi_image_pay(d5,5,erange=erange, trange=trange, center=center, psize=psize, size=size, thr_n=thr_n)  
   if index[6] eq 1 then $
    img = img+foxsi_image_pay(d6,6,erange=erange, trange=trange, center=center, psize=psize, size=size, thr_n=thr_n)  
  










  wdef,500,500
  image_cont, alog(img+1)
  print, 'max count = ',max(img)
  print, 'max count rate = ', max(img)/(trange[1]-trange[0])
  return, img/(trange[1]-trange[0])


END
