PRO plot_psf, STOP=STOP

restore, filename='psf/psf.dat'
restore, filename='psf/axis.dat'

dim_dz = n_elements(psf[0,0,*,0])
dim_offax = n_elements(psf[0,0,0,*])

dz = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
offax = [0, 3, 6, 9, 12, 15]

dimx = n_elements(psf[*,0,0,0])

!P.MULTI=[0,3,2]

loadct,5

ps, 'plot_psf', /landscape
;popen, 'plot_psf', xsize = 8, ysize = 4

FOR j = 0, dim_offax-1 DO BEGIN
        FOR i = 0, 6-1 DO BEGIN

        x = findgen(dimx)*axis[i,j]
        x = x - max(x)/2.0
        y = x

        contour, psf[*,*,i,j], x, y, yrange=[min(y),max(y)], xrange=[min(x),max(x)], /nodata, charsize = 1.2, $
                 xtitle = 'arcsecs', ytitle = 'arcsecs'
        contour, psf[*,*,i,j], x, y, levels=[0.001,0.01,0.1,1.0], /fill, /overplot
        contour, psf[*,*,i,j], x, y, levels=[0.001,0.01,0.1,1.0], /overplot

        ssw_legend, ['dz = ' + num2str(dz[i], length=3) + ' cm', 'offax = ' + num2str(offax[j], length=3), 'pixel = ' + num2str(axis[i,j], length=4)]

        ENDFOR

ENDFOR

!P.MULTI = [0,1,2]
yrange = [1e-3, 1]
xrange = [-150, 150]

fwhm_arr = fltarr(dim_offax, dim_dz, 2)

FOR i = 0, dim_dz-1 DO BEGIN
        FOR j = 0, dim_offax-1 DO BEGIN

        x = findgen(dimx)*axis[i,j]
        x = x - max(x)/2.0
        y = x

        yx = psf[dimx/2, *, i, j]
        yy = psf[*, dimx/2, i, j]
        yfit = GaussFit(x, yx, coeff, NTERMS=3)
        fwhm = 2 * SQRT(2 * ALOG(2)) * coeff[2]
        plot, x, yx, /ylog, yrange = yrange, xrange = xrange, title = 'Y'
        oplot, x, yfit, linestyle = 1
        ssw_legend, ['dz = ' + num2str(dz[i], length=3) + ' cm', 'offax = ' + num2str(offax[j], length=3) + ' arcmin', 'FWHM = ' + num2str(fwhm) + ' arcsec']
        fwhm_arr[j, i, 1] = fwhm

        yfit = GaussFit(x, yy, coeff, NTERMS=3)
        fwhm = 2 * SQRT(2 * ALOG(2)) * coeff[2]

        plot, x, yy, /ylog, yrange = yrange, xrange = xrange, title = 'X'
        oplot, x, yfit, linestyle = 1
        ssw_legend, ['dz = ' + num2str(dz[i], length=3) + ' cm', 'offax = ' + num2str(offax[j], length=3) + ' arcmin', 'FWHM = ' + num2str(fwhm) + ' arcsec']
        fwhm_arr[j, i, 0] = fwhm

ENDFOR
ENDFOR

FOR i = 0, dim_dz-1 DO BEGIN
        plot, offax, fwhm_arr[*, i, 0], xtitle = 'off axis angle [arcmin]', ytitle = 'fwhm [arcsec]', yrange = [0, 50], title = 'dz = ' + num2str(dz[i]) + ' cm'
        oplot, offax, fwhm_arr[*, i, 1], linestyle = 1
        ssw_legend, ['X', 'Y'], linestyle = [0,1]
ENDFOR
psclose

if keyword_set(stop) then stop

END