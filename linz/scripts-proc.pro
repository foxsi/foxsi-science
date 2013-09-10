; Create Level 0 data
.compile wsmr_data_to_level0
filename = 'data_2012/36.255_TM2_Flight_2012-11-02.log'
data_lvl0_D0 = wsmr_data_to_level0( filename, det=0 )
data_lvl0_D1 = wsmr_data_to_level0( filename, det=1 )
data_lvl0_D2 = wsmr_data_to_level0( filename, det=2 )
data_lvl0_D3 = wsmr_data_to_level0( filename, det=3 )
data_lvl0_D4 = wsmr_data_to_level0( filename, det=4 )
data_lvl0_D5 = wsmr_data_to_level0( filename, det=5 )
data_lvl0_D6 = wsmr_data_to_level0( filename, det=6 )
save, data_lvl0_D0, data_lvl0_D1, data_lvl0_D2, data_lvl0_D3, data_lvl0_D4, $
	data_lvl0_D5, data_lvl0_d6, $
	file = 'data_2012/foxsi_level0_data.sav'

; Create Level 1 data
.compile foxsi_level0_to_level1
filename = 'data_2012/foxsi_level0_data.sav'
data_lvl1_D0 = foxsi_level0_to_level1( filename, det=0 )
data_lvl1_D1 = foxsi_level0_to_level1( filename, det=1 )
data_lvl1_D2 = foxsi_level0_to_level1( filename, det=2 )
data_lvl1_D3 = foxsi_level0_to_level1( filename, det=3 )
data_lvl1_D4 = foxsi_level0_to_level1( filename, det=4 )
data_lvl1_D5 = foxsi_level0_to_level1( filename, det=5 )
data_lvl1_D6 = foxsi_level0_to_level1( filename, det=6 )
save, data_lvl1_D0, data_lvl1_D1, data_lvl1_D2, data_lvl1_D3, data_lvl1_D4, $
	data_lvl1_D5, data_lvl1_d6, $
	file = 'data_2012/foxsi_level1_data.sav'

; Plot positions from Level 1 data
t_launch = 64500
t4_start = t_launch + 340		; Target 4 (flare)
t4_end = t_launch + 421.2
d=data_lvl1_d6
i=where(d.error_flag eq 0 and d.wsmr_time gt t4_start and d.wsmr_time lt t4_end )
;plot,d[i].hit_xy_pay[0],d[i].hit_xy_pay[1],/psy
plot,d[i].hit_xy_pay[0],d[i].hit_xy_pay[1],/psy, xr=[200,400], yr=[200,400]
oplot, [median(d[i].hit_xy_pay[0])], [median(d[i].hit_xy_pay[1])], color=144, $
	/psy, symsize=4, thick=4
print, median( d[i].hit_xy_pay[0] ), median( d[i].hit_xy_pay[1] )
;oplot,[350],[270],/psy,color=6,symsize=5,thick=3

; Create Level 2 data
file0 = 'data_2012/foxsi_level0_data.sav'
file1 = 'data_2012/foxsi_level1_data.sav'
cal0 = 'detector_data/peaks_det108.sav'
cal1 = 'detector_data/peaks_det109.sav'
cal2 = 'detector_data/peaks_det102.sav'
cal3 = 'detector_data/peaks_det103.sav'
cal4 = 'detector_data/peaks_det104.sav'
cal5 = 'detector_data/peaks_det105.sav'
cal6 = 'detector_data/peaks_det106.sav'
data_lvl2_D0 = foxsi_level1_to_level2( file0, file1, det=0, calib=cal0 )
data_lvl2_D1 = foxsi_level1_to_level2( file0, file1, det=1, calib=cal1 )
data_lvl2_D2 = foxsi_level1_to_level2( file0, file1, det=2, calib=cal2 )
data_lvl2_D3 = foxsi_level1_to_level2( file0, file1, det=3, calib=cal3 )
data_lvl2_D4 = foxsi_level1_to_level2( file0, file1, det=4, calib=cal4 )
data_lvl2_D5 = foxsi_level1_to_level2( file0, file1, det=5, calib=cal5 )
data_lvl2_D6 = foxsi_level1_to_level2( file0, file1, det=6, calib=cal6 )
save, data_lvl2_D0, data_lvl2_D1, data_lvl2_D2, data_lvl2_D3, $
	data_lvl2_D4, data_lvl2_D5, data_lvl2_d6, $
	file = 'data_2012/foxsi_level2_data.sav'


;
;	Look at a sequence test file for comparison.
;
filename = 'data_2012/36.255_TM2_T-1hr_Vert_2012-11-02.log'
data_lvl0_D0 = wsmr_data_to_level0( filename, det=0 )
data_lvl0_D1 = wsmr_data_to_level0( filename, det=1 )
data_lvl0_D2 = wsmr_data_to_level0( filename, det=2 )
data_lvl0_D3 = wsmr_data_to_level0( filename, det=3 )
data_lvl0_D4 = wsmr_data_to_level0( filename, det=4 )
data_lvl0_D5 = wsmr_data_to_level0( filename, det=5 )
data_lvl0_D6 = wsmr_data_to_level0( filename, det=6 )
save, data_lvl0_D0, data_lvl0_D1, data_lvl0_D2, data_lvl0_D3, data_lvl0_D4, $
	data_lvl0_D5, data_lvl0_d6, $
	file = 'data_2012/sequence_level0_data.sav'

; Create Level 1 data
filename = 'data_2012/sequence_level0_data.sav'
data_lvl1_D0 = foxsi_level0_to_level1( filename, det=0 )
data_lvl1_D1 = foxsi_level0_to_level1( filename, det=1 )
data_lvl1_D2 = foxsi_level0_to_level1( filename, det=2 )
data_lvl1_D3 = foxsi_level0_to_level1( filename, det=3 )
data_lvl1_D4 = foxsi_level0_to_level1( filename, det=4 )
data_lvl1_D5 = foxsi_level0_to_level1( filename, det=5 )
data_lvl1_D6 = foxsi_level0_to_level1( filename, det=6 )
save, data_lvl1_D0, data_lvl1_D1, data_lvl1_D2, data_lvl1_D3, data_lvl1_D4, $
	data_lvl1_D5, data_lvl1_d6, $
	file = 'data_2012/sequence_level1_data.sav'

; Create Level 2 data
file0 = 'data_2012/sequence_level0_data.sav'
file1 = 'data_2012/sequence_level1_data.sav'
cal0 = 'detector_data/peaks_det108.sav'
cal1 = 'detector_data/peaks_det109.sav'
cal2 = 'detector_data/peaks_det102.sav'
cal3 = 'detector_data/peaks_det103.sav'
cal4 = 'detector_data/peaks_det104.sav'
cal5 = 'detector_data/peaks_det105.sav'
cal6 = 'detector_data/peaks_det106.sav'
data_lvl2_D0 = foxsi_level1_to_level2( file0, file1, det=0, calib=cal0, /ground )
data_lvl2_D1 = foxsi_level1_to_level2( file0, file1, det=1, calib=cal1, /ground )
data_lvl2_D2 = foxsi_level1_to_level2( file0, file1, det=2, calib=cal2, /ground )
data_lvl2_D3 = foxsi_level1_to_level2( file0, file1, det=3, calib=cal3, /ground )
data_lvl2_D4 = foxsi_level1_to_level2( file0, file1, det=4, calib=cal4, /ground )
data_lvl2_D5 = foxsi_level1_to_level2( file0, file1, det=5, calib=cal5, /ground )
data_lvl2_D6 = foxsi_level1_to_level2( file0, file1, det=6, calib=cal6, /ground )
save, data_lvl2_D0, data_lvl2_D1, data_lvl2_D2, data_lvl2_D3, $
	data_lvl2_D4, data_lvl2_D5, data_lvl2_d6, $
	file = 'data_2012/sequence_level2_data.sav'

i0=where(data_lvl2_d0.hv eq 200)
i1=where(data_lvl2_d1.hv eq 200)
i2=where(data_lvl2_d2.hv eq 200)
i3=where(data_lvl2_d3.hv eq 200)
i4=where(data_lvl2_d4.hv eq 200)
i5=where(data_lvl2_d5.hv eq 200)
i6=where(data_lvl2_d6.hv eq 200)

; Plot basic spectra
spex0=make_spectrum( data_lvl2_d0[i0], bin=0.5, /corr )
spex1=make_spectrum( data_lvl2_d1[i1], bin=0.5, /corr  )
spex2=make_spectrum( data_lvl2_d2[i2], bin=0.5, /corr  )
spex3=make_spectrum( data_lvl2_d3[i3], bin=0.5, /corr  )
spex4=make_spectrum( data_lvl2_d4[i4], bin=0.5, /corr  )
spex5=make_spectrum( data_lvl2_d5[i5], bin=0.5, /corr  )
spex6=make_spectrum( data_lvl2_d6[i6], bin=0.5, /corr  )
sum = spex0.spec_p + spex1.spec_p + spex2.spec_p + spex3.spec_p $
	 + spex4.spec_p + spex5.spec_p + spex6.spec_p

plot, spex0.energy_kev, sum, psym=10


t1=t1_start
t2=t3_end
e1=3
e2=15

i0 = where( data_lvl2_d0.error_flag eq 0 $
	and data_lvl2_d0.wsmr_time gt t1 and data_lvl2_d0.wsmr_time lt t2  $
	and data_lvl2_d0.hit_energy[1] gt e1 $
	and data_lvl2_d0.hit_energy[1] lt e2 $
	)
i1 = where( data_lvl2_d1.error_flag eq 0 and  $
	data_lvl2_d1.wsmr_time gt t1 and data_lvl2_d1.wsmr_time lt t2 and  $
	data_lvl2_d1.hit_energy[1] gt e1 and $
	data_lvl2_d1.hit_energy[1] lt e2 )
i2 = where( data_lvl2_d2.error_flag eq 0 and  $
	data_lvl2_d2.wsmr_time gt t1 and data_lvl2_d2.wsmr_time lt t2 and  $
	data_lvl2_d2.hit_energy[1] gt e1 and $
	data_lvl2_d2.hit_energy[1] lt e2 )
i3 = where( data_lvl2_d3.error_flag eq 0 and  $
	data_lvl2_d3.wsmr_time gt t1 and data_lvl2_d3.wsmr_time lt t2 and $ 
	data_lvl2_d3.hit_energy[1] gt e1 and $
	data_lvl2_d3.hit_energy[1] lt e2 )
i4 = where( data_lvl2_d4.error_flag eq 0 and  $
	data_lvl2_d4.wsmr_time gt t1 and data_lvl2_d4.wsmr_time lt t2 and  $
	data_lvl2_d4.hit_energy[1] gt e1 and $
	data_lvl2_d4.hit_energy[1] lt e2 )
i5 = where( data_lvl2_d5.error_flag eq 0 and  $
	data_lvl2_d5.wsmr_time gt t1 and data_lvl2_d5.wsmr_time lt t2 and  $
	data_lvl2_d5.hit_energy[1] gt e1 and $
	data_lvl2_d5.hit_energy[1] lt e2 )
i6 = where( data_lvl2_d6.error_flag eq 0 and  $
	data_lvl2_d6.wsmr_time gt t1 and data_lvl2_d6.wsmr_time lt t2 and  $
	data_lvl2_d6.hit_energy[1] gt e1 and $
	data_lvl2_d6.hit_energy[1] lt e2 )

; Plot basic spectra
spex0=make_spectrum( data_lvl2_d0[i0], bin=1.0);, /corr )
spex1=make_spectrum( data_lvl2_d1[i1], bin=1.0);, /corr  )
spex2=make_spectrum( data_lvl2_d2[i2], bin=1.0);, /corr  )
spex3=make_spectrum( data_lvl2_d3[i3], bin=1.0);, /corr  )
spex4=make_spectrum( data_lvl2_d4[i4], bin=1.0);, /corr  )
spex5=make_spectrum( data_lvl2_d5[i5], bin=1.0);, /corr  )
spex6=make_spectrum( data_lvl2_d6[i6], bin=1.0);, /corr  )
sum = spex0.spec_p + spex2.spec_p + spex4.spec_p + spex5.spec_p + spex6.spec_p

plot, spex6.energy_kev, spex6.spec_p, psym=10, /xlo, /ylo, xr=[2.,20.], yr=[1.,100.]



;;;;
; Measured flight data spectra
;;;;

; For reference, times of all target windows (from RLG on or target stable to new 
; target received or RLG off)
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
t1 = t4_start
t2 = t4_end
binwidth=0.5

;;; Method 1: This is the old way to do it, using a hacked routine I wrote
;; (needed before we had Level 2 data)
;restore, 'data_2012/foxsi_level0_data.sav'
;lvl0 = data_D6
;restore, 'data_2012/foxsi_level1_data.sav'
;lvl1 = data_D6
;i=where(lvl1.error_flag eq 0 and lvl1.wsmr_time gt t1 and lvl1.wsmr_time lt t2)
;data = lvl0[i]
;spec = counts2energy_diagonal( data, peaksfile='detector_data/peaks_det106.sav', $
;	binwidth=binwidth  )
;plot,  sim.energy_kev, sim.counts., xr=[1,20],yr=[10.,1.e4], thick=4, psym=10, $
;  xtitle='Energy [keV]', ytitle='FOXSI counts/keV', /ylog, /xlog, xstyle=1, line=1, $
;  title = 'FOXSI counts for 1 minute, single optic/detector'
;oplot, spec[*,2,0], spec[*,2,1]/binwidth, psym=10, thick=4, color=6
;legend, ['Simulated flare counts','Actual D6 counts'], $
;		 thick=4, line=[1,0], color=[0,6]


