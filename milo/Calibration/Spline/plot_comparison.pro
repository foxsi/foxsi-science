; Plot Comparison among interpolation using a differnt amount of
; points for one specific channel, ASIC and detector.


PRO PLOT_COMPARISON, FILE , ASIC , CH, XRANGE = XRANGE, YRANGE = YRANGE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  if not keyword_set(file) then file = '../../../calibration_data/peaks_det101.sav'
  if not keyword_set(asic) then asic = 2
  if not keyword_set(ch) then ch = 25
  if not keyword_set(xrange) then xrange = [-100, 300]
  if not keyword_set(yrange) then yrange = [-10,30]
  
  restore,file
  
  window, xsize = 1200, ysize = 800
  x_axis = findgen(1000)/1000.*(xrange[1] - xrange[0]) + xrange[0] 
  

;  set_plot,'ps'
;  device,filename=print,strmid(file,0,12)+'_ASIC'+ASIC+'.eps',/color,/INCHES,YSIZE=10.0,XSIZE=20.0
  
  !p.multi = [0, 1, 1]

  ; Interpolating
  ploty10=spline(peaks[*, ch, asic,0], peaks[*, ch, asic, 1], x_axis)
  ploty9=spline(peaks[1:9, ch, asic,0], peaks[1:9, ch, asic, 1], x_axis)
  ploty8=spline(peaks[2:9, ch, asic,0], peaks[2:9, ch, asic, 1], x_axis)
  ploty7=spline(peaks[3:9, ch, asic,0], peaks[3:9, ch, asic, 1], x_axis)
  linear=linfit(peaks[1:9, ch, asic,0], peaks[1:9, ch, asic, 1], yfit=plotyl)

  ; plotting
  loadct,12 
  plot,peaks[*, ch, asic,0],peaks[*, ch, asic,1], xrange = xrange, yrange = yrange, psym = 4,color=255
  oplot, x_axis,ploty10, psym = 0,color=200;,thick=3.0
  oplot, x_axis,ploty9, psym = 0,color=110;,thick=3.0
  oplot, x_axis,ploty8, psym = 0,color=50;,thick=3.0
  oplot, x_axis,ploty7, psym = 0,color=130;,thick=3.0
  ;oplot,
  vline,0.0,linestyle='dash',/data
  hline,0.0,linestyle='dash',/data
;  device,/close
  loadct,0
  
END
