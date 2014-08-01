
;
; Use Markus's code to get temperature of flare
;

add_path,'~/Documents/rhessi/event2010nov3/aia/teem/'

f1=file_search('~/data/aia/20121102/*18_01_0*')
f2=file_search('~/data/aia/20121102/*18_01_1*')
aia_prep, f1[0], -1, ind, dat
index2map, ind, dat, m131
aia_prep, f2[0], -1, ind, dat
index2map, ind, dat, m171
aia_prep, f2[1], -1, ind, dat
index2map, ind, dat, m193
aia_prep, f2[2], -1, ind, dat
index2map, ind, dat, m211
aia_prep, f2[3], -1, ind, dat
index2map, ind, dat, m335
aia_prep, f2[4], -1, ind, dat
index2map, ind, dat, m94

; reference images
f1=file_search('~/data/aia/20121102/*17_55_0*')
f2=file_search('~/data/aia/20121102/*17_55_1*')
aia_prep, f1[0], -1, ind, dat
index2map, ind, dat, r131
aia_prep, f2[0], -1, ind, dat
index2map, ind, dat, r171
aia_prep, f2[1], -1, ind, dat
index2map, ind, dat, r193
aia_prep, f2[2], -1, ind, dat
index2map, ind, dat, r211
aia_prep, f2[3], -1, ind, dat
index2map, ind, dat, r335
aia_prep, f2[4], -1, ind, dat
index2map, ind, dat, r94

d131 = diff_map( m131, r131 )
d171 = diff_map( m171, r171 )
d193 = diff_map( m193, r193 )
d211 = diff_map( m211, r211 )
d94 = diff_map( m94, r94 )
d335 = diff_map( m335, r335 )

;aia_sub = make_submap( aia, center=center, fov=3 )

wave_ = ['94','131','193','211','335','171']  ; 94 must go first!
te_range = [0.5, 50]*1.e6
tsig = 0.1*(1+findgen(10))
q94 = 6.7

x_arcsec =  700 + [-480, 480]
y_arcsec = -600 + [-480, 480]
;x_arcsec =  0 + [-1000, 1000]
;y_arcsec =  0 + [-1000, 1000]
fov = [ x_arcsec[0], y_arcsec[0], x_arcsec[1], y_arcsec[1] ] / 967.

npix=4
vers=''
teem_table = 'teem_table.sav'

;aia_teem_table, wave_, tsig, te_range, q94, f1[0], teem_table

maps = [d94, d131, d193, d211, d335, d171]
;maps = [m94, m131, m193, m211, m335, m171]
aia_teem_map_from_map, f1[0], maps, fov, wave_, npix, teem_table, vers
restore,'teem_map.sav',/v
plot_map, temperature_map, /cbar
temperature_map.data=10.^temperature_map.data
plot_map, temperature_map, /cbar, cen=[950,-200], fov=5

popen, xsize=6, ysize=6
plot_map, temperature_map, /cbar, cen=[950,-200], fov=5, dmax=10.e6, tit='log(T[MK])' 
plot_map, temperature_map, /cbar, cen=[950,-200], fov=5, dmin=5.e6, dmax=10.e6, tit='log(T[MK])' 
pclose


;
; Try it again using Iain's technique.
; HAVE NOT YET IMPLEMENTED THIS!  Below is an example from the July 19 flare
; Later, should modify the code for the FOXSI flare...
;

dn_in  = [19.9191, 138.957, 358.053, 1299.47, 270.617, 34.8493]
edn_in = [4.44767, 11.5318, 18.8909, 35.5225, 16.4427, 5.89218]

;restore, file='dem/aia_resp.dat'
filt=[0,1,2,3,4,6]
TRmatrix=tresp.all[*,filt]
logt=tresp.logte
order=0
reg_tweak=1
guess=0.
reg=data2dem_reg(logT, TRmatrix, dn_in, edn_in,$
 	mint=5.0, maxt=8.0, nt=100, $
	order=order,reg_tweak=reg_tweak, guess=guess, $
	channels=tresp.channels[filt])
	
title=''

linecolors
!p.multi=0
ploterr, reg.logt, reg.dem, reg.elogt, reg.edem, $
	/nohat, errcolor=9, yrange=[1.e20,1.e22], psym=1, $
	xrange=minmax(reg.logt), xstyle=17, /ylog, charsi=1.5, $
	xtitle='log!D10!N T', ytitle='DEM(T) [cm!U-5!N K!U-1!N]', title=title
x = findgen(100)/100*(7.5-5.7)+5.7
z=spline(reg.logt,reg.dem,x)
oplot, x, z

;
; Take AIA 131 data, assume RHESSI temperature, and compute FOXSI image.
;

restore, 'data_2012/aia-131-flare.sav', /v
aia = make_dmap( sub, ref_map=sub[0] )
aia = make_submap( aia, center=[aia[0].xc-1,aia[0].yc]-1, fov=1.25 )
avg = aia[0]
avg.data = total(aia[4:9].data,3) / 6.
; rebin to FOXSI pixels.
size = size( avg.data )
nx = size[1]
ny = size[2]
avg_rebin = rebin_map( avg, fix(nx/8.), fix(ny/8.),/cong )
avg_rebin.data = avg_rebin.data / total(avg_rebin.data) * total(avg.data)

; Assume the emission is at the RHESSI temperature (9.4 MK)
; Calculate the # photons in the AIA pixels.

; average the images in FOXSI target 4.  They're all 2.9 sec.
;resp = aia_get_response( /temp, /dn )
resp = resp.a131

;  DN cm^5 s^-1 pix^-1
;  tresp = dn * area(pix) / sec / npix / EM
; find where resp is = RHESSI temp (9.4 MK).  It's ~ index 59.

resp9mk = resp.tresp[59]
EM = avg_rebin.data / resp9mk / avg.dur * avg.dx * avg.dy * (0.725d8)^2 * 8.^2
em[ where(em lt 0.) ] = 0.
em_map = avg_rebin
em_map.data = em / 1.d20	; adjust by 10^20 so we don't get math errors.
plot_map, em_map, dmin=0.

; Now compute expected X-ray fluxes for this image.

; energy arrays
en1 = findgen(500)/20 + 1.
en2 = get_edges(en1, /edges_2)
en  = get_edges(en1, /mean)

nPix = n_elements(em[0,*])

flux = dblarr( 499, npix, npix ) 
sim_img = dblarr( 40, nPix, nPix )

.run
for i=0, nPix-1 do begin
	for j=0, nPix-1 do begin
	
	if (j mod 10 eq 0) then print, 'Col ', i, ', row ', j

T = 9.4d6

; calculate thermal X-ray flux
flux[*,i,j] = f_vth( en2, [em[i,j]/1.d49, t/11.8/1.d6, 1.] )

; The next routine calculates the expected FOXSI count spectrum for given thermal params.
; This includes contributions from the optics, detectors, and nominal blanketing.
; The extra blanketing isn't included.
; Off-axis angle is assumed 0.

; Sample sim to set up arrays.
simA = foxsi_count_spectrum(em[10]/1.d49, t/1.d6, time=60., n_bla=5. )
; Now do it for all temperature bins.
sim2 = foxsi_count_spectrum(em[i,j]/1.d49, t/1.d6, time=60., n_bla=5. )
sim_img[*,i,j] = sim2.counts

endfor
endfor
end

loadct, 3

sim_img[ where(finite(sim_img) eq 0) ] = 0.
total = total( sim_img, 1 )
map = make_map( total, dx=8, dy=8 )
plot_map, map

;
; Important note!  The image looks very different when sampled slightly differently
; (e.g. map is binned with 1" shift up or down.
; Let's test/demonstrate this, but with the raw AIA difference image.
;

restore, 'data_2012/aia-131-flare.sav', /v
aia_ref = sub[0]
aia_ref.data = average( sub[0:9].data, 1 )
aia = make_dmap( sub, ref_map=aia_ref )
aia = make_submap( aia, center=[aia[0].xc-1,aia[0].yc]-1, fov=3 )
; 36 sec averages during FOXSI time.
avg = aia[[27,31,36,39]]
avg[0].data = average( aia[27:30].data, 1 )
avg[1].data = average( aia[31:34].data, 1 )
avg[2].data = average( aia[36:38].data, 1 )
avg[3].data = average( aia[39:41].data, 1 )
avg[0].id = 'AIA131 18:00:32.62-18:01:08.62'
avg[1].id = 'AIA131 18:01:20.62-18:01:56.62'
avg[2].id = 'AIA131 18:02:20.62-18:02:44.62'
avg[3].id = 'AIA131 18:02:56.62-18:03:20.62'
;save, avg, file='data_2012/aia_avg.sav'

; rebin to FOXSI pixels.
size = size( avg.data )
nx = size[1]
ny = size[2]
avg_rebin0 = rebin_map( avg, fix(nx/8.), fix(ny/8.),/cong )
avg_rebin0.data = avg_rebin0.data / total(avg_rebin0.data) * total(avg.data)

; rotate by several angles and do again.
avg_rot0 = avg
avg_rot1 = rot_map(avg, 7)
avg_rot2 = rot_map(avg, 14)
avg_rot3 = rot_map(avg, 21)
avg_rot4 = rot_map(avg, 28)
avg_rot1.roll_angle=0
avg_rot2.roll_angle=0
avg_rot3.roll_angle=0
avg_rot4.roll_angle=0
avg_rebin1 = rebin_map( avg_rot1, fix(nx/8.), fix(ny/8.),/cong )
avg_rebin2 = rebin_map( avg_rot2, fix(nx/8.), fix(ny/8.),/cong )
avg_rebin3 = rebin_map( avg_rot3, fix(nx/8.), fix(ny/8.),/cong )
avg_rebin4 = rebin_map( avg_rot4, fix(nx/8.), fix(ny/8.),/cong )
avg_rebin1.data = avg_rebin1.data / total(avg_rebin1.data) * total(avg_rot1.data)
avg_rebin2.data = avg_rebin2.data / total(avg_rebin2.data) * total(avg_rot2.data)
avg_rebin3.data = avg_rebin3.data / total(avg_rebin3.data) * total(avg_rot3.data)
avg_rebin4.data = avg_rebin4.data / total(avg_rebin4.data) * total(avg_rot4.data)
avg_rebin1 = rot_map( avg_rebin1, -7 )
avg_rebin1.roll_angle=0.
avg_rebin2.roll_angle=0.
avg_rebin3.roll_angle=0.
avg_rebin4.roll_angle=0.

!p.multi=[0,3,1]
plot_map, avg,dmin=0, charsi=1.4, fov=2
;plot_map, avg_rot1,dmin=0, charsi=1.4, fov=2
plot_map, avg_rebin0, dmin=0, charsi=1.4, fov=2
plot_map, avg_rebin1, dmin=0, charsi=1.4, fov=2
