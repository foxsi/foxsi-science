t1 = '02-Nov-2012 ' + ['17:50:00','18:30:00']

obs_obj = hsi_obs_summary( obs_time_interval=t1 )
obs_obj->plotman, /ylog

t2 = '02-Nov-2012 ' + ['18:01:00','18:02:00']

obj = hsi_image()
obj-> set, det_index_mask= [0B, 0B, 1B, 1B, 1B, 1B, 1B, 1B, 0B]
obj-> set, im_energy_binning= [4., 10.]
obj-> set, im_time_interval= t2
obj-> set, image_dim= [128, 128]
obj-> set, pixel_size= [1., 1.]*0.5
;obj-> set, use_auto_time_bin= 1L
obj-> set, use_flare_xyoffset= 1L

obj-> set, smoothing_time= 4.0
obj-> set, use_phz_stacker= 1L

obj-> set, image_algorithm= 'Clean'
obj-> set, natural_weighting= 1L
obj-> set, uniform_weighting= 0L
;obj -> set,clean_show_maps=0L
;obj-> set, clean_niter = 200
obj-> set, clean_beam_width_factor = 1.5

obj -> set, CLEAN_REGRESS_COMBINE=1L

;obj-> set, image_algorithm= 'MEM_NJIT'
;obj-> set, image_alg = 'EM'

data = obj-> getdata()
obj-> plotman
obj->fitswrite
