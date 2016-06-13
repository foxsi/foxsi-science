; intensity plots of Sun with ghost ray sources weighted by intensity.

; start here.  no collimation first!
; max double ray is 4.27310.
; non focused areas are x1.e8!
max2 = 4.27310e8
;cen = [500, -200]
cen = [200, 750]

f=file_search( 'ghost-rays/zero*' )
dat_2 = read_ascii( f[0] )
dat_h = read_ascii( f[1] )
dat_p = read_ascii( f[2] )

data = dat_h.field01[1:10,1:16] + dat_p.field01[1:10,1:16]
x = reform( dat_h.field01[0,1:16])
y = total(data,1)
x = [x,x+30]
y = [y,fltarr(16)];+y[15]]
x2 = findgen(240)/4.
y2 = interpol( y,x,x2 )
;plot, x, y
;oplot, x2, smooth(y2,4)
pix = 2*30.*60./n_elements(x2)

img = fltarr( 500,500 )
map = make_map( img, dx=pix, dy=pix )
map.data[250:489,250] = y2
map=replicate(map, 360)
for i=0, 359 do map[i] = rot_map( map[i], i )
map.roll_angle=0.

map2=map[0]
map2.data = total(map.data,3)
max = max(map2.data)
map2.data = smooth(map2.data,30)
map2.data = map2.data * max / max(map2.data)

map2 = shift_map( map2, cen[0], cen[1] )
loadct, 3
plot_map, map2, /limb
map_zero = map2



f=file_search( 'ghost-rays/twelve*' )
dat_2 = read_ascii( f[0] )
dat_h = read_ascii( f[1] )
dat_p = read_ascii( f[2] )

data = dat_h.field01[1:10,1:16] + dat_p.field01[1:10,1:16]
x = reform( dat_h.field01[0,1:16])
y = total(data,1)

x2 = findgen(120)/4.
y2 = interpol( y,x,x2 )

plot, x, y
oplot, x2, smooth(y2,4)

pix = 30.*60./n_elements(x2)

img = fltarr( 500,500 )
map = make_map( img, dx=pix, dy=pix )
;map.data[300:419,200] = y2
map.data[250:369,250] = y2
map=replicate(map, 360)
for i=0, 359 do map[i] = rot_map( map[i], i )
map.roll_angle=0.

map2=map[0]
map2.data = total(map.data,3)
max = max(map2.data)
map2.data = smooth(map2.data,30)
map2.data = map2.data * max / max(map2.data)
print, max(map2.data)

map2 = shift_map( map2, cen[0], cen[1] )
loadct, 3
plot_map, map2, /limb
map_coll = map2


window, 0 
plot_map, map_zero, /limb, dmax=max2, /log, dmin=1.
window, 1                                 
plot_map, map_coll, /limb, dmax=max2, /log, dmin=1.

loadct, 3
window, 0 
plot_map, map_zero, /limb, dmax=max, dmin=1., grid=10
window, 1                                 
plot_map, map_coll, /limb, dmax=max, dmin=1., grid=10

; tried a ratio but don't like that.
;ratio = map_coll
;ratio.data = map_coll.data / map_zero.data
;plot_map, ratio, /limb, dmax=max, grid=10


window, 0 
plot_map, map_zero, /limb, dmax=max2, /log, dmin=1.
window, 1                                 
plot_map, map_coll, /limb, dmax=max2, /log, dmin=1.

map_zero.id = 'No collimation'
map_coll.id = '12-inch collimators'
;plot_map, map_zero, cen=[0,0], fov= 60, /limb, dmax=max, dmin=1., grid=10, charsi=ch, lth=4, lcol=255, gcol=255, background=0, tit=map_zero.id
;plot_map, map_coll, cen=[0,0], fov= 60, /limb, dmax=max, dmin=1., grid=10, charsi=ch, lth=4, lcol=255, gcol=255, background=0, tit=map_coll.id

max = max(map_zero.data)

;reverse_ct
!X.MARGIN=[0.35,0.35]
!Y.MARGIN=[0.35,2]
!p.multi=[0,1,2]
ch=1.2
popen, 'ghost-ray-intensity', xsi=6, ysi=8
loadct, 3
plot_map, map_zero, xra=[-1500,1500],yra=[-1100,1100], /limb, dmax=max, dmin=1., grid=10, charsi=ch, lth=8, lcol=212, gcol=255, gth=4, background=0, tit=map_zero.id, xtit='', /noxti
hsi_linecolors
oplot, [cen[0]],[cen[1]], /psy, symsi=4., thick=10, col=255
oplot, [-100],[100], /psy, symsi=4., thick=10, col=3
oplot, [-900],[-250], /psy, symsi=4., thick=10, col=3
loadct, 3
plot_map, map_coll, xra=[-1500,1500],yra=[-1100,1100],/limb, dmax=max/1.5, dmin=1., grid=10, charsi=ch, lth=8, lcol=255, gcol=255, gth=4, background=0, tit=map_coll.id
hsi_linecolors
oplot, [cen[0]],[cen[1]], /psy, symsi=4., thick=10, col=255
oplot, [-100],[100], /psy, symsi=4., thick=10, col=3
oplot, [-900],[-250], /psy, symsi=4., thick=10, col=3
pclose
!X.MARGIN=[10,3]
!Y.MARGIN=[4,2] 
!p.multi=0
spawn, 'open ghost-ray-intensity.ps'

