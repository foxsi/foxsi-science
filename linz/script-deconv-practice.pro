targ4hi = deconv_foxsi( [1,1,0,1,1,1,1], [t4_start,t4_end], first=rawtest2, erange=[6.6,12] )
targ4lo = deconv_foxsi( [1,1,0,1,1,1,1], [t4_start,t4_end], first=rawtest1, erange=[4.,6.6] )   

targ6hi = deconv_foxsi( [1,1,0,1,1,1,1], [t6_start,t6_end], first=rawtest2, erange=[6.6,12] )
targ6lo = deconv_foxsi( [1,1,0,1,1,1,1], [t6_start,t6_end], first=rawtest1, erange=[4.,6.6] )   

targ6c = deconv_foxsi( [1,1,0,1,1,1,1], [t4_start,t6_end], first=rawtest2, erange=[7.5,12] )
targ6b = deconv_foxsi( [1,1,0,1,1,1,1], [t4_start,t6_end], first=rawtest1, erange=[6.,7.5] )   
targ6a = deconv_foxsi( [1,1,0,1,1,1,1], [t4_start,t6_end], first=rawtest1, erange=[4.,6.] )   

targ = deconv_foxsi( [1,1,0,1,0,0,0], [t4_start,t6_end], first=rawtest1, psf_map=psf )

iter=[1,5,10,20,30,40,50,60,70,80,100]
low = deconv_foxsi( [1,1,0,1,1,1,1], first=raw_all6, pix=pix, iter=iter, /fix4, fov=4, psf_map=psf, $
	erange=[4.,6.6] )
high = deconv_foxsi( [1,1,0,1,1,1,1], first=raw_all6, pix=pix, iter=iter, /fix4, fov=4, psf_map=psf, $
	erange=[6.6,12] )

lowmap = low[7]
highmap = high[7]
cen = map_centroid(lowmap)

plot_map, lowmap, cen=cen
plot_map, highmap, /over

ratio = highmap
ratio.data = 0.
i = where( highmap.data gt 0.1*max(highmap.data) and lowmap.data gt 0.1*max(lowmap.data) )
ratio.data[i] = float(highmap.data[i]) / lowmap.data[i]

popen, 'ratio', xsi=8, ysi=4
!p.multi=[0,3,1]
plot_map, lowmap, cen=cen, fov=1, tit='4-6.6 keV', charsi=1.3
plot_map, highmap, cen=cen, fov=1, tit='4-6.6-12 keV', charsi=1.3
plot_map, ratio, /cbar, cen=cen, fov=1, charsi=1.3, tit='Ratio high/low'
pclose

!p.multi=[0,2,2]
;popen, 'test', xsi=8, ysi=8
plot_map, targ4lo[9]
xyouts, -10,  50, 'Target 4: 4-6.6 keV', col=255
xyouts, 10, -50, strtrim(total(targ4lo[0].data),2)+' counts', col=255
plot_map, targ4hi[9]
xyouts,  -10,  50, 'Target 4: 6.6-12 keV', col=255
xyouts, 10, -50, strtrim(total(targ4hi[0].data),2)+' counts', col=255
plot_map, targ6lo[9]
xyouts,  -10,  50, 'Target 6: 4-6.6 keV', col=255
xyouts, 10, -50, strtrim(total(targ6lo[0].data),2)+' counts', col=255
plot_map, targ6hi[9]
xyouts,  -10,  50, 'Target 6: 6.6-12 keV', col=255
xyouts, 10, -50, strtrim(total(targ6hi[0].data),2)+' counts', col=255
;pclose


!p.multi=[0,2,1]
plot_map, targ4lo[8]
xyouts, -10,  50, 'Target 4: 4-6.6 keV', col=255
xyouts, 10, -50, strtrim(total(targ4lo[0].data),2)+' counts', col=255
plot_map, targ4hi[8], /over, lev=[90],/per,col=0
plot_map, targ6lo[8]
xyouts,  -10,  50, 'Target 6: 4-6.6 keV', col=255
xyouts, 10, -50, strtrim(total(targ6lo[0].data),2)+' counts', col=255
plot_map, targ6hi[8], /over, lev=[90],/per,col=0


!p.multi=[0,2,2]
;popen, 'test', xsi=8, ysi=8
plot_map, targ6a[9]
xyouts, -10,  50, 'Target 4,6: 4-6 keV', col=255
xyouts, 10, -50, strtrim(total(targ6a[0].data),2)+' counts', col=255
plot_map, targ6b[9]
xyouts,  -10,  50, 'Target 4,6: 6-7.5 keV', col=255
xyouts, 10, -50, strtrim(total(targ6b[0].data),2)+' counts', col=255
plot_map, targ6c[9]
xyouts,  -10,  50, 'Target 4,6: 7.5-12 keV', col=255
xyouts, 10, -50, strtrim(total(targ6c[0].data),2)+' counts', col=255
;pclose

!p.multi=[0,2,2]
;popen, 'test', xsi=8, ysi=8
plot_map, targ6a[0]
xyouts, -10,  50, 'Target 4,6: 4-6 keV', col=255
xyouts, 10, -50, strtrim(total(targ6a[0].data),2)+' counts', col=255
plot_map, targ6b[0]
xyouts,  -10,  50, 'Target 4,6: 6-7.5 keV', col=255
xyouts, 10, -50, strtrim(total(targ6b[0].data),2)+' counts', col=255
plot_map, targ6c[0]
xyouts,  -10,  50, 'Target 4,6: 7.5-12 keV', col=255
xyouts, 10, -50, strtrim(total(targ6c[0].data),2)+' counts', col=255
;pclose

