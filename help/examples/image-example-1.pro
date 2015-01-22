; Set auto parameters for 2014 flight.
@foxsi-setup-script-2014

; Choose the time range and location.
trange = [t1_pos2_start,t1_pos2_end]  ; values defined in setup script
center = cen1_pos2		; values defined in setup script

; Make the image.
map6 = foxsi_image_map( data_lvl2_d6, center, $
	trange=[t1_pos2_start, t1_pos2_end], /xycorr )

plot_map, map6, /log, /cbar

