; Plot Spline interpolation for all the 64 channel given a ASIC for 
; an specific detector

PRO PLOT_SPLINE, FILE , ASIC , CH, XRANGE = XRANGE, YRANGE = YRANGE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  if not keyword_set(file) then file = '../../../calibration_data/peaks_det101.sav'
  if not keyword_set(asic) then asic = 2
  if not keyword_set(ch) then ch = 25
  if not keyword_set(xrange) then xrange = [0, 1024]
  if not keyword_set(yrange) then yrange = [0,100]
  
  restore,file
  
  window, xsize = 1200, ysize = 800
  x_axis = findgen(1000)/1000.*(xrange[1] - xrange[0]) + xrange[0] 
  

;  set_plot,'ps'
;  device,filename=print,strmid(file,0,12)+'_ASIC'+ASIC+'.eps',/color,/INCHES,YSIZE=10.0,XSIZE=20.0
  
  !p.multi = [0, 1, 1]
  
  ploty=spline(peaks[*, ch, asic,0], peaks[*, ch, asic, 1], x_axis)
  plot,peaks[*, ch, asic,0],peaks[*, ch, asic,1], xrange = xrange, yrange = yrange, psym = 4
  oplot, x_axis,ploty, psym = 0,color=255;,thick=3.0
  loadct,13  
;  device,/close
  loadct,0
  
END
