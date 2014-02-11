FUNCTION	GET_TARGET_SPECTRA, TARGET, CORRECT=CORRECT, BINWIDTH=BINWIDTH, GOOD=GOOD

;	Returns structure array (7 elements) holding spectra for all detectors
;   for the selected target.  (Targets numbered 1-6.)
;	Units are counts per keV per second.
;
;	2014 Feb	Linz	Added keyword GOOD
;

default, binwidth, 0.5

add_path, '~/Documents/foxsi/flight-analysis/foxsi-science/resp'
add_path, '~/Documents/foxsi/flight-analysis/foxsi-science/spec'

restore, 'data_2012/foxsi_level2_data.sav', /v

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

case target of
	1:  t1 = t1_start
	2:  t1 = t2_start
	3:  t1 = t3_start
	4:  t1 = t4_start
	5:  t1 = t5_start
	6:  t1 = t6_start
	else: begin
		print, 'Target must be 1-6.'
		return, -1
	end
endcase

case target of
	1:  t2 = t1_end
	2:  t2 = t2_end
	3:  t2 = t3_end
	4:  t2 = t4_end
	5:  t2 = t5_end
	6:  t2 = t6_end
endcase

delta_t = t2 - t1

if keyword_set(good) then begin
	i0 = where(data_lvl2_d0.wsmr_time gt t1 and data_lvl2_d0.wsmr_time lt t2 and data_lvl2_d0.error_flag eq 0)
	i1 = where(data_lvl2_d1.wsmr_time gt t1 and data_lvl2_d1.wsmr_time lt t2 and data_lvl2_d1.error_flag eq 0)
	i2 = where(data_lvl2_d2.wsmr_time gt t1 and data_lvl2_d2.wsmr_time lt t2 and data_lvl2_d2.error_flag eq 0)
	i3 = where(data_lvl2_d3.wsmr_time gt t1 and data_lvl2_d3.wsmr_time lt t2 and data_lvl2_d3.error_flag eq 0)
	i4 = where(data_lvl2_d4.wsmr_time gt t1 and data_lvl2_d4.wsmr_time lt t2 and data_lvl2_d4.error_flag eq 0)
	i5 = where(data_lvl2_d5.wsmr_time gt t1 and data_lvl2_d5.wsmr_time lt t2 and data_lvl2_d5.error_flag eq 0)
	i6 = where(data_lvl2_d6.wsmr_time gt t1 and data_lvl2_d6.wsmr_time lt t2 and data_lvl2_d6.error_flag eq 0)
endif else begin
	i0 = where(data_lvl2_d0.wsmr_time gt t1 and data_lvl2_d0.wsmr_time lt t2)
	i1 = where(data_lvl2_d1.wsmr_time gt t1 and data_lvl2_d1.wsmr_time lt t2)
	i2 = where(data_lvl2_d2.wsmr_time gt t1 and data_lvl2_d2.wsmr_time lt t2)
	i3 = where(data_lvl2_d3.wsmr_time gt t1 and data_lvl2_d3.wsmr_time lt t2)
	i4 = where(data_lvl2_d4.wsmr_time gt t1 and data_lvl2_d4.wsmr_time lt t2)
	i5 = where(data_lvl2_d5.wsmr_time gt t1 and data_lvl2_d5.wsmr_time lt t2)
	i6 = where(data_lvl2_d6.wsmr_time gt t1 and data_lvl2_d6.wsmr_time lt t2)
endelse

spec_d0 = make_spectrum( data_lvl2_d0[i0], bin=binwidth, correct=correct )
spec_d1 = make_spectrum( data_lvl2_d1[i1], bin=binwidth, correct=correct )
spec_d2 = make_spectrum( data_lvl2_d2[i2], bin=binwidth, correct=correct )
spec_d3 = make_spectrum( data_lvl2_d3[i3], bin=binwidth, correct=correct )
spec_d4 = make_spectrum( data_lvl2_d4[i4], bin=binwidth, correct=correct )
spec_d5 = make_spectrum( data_lvl2_d5[i5], bin=binwidth, correct=correct )
spec_d6 = make_spectrum( data_lvl2_d6[i6], bin=binwidth, correct=correct )

spec = [spec_d0, spec_d1, spec_d2, spec_d3, spec_d4, spec_d5, spec_d6]

spec.spec_n = spec.spec_n / delta_t
spec.spec_p = spec.spec_p / delta_t
spec.spec_p_err = spec.spec_p_err / delta_t

return, spec

END
