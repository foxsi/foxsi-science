;+
;PROCEDURE:   pclose
;INPUT:  none
;PURPOSE: Close postscript file opened with popen, and change device back to 
;  default.
;  If common block string 'printer_name' is set, then file is sent to that
;  printer.
;SEE ALSO: 	"print_options"
;		"popen"
;
;CREATED BY:	Davin Larson
;LAST MODIFICATION:	@(#)pclose.pro	1.10 99/02/18
;-



pro pclose,printer=printer,xview=xview,comment=comment
@popen_com.pro

if !d.name eq 'PS' then begin
   device,/close
   set_plot,old_device
   !p.background = old_plot.background
   !p.color      = old_plot.color
   !p.font       = old_plot.font
   !p.charsize   = old_plot.charsize
   print,"Closing plot ",old_fname
endif

if keyword_set(printer_name) and not keyword_set(printer) then printer=printer_name
;if n_elements(printer) then printer_name = string(printer)

if keyword_set(comment) then begin
  print,'Appending comment to ',old_fname
  openu,lu,old_fname,/append,/get_lun
  for i=0,n_elements(comment)-1 do begin
     printf,lu,'% '+comment[i]
  endfor
  free_lun,lu
endif


if keyword_set(printer) then begin
   maxque = 2
   command = 'lpq -P'+printer+' | grep -c '+getenv('USER')
   repeat begin
   spawn,command,res
   n = fix(res(n_elements(res)-1))
   if n ge maxque  then begin
      print,systime(),': ',n,' plots in the que.  Waiting...'
      wait, 60.
   endif
   endrep until n lt maxque

   command = 'lpr -P'+printer+' '+old_fname
   print,command
   spawn,command
   print,old_fname,' has been sent to printer '+printer
endif

if keyword_set(xview) then begin
  spawn,'xv '+old_fname+' &'
endif

popened = 0

common colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr
r_orig = old_colors_com.r_orig
g_orig = old_colors_com.b_orig
b_orig = old_colors_com.g_orig
r_curr = old_colors_com.r_curr
b_curr = old_colors_com.b_curr
g_curr = old_colors_com.g_curr

return
end

