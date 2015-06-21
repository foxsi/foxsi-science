;
;	Scripts for imaging spectroscopy
; (combines elements from img and spec!)
;


;
; Imspex, Flare 2
;

trange=[t5_start, t5_end]
cen = cen5

m1 = foxsi_image_map( data_lvl2_d6, cen, erange=[4.,6.], trange=trange, thr_n=4., /xycorr, smooth=2 )
m2 = foxsi_image_map( data_lvl2_d6, cen, erange=[6.,8.], trange=trange, thr_n=4., /xycorr, smooth=2 )
m3 = foxsi_image_map( data_lvl2_d6, cen, erange=[8.,11.], trange=trange, thr_n=4., /xycorr, smooth=2 )

plot_map, m1, cen=[-65,90], fov=3
plot_map, m2, /over
plot_map, m3, /over

ratio = m1
ratio.data = m2.data / m1.data 
ratio.data[ where(m2.data lt 1.1) ] = 0.
ratio.data[ where(m1.data lt 1.1) ] = 0.
loadct,5
plot_map, ratio, /log, cen=[-65,90], fov=3, /cbar
plot_map, m1, /over

f094=file_search('~/data/aia/20141211/*_0094*')
f131=file_search('~/data/aia/20141211/*_0131*')
fits2map, f094[20:40], m094
fits2map, f131[20:40], m131
plot_map, m094[19], cen=[-90,80], fov=2, /log
plot_map, m1, /over

smap = make_submap( m094, cen=[-90,80], fov=3)
dmap = make_dmap(smap, ref_map=smap[0] )
plot_map, dmap, cen=[-90,80], fov=2, /log
plot_map, m1, /over



;
; Plotting code
;

m1.id = 'FOXSI Det6'
smap.id = 'AIA 94A'
dmap.id = 'AIA 94A'

popen, xsi=5, ysi=5
loadct, 5
plot_map, m1, charsi=1.4, charth=2, xth=5, yth=5, cen=[-90,80], fov=2.5, dmax=-0.1, /nodate
hsi_linecolors
plot_map, m1, /over, thick=8, col=6, lev=[10,50,90], /per
plot_map, m2, /over, thick=8, col=7, lev=[30,70,90], /per
plot_map, m3, /over, thick=8, col=12, lev=[50,90], /per
xyouts, -160,140, '4-6 keV', col=6, charsi=1.6
xyouts, -160,125, '6-8 keV', col=7, charsi=1.6
xyouts, -160,110, '8-11 keV', col=12, charsi=1.6

loadct, 1
reverse_ct
plot_map, smap[40], charsi=1.4, charth=2, xth=5, yth=5, cen=[-90,80], fov=2.5, col=255, /nodate

loadct, 5
plot_map, ratio, charsi=1.4, charth=2, xth=5, yth=5, cen=[-90,80], fov=2.5, /nodate

loadct, 1
reverse_ct
plot_map, dmap[29], charsi=1.4, charth=2, xth=5, yth=5, cen=[-90,80], fov=2.5, col=255, dmin=-1, dmax=50 , /nodate
hsi_linecolors
plot_map, ratio, /over, thick=8, lev=[10,30], /per, col=255

pclose


;
; IMSPEX, AR1, entire flight, all Si detectors
; This should be Target 1,2,5
;

trange=[t1_pos0_start, t1_pos0_end]
xy_flare1 = [ 75,-240]
xy_flare2 = [-90,80]

m1 = foxsi_image_map( data_lvl2_d6, cen1_pos0, erange=[4.,7.], trange=trange, thr_n=4., /xycorr, smooth=2 )
m2 = foxsi_image_map( data_lvl2_d6, cen1_pos0, erange=[7.,11.], trange=trange, thr_n=4., /xycorr, smooth=2 )

plot_map, m1, cen=xy_flare1, fov=3
plot_map, m2, /over

tstart = [102.,112.,122.,138.,148.,167.,177.,187.,197.]
tend   = [112.,122.,132.,148.,158.,177.,187.,197.,205.]

undefine, mlo0
undefine, mlo1
undefine, mlo4
undefine, mlo5
undefine, mlo6
undefine, mhi0
undefine, mhi1
undefine, mhi4
undefine, mhi5
undefine, mhi6
.run
for i=0, n_elements(tstart)-1 do begin
	if i lt 3 then cen = cen1_pos0 else if i lt 5 then cen = cen1_pos1 else cen = cen1_pos2
	trange = [tstart[i],tend[i]]
	print, trange, cen
	push, mlo0, foxsi_image_map( data_lvl2_d0, cen, erange=[4.,7.], trange=trange, thr_n=4., /xycorr, smooth=2 )
	push, mlo1, foxsi_image_map( data_lvl2_d1, cen, erange=[4.,7.], trange=trange, thr_n=4., /xycorr, smooth=2 )
	push, mlo4, foxsi_image_map( data_lvl2_d4, cen, erange=[4.,7.], trange=trange, thr_n=4., /xycorr, smooth=2 )
	push, mlo5, foxsi_image_map( data_lvl2_d5, cen, erange=[4.,7.], trange=trange, thr_n=4., /xycorr, smooth=2 )
	push, mlo6, foxsi_image_map( data_lvl2_d6, cen, erange=[4.,7.], trange=trange, thr_n=4., /xycorr, smooth=2 )
	push, mhi0, foxsi_image_map( data_lvl2_d0, cen, erange=[7.,11.], trange=trange, thr_n=4., /xycorr, smooth=2 )
	push, mhi1, foxsi_image_map( data_lvl2_d1, cen, erange=[7.,11.], trange=trange, thr_n=4., /xycorr, smooth=2 )
	push, mhi4, foxsi_image_map( data_lvl2_d4, cen, erange=[7.,11.], trange=trange, thr_n=4., /xycorr, smooth=2 )
	push, mhi5, foxsi_image_map( data_lvl2_d5, cen, erange=[7.,11.], trange=trange, thr_n=4., /xycorr, smooth=2 )
	push, mhi6, foxsi_image_map( data_lvl2_d6, cen, erange=[7.,11.], trange=trange, thr_n=4., /xycorr, smooth=2 )
endfor
end

!p.multi=[0,5,5]
.run
for i=0, 4 do begin
	plot_map, mlo0[i], cen=xy_flare1, fov=3
	plot_map, mhi0[i], /over
endfor
for i=0, 4 do begin
	plot_map, mlo1[i], cen=xy_flare1, fov=3
	plot_map, mhi1[i], /over
endfor
for i=0, 4 do begin
	plot_map, mlo4[i], cen=xy_flare1, fov=3
	plot_map, mhi4[i], /over
endfor
for i=0, 4 do begin
	plot_map, mlo5[i], cen=xy_flare1, fov=3
	plot_map, mhi5[i], /over
endfor
for i=0, 4 do begin
	plot_map, mlo6[i], cen=xy_flare1, fov=3
	plot_map, mhi6[i], /over
endfor
end
!p.multi=0

; This isn't really what I want yet.  Come back to this.  
; Detailed flare images for all time intervals, all detectors.

;
; Moving on to redoing the temperature plots for the first and second flares.
;

; First, just integrated flux for each detector for first flare, best target.

trange=[t1_pos2_start, t1_pos2_end]
cen = cen1_pos2
xy_flare1 = [ 30,-240]

m0 = foxsi_image_map( data_lvl2_d0, cen, erange=[4.,12.], trange=trange, thr_n=4., /xycorr);, smooth=3 )
m1 = foxsi_image_map( data_lvl2_d1, cen, erange=[4.,12.], trange=trange, thr_n=4., /xycorr);, smooth=3 )
m4 = foxsi_image_map( data_lvl2_d4, cen, erange=[4.,12.], trange=trange, thr_n=4., /xycorr);, smooth=3 )
m5 = foxsi_image_map( data_lvl2_d5, cen, erange=[4.,12.], trange=trange, thr_n=4., /xycorr);, smooth=3 )
m6 = foxsi_image_map( data_lvl2_d6, cen, erange=[4.,12.], trange=trange, thr_n=4., /xycorr);, smooth=3 )

m0_smooth = foxsi_image_map( data_lvl2_d0, cen, erange=[4.,12.], trange=trange, thr_n=4., /xycorr, smooth=2 )
m1_smooth = foxsi_image_map( data_lvl2_d1, cen, erange=[4.,12.], trange=trange, thr_n=4., /xycorr, smooth=2 )
m4_smooth = foxsi_image_map( data_lvl2_d4, cen, erange=[4.,12.], trange=trange, thr_n=4., /xycorr, smooth=2 )
m5_smooth = foxsi_image_map( data_lvl2_d5, cen, erange=[4.,12.], trange=trange, thr_n=4., /xycorr, smooth=2 )
m6_smooth = foxsi_image_map( data_lvl2_d6, cen, erange=[4.,12.], trange=trange, thr_n=4., /xycorr, smooth=2 )

loadct, 7
reverse_ct
!X.MARGIN=[0.35,0.35]
!Y.MARGIN=[0.35,0.35] 
!p.multi=[0,5,2]
;popen, 'plots/foxsi2/img/flare1_raw', xsi=7, ysi=7
factor=0.0001
plot_map, m0, cen=xy_flare1, fov=4, xth=5,yth=5,charsi=1.2,charth=2, dmin=factor*max(m0.data), col=255, tit=m0.id
plot_map, m1, cen=xy_flare1, fov=4, xth=5,yth=5,charsi=1.2,charth=2, dmin=factor*max(m1.data), col=255, /nodate, ytit='', /noytick, tit=m1.id
plot_map, m4, cen=xy_flare1, fov=4, xth=5,yth=5,charsi=1.2,charth=2, dmin=factor*max(m4.data), col=255, /nodate, ytit='', /noytick, tit=m4.id
plot_map, m5, cen=xy_flare1, fov=4, xth=5,yth=5,charsi=1.2,charth=2, dmin=factor*max(m5.data), col=255, /nodate, ytit='', /noytick, tit=m5.id
plot_map, m6, cen=xy_flare1, fov=4, xth=5,yth=5,charsi=1.2,charth=2, dmin=factor*max(m6.data), col=255, /nodate, ytit='', /noytick, tit=m6.id
plot_map, m0_smooth, cen=xy_flare1, fov=4, xth=5,yth=5,charsi=1.2,charth=2, dmin=factor*max(m0.data), col=255, /nodate, tit=m0.id
plot_map, m1_smooth, cen=xy_flare1, fov=4, xth=5,yth=5,charsi=1.2,charth=2, dmin=factor*max(m1.data), col=255, /nodate, ytit='', /noytick, tit=m1.id
plot_map, m4_smooth, cen=xy_flare1, fov=4, xth=5,yth=5,charsi=1.2,charth=2, dmin=factor*max(m4.data), col=255, /nodate, ytit='', /noytick, tit=m4.id
plot_map, m5_smooth, cen=xy_flare1, fov=4, xth=5,yth=5,charsi=1.2,charth=2, dmin=factor*max(m5.data), col=255, /nodate, ytit='', /noytick, tit=m5.id
plot_map, m6_smooth, cen=xy_flare1, fov=4, xth=5,yth=5,charsi=1.2,charth=2, dmin=factor*max(m6.data), col=255, /nodate, ytit='', /noytick, tit=m6.id
;pclose
!p.multi=0
!X.MARGIN=[10,3]
!Y.MARGIN=[4,2]

; Add them together and smooth this.

m = m6
m.data = m0.data + m1.data + m4.data + m5.data + m6.data
m.id = 'All Si added'
m_smooth = m
m_smooth.data = smooth( m.data, 2 )
!p.multi=[0,3,1]
plot_map, m6_smooth, cen=xy_flare1, fov=4, xth=5,yth=5,charsi=2,charth=2, dmin=factor*max(m6.data), col=255, /nodate, ytit='', /noytick, tit=m6.id
plot_map, m, cen=xy_flare1, fov=4, xth=5,yth=5,charsi=2,charth=2, dmin=factor*max(m6.data), col=255, /nodate, ytit='', /noytick, tit=m6.id
plot_map, m_smooth, cen=xy_flare1, fov=4, xth=5,yth=5,charsi=2,charth=2, dmin=factor*max(m6.data), col=255, /nodate, ytit='', /noytick, tit=m6.id

; Still a bit of blurring when doing this.  Might be better to just use D6 for now.

; Next, imaging spectroscopy

trange=[t1_pos2_start, t1_pos2_end]
cen = cen1_pos2
xy_flare1 = [ 30,-240]

en1 = [4.,5.5]
en2 = [6.,11.]
mlo0 = foxsi_image_map( data_lvl2_d0, cen, erange=en1, trange=trange, thr_n=4., /xycorr, smooth=3 )
mlo1 = foxsi_image_map( data_lvl2_d1, cen, erange=en1, trange=trange, thr_n=4., /xycorr, smooth=3 )
mlo4 = foxsi_image_map( data_lvl2_d4, cen, erange=en1, trange=trange, thr_n=4., /xycorr, smooth=3 )
mlo5 = foxsi_image_map( data_lvl2_d5, cen, erange=en1, trange=trange, thr_n=4., /xycorr, smooth=3 )
mlo6 = foxsi_image_map( data_lvl2_d6, cen, erange=en1, trange=trange, thr_n=4., /xycorr, smooth=3 )
mhi0 = foxsi_image_map( data_lvl2_d0, cen, erange=en2, trange=trange, thr_n=4., /xycorr, smooth=3 )
mhi1 = foxsi_image_map( data_lvl2_d1, cen, erange=en2, trange=trange, thr_n=4., /xycorr, smooth=3 )
mhi4 = foxsi_image_map( data_lvl2_d4, cen, erange=en2, trange=trange, thr_n=4., /xycorr, smooth=3 )
mhi5 = foxsi_image_map( data_lvl2_d5, cen, erange=en2, trange=trange, thr_n=4., /xycorr, smooth=3 )
mhi6 = foxsi_image_map( data_lvl2_d6, cen, erange=en2, trange=trange, thr_n=4., /xycorr, smooth=3 )

mlo = mlo6
mlo.data = mlo0.data + mlo1.data + mlo4.data + mlo5.data + mlo6.data
mlo.id = 'All Si added'
mhi = mhi6
mhi.data = mhi0.data + mhi1.data + mhi4.data + mhi5.data + mhi6.data
mhi.id = 'All Si added'

; Temperatures from flux ratios

ratio0 = mlo0
ratio1 = mlo1
ratio4 = mlo4
ratio5 = mlo5
ratio6 = mlo6
ratio = mlo
ratio0.data = mhi0.data / mlo0.data 
ratio1.data = mhi1.data / mlo1.data 
ratio4.data = mhi4.data / mlo4.data 
ratio5.data = mhi5.data / mlo5.data 
ratio6.data = mhi6.data / mlo6.data 
ratio.data = mhi.data / mlo.data 
ratio0.data[ where(mhi0.data lt 1.5) ] = 0.
ratio1.data[ where(mhi1.data lt 1.5) ] = 0.
ratio4.data[ where(mhi4.data lt 1.5) ] = 0.
ratio5.data[ where(mhi5.data lt 1.5) ] = 0.
ratio6.data[ where(mhi6.data lt 1.5) ] = 0.
ratio.data[ where(mhi.data lt 1.5) ] = 0.
ratio0.data[ where(mlo0.data lt 1.5) ] = 0.
ratio1.data[ where(mlo1.data lt 1.5) ] = 0.
ratio4.data[ where(mlo4.data lt 1.5) ] = 0.
ratio5.data[ where(mlo5.data lt 1.5) ] = 0.
ratio6.data[ where(mlo6.data lt 1.5) ] = 0.
ratio.data[ where(mlo.data lt 1.5) ] = 0.

; Plotting

loadct, 7
reverse_ct
!X.MARGIN=[0.35,0.35]
!Y.MARGIN=[0.35,0.35] 
!p.multi=[0,5,2]
popen, 'plots/foxsi2/img/flare1_imspex', xsi=7, ysi=7
factor=0.1
lev = [30,60,90]
plot_map, mlo0, cen=xy_flare1, fov=3, dmin=factor*max(mlo0.data), col=255, xth=5,yth=5,charsi=1.2,charth=2, bot=8, tit=m0.id
plot_map, mhi0, /over, lev=lev, /per, thick=3
plot_map, mlo1, cen=xy_flare1, fov=3, dmin=factor*max(mlo0.data), col=255, xth=5,yth=5,charsi=1.2,charth=2, bot=8, /noyticks, ytit='', tit=m1.id
plot_map, mhi1, /over, lev=lev, /per, thick=3
plot_map, mlo4, cen=xy_flare1, fov=3, dmin=factor*max(mlo0.data), col=255, xth=5,yth=5,charsi=1.2,charth=2, bot=8, /noyticks, ytit='', tit=m4.id
plot_map, mhi4, /over, lev=lev, /per, thick=3
plot_map, mlo5, cen=xy_flare1, fov=3, dmin=factor*max(mlo0.data), col=255, xth=5,yth=5,charsi=1.2,charth=2, bot=8, /noyticks, ytit='', tit=m5.id
plot_map, mhi5, /over, lev=lev, /per, thick=3
plot_map, mlo6, cen=xy_flare1, fov=3, dmin=factor*max(mlo0.data), col=255, xth=5,yth=5,charsi=1.2,charth=2, bot=8, /noyticks, ytit='', tit=m6.id
plot_map, mhi6, /over, lev=lev, /per, thick=3
plot_map, mlo, cen=xy_flare1, fov=3, dmin=factor*max(mlo0.data), col=255, xth=5,yth=5,charsi=1.2,charth=2, bot=8, tit=m.id
plot_map, mhi, /over, lev=lev, /per, thick=3
loadct,5
plot_map, ratio6, cen=xy_flare1, fov=3, dmin=factor*max(mlo0.data), col=0, xth=5,yth=5,charsi=1.2,charth=2, /noyticks, ytit='', tit='Ratio, Det6'
plot_map, mlo6, /over, lev=lev, /per, thick=3, col=255
plot_map, ratio, cen=xy_flare1, fov=3, dmin=factor*max(mlo0.data), col=0, xth=5,yth=5,charsi=1.2,charth=2, /noyticks, ytit='', tit='Ratio, Si summed'
plot_map, mlo, /over, lev=lev, /per, thick=3, col=255
pclose
!p.multi=0
!X.MARGIN=[10,3]
!Y.MARGIN=[4,2]


; Overplot on AIA, then we'll call it a day.

f094=file_search('~/data/aia/20141211/*_0094*')
f131=file_search('~/data/aia/20141211/*_0131*')
fits2map, f094[10:18], m094
fits2map, f131[10:18], m131
s094 = make_submap( m094, cen=xy_flare1, fov=10 )
s131 = make_submap( m131, cen=xy_flare1, fov=10 )
d094 = make_dmap( s094, ref=s094[0] )
d131 = make_dmap( s131, ref=s131[0] )

fits2map, f094[0:18], m094
fits2map, f131[0:18], m131
s094 = make_submap( m094, cen=xy_flare1, fov=10 )
s131 = make_submap( m131, cen=xy_flare1, fov=10 )

popen, 'plots/foxsi2/img/flare1-D6-on-AIA', xsi=8, ysi=8
!p.multi=[0,2,2]
aia_lct,r,g,b,wave=94, /load
plot_map, m094[15], cen=xy_flare1, fov=5, dmax=100, dmin=0., xth=5,yth=5,charsi=1.1,charth=2, /nodate
plot_map, m094[15], cen=xy_flare1, fov=5, dmax=100, dmin=0., xth=5,yth=5,charsi=1.1,charth=2, /nodate
plot_map, m6_smooth, /over, thick=3, lev=[10,30,50,70,90], /per, col=255
plot_map, m094[15], cen=cen1_pos2+[0.,100.], fov=16, dmax=80, dmin=0., xth=5,yth=5,charsi=1.1,charth=2, /nodate
plot_map, m094[15], cen=cen1_pos2+[0.,100.], fov=16, dmax=80, dmin=0., xth=5,yth=5,charsi=1.1,charth=2, /nodate
plot_map, m_smooth, /over, thick=3, lev=[5,10,30,50,70,90], /per, col=255
pclose
!p.multi=0


; quick check to see what we find from the other AR.
!p.multi=[0,2,2]
aia_lct,r,g,b,wave=94, /load
plot_map, m094[15], cen=xy_flare2, fov=3, dmax=100, dmin=0., xth=5,yth=5,charsi=1.1,charth=2, /nodate
plot_map, m094[15], cen=xy_flare2, fov=3, dmax=100, dmin=0., xth=5,yth=5,charsi=1.1,charth=2, /nodate
plot_map, m, /over, thick=3, lev=[3,5,8], /per, col=255
!p.multi=0
; Result:  it's a tiny flare, too!!  Maybe we don't have any quiescent AR measurements after all...


; Repeat some steps for the last target (other flare)

trange=[t5_start, t5_end]
cen = cen5
xy_flare2 = [-90,80]

m0 = foxsi_image_map( data_lvl2_d0, cen, erange=[4.,12.], trange=trange, thr_n=4., /xycorr)
m1 = foxsi_image_map( data_lvl2_d1, cen, erange=[4.,12.], trange=trange, thr_n=4., /xycorr)
m4 = foxsi_image_map( data_lvl2_d4, cen, erange=[4.,12.], trange=trange, thr_n=4., /xycorr)
m5 = foxsi_image_map( data_lvl2_d5, cen, erange=[4.,12.], trange=trange, thr_n=4., /xycorr)
m6 = foxsi_image_map( data_lvl2_d6, cen, erange=[4.,12.], trange=trange, thr_n=4., /xycorr)

m6_smooth = foxsi_image_map( data_lvl2_d6, cen, erange=[4.,12.], trange=trange, thr_n=4., /xycorr, smooth=2 )

m = m6_smooth
m.data = m0.data + m1.data + m4.data + m5.data + m6.data


loadct, 7
reverse_ct
!X.MARGIN=[0.35,0.35]
!Y.MARGIN=[0.35,0.35] 
!p.multi=[0,5,2]
;popen, 'plots/foxsi2/img/flare2_raw', xsi=7, ysi=7
factor=0.0001
plot_map, m6, cen=xy_flare2, fov=4, xth=5,yth=5,charsi=1.2,charth=2, dmin=factor*max(m6.data), col=255, /nodate, ytit='', /noytick, tit=m6.id
plot_map, m6_smooth, cen=xy_flare2, fov=4, xth=5,yth=5,charsi=1.2,charth=2, dmin=factor*max(m6.data), col=255, /nodate, ytit='', /noytick, tit=m6.id
;pclose
!p.multi=0
!X.MARGIN=[10,3]
!Y.MARGIN=[4,2] 


