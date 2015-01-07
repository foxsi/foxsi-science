
; Some outstanding notes
; OUTSTANDING ISSUES!!!
; -- Livetime has some odd values (4 striations).  Look at this carefully.
; 		Also, it will be difficult to calculate livetime accurately w/o knowing
;   	some info about what frames might be missing...


		 
get_target_data, 2, d0,d1,d2,d3,d4,d5,d6

error = d0[ where(d0.error_flag ne 0) ].error_flag
print, error, format='(B8.8)'
error = string(error, format='(B8.8)')
err0 = strmid(error, 7, 1)
err1 = strmid(error, 6, 1)
err2 = strmid(error, 5, 1)
err3 = strmid(error, 4, 1)
err4 = strmid(error, 3, 1)
err5 = strmid(error, 2, 1)
err6 = strmid(error, 1, 1)


t_int = ['02-Nov-2012 17:40:00', '02-Nov-2012 18:40:00.000']
search_network, /enable

obs_obj = hsi_obs_summary()
obs_obj-> set, obs_time_interval= t_int
obs_obj-> plotman, /ylog

obj = hsi_spectrum()
obj-> set, obs_time_interval= t_int
obj-> set, decimation_correct= 1                                                             
obj-> set, rear_decimation_correct= 0                                                        
obj-> set, pileup_correct= 0                                                                 
obj-> set, seg_index_mask= [1B, 0B, 1B, 1B, 1B, 1B, 0B, 1B, 1B, $
							0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B]
obj-> set, sp_chan_binning= 0
obj-> set, sp_chan_max= 0
obj-> set, sp_chan_min= 0
obj-> set, sp_data_unit= 'Flux'
obj-> set, sp_energy_binning= 6L
obj-> set, sp_semi_calibrated= 0B
obj-> set, sp_time_interval= 10
obj-> set, sum_flag= 1
obj-> set, time_range= [0.0000000D, 0.0000000D]
obj-> set, use_flare_xyoffset= 1

data = obj->getdata()    ; retrieve the spectrum data
;obj-> plot               ; plot the spectrum
;obj-> plotman            ; plot the spectrum in plotman
;obj-> plot, /pl_time     ; plot the time history
;obj-> plotman, pl_time   ; plot the time history in plotman

specfile = 'hsi_spec_20121102.fits'
srmfile = 'hsi_srm_20121102.fits'
obj->filewrite, /buildsrm, srmfile = srmfile, specfile = specfile

s=obj->get(/spex_summ)

en2 = s.spex_summ_energy
en1 = get_edges(en2,/edges_1)
en  = get_edges(en2, /mean)
en_bin = get_edges(en2, /width)
conv = s.spex_summ_conv
ct_rate = s.spex_summ_ct_rate / s.spex_summ_area
bkgd_rate = s.spex_summ_bk_rate

flare = [flare[0],flare[2:6]]


area=get_foxsi_effarea(energy_arr=emid, offaxis=7. )
area_fx = interpol( area.eff_area_cm2, area.energy_kev, en )
cts_fx  = interpol( total(flare.spec_p,2), flare[5].energy_kev, en )
phot_fx = cts_fx / area_fx

plot, en, phot_fx, /xlog, /ylog, xr=[1.,20], yr=[1.e-4, 1.e3], /xsty, psym=10, thick=4

cts_hsi = phot_fx * conv

plot, en, cts_hsi, /xlog, /ylog, xr=[1.,20], yr=[1.e-4, 1.], /xsty, psym=10, thick=4
oplot, en, ct_rate, psym=10

