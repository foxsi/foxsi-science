
r_solar = (get_rb0p('02-Nov-2013'))[0]   ; solar radius on the launch date
xy_nominal = [-850.5, 150.4]   ; nominal position (center of FOV) in solar coordinate 
psize = 7.735  ;  detector pixel size in arcseconds
pos_error = 50.0  ;   maximum position uncertainty supposed in arcseconds

; count on-disk and off-disk pixels for each detector
ondisk_pixels = fltarr(7)
offdisk_pixels = fltarr(7)

for det=0, 6 do begin
    for ix=0, 126 do begin
        for iy=0, 126 do begin
            xy_pay = get_payload_coords([ix+1,iy+1], det) ; payload coordinates
            xy_solar = xy_pay + xy_nominal ; solar coordinates 
            rr = sqrt(total(xy_solar^2))
            if rr gt r_solar + pos_error then offdisk_pixels[det] += 1
            if rr lt r_solar - pos_error then ondisk_pixels[det] +=1
        endfor
    endfor
endfor


; count on-disk and off-disk photons for each detector

trange = [154.8,244.7]

counts=foxsi_count_ondisk(data_lvl2_d0, 0, trange=trange, pos_error=pos_error, /xycor)
;counts+=foxsi_count_ondisk(data_lvl2_d1, 1, trange=trange, pos_error=pos_error, /xycor)
counts+=foxsi_count_ondisk(data_lvl2_d2, 2, trange=trange, pos_error=pos_error, /xycor)
counts+=foxsi_count_ondisk(data_lvl2_d4, 4, trange=trange, pos_error=pos_error, /xycor)
counts+=foxsi_count_ondisk(data_lvl2_d5, 5, trange=trange, pos_error=pos_error, /xycor)
counts+=foxsi_count_ondisk(data_lvl2_d6, 6, trange=trange, pos_error=pos_error, /xycor)

index=[1,0,1,0,1,1,1]
pixels=[total(offdisk_pixels*index),total(ondisk_pixels*index)]

print, 'off/on disk counts: ', counts
print, 'off/on disk pixels: ', pixels
print, 'off/in disk counts/pixels', counts/pixels
print, 'bgd sigma (counts/pixels): ', sqrt(counts[0])/pixels[0]
print, (counts[1]/pixels[1]-counts[0]/pixels[0])/(sqrt(counts[0])/pixels[0]), ' sigma detection!'




end




