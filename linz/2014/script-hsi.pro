;
; Using Säm's RHESSI image.
;

restore,'sam/rhsi_xrt_last_foxsi_target.dat'
loadct2,3
;popen
!p.multi=[0,2,1]
this_fov=3
this_center=[20,-70]
this_center=[-65,90]
this_level=[50,70,90]
this_xrt=gxmap23
this_shift=[23,24]
this_xrt.xc=this_xrt.xc+this_shift(0)
this_xrt.yc=this_xrt.yc+this_shift(1)

plot_map,this_xrt,fov=this_fov,center=this_center,bot=9,dmax=-1700,dmin=-2500
plot_map,h_arx,/over,/per,levels=this_level,color=2,thick=4
xyouts,-147,19,'RHESSI 4-8 keV',charsize=1.4,color=2
xyouts,-147,7,'19:18:50-19:19:14UT',charsize=1.4,color=2

this_xrt2=gxmap24
this_xrt2.xc=this_xrt2.xc+this_shift(0)
this_xrt2.yc=this_xrt2.yc+this_shift(1)
plot_map,this_xrt2,fov=this_fov,center=this_center,bot=9,dmax=-1700,dmin=-3200
plot_map,h_arx,/over,/per,levels=this_level,color=2,thick=4
xyouts,-147,19,'RHESSI 4-8 keV',charsize=1.4,color=2
xyouts,-147,7,'19:18:50-19:19:14UT',charsize=1.4,color=2
;pclose

;
; end Säm's script.
;

; Adding on the FOXSI image too.

trange=[t5_start, t5_end]
cen = cen5
en = [4.,8.]
m = foxsi_image_map( data_lvl2_d6, cen, erange=en, trange=trange, /XYCORR, thr_n=4., smooth=2 )
m.id = 'FOXSI Det6 4-8 keV'

loadct, 5
plot_map, m, cen=this_center, fov=3

sub_fox = make_submap( m, cen=this_center, fov=3)
sub_hsi = make_submap( h_arx, cen=this_center, fov=3)
print, map_centroid(sub_fox, thr=1.)
print, map_centroid(sub_hsi, thr=0.0)
IDL> print, map_centroid(sub_fox, thr=1.)
      -108.09132       47.718691
IDL> print, map_centroid(sub_hsi, thr=0.004)
      -65.583088       89.430286
print, map_centroid(sub_hsi, thr=0.004) - map_centroid(sub_fox, thr=1.)
IDL> print, map_centroid(sub_hsi, thr=0.004) - map_centroid(sub_fox, thr=1.)
       42.508237       41.711595
;;;;; UPDATING THESE NUMBERS IN SETUP FILE ;;;;;


trange=[t5_start, t5_end]
cen = cen5

m1 = foxsi_image_map( data_lvl2_d6, cen, erange=[4.,6.], trange=trange, thr_n=4., /xycorr, smooth=2 )
m2 = foxsi_image_map( data_lvl2_d6, cen, erange=[6.,8.], trange=trange, thr_n=4., /xycorr, smooth=2 )
m3 = foxsi_image_map( data_lvl2_d6, cen, erange=[8,11.], trange=trange, thr_n=4., /xycorr, smooth=2 )

ma = foxsi_image_map( data_lvl2_d0, cen, erange=[8,11.], trange=trange, thr_n=4., /xycorr, smooth=2 )
mb = foxsi_image_map( data_lvl2_d1, cen, erange=[8,11.], trange=trange, thr_n=4., /xycorr, smooth=2 )
mc = foxsi_image_map( data_lvl2_d4, cen, erange=[8,11.], trange=trange, thr_n=4., /xycorr, smooth=2 )
md = foxsi_image_map( data_lvl2_d5, cen, erange=[8,11.], trange=trange, thr_n=4., /xycorr, smooth=2 )
me = foxsi_image_map( data_lvl2_d6, cen, erange=[8,11.], trange=trange, thr_n=4., /xycorr, smooth=2 )

m4 = ma
m4.data = ma.data+mb.data+mc.data+md.data+me.data


plot_map, m3, cen=this_center, fov=2

ratio = m1
ratio.data = m2.data / m1.data 
ratio.data[ where(m2.data lt 1.1) ] = 0.
ratio.data[ where(m1.data lt 1.1) ] = 0.
plot_map, ratio, /log, cen=[-100,100], fov=3, /cbar
plot_map, m1, /over







; Other work.


t1 = '11-Dec-2014 ' + ['19:10:00','20:10:00']

obs_obj = hsi_obs_summary( obs_time_interval=t1 )
obs_obj->plotman, /ylog

; Note: for this event, don't use 2, 4, or 5!

;
; SPEX
;

t_int = '11-Dec-2014 ' + ['18:40:00','20:10:00']

obs_obj = hsi_obs_summary()
obs_obj-> set, obs_time_interval= t_int
;obs_obj-> plotman, /ylog

obj = hsi_spectrum()
obj-> set, obs_time_interval= t_int
obj-> set, decimation_correct= 1                                                             
obj-> set, rear_decimation_correct= 0                                                        
obj-> set, pileup_correct= 0                                                                 
obj-> set, seg_index_mask= [1B, 0B, 1B, 0B, 0B, 1B, 0B, 1B, 1B, $
							0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B]
obj-> set, sp_chan_binning= 0
obj-> set, sp_chan_max= 0
obj-> set, sp_chan_min= 0
obj-> set, sp_data_unit= 'Flux'
obj-> set, sp_energy_binning= 22L
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

specfile = 'linz/2014/hsi/hsi_spec_20141211.fits'
srmfile = 'linz/2014/hsi/hsi_srm_20141211.fits'
obj->filewrite, /buildsrm, all_simplify = 0, srmfile = srmfile, specfile = specfile

obj-> set, seg_index_mask= [1B, 0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B, $
							0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B]
specfile = 'linz/2014/hsi/hsi_spec_20141211_D1.fits'
srmfile = 'linz/2014/hsi/hsi_srm_20141211_D1.fits'
obj->filewrite, /buildsrm, all_simplify = 0, srmfile = srmfile, specfile = specfile
obj-> set, seg_index_mask= [0B, 0B, 1B, 0B, 0B, 0B, 0B, 0B, 0B, $
							0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B]
specfile = 'linz/2014/hsi/hsi_spec_20141211_D3.fits'
srmfile = 'linz/2014/hsi/hsi_srm_20141211_D3.fits'
obj->filewrite, /buildsrm, all_simplify = 0, srmfile = srmfile, specfile = specfile
obj-> set, seg_index_mask= [0B, 0B, 0B, 0B, 0B, 1B, 0B, 0B, 0B, $
							0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B]
specfile = 'linz/2014/hsi/hsi_spec_20141211_D6.fits'
srmfile = 'linz/2014/hsi/hsi_srm_20141211_D6.fits'
obj->filewrite, /buildsrm, all_simplify = 0, srmfile = srmfile, specfile = specfile
obj-> set, seg_index_mask= [0B, 0B, 0B, 0B, 0B, 0B, 1B, 0B, 0B, $
							0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B]
specfile = 'linz/2014/hsi/hsi_spec_20141211_D7.fits'
srmfile = 'linz/2014/hsi/hsi_srm_20141211_D7.fits'
obj->filewrite, /buildsrm, all_simplify = 0, srmfile = srmfile, specfile = specfile
obj-> set, seg_index_mask= [0B, 0B, 0B, 0B, 0B, 0B, 0B, 1B, 0B, $
							0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B]
specfile = 'linz/2014/hsi/hsi_spec_20141211_D8.fits'
srmfile = 'linz/2014/hsi/hsi_srm_20141211_D8.fits'
obj->filewrite, /buildsrm, all_simplify = 0, srmfile = srmfile, specfile = specfile
obj-> set, seg_index_mask= [0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B, 1B, $
							0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B]
specfile = 'linz/2014/hsi/hsi_spec_20141211_D9.fits'
srmfile = 'linz/2014/hsi/hsi_srm_20141211_D9.fits'
obj->filewrite, /buildsrm, all_simplify = 0, srmfile = srmfile, specfile = specfile

; Definitely don't use D2,4,or 5.  The rest look ok from the quicklook.


obj = ospex()
obj-> set, spex_specfile= 'linz/2014/hsi/hsi_spec_20141211.fits'
obj-> set, spex_drmfile= 'linz/2014/hsi/hsi_srm_20141211.fits'
obj-> set, spex_bk_time_interval=[' 11-Dec-2014 18:40:40.000', ' 11-Dec-2014 18:44:00.000']
obj-> set, spex_fit_time_interval= [['11-Dec-2014 19:11:30.000', $
 '11-Dec-2014 19:12:00.000'], ['11-Dec-2014 19:12:00.000', '11-Dec-2014 19:12:30.000'], $
 ['11-Dec-2014 19:12:30.000', '11-Dec-2014 19:13:00.000'], ['11-Dec-2014 19:13:00.000', $
 '11-Dec-2014 19:13:30.000'], ['11-Dec-2014 19:13:30.000', '11-Dec-2014 19:14:00.000']]    ;, $
; ['11-Dec-2014 19:14:00.000', '11-Dec-2014 19:14:30.000'], ['11-Dec-2014 19:14:30.000', $
; '11-Dec-2014 19:15:00.000'], ['11-Dec-2014 19:15:00.000', '11-Dec-2014 19:15:30.000'], $
; ['11-Dec-2014 19:15:30.000', '11-Dec-2014 19:16:00.000'], ['11-Dec-2014 19:16:00.000', $
; '11-Dec-2014 19:16:30.000'], ['11-Dec-2014 19:16:30.000', '11-Dec-2014 19:17:00.000'], $
; ['11-Dec-2014 19:17:00.000', '11-Dec-2014 19:17:30.000'], ['11-Dec-2014 19:17:30.000', $
; '11-Dec-2014 19:18:00.000'], ['11-Dec-2014 19:18:00.000', '11-Dec-2014 19:18:30.000'], $
; ['11-Dec-2014 19:18:30.000', '11-Dec-2014 19:19:00.000'], ['11-Dec-2014 19:19:00.000', $
; '11-Dec-2014 19:19:30.000'], ['11-Dec-2014 19:19:30.000', '11-Dec-2014 19:20:00.000']]  
;;obj-> set, spex_fit_time_interval= [['11-Dec-2014 19:13:30','11-Dec-2014 19:14:00']]
obj-> set, spex_fit_time_interval= [['11-Dec-2014 19:12:40','11-Dec-2014 19:13:20']]
obj-> set, spex_erange = [4.,12.]
;obj-> set, spex_erange = -1

obj -> dofit, /all                                                                                     
obj -> savefit

;
; RHESSI images
;

t2 = '11-Dec-2014 ' + ['19:13:00','19:13:50']
t2 = '11-Dec-2014 ' + ['19:19:00','19:20:00']

obj = hsi_image()
obj-> set, det_index_mask= [0B, 0B, 1B, 0B, 1B, 1B, 1B, 1B, 0B]
obj-> set, im_energy_binning= [4., 12.]
obj-> set, im_time_interval= t2
obj-> set, image_dim= [256, 256]
obj-> set, pixel_size= [4., 4.]
;obj-> set, use_auto_time_bin= 1L
;obj-> set, use_flare_xyoffset= 1L
obj-> set, xyoffset = [-80,80]

obj-> set, smoothing_time= 4.0
obj-> set, use_phz_stacker= 1L

obj-> set, image_algorithm= 'Clean'
;obj-> set, natural_weighting= 1L
;obj-> set, uniform_weighting= 0L
;obj -> set,clean_show_maps=0L
obj-> set, clean_niter = 300
;obj-> set, clean_beam_width_factor = 1.5

;obj -> set, CLEAN_REGRESS_COMBINE=1L

;obj-> set, image_algorithm= 'MEM_NJIT'
;obj-> set, image_alg = 'EM'

data = obj-> getdata()
obj-> plotman
obj->fitswrite

cfits2maps, 'hsi_clean_191300.fits', hsi


;
; RHESSI SPEX from Säm
;

restore,'rhessi_spectral_fit_foxsi_flare_September2014.sav',/verbose
plot_oo,average(ebins,1),obs_all(*,0),xrange=[4,12],xstyle=1,yrange=[1e-3,1e4], psym=10
    for i=0,det_dim-1 do oplot,average(ebins,1),obs_all(*,i), psym=10
    ;for i=0,det_dim-1 do oplot,average(ebins,1),bkg_all(*,i), psym=10
    oplot,average(ebins,1),average(bkg_all,2),thick=3,color=1, psym=10
    oplot,average(ebins,1),average(ph_all,2),thick=3,color=6, psym=10
    
    
;
; Trying SPEX again with all 6 good RHESSI dets.
;

obj = hsi_spectrum()
obj-> set, obs_time_interval= '11-Dec-2014 ' + ['19:05:00','19:20:00']
obj-> set, decimation_correct= 1                                                             
obj-> set, rear_decimation_correct= 0                                                        
obj-> set, pileup_correct= 0                                                                 
obj-> set, seg_index_mask= [1B, 0B, 1B, 0B, 0B, 1B, 1B, 1B, 1B, $
							0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B, 0B]
obj-> set, sp_chan_binning= 0
obj-> set, sp_chan_max= 0
obj-> set, sp_chan_min= 0
obj-> set, sp_data_unit= 'Flux'
obj-> set, sp_energy_binning= [4,8,12]
obj-> set, sp_semi_calibrated= 0B
obj-> set, sp_time_interval= 10
obj-> set, sum_flag= 1
obj-> set, time_range= [0.0000000D, 0.0000000D]
obj-> set, use_flare_xyoffset= 1

data = obj->getdata()    ; retrieve the spectrum data
specfile = 'linz/2014/hsi/hsi_spec_20141211_6det.fits'
srmfile = 'linz/2014/hsi/hsi_srm_20141211_6det.fits'
obj->filewrite, /buildsrm, all_simplify = 0, srmfile = srmfile, specfile = specfile


obj = ospex()
obj-> set, spex_specfile= 'linz/2014/hsi/hsi_spec_20141211_6det.fits'
obj-> set, spex_drmfile= 'linz/2014/hsi/hsi_srm_20141211_6det.fits'
obj-> set, spex_bk_time_interval=[' 11-Dec-2014 19:05:00.000', ' 11-Dec-2014 19:10:00.000']
obj-> set, spex_eband= [4.0000000D, 12.000000D]                                                              

obj -> plot_time, /no_plotman, ylog=0, /bksub, spex_units='rate'

popen, xsi=8, ysi=6
!p.multi=[0,1,2]
ch=1.
obj -> plot_time, /no_plotman, ylog=0, /bksub, spex_units='rate', thick=4, charsi=ch, charth=2, xth=5, yth=5
restore, 'fxi-5det-total-lc.sav'
draw_target_change_times, thick=4, yr=[-50,150]
utplot, anytim(lc.time,/yo), lc.persec, /nodata, charsi=ch, charth=2, xth=5, yth=5, $
	title= 'FOXSI count rates, all Si detectors', ytit='counts s!U-1!N', timerange='2014-dec-11 '+['19:05','19:20']
outplot, anytim(lc.time,/yo), lc.persec, th=4, psym=10
eutplot, anytim(lc.time,/yo), lc.persec, yerr=lc_err, th=4, psym=10
draw_target_change_times, thick=4, yr=[0,200]
al_legend, ['Target start','Target end','Shutter motion'], col=[6,7,4], thick=6, line=0, $
	charsi=ch, charth=2, /left, box=0
al_legend, ['Detectors: 0 1 4 5 6, 4-12 keV'], charsi=ch, box=0, /left, /bot
pclose
