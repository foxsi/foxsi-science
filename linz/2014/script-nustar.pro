shift = shift_map( nu_map, -40., 40. )

loadct,3
plot_map, shift, cen=smooth, fov=10, /limb
plot_map, total, /over, lev=[30,50,70,90], /per, col=255, thick=3

popen, 'nustar-on-aia', xsi=7, ysi=7
loadct,1
reverse_ct
plot_map, aia131[0], cen=smooth, fov=10, /limb, dmin=0., dmax=100., $
	charsi=1.2, charth=2, xth=5, yth=5, color=255
plot_map, shift, /over, lev=[30,50,70,90], /per, thick=5, col=255
xyouts, 1050, -600, 'NuSTAR', charsi=2, col=255
pclose

;hsi_linecolors
