;+
;PROCEDURE: popen, filename
;PURPOSE:
;  Change plot device to postscript.
;INPUT:    optional;  if:
;  string   :  string used as filename,  '.ps' extension is added automatically
;  integer X:  filename set to 'plotX.ps'.  value of x is incremented by 1.
;  none:       filename set to 'plot.ps'
;KEYWORDS: See print_options for info.
;  COPY:    pass COPY keyword to set_plot
;  INTERP:  pass INTERP keyword to set_plot  (default is to have interp off)
;  XSIZE:   postscript plot size in the x direction
;  YSIZE:   postscript plot size in the y direction
;  UNITS:   plot size units (inches or cm)
;SEE ALSO:	"pclose",
;		"print_options",
;		"popen_com"
;HISOTRY:
; 4-apr-2008   cg, added optional keywords for postscript plot size
;                  units for plot size variables
;CREATED BY:	Davin Larson
;LAST MODIFICATION:	@(#)popen.pro	1.21 98/06/23
;-

pro popen,n,          $
  port=port,          $
  landscape=land,          $
  color=color,        $
  bw=bw,              $
  printer=printer,    $
  directory=printdir, $
  font = font,        $
  aspect = aspect,    $
  xsize = xsize,      $
  ysize = ysize,      $
  units = units,      $
  interp = interp,    $
  ctable = ctable,    $
  options = options,  $
  copy = copy,        $
  encapsulated = encap
  
@popen_com.pro

common colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr

; lphilpott 9-may-2012, check to see whether a color table has been loaded (this is the way loadct checks)
if (n_elements(r_orig) lt !d.table_size) then begin
  dprint, dlevel=2, 'No color table set, loading color table 39.'
  loadct, 39
endif
old_colors_com = {r_orig: r_orig, g_orig: g_orig, b_orig: b_orig,$
	r_curr: r_curr, g_curr: g_curr, b_curr: b_curr}

print_options,directory=printdir,land=land,port=port


str_element,options,'encapsulated',encap
str_element,options,'filename',n
str_element,options,'xsize',xsize
str_element,options,'ysize',ysize
str_element,options,'units',units
str_element,options,'ctable',ctable
str_element,options,'charsize',charsize
str_element,options,'landscape',land
str_element,options,'noplot',ignore

if keyword_set(ignore) then return

extension = (['.ps','.eps'])(keyword_set(encap))

if n_elements(n) ne 0 then begin
  if data_type(n) eq 0 then n = 1
  if data_type(n) eq 2 then begin
    fname = strcompress('plot'+string(n)+extension,/REMOVE_ALL)
    n = n+1
  endif
  if data_type(n) eq 7 then $
    if strpos(n,extension) ne strlen(n)-strlen(extension) then $
    fname=n+extension else fname = n
endif
if data_type(fname) ne 7 then fname = 'plot'+extension
if print_directory ne '' then fname = print_directory+'/'+fname

if n_elements (old_device) eq 0 then popened = 0
if popened then  pclose,printer=printer

print ,'Opening postscript file ',fname,' Use PCLOSE to close'

old_device = !d.name
old_fname  = fname
old_plot   = !p
;old_color  = !p.color
;old_font   = !p.font
;old_bckgrnd= !p.background

if n_elements(interp) eq 0 then interp = 0
if n_elements(copy) eq 0 then copy =0

set_plot,'PS',interp=interp,copy=copy

if keyword_set(encap) then  device,encap=1 else device,encap=0

if keyword_set(charsize) then !p.charsize = charsize


print_options,port=port,land=land,color=color,bw=bw, $
    printer=printer,font=font,aspect=aspect, $
    xsize=xsize,ysize=ysize,units=units


if n_elements(ctable) ne 0 then loadct2,ctable

if keyword_set(bw) then begin  ; force all colors to black
  tvlct,r,g,b,/get
  r(*) = 100 & g(*)=200 & b(*)=30
  tvlct,r,g,b
endif

device,file=old_fname

popened = 1

return
end


