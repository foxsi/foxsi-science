;+
;COMMON BLOCK:	popen_com
;PURPOSE:	Common block for print routines
;
;SEE ALSO:	"popen","pclose",
;		"print_options"
;
;CREATED BY:	Davin Larson
;LAST MODIFICATION:	@(#)popen_com.pro	1.10 97/12/05
;-


common hardcopy_stuff2,old_device, $
    print_opts, $
    old_plot, $
    old_fname, $
    old_colors_com, $
;    old_color, $
;    old_bckgrnd, $
;    old_font,  $
    portrait,  $
    in_color,  $
    print_aspect,  $
    printer_name,  $
    print_directory, $
    print_font, $
    popened
