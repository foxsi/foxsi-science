restore,'rhessi_imaging_foxsi_flare_march2013.sav',/ver


loadct2,3
center=[960,-205]
fov=1.5
!p.multi=[0,4,1]
;RHESSI
loadct2,5
plot_map,c3n,/limb,center=center,fov=fov,bot=8,lcolor=255,gcolor=255,grid=2
plot_map,vff,/over,/per,levels=[50],color=255,thick=2
plot_map,njmap,/limb,center=center,fov=fov,bot=8,lcolor=255,gcolor=255,grid=2
plot_map,vff,/over,/per,levels=[50],color=255,thick=2
plot_map,vff,/limb,center=center,fov=fov,bot=8,lcolor=255,gcolor=255,grid=2
plot_map,vff,/over,/per,levels=[50],color=255,thick=2
plot_map,pmap,/limb,center=center,fov=fov,bot=8,lcolor=255,gcolor=255,grid=2
plot_map,vff,/over,/per,levels=[50],color=255,thick=2
