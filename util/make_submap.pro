FUNCTION make_submap, map, refmap, xrange=xrange, yrange=yrange, drot_time=drot_time, $
					  center=center, fov=fov, _extra=extra


if (keyword_set(center) and not keyword_set(refmap)) then begin
    xrange=[center(0)-fov*30.,center(0)+fov*30.]
    yrange=[center(1)-fov*30.,center(1)+fov*30.]
endif

fdim=n_elements(map)
if keyword_set(drot_time) then reftime=anytim(drot_time)

for i=0,fdim-1 do begin 
   sub_map,map(i),hmap,ref_map=refmap,xrange=xrange,yrange=yrange, _extra=extra
   if keyword_set(drot_time) then begin
      ttt=(-anytim(hmap.time)+reftime)/3600.
      print,ttt
      rmap=drot_map(hmap,ttt)
      hmap=rmap
   endif
  if i eq 0 then begin 
     smap=hmap
  endif else begin 
     smap=[smap,hmap]
  endelse
endfor


return,smap

END