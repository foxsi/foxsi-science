@foxsi-setup-script-2014
data=data_lvl2_d6
loadct, 7
reverse_ct

trange=[t1_pos0_start,t1_pos0_end]
area_center = [0.,0.]
area_radius = [150.,750.]
energy_band = [5.,10.]

data = area_cut( data, area_center, area_radius, /xycorr)
m = foxsi_image_map( data, cen1_pos0, erange=[5.,10.], trange=trange, thr_n=4., /xycorr )
plot_map, m, /limb, lcol=255, col=255, charsi=1.2, title=m.id, /log, /cbar
draw_fov,det=6,target=1,shift=shift6,/xycor 
tvcircle,area_radius[0],area_center[0],area_center[1],/data
tvcircle,area_radius[1],area_center[0],area_center[1],/data


