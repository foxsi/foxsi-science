;
; Alteration of the deconv script to try and work out the FOXSI PSF backwards
; using the RHESSI measured source.
;

pix=1.		; usual value 3
fov=2.		; 2 arcmin is probably the best to use, although it doesn't make much difference.
dim = fov*60./pix
erange=[4,15]		; default [4,15]
loadct, 5

;;;;;; STEP 1 ;;;;;;
;;;;; LOAD PSF ;;;;;

restore, 'linz/psf-D5.sav'
; This SAV file has the already-processed PSF.  If reprocessing is necessary, 
; then uncomment the following lines.

; print, 'Defining PSF...'
; f=file_search('data_2012/45az*.fits')
; fits_read, f, data, ind
; plate_scale = 1.3   ; arcsec
; m0 = make_map( float(data[*,*,0]), dx=plate_scale, dy=plate_scale )
; m1 = make_map( float(data[*,*,1]), dx=plate_scale, dy=plate_scale )
; m2 = make_map( float(data[*,*,2]), dx=plate_scale, dy=plate_scale )
; m3 = make_map( float(data[*,*,3]), dx=plate_scale, dy=plate_scale )
; m4 = make_map( float(data[*,*,4]), dx=plate_scale, dy=plate_scale )
; m5 = make_map( float(data[*,*,5]), dx=plate_scale, dy=plate_scale )
; m6 = make_map( float(data[*,*,6]), dx=plate_scale, dy=plate_scale )
; m7 = make_map( float(data[*,*,7]), dx=plate_scale, dy=plate_scale )
; m8 = make_map( float(data[*,*,8]), dx=plate_scale, dy=plate_scale )
; m9 = make_map( float(data[*,*,9]), dx=plate_scale, dy=plate_scale )
; m=[m0,m1,m2,m3,m4,m5,m6,m7,m8,m9]
; m_sum = m0
; m_sum.data = total(m.data, 3)
; med = median( m_sum.data )
; m_sum.data = m_sum.data - med
; for i=0, n_elements(m)-1 do begin & $
;	med = median(m[i].data) & $
; 	m[i].data = m[i].data - med & $
; endfor
; ; Switch PSF to center of a map.
; cen = [250., -326.]/1.3*plate_scale
; psf = shift_map( make_submap( m_sum, cen=cen, fov=fov ), -cen[0], -cen[1] )
; psf_orig = shift_map( make_submap( m_sum, cen=cen, fov=fov ), -cen[0], -cen[1] )
; psf  = rot_map( psf, 90 )	; true should prob be ~79 deg.
; ; save, psf, file='linz/psf-D5.sav'

; renormalize:
psf  = make_map( frebin( psf.data, dim, dim, /total ), dx=pix, dy=pix )
psf.data = psf.data / total(psf.data)
psf.data = smooth(psf.data,8)

;;;;;;;; STEP 2 ;;;;;;;;;
;; RETRIEVE FLARE DATA ;;

print, 'Retrieving flare data...'

t4_start = 340			; Target 4 (flare)
t4_end = 421.2
;flare2 = [967,-205]
flare = [120,-95]
flare = flare2
t6_start = 438.5		; Target 6 (flare)
t6_end = 498.3
tr = [t4_start, t4_end]

;imdim = 3000/fix(pix)
;img6=foxsi_image_solar(data_lvl2_d6,6,psize=pix,erange=erange,trange=tr,thr_n=4.,/xycor, size=[imdim,imdim])
;smooth=8
;map6 = make_map( smooth(img6,smooth), xcen=0., ycen=0., dx=pix, dy=pix )

; Selecting subregions...'

map=map6
flare=map_centroid( map, thresh=0.3*max(map.data) )
raw6 = shift_map( make_submap( map, cen=flare, fov=fov), -flare[0], -flare[1] )
raw6 = rebin_map(raw6, dim, dim)
raw6.roll_angle=0
plot_map, raw6, /limb, /cbar


;;;;;; STEP 2.5 ;;;;
;;; GET RHESSI IMAGE

; Prepare RHESSI map as "true source"
restore,'data_2012/rhessi_imaging_foxsi_flare_march2013.sav',/ver
clean=c3n
clean.data[where(clean.data lt 0.04)]=0.
rhessi  = make_map( frebin( clean.data, dim, dim, /total ), dx=pix, dy=pix )
rhessi=rot_map(shift_map(rhessi,-4,-10),-14) 
rhessi.roll_angle=0.

;;;;;; STEP 3 ;;;;;;
;;; DO DECONVOLUTION

print, 'Performing deconvolution...'

iter = [1,5,10,20,40,60,80,100,200]
n = n_elements(iter)
deconv_map = replicate( raw6, n )
reconv_map = replicate( raw6, n )
raw = raw6

;.r
for j=0, n-1 do begin & $
undefine, deconv & $
for i=0, iter[j] do max_likelihood, raw.data, rhessi.data, deconv, reconv & $
deconv_map[j].data = deconv & $
reconv_map[j].data = reconv & $
deconv_map[j].id=strtrim(iter[j],2)+' iter' & $
endfor & $
;end

plot_map, deconv_map[3]

ellfit, raw.data, a,b,c,d,e,f
print, 'RAW FOXSI MAP PARAMS: ',a,b,c,d,e,f
ellfit, deconv_map[4].data, a,b,c,d,e,f
print, 'DECONV PSF PARAMS: ',a,b,c,d,e,f
ellfit, rhessi.data, a,b,c,d,e,f
print, 'RHESSI MAP PARAMS: ',a,b,c,d,e,f
ellfit, psf.data, a,b,c,d,e,f
print, 'MEASURED PSF MAP PARAMS: ',a,b,c,d,e,f

; movie_map, deconv_map, /nosc

ch=1.1
popen, xsi=8, ysi=11
!p.multi=[0,3,4]
plot_map, psf, tit='PSF (measured post-flight D5), charsi=ch
plot_map, raw, tit='Raw Det 6 image', charsi=ch
plot_map, rhessi, center=raw, tit='RHESSI CLEAN', fov=2
for j=0, n-1 do plot_map, deconv_map[j], tit=deconv_map[j].id, charsi=ch
pclose
