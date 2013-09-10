PRO		GET_TARGET_DATA, TARGET, D0, D1, D2, D3, D4, D5, D6, LEVEL=LEVEL, $
		RADIUS=RADIUS, CENTER=CENTER, STOP=STOP, EBAND=EBAND

;	Returns data for the desired target. (Targets numbered 1-6.)
;	If level=1, then level 1 data is returned, otherwise level 2.
;
;	RADIUS	If set, then restrict data to a radius around the center position.
;	CENTER	Center for selected region.  If RADIUS is 0 then CENTER is ignored.
;	EBAND	If set, restrict to energy range defined by this 2-element array.

if keyword_set(level) then restore, 'data_2012/foxsi_level1_data.sav', /v else $
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
		return
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

if keyword_set(level) then begin
	d0 = data_lvl1_d0[ where(data_lvl1_d0.wsmr_time gt t1 and data_lvl1_d0.wsmr_time lt t2) ]
	d1 = data_lvl1_d1[ where(data_lvl1_d1.wsmr_time gt t1 and data_lvl1_d1.wsmr_time lt t2) ]
	d2 = data_lvl1_d2[ where(data_lvl1_d2.wsmr_time gt t1 and data_lvl1_d2.wsmr_time lt t2) ]
	d3 = data_lvl1_d3[ where(data_lvl1_d3.wsmr_time gt t1 and data_lvl1_d3.wsmr_time lt t2) ]
	d4 = data_lvl1_d4[ where(data_lvl1_d4.wsmr_time gt t1 and data_lvl1_d4.wsmr_time lt t2) ]
	d5 = data_lvl1_d5[ where(data_lvl1_d5.wsmr_time gt t1 and data_lvl1_d5.wsmr_time lt t2) ]
	d6 = data_lvl1_d6[ where(data_lvl1_d6.wsmr_time gt t1 and data_lvl1_d6.wsmr_time lt t2) ]
endif else begin
	d0 = data_lvl2_d0[ where(data_lvl2_d0.wsmr_time gt t1 and data_lvl2_d0.wsmr_time lt t2) ]
	d1 = data_lvl2_d1[ where(data_lvl2_d1.wsmr_time gt t1 and data_lvl2_d1.wsmr_time lt t2) ]
	d2 = data_lvl2_d2[ where(data_lvl2_d2.wsmr_time gt t1 and data_lvl2_d2.wsmr_time lt t2) ]
	d3 = data_lvl2_d3[ where(data_lvl2_d3.wsmr_time gt t1 and data_lvl2_d3.wsmr_time lt t2) ]
	d4 = data_lvl2_d4[ where(data_lvl2_d4.wsmr_time gt t1 and data_lvl2_d4.wsmr_time lt t2) ]
	d5 = data_lvl2_d5[ where(data_lvl2_d5.wsmr_time gt t1 and data_lvl2_d5.wsmr_time lt t2) ]
	d6 = data_lvl2_d6[ where(data_lvl2_d6.wsmr_time gt t1 and data_lvl2_d6.wsmr_time lt t2) ]
endelse

; if keyword RADIUS is set, then restrict data to a radius around center.

if keyword_set(stop) then stop

if keyword_set(radius) then begin
	if n_elements(center) eq 2 then center=[[center],[center],[center],[center],[center],[center],[center]]
;	d0 = d0[ where( sqrt((d0.hit_xy_solar[0,*]-center[0,0])^2 +(d0.hit_xy_solar[1,*]-center[1,0])^2) lt radius)	]
;	d1 = d1[ where( sqrt((d1.hit_xy_solar[0,*]-center[0,1])^2 +(d1.hit_xy_solar[1,*]-center[1,1])^2) lt radius)	]
;	d2 = d2[ where( sqrt((d2.hit_xy_solar[0,*]-center[0,2])^2 +(d2.hit_xy_solar[1,*]-center[1,2])^2) lt radius)	]
;	d3 = d3[ where( sqrt((d3.hit_xy_solar[0,*]-center[0,3])^2 +(d3.hit_xy_solar[1,*]-center[1,3])^2) lt radius)	]
;	d4 = d4[ where( sqrt((d4.hit_xy_solar[0,*]-center[0,4])^2 +(d4.hit_xy_solar[1,*]-center[1,4])^2) lt radius)	]
;	d5 = d5[ where( sqrt((d5.hit_xy_solar[0,*]-center[0,5])^2 +(d5.hit_xy_solar[1,*]-center[1,5])^2) lt radius)	]
;	d6 = d6[ where( sqrt((d6.hit_xy_solar[0,*]-center[0,6])^2 +(d6.hit_xy_solar[1,*]-center[1,6])^2) lt radius)	]
	d0 = d0[ where( ((d0.hit_xy_solar[0,*]-center[0,0]) le 0) and ((d0.hit_xy_solar[1,*]-center[1,0]) le 0) and sqrt((d0.hit_xy_solar[0,*]-center[0,0])^2 +(d0.hit_xy_solar[1,*]-center[1,0])^2) lt radius)	]
	d1 = d1[ where( ((d1.hit_xy_solar[0,*]-center[0,1]) le 0) and ((d1.hit_xy_solar[1,*]-center[1,1]) le 0) and sqrt((d1.hit_xy_solar[0,*]-center[0,1])^2 +(d1.hit_xy_solar[1,*]-center[1,1])^2) lt radius)	]
	d2 = d2[ where( ((d2.hit_xy_solar[0,*]-center[0,2]) le 0) and ((d2.hit_xy_solar[1,*]-center[1,2]) le 0) and sqrt((d2.hit_xy_solar[0,*]-center[0,2])^2 +(d2.hit_xy_solar[1,*]-center[1,2])^2) lt radius)	]
	d3 = d3[ where( ((d3.hit_xy_solar[0,*]-center[0,3]) le 0) and ((d3.hit_xy_solar[1,*]-center[1,3]) le 0) and sqrt((d3.hit_xy_solar[0,*]-center[0,3])^2 +(d3.hit_xy_solar[1,*]-center[1,3])^2) lt radius)	]
	d4 = d4[ where( ((d4.hit_xy_solar[0,*]-center[0,4]) le 0) and ((d4.hit_xy_solar[1,*]-center[1,4]) le 0) and sqrt((d4.hit_xy_solar[0,*]-center[0,4])^2 +(d4.hit_xy_solar[1,*]-center[1,4])^2) lt radius)	]
	d5 = d5[ where( ((d5.hit_xy_solar[0,*]-center[0,5]) le 0) and ((d5.hit_xy_solar[1,*]-center[1,5]) le 0) and sqrt((d5.hit_xy_solar[0,*]-center[0,5])^2 +(d5.hit_xy_solar[1,*]-center[1,5])^2) lt radius)	]
	d6 = d6[ where( ((d6.hit_xy_solar[0,*]-center[0,6]) le 0) and ((d6.hit_xy_solar[1,*]-center[1,6]) le 0) and sqrt((d6.hit_xy_solar[0,*]-center[0,6])^2 +(d6.hit_xy_solar[1,*]-center[1,6])^2) lt radius)	]
endif

if keyword_set(eband) then begin
	d0 = d0[ where(d0.hit_energy[1,*] gt eband[0] and d0.hit_energy[1,*] lt eband[1]) ]
	d1 = d1[ where(d1.hit_energy[1,*] gt eband[0] and d1.hit_energy[1,*] lt eband[1]) ]
	d2 = d2[ where(d2.hit_energy[1,*] gt eband[0] and d2.hit_energy[1,*] lt eband[1]) ]
	d3 = d3[ where(d3.hit_energy[1,*] gt eband[0] and d3.hit_energy[1,*] lt eband[1]) ]
	d4 = d4[ where(d4.hit_energy[1,*] gt eband[0] and d4.hit_energy[1,*] lt eband[1]) ]
	d5 = d5[ where(d5.hit_energy[1,*] gt eband[0] and d5.hit_energy[1,*] lt eband[1]) ]
	d6 = d6[ where(d6.hit_energy[1,*] gt eband[0] and d6.hit_energy[1,*] lt eband[1]) ]
endif	

return

END
