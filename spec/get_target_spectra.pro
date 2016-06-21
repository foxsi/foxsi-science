FUNCTION	GET_TARGET_SPECTRA, TARGET, CORRECT=CORRECT, BINWIDTH=BINWIDTH, GOOD=GOOD, $
			YEAR=YEAR, LOG=LOG, STOP=STOP

;	Returns structure array (7 elements) holding spectra for all detectors
;   for the selected target.  (Targets numbered 1-6.)
;	Units are counts per keV per second.
;
;	2014 Feb	Linz	Added keyword GOOD
;

COMMON FOXSI_PARAM
default, binwidth, 0.5


if tlaunch eq 69060 then begin
	t1_start = t1_pos2_start + t_launch
	t1_end   = t1_pos2_end + t_launch
	t2_start = t2_pos1_start + t_launch
	t2_end   = t2_pos1_end + t_launch
	t3_start = t3_pos2_start + t_launch
	t3_end   = t3_pos2_end + t_launch
	t4_start = t4_start + t_launch
	t4_end   = t_shtr_start + t_launch
	t5_start = t5_start + t_launch
	t5_end   = t5_end + t_launch
endif 

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

if keyword_set( LOG ) then begin
	spec_d0 = make_spectrum( data_lvl2_d0[i0], correct=correct, /log )
	spec_d1 = make_spectrum( data_lvl2_d1[i1], correct=correct, /log )
	spec_d2 = make_spectrum( data_lvl2_d2[i2], correct=correct, /log )
	spec_d3 = make_spectrum( data_lvl2_d3[i3], correct=correct, /log )
	spec_d4 = make_spectrum( data_lvl2_d4[i4], correct=correct, /log )
	spec_d5 = make_spectrum( data_lvl2_d5[i5], correct=correct, /log )
	spec_d6 = make_spectrum( data_lvl2_d6[i6], correct=correct, /log )
endif else begin
	spec_d0 = make_spectrum( data_lvl2_d0[i0], correct=correct, binwidth=binwidth )
	spec_d1 = make_spectrum( data_lvl2_d1[i1], correct=correct, binwidth=binwidth )
	spec_d2 = make_spectrum( data_lvl2_d2[i2], correct=correct, binwidth=binwidth )
	spec_d3 = make_spectrum( data_lvl2_d3[i3], correct=correct, binwidth=binwidth )
	spec_d4 = make_spectrum( data_lvl2_d4[i4], correct=correct, binwidth=binwidth )
	spec_d5 = make_spectrum( data_lvl2_d5[i5], correct=correct, binwidth=binwidth )
	spec_d6 = make_spectrum( data_lvl2_d6[i6], correct=correct, binwidth=binwidth )
endelse

spec = [spec_d0, spec_d1, spec_d2, spec_d3, spec_d4, spec_d5, spec_d6]

spec.spec_n = spec.spec_n / delta_t
spec.spec_p = spec.spec_p / delta_t
spec.spec_p_err = spec.spec_p_err / delta_t

if keyword_set(stop) then stop

return, spec

END
