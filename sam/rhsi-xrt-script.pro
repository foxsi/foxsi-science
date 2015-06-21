restore,'rhsi_xrt_last_foxsi_target.dat'
loadct2,3
popen
!p.multi=[0,2,1]
this_fov=3
this_center=[20,-70]
this_center=[-65,90]
this_level=[50,70,90]
this_xrt=gxmap23
this_shift=[23,24]
this_xrt.xc=this_xrt.xc+this_shift(0)
this_xrt.yc=this_xrt.yc+this_shift(1)

plot_map,this_xrt,fov=this_fov,center=this_center,bot=9,dmax=-1700,dmin=-2500
plot_map,h_arx,/over,/per,levels=this_level,color=2,thick=4
xyouts,-147,19,'RHESSI 4-8 keV',charsize=1.4,color=2
xyouts,-147,7,'19:18:50-19:19:14UT',charsize=1.4,color=2

this_xrt2=gxmap24
this_xrt2.xc=this_xrt2.xc+this_shift(0)
this_xrt2.yc=this_xrt2.yc+this_shift(1)
plot_map,this_xrt2,fov=this_fov,center=this_center,bot=9,dmax=-1700,dmin=-3200
plot_map,h_arx,/over,/per,levels=this_level,color=2,thick=4
xyouts,-147,19,'RHESSI 4-8 keV',charsize=1.4,color=2
xyouts,-147,7,'19:18:50-19:19:14UT',charsize=1.4,color=2
pclose