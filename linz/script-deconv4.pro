foxsi,2012

iter=[1,5,10,20,40,60,80,100,150,200]
iter=findgen(12)*5+5
pix=1.0
deconv0 = deconv_foxsi( [1,0,0,0,0,0,0], first=raw0, pix=pix, iter=iter  )
deconv1 = deconv_foxsi( [0,1,0,0,0,0,0], first=raw1, pix=pix, iter=iter  )
deconv2 = deconv_foxsi( [0,0,1,0,0,0,0], first=raw2, pix=pix, iter=iter  )
deconv3 = deconv_foxsi( [0,0,0,1,0,0,0], first=raw3, pix=pix, iter=iter  )
deconv4 = deconv_foxsi( [0,0,0,0,1,0,0], first=raw4, pix=pix, iter=iter, /fix4  )
deconv5 = deconv_foxsi( [0,0,0,0,0,1,0], first=raw5, pix=pix, iter=iter  )
deconv6 = deconv_foxsi( [0,0,0,0,0,0,1], pix=pix, iter=iter, year=2012 )
deconv_all3 = deconv_foxsi( [0,0,0,0,1,1,1], first=raw_all3, pix=pix, iter=iter, /fix4, fov=5 )
deconv_all6 = deconv_foxsi( [1,1,0,1,1,1,1], first=raw_all6, pix=pix, iter=iter, /fix4, fov=4, psf_map=psf, $
	reconv_map=reconv_all6, cstat=cstat, img_smooth=9 )

; Look at residuals.
resid = make_dmap( reconv_all6, cen=cen, fov=2 )

popen, 'cstat', xsi=6, ysi=5
iter=findgen(30)*5+5
c=cstat[1:29]
plot, iter[1:29],c, yr=[0.117,0.12], /ysty, yticks=5, psym=-1, xtit='Iterations', $
	ytit='C stat', charsi=1.2, thick=8, charth=2
pclose


loadct, 8
reverse_ct
!p.multi=[0,3,3]
popen, 'multi-iter', xsi=8, ysi=8
!X.MARGIN=[2,2]
!Y.MARGIN=[2,2] 
plot_map, deconv_all6[0], cen=map_centroid(deconv_all6[0]), fov=2, col=255, charsi=1.5, $
	charth=5, tit='Raw, smoothed', xtit='', ytit='' &$
for i=3, 10 do begin &$
plot_map, deconv_all6[i], cen=map_centroid(deconv_all6[i]), fov=2, col=255, charsi=1.5, $
	charth=5, tit=deconv_all6[i].id, xtit='', ytit='' &$
endfor
plot_map, reconv_all6[0], cen=map_centroid(reconv_all6[0], thresh=0.1), fov=2, col=255, $
	charth=5, charsi=1.5, tit='Raw, smoothed', xtit='', ytit='' &$
for i=3, 10 do begin &$
plot_map, reconv_all6[i], cen=map_centroid(reconv_all6[i], thresh=0.1), fov=2, col=255, $
	charth=5, charsi=1.5, tit=deconv_all6[i].id, xtit='', ytit='' &$
xyouts, 40,-10, cstat[i-1], size=1., color=255 &$
endfor
pclose
!X.MARGIN=[10,3]
!Y.MARGIN=[4,2] 


!p.multi=[0,3,2]

popen, 'deconv-results-all', xsi=8, ysi=5

plot_map, raw0, tit='Raw D0 image'
plot_map, raw1, tit='Raw D1 image'
plot_map, raw2, tit='Raw D2 image'
plot_map, deconv0[8], tit='Deconvolved (40 iter)'
plot_map, deconv1[8], tit='Deconvolved (40 iter)'
plot_map, deconv2[8], tit='Deconvolved (40 iter)'
plot_map, raw3, tit='Raw D3 image'
plot_map, raw4, tit='Raw D4 image'
plot_map, raw5, tit='Raw D5 image'
plot_map, deconv3[8], tit='Deconvolved (40 iter)'
plot_map, deconv4[8], tit='Deconvolved (40 iter)'
plot_map, deconv5[8], tit='Deconvolved (40 iter)'
plot_map, raw6, tit='Raw D6 image'
plot_map, raw_all3, tit='Raw D4-6 image'
plot_map, raw_all6, tit='Raw D0-6 except 3 image'
plot_map, deconv6[8], tit='Deconvolved (40 iter)'
plot_map, deconv_all3[8], tit='Deconvolved (40 iter)'
plot_map, deconv_all6[8], tit='Deconvolved (40 iter)'

pclose


;
; Try Richard's suggestion of simulating some sources.
;

; What sources to try?
; -- point source(s)
; -- loop
; -- elliptical gaussian at arbitrary angle

; Step 1: Get PSF.
; Step 2: Set up the source.
; Step 3: Convolve with the PSF.
; Step 4: Bin to large pixels.
; Step 5: Smear the source based on statistics.
; Step 6: Try the deconvolution.
; Step 7: Compare results.

fov=3
psf = foxsi_psf(fov=fov)
smallpsf = make_submap( psf, cen=[0.,0.], fov=fov-2 )
size = size(psf.data)

; First, a single circular Gaussian.

source = make_map( psf_gaussian( npixel=size[1:2], fwhm=[30,30], cen=[90.3,110.4] ) )
source = make_map( psf_gaussian( npixel=size[1:2], fwhm=[30,30], cen=[90,90] ) )
; Get the desired number of counts.
nData = 6000.
source.data = source.data / total(source.data) * nData

; convolve with the PSF.
conv = make_map( convolve( source.data, psf.data ) )

; Bin to 7.735 arcsec pixels.
pitch = 7.735
pitch = 8.
dim = fix(size[1]/pitch)
rebin = make_map( frebin( conv.data, dim, dim, /total ), dx=pitch, dy=pitch )

; Smear each pixel value by statistical uncertainty
smear = rebin
for i=0, n_elements(smear.data[*,0])-1 do $
	for j=0, n_elements(smear.data[0,*])-1 do $
		smear.data[i,j] = smear.data[i,j] + randomn( seed, 1 )*sqrt( smear.data[i,j] )
smear.data[ where(smear.data lt 0.) ] = 0.

; Now starts the recovery process.  Start by binning to 1" pixels.
pix = 1.
;newdim = fix(dim*pitch/pix)
newdim=size[1]
rebin2 = make_map( frebin( smear.data, newdim, newdim, /total ), dx=pix, dy=pix )

; Smooth the image.
raw = rebin2
;raw.data = smooth( raw.data, 10 )

; Move it off in the corner to avoid the usual problem...
raw.data = shift( raw.data, [3,3] )

; Try the deconvolution!
iter = [1,5,10,20,30,40,50,60,80,100]
niter = n_elements(iter)
deconv_map = replicate( raw, niter )	; leave an extra at beginning to contain raw image.
reconv_map = replicate( raw, niter )
    
.run
for j=0, niter-1 do begin
	undefine, deconv
  	print, j, iter[j]
  	for i=0, iter[j] do begin
  		stopflag = 0
	  	;if j eq 0 and i eq iter[j] then stopflag=1 else stopflag=0			
  		max_likelihood2, raw.data, smallpsf.data, deconv, reconv, stop=stopflag
  	endfor
  	deconv_map[j].data = deconv
  	reconv_map[j].data = reconv
  	deconv_map[j].id=strtrim(iter[j],2)+' iter'
 endfor
end
;plot_map, make_map( deconv ), /cbar

movie_map, deconv_map, /nosc
;print, fullwid_halfmax( deconv_map[6].data )

;popen, 'fig/simulation', xsi=8, ysi=4
!p.multi=[0,4,2]
!X.MARGIN=[2,2]
!Y.MARGIN=[2,2] 
ch=1.2
plot_map, source, cen=map_centroid(source), fov=2, charsi=ch, tit='Simulated source', $
	xtit='', ytit=''
;fwhm = strtrim(string(fullwid_halfmax(source.data),format='(f8.2)'),2)
;xyouts, -55, -30, 'FWHM '+fwhm[0]+' '+fwhm[1]+' arcsec', size=0.8, col=255
plot_map, psf, cen=map_centroid(psf), fov=2, charsi=ch, tit='PSF', $
	xtit='', ytit=''
plot_map, conv, cen=map_centroid(conv), fov=2, charsi=ch, tit='PSF*Source', $
	xtit='', ytit=''
plot_map, rebin, cen=map_centroid(rebin), fov=2, charsi=ch, tit='Binned', $
	xtit='', ytit=''
plot_map, smear, cen=map_centroid(smear), fov=2, charsi=ch, tit='Smeared', $
	xtit='', ytit=''
;fwhm = strtrim(string(pitch*fullwid_halfmax(smear.data),format='(f8.2)'),2)
;xyouts, -55, -35, 'FWHM '+fwhm[0]+' '+fwhm[1]+' arcsec', size=0.8, col=255
plot_map, rebin2, cen=map_centroid(rebin2), fov=2, charsi=ch, tit='Rebinned', $
	xtit='', ytit=''
plot_map, raw, cen=map_centroid(raw, thr=1.), fov=2, charsi=ch, tit='Smoothed', $
	xtit='', ytit=''
;fwhm = strtrim(string(fullwid_halfmax(raw.data),format='(f8.2)'),2)
;xyouts, -15, -10, 'FWHM '+fwhm[0]+' '+fwhm[1]+' arcsec', size=0.8, col=255
plot_map, deconv_map[6], cen=map_centroid(deconv_map[6],thr=1.), fov=2, charsi=ch, $
	tit='Deconvolved 50 iter', xtit='', ytit=''
;fwhm = strtrim(string(fullwid_halfmax(deconv_map[6].data),format='(f8.2)'),2)
;xyouts, -17, -15, 'FWHM '+fwhm[0]+' '+fwhm[1]+' arcsec', size=0.8, col=255
pclose
!X.MARGIN=[10,3]
!Y.MARGIN=[4,2] 


