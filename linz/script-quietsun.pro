;
; scripts to estimate quiet Sun HXR limits
;

; 4 tasks:
; 1 -- examine flux at distances going away from the flare.
; 2 -- estimate a quiet Sun flux using the "background area" in Target 4/6.
; 3 -- do the calculation at 10 keV for Hugh.
; 4 -- estimate the max flux at 10 keV for Hugh.

;
; DON'T FORGET ABOUT LIVETIME!!!
;

; Task 1:
; Compare count flux per area on Target 4/6 background area with that in Target 2.

; Get counts in the "background" area of target 4/6.
get_target_data, 4, d0,d1,d2,d3,d4,d5,d6_t4_bkgd, cen=[500,-700],rad=200.
get_target_data, 6, d0,d1,d2,d3,d4,d5,d6_t6_bkgd, cen=[500,-700],rad=200.

d6bkgd = [d6_t4_bkgd, d6_t6_bkgd]
d6bkgd = d6bkgd[ where( d6bkgd.error_flag eq 0 ) ]
spec_bkgd = make_spectrum( d6bkgd, bin=2. )

; result: 12 counts within 4-12 keV.  (total(spec_p[2:5]*2keV))

; Examine other targets:
get_target_data, 1, d0,d1,d2,d3,d4,d5,d6_t1
get_target_data, 2, d0,d1,d2,d3,d4,d5,d6_t2
get_target_data, 3, d0,d1,d2,d3,d4,d5,d6_t3
d6_t1 = d6_t1[ where( d6_t1.error_flag eq 0 ) ]
spec1 = make_spectrum( d6_t1, bin=2. )
d6_t2 = d6_t2[ where( d6_t2.error_flag eq 0 ) ]
spec2 = make_spectrum( d6_t2, bin=2. )
d6_t3 = d6_t3[ where( d6_t3.error_flag eq 0 ) ]
spec3 = make_spectrum( d6_t3, bin=2. )

; put it all into counts per second per keV, in 4-12 keV range.
; Also correct for area.
int1 = t1_end - t1_start
int2 = t2_end - t2_start
int3 = t3_end - t3_start
int46 = t4_end + t6_end - t4_start - t6_start
area46corr = (7.78*122)^2 / (!pi*200.^2)
rate1 = total( spec1.spec_p[2:5] ) / int1
rate2 = total( spec2.spec_p[2:5] ) / int2
rate3 = total( spec3.spec_p[2:5] ) / int3
rate46 = total( spec_bkgd.spec_p[2:5] ) / int46*area46corr

; result:
; IDL> print, 	rate1, 	  	  rate2, 	   rate3, 		rate46
;      			0.0574713     0.155731     0.204871     0.307697

; At this point, should throw in a blanketing factor!  Put it in as a placeholder.
blanket = 1.
rate_spec1 = spec1.spec_p / int1 / blanket
rate_spec2 = spec2.spec_p / int2 / blanket
rate_spec3 = spec3.spec_p / int3 / blanket
rate_spec46 = spec_bkgd.spec_p / int46*area46corr / blanket

; Lastly, divide by effective area.
en = findgen(100.)/(100./15)
foxsi_area = get_foxsi_effarea( energy_arr=en, /per)
area0 = interpol( foxsi_area.eff_area_cm2, foxsi_area.energy_kev, spec1.energy_kev )
; divide by 2 to account for thrown-out counts.
area = area0/2.

phot1 = rate_spec1 / area
phot2 = rate_spec2 / area
phot3 = rate_spec3 / area
phot46 = rate_spec46 / area

loadct,0
hsi_linecolors
energy = spec1.energy_kev
popen, xsi=7, ysi=5
plot, energy, phot1, psym=10, /xlo, /ylo, xr=[2.,20], yr=[1.e-5,4.e0], /xsty, /ysty, /nodata, $
	xtitle='Energy [keV]', ytit='Phot s!U-1!N keV!U-1!N cm!U-2!N', charth=2.,$
	tit='FOXSI Det 6 photon spectra, no blanketing', charsi=1.4;, $
;	xtickv=[2.,3.,4.,5.,6.,7.,8.,9.,10.,11.,12.]
oplot_err, energy, phot1, xerr=1., psym=2, thick=8, color=6, symsi=1.5
oplot_err, energy, phot2, xerr=1., psym=2, thick=8, color=7, symsi=1.5
oplot_err, energy, phot3, xerr=1., psym=2, thick=8, color=2, symsi=1.5
oplot_err, energy, phot46, xerr=1., psym=2, thick=8, color=0, symsi=1.5
legend, ['Target 1','Target 2','Target 3','Target 4+6, background area'], $
	/bot, /left, box=0, textcolor=[6,7,2,0], thick=6, charsi=1.4
pclose


; desired plots:
; -- Target 4/6 image, showing flare on log scale and selected background area.