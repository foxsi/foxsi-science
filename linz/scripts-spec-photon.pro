;
; Scripts for producing FOXSI spectra based on the blanketing self-calibration
;

@foxsi-setup-script

; Blanketing factors and % open for all 7 det.  Including a slot for 3 for no good reason.
factor = [6.3, 7.0, 7.9, 1, 6.1, 4.9, 4.5]
percent = [0.015, 0.015, 0.005, 1., 0.015, 0.02, 0.005]

get_target_data, 4, d0,d1,d2,d3,d4,d5,d6, center=flare, rad=200, eband=[3.,10.]
t1 = t4_start
t2 = t4_end
delta_t = t2 - t1
bin = 0.3
spec_d0 = make_spectrum( d0, bin=bin, /correct )
spec_d1 = make_spectrum( d1, bin=bin, /correct )
spec_d2 = make_spectrum( d2, bin=bin, /correct )
spec_d3 = make_spectrum( d3, bin=bin, /correct )
spec_d4 = make_spectrum( d4, bin=bin, /correct )
spec_d5 = make_spectrum( d5, bin=bin, /correct )
spec_d6 = make_spectrum( d6, bin=bin, /correct )

inverse0 = inverse_resp( spec_d0.energy_kev, offaxis=7.3, n_bla=factor[0], offset=percent[0] )
inverse1 = inverse_resp( spec_d1.energy_kev, offaxis=7.3, n_bla=factor[1], offset=percent[1] )
inverse2 = inverse_resp( spec_d2.energy_kev, offaxis=7.3, n_bla=factor[2], offset=percent[2] )
inverse3 = inverse_resp( spec_d3.energy_kev, offaxis=7.3, n_bla=factor[3], offset=percent[3] )
inverse4 = inverse_resp( spec_d4.energy_kev, offaxis=7.3, n_bla=factor[4], offset=percent[4] )
inverse5 = inverse_resp( spec_d5.energy_kev, offaxis=7.3, n_bla=factor[5], offset=percent[5] )
inverse6 = inverse_resp( spec_d6.energy_kev, offaxis=7.3, n_bla=factor[6], offset=percent[6] )

phot0 = spec_d0.spec_p * inverse0.per_cm2 / delta_t
phot1 = spec_d1.spec_p * inverse1.per_cm2 / delta_t
phot2 = spec_d2.spec_p * inverse2.per_cm2 / delta_t
phot3 = spec_d3.spec_p * inverse3.per_cm2 / delta_t
phot4 = spec_d4.spec_p * inverse4.per_cm2 / delta_t
phot5 = spec_d5.spec_p * inverse5.per_cm2 / delta_t
phot6 = spec_d6.spec_p * inverse6.per_cm2 / delta_t

; Get background.
get_target_data, 4, d0,d1,d2,d3,d4,d5,d6bkgd, cen=[350,-700],rad=200.
d6bkgd = d6bkgd[ where( d6bkgd.error_flag eq 0 ) ]
spec_bkgd = make_spectrum( d6bkgd, bin=2. )
inv_bkgd = interpol( inverse6.per_cm2, spec_d6.energy_kev, spec_bkgd.energy_kev )
bkgd = spec_bkgd.spec_p * inv_bkgd / (t4_end - t4_start)

en = spec_d0.energy_kev

popen, 'fig/foxsi-photon-spex', xsi=7.5, ysi=4
!p.multi=[0,2,1]
!X.MARGIN=[3,1.5]
loadct,0
hsi_linecolors
plot, en, phot0, /xlo, /ylo, xr=[4.,12.], /xsty, yr=[1.e-4,1.e4], /nodata, $
	charsi=1., charth=5, xth=8, yth=8, $
	xtit='Energy [keV]', ytit='Photons cm!U-2!N s!U-1!N keV!U-1!N', $
	tit='FOXSI spectra from self-calibration'
oplot, en, phot0, psym=10, thick=5, color=6
oplot, en, phot2, psym=10, thick=5, color=8
oplot, en, phot4, psym=10, thick=5, color=10
oplot, en, phot5, psym=10, thick=5, color=12
oplot, en, phot6, psym=10, thick=5, color=2
oplot, spec_bkgd.energy_kev, bkgd, thick=5, psym=10
al_legend, ['D0','D1','D2','D4','D5','D6','Background'], line=[0,0,0,0,0,0,0], $
	thick=5, col=[6,7,8,10,12,2,0], /top, /right, box=0, charsi=0.8, charth=2
; Same for RHESSI
;restore,'rhessi_spectral_fit_foxsi_flare_September2014.sav',/verbose
plot_oo,average(ebins,1),obs_all(*,0),xrange=[4,12],xstyle=1,yrange=[1e-4,1e4], /nodata,$
	charsi=1., charth=5, xth=8, yth=8, $
	xtit='Energy [keV]', ytit='Photons cm!U-2!N s!U-1!N keV!U-1!N', $
	tit='RHESSI spectra'
;for i=0,det_dim-1 do oplot,average(ebins,1),obs_all(*,i), psym=10
oplot, average(ebins,1), obs_all[*,0], psym=10, thick=5, color=6
oplot, average(ebins,1), obs_all[*,1], psym=10, thick=5, color=7
oplot, average(ebins,1), obs_all[*,2], psym=10, thick=5, color=8
oplot, average(ebins,1), obs_all[*,3], psym=10, thick=5, color=9
oplot, average(ebins,1), obs_all[*,4], psym=10, thick=5, color=10
oplot, average(ebins,1), obs_all[*,5], psym=10, thick=5, color=2
;for i=0,det_dim-1 do oplot,average(ebins,1),bkg_all(*,i), psym=10
oplot,average(ebins,1),average(bkg_all,2),thick=5, psym=10
;oplot,average(ebins,1),average(ph_all,2),thick=3,color=6, psym=10
al_legend, ['D1','D3','D5','D6','D8','D9','Background'], line=[0,0,0,0,0,0,0], $
	thick=5, col=[6,7,8,9,10,2,0], /top, /right, box=0, charsi=0.8, charth=2
pclose




;
; Modeled photon spectra
;

t = [8.1,8.8,5.6,0.,8.1,8.0,8.2]
em = [0.0044,0.0033,0.63,0.,0.013,0.0064,0.0036]

; Set up energy bins 0-20 keV. These bins are finer than those desired!!
e1 = dindgen(2000)/100
e2 = get_edges(e1,/edges_2)
emid = get_edges(e1,/mean)
ewid = get_edges(e1,/width)

TEMP = T/11.6      ; switch temperature to units of keV

; f_vth won't work if you include energies below 1 keV.
; Only simulate above 2 keV.
;i=where( emid gt 2. )
;flux0 = dblarr( n_elements(emid) )
;flux0[i] = f_vth(e2[*,i], [EM[0], TEMP[0], 1.], /cont)		; compute thermal X-ray flux
;flux0[ where( emid le 2 ) ] = sqrt(-1)

; update: since you used brem_49 in your code, you should use that here.
; later, try to see why brem_49 and f_vth aren't giving the same thing.

flux0 = brem_49( emid, temp[0])*em[0]
flux1 = brem_49( emid, temp[1])*em[1]
flux2 = brem_49( emid, temp[2])*em[2]
flux3 = brem_49( emid, temp[3])*em[3]
flux4 = brem_49( emid, temp[4])*em[4]
flux5 = brem_49( emid, temp[5])*em[5]
flux6 = brem_49( emid, temp[6])*em[6]

i=where( emid gt 2. )
emid_vth = get_edges( e2[*,i], /mean )
flux0_vth = f_vth( e2[*,i], [EM[0], Temp[0], 1.] )
flux1_vth = f_vth( e2[*,i], [EM[1], Temp[1], 1.] )
flux2_vth = f_vth( e2[*,i], [EM[2], Temp[2], 1.] )
flux4_vth = f_vth( e2[*,i], [EM[4], Temp[4], 1.] )
flux5_vth = f_vth( e2[*,i], [EM[5], Temp[5], 1.] )
flux6_vth = f_vth( e2[*,i], [EM[6], Temp[6], 1.] )

; Plot modeled curves only

popen, 'fig/foxsi-photon-spex', xsi=7.5, ysi=4
!p.multi=[0,2,1]
!X.MARGIN=[3,1.5]
loadct,0
hsi_linecolors
plot, en, phot0, /xlo, /ylo, xr=[3.,15.], /xsty, yr=[1.e-4,1.e5], /nodata, $
	charsi=1., charth=5, xth=8, yth=8, $
	xtit='Energy [keV]', ytit='Photons cm!U-2!N s!U-1!N keV!U-1!N', $
	tit='FOXSI spectra from self-calibration'
oplot, en, phot0, psym=10, thick=5, color=6
;oplot, emid, flux0, thick=3, col=6, line=1
;;oplot, en, phot1, psym=10, thick=5, color=7
;;oplot, emid, flux1, thick=3, col=7, line=1
oplot, en, phot2, psym=10, thick=5, color=8
;oplot, emid, flux2, thick=3, col=8, line=1
oplot, en, phot4, psym=10, thick=5, color=10
;oplot, emid, flux4, thick=3, col=10, line=1
oplot, en, phot5, psym=10, thick=5, color=12
;oplot, emid, flux5, thick=3, col=12, line=1
oplot, en, phot6, psym=10, thick=5, color=2
;oplot, emid, flux6, thick=3, col=2, line=1
oplot, spec_bkgd.energy_kev, bkgd, thick=5, psym=10
al_legend, ['D0','D1','D2','D4','D5','D6','Background'], line=[0,0,0,0,0,0,0], $
	thick=5, col=[6,7,8,10,12,2,0], /top, /right, box=0, charsi=0.8, charth=2
plot, en, phot0, /xlo, /ylo, xr=[3.,15.], /xsty, yr=[1.e-4,1.e5], /nodata, $
	charsi=1., charth=5, xth=8, yth=8, $
	xtit='Energy [keV]', ytit='', $; ytit='Photons cm!U-2!N s!U-1!N keV!U-1!N', $
	tit='FOXSI model photon spectra'
oplot, emid_vth, flux0_vth, thick=3, col=6
;oplot, emid_vth, flux1_vth, thick=3, col=7
oplot, emid_vth, flux2_vth, thick=3, col=8
oplot, emid_vth, flux4_vth, thick=3, col=10
oplot, emid_vth, flux5_vth, thick=3, col=12
oplot, emid_vth, flux6_vth, thick=3, col=2
al_legend, ['D0','D1','D2','D4','D5','D6'], line=[0,0,0,0,0,0], $
	thick=5, col=[6,7,8,10,12,2], /top, /right, box=0, charsi=0.8, charth=2
pclose
!X.MARGIN=[10,3]
