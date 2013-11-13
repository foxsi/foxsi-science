; FOXSI software paths for simulated count spec and instrument response
add_path,'spec'
add_path,'resp'

; set up the temperature array, from log(T) = {5.5, 7.5}
logT = findgen(21)/10. + 5.5

; Choose values from one of the two examples below.

; Case 1: 1x1 pixel (4"x4")
area = 4.^2 * (0.725d8)^2
; dem values from Ishikawa
dem = [ 10., 5.7615336e+09, 3.6089325e+16, 9.6696061e+20, 3.5377804e+22, 8.7783289e+21, $
		4.0188885e+20, 7.9382189e+19, 2.3459946e+20, 1.9350063e+21, 6.9564576e+21, $
		2.8403134e+21, 2.9826793e+20, 2.9016692e+19, 8.4066512e+18, 7.3720743e+18, $
		9.8257205e+18, 1.0305182e+19, 6.1854576e+18, 2.5750783e+18, 9.1455790e+17 ]
title = '4"x4" Hinode AR'
file  = 'hinode-ar-1pix'

; Case 2: 25x25 pixels (100"x100")
area = 100.^2 * (0.725d8)^2
dem = [ 9.2702526e+20, 7.7229808e+17, 6.7899155e+15, 1.1811620e+15, 8.3469140e+15, $
		8.3893852e+17, 1.3764897e+20, 4.4214144e+21, 1.0777911e+22, 4.7550073e+21, $
		9.2400217e+20, 1.6420199e+20, 3.9138261e+19, 1.7319996e+19, 1.9518247e+19, $
		3.8958065e+19, 6.1678387e+19, 3.3981301e+19, 4.3694079e+18, 1.7278429e+17, $
		2.6657822e+15 ]
title = '100"x100" Hinode AR'
file  = 'hinode-ar-25pix'
		
; Calculate EM in cm^-3 for each bin.
T = 10.^logt
dT = get_edges(T, /width)
dt = [dt, dt[19]]
em = dem*dt*area

; energy arrays for simulated thermal fluxes
en1 = findgen(500)/20 + 1.
en2 = get_edges(en1, /edges_2)
en  = get_edges(en1, /mean)
n = n_elements(t)

; calculate thermal X-ray fluxes for each temperature/EM pair.
flux = dblarr( n_elements(en), n )
for i=0, 20 do flux[*,i] = f_vth( en2, [em[i]/1.d49, t[i]/11.8/1.d6, 1.] )

; The next routine calculates the expected FOXSI count spectrum for given thermal params.
; This includes contributions from the optics, detectors, and nominal blanketing.
; The extra blanketing isn't included.
; Off-axis angle is assumed 0.

; Sample sim to set up arrays.
simA = foxsi_count_spectrum(em[10]/1.d49, t[10]/1.d6, time=1. )
; Now do it for all temperature bins.
sim = dblarr( n_elements(simA.energy_keV), n_elements(logt) )
.run
for i=0, 20 do begin sim2 = foxsi_count_spectrum(em[i]/1.d49, t[i]/1.d6, time=1. )
	sim[*,i] = sim2.counts
endfor
end

; FOXSI_COUNT_SPECTRUM produces counts / keV, but we have run the simulation with a time value of
; 1 sec, so it's actually counts / sec / keV.


; display results

loadct, 5
colors = 220-findgen(n)*10+20
;popen, file, xsi=7, ysi=5
plot, en, flux[*,15], psym=10, /xlo, /ylo, xr=[1.,30.], yr=[1.e-2, 1.e5], /xsty, /ysty, $
	xtit='Energy [keV]', ytit='Phot s!U-1!N cm!U-2!N keV!U-1!N', charsi=1.1, $
	tit='Photon flux, '+title
for i=0, n_elements(logt)-1 do $
	oplot, en, flux[*,i], psym=10, thick=3, col=colors[i]
legend, strtrim( logt ,2), textcolor=colors, box=0, thick=th, $
	/right, charth=2, charsi=1.1

plot, simA.energy_kev, sim[*,15], psym=10, /xlo, /ylo, xr=[1.,30], /xsty, $
	yr=[1.e-3, 1.e3], /ysty, xtit='Energy [keV]', ytit='Counts s!U-1!N keV!U-1!N', $
	tit='Simulated FOXSI flux, '+title
for i=0, n_elements(logt)-1 do oplot, simA.energy_kev, sim[*,i], psym=10, thick=3, col=colors[i]
legend, strtrim( logt ,2), textcolor=colors, box=0, thick=th
;pclose


;
; Calculate FOXSI sensitivity curves
; Do this both for the measured counts (as if we did measure the emission)
; and for a sensitivity curve assuming we did not measure it.
;

; Needed paths and data
add_path, 'spec'
add_path, 'resp'
restore, '~/Documents/foxsi/flight-analysis/foxsi-science/data_2012/foxsi_level2_data.sav', /v

; Times for all targets
t_launch = 64500
t1_start = t_launch + 108.3		; Target 1 (AR)
t1_end = t_launch + 151.8
t2_start = t_launch + 154.8		; Target 2 (AR)
t2_end = t_launch + 244.7
t3_start = t_launch + 247		; Target 3 (quiet Sun)
t3_end = t_launch + 337.3
t4_start = t_launch + 340		; Target 4 (flare)
t4_end = t_launch + 421.2
t5_start = t_launch + 423.5		; Target 5 (off-pointing)
t5_end = t_launch + 435.9
t6_start = t_launch + 438.5		; Target 6 (flare)
t6_end = t_launch + 498.3

; Retrieve measured counts on the first target.
; Select only events w/o errors and in desired time range.
; Use /corr keyword to correct the spectrum for the thrown-out counts. (i.e. errors)

t1 = t1_start		; choose first target
t2 = t1_end			; choose first target
delta_t = t2 - t1	; choose first target
binwidth=1.0
i0 = where(data_lvl2_d0.wsmr_time gt t1 and data_lvl2_d0.wsmr_time lt t2)
i1 = where(data_lvl2_d1.wsmr_time gt t1 and data_lvl2_d1.wsmr_time lt t2)
i2 = where(data_lvl2_d2.wsmr_time gt t1 and data_lvl2_d2.wsmr_time lt t2)
i3 = where(data_lvl2_d3.wsmr_time gt t1 and data_lvl2_d3.wsmr_time lt t2)
i4 = where(data_lvl2_d4.wsmr_time gt t1 and data_lvl2_d4.wsmr_time lt t2)
i5 = where(data_lvl2_d5.wsmr_time gt t1 and data_lvl2_d5.wsmr_time lt t2)
i6 = where(data_lvl2_d6.wsmr_time gt t1 and data_lvl2_d6.wsmr_time lt t2)
spec_d0 = make_spectrum( data_lvl2_d0[i0], bin=binwidth, /correct )
spec_d1 = make_spectrum( data_lvl2_d1[i1], bin=binwidth, /correct )
spec_d2 = make_spectrum( data_lvl2_d2[i2], bin=binwidth, /correct )
spec_d3 = make_spectrum( data_lvl2_d3[i3], bin=binwidth, /correct )
spec_d4 = make_spectrum( data_lvl2_d4[i4], bin=binwidth, /correct )
spec_d5 = make_spectrum( data_lvl2_d5[i5], bin=binwidth, /correct )
spec_d6 = make_spectrum( data_lvl2_d6[i6], bin=binwidth, /correct )
spec_sum = spec_d6
spec_sum.spec_p = spec_d0.spec_p + spec_d2.spec_p + spec_d3.spec_p + $		; all det's except for 1.
	spec_d4.spec_p + spec_d5.spec_p + spec_d6.spec_p

plot,  spec_sum.energy_kev, spec_sum.spec_p, xr=[2,20], thick=4, psym=10, /xlog, /ylog, /ysty, $
  xtitle='Energy [keV]', ytitle='FOXSI counts s!U-1!N keV!U-1!N', xstyle=1, line=1, $
  title = 'FOXSI count spectrum, all detectors, First target', charsize=1.2, yr=[1., 1.e2]

;
; NOTE: Need temperature array (in log and linear), temperature bin width,
; and areas from one of Ishikawa's sets of values, above.
;

; If desired, subtract a background.
bkgd = [0.,0.,0., bkgd_off, fltarr(87)] * delta_t * 16.4^2
spec_sum.spec_p -= bkgd

; If desired, assume no detection and use 3-sigma of background as a limit.
spec_sum.spec_p = bkgd + 3*sqrt(bkgd)

; Calculate FOXSI expected counts for each temperature interval.
; For now, just do this for temperatures above ~3 MK.
; Use a 1.d49 EM.
sim10 = foxsi_count_spectrum(1., t[10]/1.d6, binsize=binwidth, time=1.)
sim11 = foxsi_count_spectrum(1., t[11]/1.d6, binsize=binwidth, time=1.)
sim12 = foxsi_count_spectrum(1., t[12]/1.d6, binsize=binwidth, time=1.)
sim13 = foxsi_count_spectrum(1., t[13]/1.d6, binsize=binwidth, time=1.)
sim14 = foxsi_count_spectrum(1., t[14]/1.d6, binsize=binwidth, time=1.)
sim15 = foxsi_count_spectrum(1., t[15]/1.d6, binsize=binwidth, time=1.)
sim16 = foxsi_count_spectrum(1., t[16]/1.d6, binsize=binwidth, time=1.)
sim17 = foxsi_count_spectrum(1., t[17]/1.d6, binsize=binwidth, time=1.)
sim18 = foxsi_count_spectrum(1., t[18]/1.d6, binsize=binwidth, time=1.)
sim19 = foxsi_count_spectrum(1., t[19]/1.d6, binsize=binwidth, time=1.)
sim20 = foxsi_count_spectrum(1., t[20]/1.d6, binsize=binwidth, time=1.)

; Calculate dEM.  Earlier we assumed an EM of 1.d49 cm^-5 for the simulations.
; The ratio of measured counts to simulated counts tells us how much that EM 
; needs to be adjusted for the observations to fit well for a particular
; energy channel.  Divide by delta_t to get the measured counts in cts / sec / keV.
; Divide by area and temperature width to get dEM in units of cm^-5.

dem10 = spec_sum.spec_p[0:9]/delta_t / sim10.counts *1.d49 / dt[10] / area
dem11 = spec_sum.spec_p[0:9]/delta_t / sim11.counts *1.d49 / dt[11] / area
dem12 = spec_sum.spec_p[0:9]/delta_t / sim12.counts *1.d49 / dt[12] / area
dem13 = spec_sum.spec_p[0:9]/delta_t / sim13.counts *1.d49 / dt[13] / area
dem14 = spec_sum.spec_p[0:9]/delta_t / sim14.counts *1.d49 / dt[14] / area
dem15 = spec_sum.spec_p[0:9]/delta_t / sim15.counts *1.d49 / dt[15] / area
dem16 = spec_sum.spec_p[0:9]/delta_t / sim16.counts *1.d49 / dt[16] / area
dem17 = spec_sum.spec_p[0:9]/delta_t / sim17.counts *1.d49 / dt[17] / area
dem18 = spec_sum.spec_p[0:9]/delta_t / sim18.counts *1.d49 / dt[18] / area
dem19 = spec_sum.spec_p[0:9]/delta_t / sim19.counts *1.d49 / dt[19] / area
dem20 = spec_sum.spec_p[0:9]/delta_t / sim20.counts *1.d49 / dt[20] / area

; Worst-case factor for blanketing.  set =1 to ignore blanket problem.
blanket_factor = 0.05
dem10b = spec_sum.spec_p[0:9]/delta_t / sim10.counts *1.d49 / dt[10] / area / blanket_factor
dem11b = spec_sum.spec_p[0:9]/delta_t / sim11.counts *1.d49 / dt[11] / area / blanket_factor
dem12b = spec_sum.spec_p[0:9]/delta_t / sim12.counts *1.d49 / dt[12] / area / blanket_factor
dem13b = spec_sum.spec_p[0:9]/delta_t / sim13.counts *1.d49 / dt[13] / area / blanket_factor
dem14b = spec_sum.spec_p[0:9]/delta_t / sim14.counts *1.d49 / dt[14] / area / blanket_factor
dem15b = spec_sum.spec_p[0:9]/delta_t / sim15.counts *1.d49 / dt[15] / area / blanket_factor
dem16b = spec_sum.spec_p[0:9]/delta_t / sim16.counts *1.d49 / dt[16] / area / blanket_factor
dem17b = spec_sum.spec_p[0:9]/delta_t / sim17.counts *1.d49 / dt[17] / area / blanket_factor
dem18b = spec_sum.spec_p[0:9]/delta_t / sim18.counts *1.d49 / dt[18] / area / blanket_factor
dem19b = spec_sum.spec_p[0:9]/delta_t / sim19.counts *1.d49 / dt[19] / area / blanket_factor
dem20b = spec_sum.spec_p[0:9]/delta_t / sim20.counts *1.d49 / dt[20] / area / blanket_factor

test4 = [dem11[4],dem12[4],dem13[4],dem14[4],dem15[4],dem16[4],dem17[4],dem18[4],dem19[4],dem20[4]]
test5 = [dem11[5],dem12[5],dem13[5],dem14[5],dem15[5],dem16[5],dem17[5],dem18[5],dem19[5],dem20[5]]
test4b = [dem11b[4],dem12b[4],dem13b[4],dem14b[4],dem15b[4],dem16b[4],dem17b[4],dem18b[4],dem19b[4],dem20b[4]]
test5b = [dem11b[5],dem12b[5],dem13b[5],dem14b[5],dem15b[5],dem16b[5],dem17b[5],dem18b[5],dem19b[5],dem20b[5]]

popen, 'dem-loci-4', xsi=7, ysi=5
th=4.
loadct, 5
hsi_linecolors
colors = findgen(7)*32+16
plot, logt, dem, /ylog, psym=10, thick=4, xtit='log[ T (MK) ]', ytit='dEM [cm!U-5!N K!U-1!N]', $
	tit='FOXSI locii, no detection 3-sigma above bkgd', charsi=1.1
;oplot, 	logt[11:20], $
;	   	[dem11b[3],dem12b[3],dem13b[3],dem14b[3],dem15b[3],dem16b[3],dem17b[3],dem18b[3],dem19b[3],dem20b[3]], $
;	   	color = 6, thick=4
oplot, 	logt[11:20], $
	   	[dem11b[4],dem12b[4],dem13b[4],dem14b[4],dem15b[4],dem16b[4],dem17b[4],dem18b[4],dem19b[4],dem20b[4]], $
	   	color = 7, thick=10
oplot, 	logt[11:20], $
	   	[dem11b[5],dem12b[5],dem13b[5],dem14b[5],dem15b[5],dem16b[5],dem17b[5],dem18b[5],dem19b[5],dem20b[5]], $
	   	color = 8, thick=10
polyfill, [logt[11:20],reverse(logt[11:20])], [test4, reverse(test4b)], color=7, /line_fill
polyfill, [logt[11:20],reverse(logt[11:20])], [test5, reverse(test5b)], color=8, /line_fill
;oplot, 	logt[11:20], $
;	   	[dem11b[6],dem12b[6],dem13b[6],dem14b[6],dem15b[6],dem16b[6],dem17b[6],dem18b[6],dem19b[6],dem20b[6]], $
;	   	color = 9, thick=4
;oplot, 	logt[11:20], $
;	   	[dem11b[7],dem12b[7],dem13b[7],dem14b[7],dem15b[7],dem16b[7],dem17b[7],dem18b[7],dem19b[7],dem20b[7]], $
;	   	color = 10, thick=4
;oplot, 	logt[11:20], $
;	   	[dem11b[8],dem12b[8],dem13b[8],dem14b[8],dem15b[8],dem16b[8],dem17b[8],dem18b[8],dem19b[8],dem20b[8]], $
;	   	color = 12, thick=4
;oplot, 	logt[11:20], $
;	   	[dem11b[9],dem12b[9],dem13b[9],dem14b[9],dem15b[9],dem16b[9],dem17b[9],dem18b[9],dem19b[9],dem20b[9]], $
;	   	color = 2, thick=4
oplot, 	logt[11:20], $
	   	[dem11[3],dem12[3],dem13[3],dem14[3],dem15[3],dem16[3],dem17[3],dem18[3],dem19[3],dem20[3]], $
	   	color = 6, thick=4
oplot, 	logt[11:20], $
	   	[dem11[4],dem12[4],dem13[4],dem14[4],dem15[4],dem16[4],dem17[4],dem18[4],dem19[4],dem20[4]], $
	   	color = 7, thick=4
oplot, 	logt[11:20], $
	   	[dem11[5],dem12[5],dem13[5],dem14[5],dem15[5],dem16[5],dem17[5],dem18[5],dem19[5],dem20[5]], $
	   	color = 8, thick=4
oplot, 	logt[11:20], $
	   	[dem11[6],dem12[6],dem13[6],dem14[6],dem15[6],dem16[6],dem17[6],dem18[6],dem19[6],dem20[6]], $
	   	color = 9, thick=4
oplot, 	logt[11:20], $
	   	[dem11[7],dem12[7],dem13[7],dem14[7],dem15[7],dem16[7],dem17[7],dem18[7],dem19[7],dem20[7]], $
	   	color = 10, thick=4
oplot, 	logt[11:20], $
	   	[dem11[8],dem12[8],dem13[8],dem14[8],dem15[8],dem16[8],dem17[8],dem18[8],dem19[8],dem20[8]], $
	   	color = 12, thick=4
oplot, 	logt[11:20], $
	   	[dem11[9],dem12[9],dem13[9],dem14[9],dem15[9],dem16[9],dem17[9],dem18[9],dem19[9],dem20[9]], $
	   	color = 2, thick=4
legend, ['4.5 keV, 95% blanket absorption','5.5 keV, 95% blanket absorption',strtrim(spec_sum.energy_kev[3:9],2)+' keV'], color=[7,8,6,7,8,9,10,12,2], line=0, box=0, thick=[10,10,4,4,4,4,4,4,4], charsize=0.8
pclose


;
; Now, using the new FOXSI_DEM_LOCI routine...
;

@foxsi-setup-script

energy_bin=[6.,7.]		; choose an energy bin; the function returns a single 
						; loci curve for this bin.
target=1				; choose a FOXSI target; default is first target
logte = findgen(21)/10. + 5.5	; choose a temperature array
area = 100.^2 * (0.725d8)^2		; choose an area
detectors = [0,0,0,0,1,0,0]		; choose which detector to use.
								; most of the counts are from D4,
								; so best to use D4 only.

loci_6keV = foxsi_dem_loci( logte, energy_bin, area, target=1, dindex=dindex, $
	d0=data_lvl2_d0, d1=data_lvl2_d1, d2=data_lvl2_d2, d3=data_lvl2_d3, $
	d4=data_lvl2_d4, d5=data_lvl2_d5, d6=data_lvl2_d6 )

plot, logte, loci_6keV, /ylog, xtitle='Temperature [log(MK)]', ytitle='dEM [cm!U-5!N]'
