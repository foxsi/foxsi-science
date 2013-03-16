restore,'data_2012/rhsi_foxsi_flare1_photon_spectrum.sav'

erange=[1,30]
frange=[1d-7,1d4]
loadct2,0
chs=0.8
plot_oo,erange,frange,$
        xr=erange,xstyle=5,charsize=chs,$
        yr=frange,ystyle=5,charthick=chth,/nodata        
polyfill,[abins(0),abins,max(abins)],[0,s_max,0],color=188
polyfill,[1,abins,max(abins)],[0,s_min,0],color=0
oplot,abins,s_sum,color=6,thick=2
axis,xaxis=0,xr=erange,xstyle=1,xtitle='energy [keV]',charsize=chs
axis,yaxis=0,yr=frange,ystyle=1,ytitle='photons s!U-1!N cm!U-2!N keV!U-1!N',charsize=chs


popen,xsize=9./2.54,ysize=10./2.54
erange=[1,30]
frange=[1d-7,1d4]
loadct2,0
chs=0.8
plot_oo,erange,frange,$
        xr=erange,xstyle=5,charsize=chs,$
        yr=frange,ystyle=5,charthick=chth,/nodata        
polyfill,[abins(0),abins,max(abins)],[0,s_max,0],color=188
polyfill,[1,abins,max(abins)],[0,s_min,0],color=255
oplot,abins,s_sum,color=6,thick=2
axis,xaxis=0,xr=erange,xstyle=1,xtitle='energy [keV]',charsize=chs
axis,yaxis=0,yr=frange,ystyle=1,ytitle='photons s!U-1!N cm!U-2!N keV!U-1!N',charsize=chs
pclose

