.compile foxsi_level0_to_level1
filename = 'data_2012/foxsi_level0_data.sav'
data_D0 = foxsi_level0_to_level1( filename, det=0 )
data_D1 = foxsi_level0_to_level1( filename, det=1 )
data_D2 = foxsi_level0_to_level1( filename, det=2 )
data_D3 = foxsi_level0_to_level1( filename, det=3 )
data_D4 = foxsi_level0_to_level1( filename, det=4 )
data_D5 = foxsi_level0_to_level1( filename, det=5 )
data_D6 = foxsi_level0_to_level1( filename, det=6 )
save, data_D0, data_D1, data_D2, data_D3, data_D4, data_D5, data_d6, $
	file = 'data_2012/foxsi_level1_data.sav'


d=d6
i=where(d.inflight gt 0 and d.hit_adc[0] gt 100)
plot,d[i].hit_xy_pay[0],d[i].hit_xy_pay[1],/psy
oplot,[350],[270],/psy,color=6,symsize=5,thick=3

j=where(d[i].error_flag eq 1)

d=d2                                            
j=where(d.inflight gt 0 and d.hit_adc[1] gt 100)
plot,d[j].hit_xy_pay[0],d[j].hit_xy_pay[1],/psy, xr=[-700,700],yr=[-700,700],/xsty,/ysty
oplot,[315],[260],/psy,color=6,symsize=5

; OUTSTANDING ISSUES!!!
; -- Livetime has some odd values (4 striations).  Look at this carefully.
; 		Also, it will be difficult to calculate livetime accurately w/o knowing
;   	some info about what frames might be missing...


	.compile wsmr_data_to_level0
	filename = 'data_2012/36.255_TM2_Flight_2012-11-02.log'
 	data_D0 = wsmr_data_to_level0( filename, det=0 )
 	data_D1 = wsmr_data_to_level0( filename, det=1 )
 	data_D2 = wsmr_data_to_level0( filename, det=2 )
 	data_D3 = wsmr_data_to_level0( filename, det=3 )
 	data_D4 = wsmr_data_to_level0( filename, det=4 )
 	data_D5 = wsmr_data_to_level0( filename, det=5 )
 	data_D6 = wsmr_data_to_level0( filename, det=6 )
	save, data_D0, data_D1, data_D2, data_D3, data_D4, data_D5, data_d6, $
		file = 'data_2012/foxsi_level0_data.sav'

i0=where(data_d0.error_flag eq 0 and data_d0.hit_adc[0] gt 100)
i1=where(data_d1.error_flag eq 0 and data_d1.hit_adc[0] gt 100)
i2=where(data_d2.error_flag eq 0 and data_d2.hit_adc[0] gt 100)
i3=where(data_d3.error_flag eq 0 and data_d3.hit_adc[0] gt 100)
i4=where(data_d4.error_flag eq 0 and data_d4.hit_adc[0] gt 100)
i5=where(data_d5.error_flag eq 0 and data_d5.hit_adc[0] gt 100)
i6=where(data_d6.error_flag eq 0 and data_d6.hit_adc[0] gt 100)

hsi_linecolors
plot, data_d0[i0].hit_xy_pay[0], data_d0[i0].hit_xy_pay[1], /psy
oplot, data_d1[i1].hit_xy_pay[0], data_d1[i1].hit_xy_pay[1], /psy, color=6
oplot, data_d2[i2].hit_xy_pay[0], data_d2[i2].hit_xy_pay[1], /psy, color=7
oplot, data_d3[i3].hit_xy_pay[0], data_d3[i3].hit_xy_pay[1], /psy, color=8
oplot, data_d4[i4].hit_xy_pay[0], data_d4[i4].hit_xy_pay[1], /psy, color=9
oplot, data_d5[i5].hit_xy_pay[0], data_d5[i5].hit_xy_pay[1], /psy, color=10
oplot, data_d6[i6].hit_xy_pay[0], data_d6[i6].hit_xy_pay[1], /psy, color=11

print, max( histogram( data_d0[i0].hit_xy_pay[0], min=-500, max=500, binsize=10 ), max0X)
print, max( histogram( data_d0[i0].hit_xy_pay[1], min=-500, max=500, binsize=10 ), max0Y)
print, max( histogram( data_d1[i1].hit_xy_pay[0], min=-500, max=500, binsize=10 ), max1X)
print, max( histogram( data_d1[i1].hit_xy_pay[1], min=-500, max=500, binsize=10 ), max1Y)
print, max( histogram( data_d2[i2].hit_xy_pay[0], min=-500, max=500, binsize=10 ), max2X)
print, max( histogram( data_d2[i2].hit_xy_pay[1], min=-500, max=500, binsize=10 ), max2Y)
print, max( histogram( data_d3[i3].hit_xy_pay[0], min=-500, max=500, binsize=10 ), max3X)
print, max( histogram( data_d3[i3].hit_xy_pay[1], min=-500, max=500, binsize=10 ), max3Y)
print, max( histogram( data_d4[i4].hit_xy_pay[0], min=-500, max=500, binsize=10 ), max4X)
print, max( histogram( data_d4[i4].hit_xy_pay[1], min=-500, max=500, binsize=10 ), max4Y)
print, max( histogram( data_d5[i5].hit_xy_pay[0], min=-500, max=500, binsize=10 ), max5X)
print, max( histogram( data_d5[i5].hit_xy_pay[1], min=-500, max=500, binsize=10 ), max5Y)
print, max( histogram( data_d6[i6].hit_xy_pay[0], min=-500, max=500, binsize=10 ), max6X)
print, max( histogram( data_d6[i6].hit_xy_pay[1], min=-500, max=500, binsize=10 ), max6Y)

print, max0X, max1X, max2X, max3X, max4X, max5X, max6X
print, max0Y, max1Y, max2Y, max3Y, max4Y, max5Y, max6Y 

deltax = [max0X-max0X, max1X-max0X, max2X-max0X, max3X-max0X, max4X-max0X, max5X-max0X, max6X-max0X]*10
deltay = [max0Y-max0Y, max1Y-max0Y, max2Y-max0Y, max3Y-max0Y, max4Y-max0Y, max5Y-max0Y, max6Y-max0Y]*10

plot, data_d0[i0[50:90]].hit_xy_pay[0], data_d0[i0[50:90]].hit_xy_pay[1], /psy
;oplot, data_d1[i1[50:90]].hit_xy_pay[0]-deltax[1], data_d1[i1[50:90]].hit_xy_pay[1]-deltay[1], /psy, color=6
oplot, data_d2[i2[50:90]].hit_xy_pay[0]-deltax[2], data_d2[i2[50:90]].hit_xy_pay[1]-deltay[2], /psy, color=7
oplot, data_d3[i3[50:90]].hit_xy_pay[0]-deltax[3], data_d3[i3[50:90]].hit_xy_pay[1]-deltay[3], /psy, color=8
oplot, data_d4[i4[50:90]].hit_xy_pay[0]-deltax[4], data_d4[i4[50:90]].hit_xy_pay[1]-deltay[4], /psy, color=9
oplot, data_d5[i5[50:90]].hit_xy_pay[0]-deltax[5], data_d5[i5[50:90]].hit_xy_pay[1]-deltay[5], /psy, color=10
oplot, data_d6[i6[50:90]].hit_xy_pay[0]-deltax[6], data_d6[i6[50:90]].hit_xy_pay[1]-deltay[6], /psy, color=11

;;;;;;;;;; March 4 2013 ;;;;;;;;;;;;
; Using simulation scripts and FOXSI response routines to calculate expected counts for our microflare.

T = 9.4  ; temperature in MK
EM = 4.8e-3  ; emission measure in units of 10^49

e1 = dindgen(1000)/100+2
e2 = get_edges(e1,/edges_2)
emid = get_edges(e1,/mean)

sim = foxsi_count_spectrum( em, t, time=60., binsize=0.5, data_dir='detector_data/', let_file='efficiency_det106_asic3.sav')

rhessi = rhessi_eff_area(e1, 0.25, 0)

loadct,0
hsi_linecolors
popen, 'plots/response_factors', xsize=7, ysize=5
plot, area_bare.energy_kev, area_blankets.eff_area_cm2/area_bare.eff_area_cm2, charsize=1.2, thick=4, $
	xtitle='Energy [keV]', ytitle='Response', /nodata, $
	title='Attenuation factors in FOXSI response'
oplot, area_bare.energy_kev, area_blankets.eff_area_cm2/area_bare.eff_area_cm2, thick=4, color=6
oplot, area_bare.energy_kev, area_det.eff_area_cm2/area_bare.eff_area_cm2, thick=4, color=7
oplot, area_bare.energy_kev, area_offaxis.eff_area_cm2/area_bare.eff_area_cm2, thick=4, color=8
legend, ['Blanketing','Detector efficiency (inc LET)','Off-axis response'], thick=4, color=[6,7,8], $
	/bottom, /right, line=[0,0,0]
plot, area_bare.energy_kev, area_bare.eff_area_cm2, charsize=1.2, thick=4, yr=[0,250], $
	xtitle='Energy [keV]', ytitle='Effective area [cm!U2!N]', line=2
oplot, area_bare.energy_kev, area_blankets.eff_area_cm2, thick=4, color=6
oplot, area_bare.energy_kev, area_det.eff_area_cm2, thick=4, color=7
oplot, area_bare.energy_kev, area_offaxis.eff_area_cm2, thick=4, color=8
oplot, area.energy_kev, area.eff_area_cm2, thick=4
oplot, e1, rhessi, thick=4, line=1
legend, ['Optics eff area','Optics eff area inc. blankets','Optics eff area inc det efficiency',$
	'Optics eff area at 7 arcmin','Total FOXSI effective area for microflare','RHESSI eff area'],$
	thick=4, /top, /right, line=[2,0,0,0,0,1], color=[0,6,7,8,0,0]
pclose

;;;;
; Measured flight data spectra
;;;;
t1 = 64845  ; 18:00:45
t2 = 64905  ; 18:01:45
binwidth=0.5
restore, 'data_2012/foxsi_level0_data.sav'
lvl0_0 = data_D0
lvl0_1 = data_D1
lvl0_2 = data_D2
lvl0_3 = data_D3
lvl0_4 = data_D4
lvl0_5 = data_D5
lvl0_6 = data_D6
restore, 'data_2012/foxsi_level1_data.sav'
lvl1_0 = data_D0
lvl1_1 = data_D1
lvl1_2 = data_D2
lvl1_3 = data_D3
lvl1_4 = data_D4
lvl1_5 = data_D5
lvl1_6 = data_D6
i0=where(lvl1_0.error_flag eq 0 and lvl1_0.wsmr_time gt t1 and lvl1_0.wsmr_time lt t2)
i1=where(lvl1_1.error_flag eq 0 and lvl1_1.wsmr_time gt t1 and lvl1_1.wsmr_time lt t2)
i2=where(lvl1_2.error_flag eq 0 and lvl1_2.wsmr_time gt t1 and lvl1_2.wsmr_time lt t2)
i3=where(lvl1_3.error_flag eq 0 and lvl1_3.wsmr_time gt t1 and lvl1_3.wsmr_time lt t2)
i4=where(lvl1_4.error_flag eq 0 and lvl1_4.wsmr_time gt t1 and lvl1_4.wsmr_time lt t2)
i5=where(lvl1_5.error_flag eq 0 and lvl1_5.wsmr_time gt t1 and lvl1_5.wsmr_time lt t2)
i6=where(lvl1_6.error_flag eq 0 and lvl1_6.wsmr_time gt t1 and lvl1_6.wsmr_time lt t2)
data0 = lvl0_0[i0]
data1 = lvl0_1[i1]
data2 = lvl0_2[i2]
data3 = lvl0_3[i3]
data4 = lvl0_4[i4]
data5 = lvl0_5[i5]
data6 = lvl0_6[i6]
spec_D0 = counts2energy_diagonal( data0, peaksfile='detector_data/peaks_det109.sav', binwidth=binwidth  )
spec_D1 = counts2energy_diagonal( data1, peaksfile='detector_data/peaks_det108.sav', binwidth=binwidth  )
spec_D2 = counts2energy_diagonal( data2, peaksfile='detector_data/peaks_det102.sav', binwidth=binwidth  )
spec_D3 = counts2energy_diagonal( data3, peaksfile='detector_data/peaks_det103.sav', binwidth=binwidth  )
spec_D4 = counts2energy_diagonal( data4, peaksfile='detector_data/peaks_det104.sav', binwidth=binwidth  )
spec_D5 = counts2energy_diagonal( data5, peaksfile='detector_data/peaks_det105.sav', binwidth=binwidth  )
spec_D6 = counts2energy_diagonal( data6, peaksfile='detector_data/peaks_det106.sav', binwidth=binwidth )
;;;;;;; DOUBLE CHECK DETECTOR NUMBERS ;;;;;;;;
save, spec_D0, spec_D1, spec_D2, spec_D3, spec_D4, spec_D5, spec_D6, file = 'basic_spectra.sav'

restore, 'basic_spectra.sav',/v

popen, 'plots/flare_counts', xsize=7, ysize=5
plot,  sim.energy_kev, sim.counts/7., xr=[1,20],yr=[10.,1.e4], thick=4, psym=10, $
  xtitle='Energy [keV]', ytitle='FOXSI counts/keV', /ylog, /xlog, xstyle=1, line=1, $
  title = 'FOXSI counts for 1 minute, single optic/detector'
oplot, spec_d0[*,2,0], spec_d0[*,2,1]/binwidth, psym=10, thick=4, color=6
oplot, spec_d1[*,2,0], spec_d1[*,2,1]/binwidth, psym=10, thick=4, color=7
oplot, spec_d2[*,3,0], spec_d2[*,3,1]/binwidth, psym=10, thick=4, color=8
oplot, spec_d3[*,3,0], spec_d3[*,3,1]/binwidth, psym=10, thick=4, color=9
oplot, spec_d4[*,2,0], spec_d4[*,2,1]/binwidth, psym=10, thick=4, color=10
oplot, spec_d5[*,2,0], spec_d5[*,2,1]/binwidth, psym=10, thick=4, color=12
oplot, spec_d6[*,3,0], spec_d6[*,3,1]/binwidth, psym=10, thick=4, color=2
legend, ['Simulated flare counts','Det0','Det1','Det2','Det3','Det4','Det5','Det6'], $
		 thick=4, line=[1,0,0,0,0,0,0,0], color=[0,6,7,8,9,10,12,2]
pclose

; do both curves again with finer bins.
sim_fine = foxsi_count_spectrum( em, t, time=60., binsize=0.1, data_dir='detector_data/', $
	let_file='efficiency_det106_asic3.sav')
spec_D0_fine = counts2energy_diagonal( data0, peaksfile='detector_data/peaks_det109.sav', binwidth=0.1 )
spec_D1_fine = counts2energy_diagonal( data1, peaksfile='detector_data/peaks_det108.sav', binwidth=0.1 )
spec_D2_fine = counts2energy_diagonal( data2, peaksfile='detector_data/peaks_det102.sav', binwidth=0.1 )
spec_D3_fine = counts2energy_diagonal( data3, peaksfile='detector_data/peaks_det103.sav', binwidth=0.1 )
spec_D4_fine = counts2energy_diagonal( data4, peaksfile='detector_data/peaks_det104.sav', binwidth=0.1 )
spec_D5_fine = counts2energy_diagonal( data5, peaksfile='detector_data/peaks_det105.sav', binwidth=0.1 )
spec_D6_fine = counts2energy_diagonal( data6, peaksfile='detector_data/peaks_det106.sav', binwidth=0.1 )

FUNCTION get_foxsi_effarea, ENERGY_ARR = energy_arr, PER_MODULE = per_module, $
PLOT = plot, NODET = nodet, NOSHUT = noshut, BE_UM = be_um, DET_THICK = det_thick, $
TYPE = type, FOXSI2 = FOXSI2, NOPATH = nopath, LET_FILE = let_file, $
DATA_DIR = data_dir, OFFAXIS_ANGLE = offaxis_angle, _EXTRA = _extra

mylar=82.55
al=2.6
kapton=203.2

; plot ratio of two and compare to blanketing schemes.
area = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/')
areaX2 = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/', $
			mylar=2.*mylar, al=2*al, kap=2*kapton)
areaX4 = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/', $
			mylar=4.*mylar, al=4*al, kap=4*kapton)
areaX6 = get_foxsi_effarea(energy_arr=emid, /nodet, /noshut, data_dir='detector_data/', $
			mylar=6.*mylar, al=6*al, kap=6*kapton)
plot, sim_fine.energy_kev, (spec_d6_fine[0:120,3,1]/0.1)/(sim_fine.counts/7.), xr=[2,10], $
;	yr=[1.e-3,10.], /ylog, $
	yr=[0.,1.], $
	thick=4, charsize=1.2, xtitle='Energy [keV]', ytitle='ratio of measured to simulated counts', $
	title='Comparison of sim and measured counts for detector 6 (1 minute)', psym=10, /nodata
oplot, sim_fine.energy_kev, (2*spec_d0_fine[20:140,2,1]/0.1)/(sim_fine.counts/7.), psym=10, color=6
oplot, sim_fine.energy_kev, (2*spec_d1_fine[20:140,2,1]/0.1)/(sim_fine.counts/7.), psym=10, color=7
oplot, sim_fine.energy_kev, (2*spec_d2_fine[20:140,3,1]/0.1)/(sim_fine.counts/7.), psym=10, color=8
oplot, sim_fine.energy_kev, (2*spec_d3_fine[20:140,3,1]/0.1)/(sim_fine.counts/7.), psym=10, color=9
oplot, sim_fine.energy_kev, (2*spec_d4_fine[20:140,2,1]/0.1)/(sim_fine.counts/7.), psym=10, color=10
oplot, sim_fine.energy_kev, (2*spec_d5_fine[20:140,2,1]/0.1)/(sim_fine.counts/7.), psym=10, color=12
oplot, sim_fine.energy_kev, (2*spec_d6_fine[20:140,3,1]/0.1)/(sim_fine.counts/7.), psym=10, color=2
oplot, area.energy_kev, areaX2.eff_area_cm2/area.eff_area_cm2, thick=4, line=2, color=6
oplot, area.energy_kev, areaX4.eff_area_cm2/area.eff_area_cm2, thick=4, line=2, color=7
oplot, area.energy_kev, areaX6.eff_area_cm2/area.eff_area_cm2, thick=4, line=2, color=8
;legend, ['effect of 2X blanketing','4X blanketing','6X blanketing'], thick=4, line=2, color=[6,7,8]
legend, ['Simulated flare counts','Det0','Det1','Det2','Det3','Det4','Det5','Det6'], $
		 thick=4, line=[1,0,0,0,0,0,0,0], color=[0,6,7,8,9,10,12,2]

