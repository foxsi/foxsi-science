
;
; Use Markus's code to get temperature of flare
;

add_path,'~/Documents/rhessi/event2010nov3/aia/teem/'

f1=file_search('~/data/aia/20121102/*18_01_0*')
f2=file_search('~/data/aia/20121102/*18_01_1*')
aia_prep, f1[0], -1, ind, dat
index2map, ind, dat, m131
aia_prep, f2[0], -1, ind, dat
index2map, ind, dat, m171
aia_prep, f2[1], -1, ind, dat
index2map, ind, dat, m193
aia_prep, f2[2], -1, ind, dat
index2map, ind, dat, m211
aia_prep, f2[3], -1, ind, dat
index2map, ind, dat, m335
aia_prep, f2[4], -1, ind, dat
index2map, ind, dat, m94

; reference images
f1=file_search('~/data/aia/20121102/*17_55_0*')
f2=file_search('~/data/aia/20121102/*17_55_1*')
aia_prep, f1[0], -1, ind, dat
index2map, ind, dat, r131
aia_prep, f2[0], -1, ind, dat
index2map, ind, dat, r171
aia_prep, f2[1], -1, ind, dat
index2map, ind, dat, r193
aia_prep, f2[2], -1, ind, dat
index2map, ind, dat, r211
aia_prep, f2[3], -1, ind, dat
index2map, ind, dat, r335
aia_prep, f2[4], -1, ind, dat
index2map, ind, dat, r94

d131 = diff_map( m131, r131 )
d171 = diff_map( m171, r171 )
d193 = diff_map( m193, r193 )
d211 = diff_map( m211, r211 )
d94 = diff_map( m94, r94 )
d335 = diff_map( m335, r335 )

;aia_sub = make_submap( aia, center=center, fov=3 )

wave_ = ['94','131','193','211','335','171']  ; 94 must go first!
te_range = [0.5, 50]*1.e6
tsig = 0.1*(1+findgen(10))
q94 = 6.7

x_arcsec =  700 + [-480, 480]
y_arcsec = -600 + [-480, 480]
;x_arcsec =  0 + [-1000, 1000]
;y_arcsec =  0 + [-1000, 1000]
fov = [ x_arcsec[0], y_arcsec[0], x_arcsec[1], y_arcsec[1] ] / 967.

npix=4
vers=''
teem_table = 'teem_table.sav'

;aia_teem_table, wave_, tsig, te_range, q94, f1[0], teem_table

maps = [d94, d131, d193, d211, d335, d171]
;maps = [m94, m131, m193, m211, m335, m171]
aia_teem_map_from_map, f1[0], maps, fov, wave_, npix, teem_table, vers
restore,'teem_map.sav',/v
plot_map, temperature_map, /cbar
temperature_map.data=10.^temperature_map.data
plot_map, temperature_map, /cbar, cen=[950,-200], fov=5

popen, xsize=6, ysize=6
plot_map, temperature_map, /cbar, cen=[950,-200], fov=5, dmax=10.e6, tit='log(T[MK])' 
plot_map, temperature_map, /cbar, cen=[950,-200], fov=5, dmin=5.e6, dmax=10.e6, tit='log(T[MK])' 
pclose


