PRO plot_psf, OFFAXIS, STOP = STOP, THRESH = THRESH, FILENAME=FILENAME

; Procedure modified by Lindsay to work for a particular off-axis angle only.
; It still plots all the possibilities for the Z offset.
; The Gaussian fit is done only above the threshold percentage.
; Plots are sent to a file named <filename>.
;
; Example:
; 	plot_psf, 3, thresh=0.4
;
;	This will make files with plots for an off-axis angle of 3 arcmin and only
;	fitting the Gaussian above 40% of the max.
;

default, thresh, 0.2
default, filename, 'plot_psf'

restore, filename='psf/psf.dat'
restore, filename='psf/axis.dat'

dim_dz = n_elements(psf[0,0,*,0])
dim_offax = n_elements(psf[0,0,0,*])

dz = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
offax = [0, 3, 6, 9, 12, 15]

if total( offaxis eq offax ) ne 1 then begin
	print, 'Acceptable off-axis angle inputs are [0,3,6,9,12,15].'
	return
endif
j = where(offax eq offaxis)
j = fix( j[0] )

dimx = n_elements(psf[*,0,0,0])

!P.MULTI=[0,3,2]

loadct,5

ps, filename, /landscape
;popen, 'plot_psf', xsize = 8, ysize = 4

;FOR j = 0, dim_offax-1 DO BEGIN
        FOR i = 0, 6-1 DO BEGIN

        x = findgen(dimx)*axis[i,j]
        x = x - max(x)/2.0
        y = x

        contour, psf[*,*,i,j], x, y, yrange=[min(y),max(y)], xrange=[min(x),max(x)], $
        		/nodata, charsize = 1.2, xtitle = 'arcsecs', ytitle = 'arcsecs'
        contour, psf[*,*,i,j], x, y, levels=[0.001,0.01,0.1,1.0], /fill, /overplot
        contour, psf[*,*,i,j], x, y, levels=[0.001,0.01,0.1,1.0], /overplot

        ssw_legend, ['dz = ' + num2str(dz[i], length=3) + ' cm', 'offax = ' + $
        		num2str(offaxis, length=3), 'pixel = ' + num2str(axis[i,j], length=4)]

        ENDFOR

;ENDFOR

!P.MULTI = [0,1,2]
yrange = [1e-3, 1]
xrange = [-30, 30]

fwhm_arr = fltarr(dim_offax, dim_dz, 2)

FOR i = 0, dim_dz-1 DO BEGIN
;        FOR j = 0, dim_offax-1 DO BEGIN

        x = findgen(dimx)*axis[i,j]
        x = x - max(x)/2.0
        y = x
        
        yx = psf[dimx/2, *, i, j]
        yy = psf[*, dimx/2, i, j]

        coreX = where( yx gt THRESH )
        coreY = where( yy gt THRESH )
        
        yfit = GaussFit(x[coreX], yx[coreX], coeff, NTERMS=3)
;        fwhm = 2 * SQRT(2 * ALOG(2)) * coeff[2]

	    new_x = findgen(800)/10.-40
	    new_yx = interpol( yx, x, new_x )
	    new_yy = interpol( yy, x, new_x )
		new_coreX = where( new_yx ge 0.5 )
		new_coreY = where( new_yy ge 0.5 )
		fwhmX = new_x[ max(new_coreX) ] - new_x[ min(new_coreX) ]
		fwhmY = new_x[ max(new_coreY) ] - new_x[ min(new_coreY) ]
		print, 'FWHM in X: ', fwhmX	
		print, 'FWHM in Y: ', fwhmY

        plot, x, yx, yrange = yrange, xrange = xrange, title = 'Y'
;        oplot, x[coreX], yfit, linestyle = 1
		oplot, 1.5*xrange, [0.5,0.5], line=3
        ssw_legend, ['dz = ' + num2str(dz[i], length=3) + ' cm', 'offax = ' + $
        	num2str(offaxis, length=3) + ' arcmin', 'FWHM = ' + num2str(fwhmX)+' arcsec']
        fwhm_arr[j, i, 1] = fwhmX
        
        oplot, [new_x[ min(new_coreX) ]], [new_yx[ min(new_coreX) ]], /psy
        oplot, [new_x[ max(new_coreX) ]], [new_yx[ max(new_coreX) ]], /psy

        yfit = GaussFit(x[coreY], yy[coreY], coeff, NTERMS=3)
;        fwhm = 2 * SQRT(2 * ALOG(2)) * coeff[2]

        plot, x, yy, yrange = yrange, xrange = xrange, title = 'X'
;        oplot, x[coreY], yfit, linestyle = 1
		oplot, 1.5*xrange, [0.5,0.5], line=3
        ssw_legend, ['dz = ' + num2str(dz[i], length=3) + ' cm', 'offax = ' + $
        	num2str(offaxis, length=3) + ' arcmin', 'FWHM = ' + num2str(fwhmY)+' arcsec']
        fwhm_arr[j, i, 0] = fwhmY
        
        oplot, [new_x[ min(new_coreY) ]], [new_yy[ min(new_coreY) ]], /psy
        oplot, [new_x[ max(new_coreY) ]], [new_yy[ max(new_coreY) ]], /psy
		

;ENDFOR
ENDFOR

;FOR i = 0, dim_dz-1 DO BEGIN
;        plot, offax, fwhm_arr[*, i, 0], xtitle = 'off axis angle [arcmin]', $
;        	ytitle = 'fwhm [arcsec]', yrange = [0, 50], title = 'dz = ' + $
;        	num2str(dz[i]) + ' cm'
;        oplot, offax, fwhm_arr[*, i, 1], linestyle = 1
;        ssw_legend, ['X', 'Y'], linestyle = [0,1]
;ENDFOR
psclose

if keyword_set(stop) then stop

END