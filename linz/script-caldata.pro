;
; Looking at some of the calibration data to make sure imaging is ok.
;

;; formatter interface
add_path, '~/FOXSI-calib/calsoft_linz/'
.compile formatter_packet_b_for_flight

dir = 'data_2012/'
f = 'data_121102_114631.dat'
file = dir + f
detector=6

; copied this from the procedure since it won't run on own w/o hanging.
    print, 'Reading file ', file
    raw_data = read_binary(file, data_type=12) ; data_dims=[256,nFrames], data_type=12)
    n = n_elements(raw_data)
    nFrames = n/256
    det_time = uintarr(nFrames)
    form_time = uintarr(nFrames)
    raw_data = raw_data[0:(n/256)*256-1]
    ;raw_data = transpose(reform(raw_data,[nFrames,256]))
    raw_data = reform(raw_data,[256,nFrames])
    
    hvgood = where( raw_data[13,*] eq 25604 )
    raw_data = raw_data[*,hvgood]

blank = where( 	raw_data[23+0*33,*] ne 0 or raw_data[23+1*33,*] ne 0 or $
				raw_data[23+2*33,*] ne 0 or raw_data[23+3*33,*] ne 0 or $
				raw_data[23+4*33,*] ne 0 or raw_data[23+5*33,*] ne 0 or $
				raw_data[23+6*33,*] ne 0 )
raw_data = raw_data[*,blank]
save, raw_data, file='linz/flight-raw-data-D6.sav'


detnum=6
data=formatter_packet_b(dir+f,detnum)
str = 'linz/struct_D'+strtrim(detnum,2)+'_'+f
save,data,file=str
;h=makehist(str,/sub)
;draw_4hist,h,xrange=[0,900],yr=[0,3]

rot0 = 82.5
rot1 = 75.
rot2 = -67.5
rot3 = -75.
rot4 = 97.5
rot5 = 90.
rot6 = -60.

badch=intarr(4,64)
badch[2,61]=1
badch[2,62]=1
badch[2,63]=1
badch[3, 0]=1
badch[3, 1]=1
badch[3, 2]=1

str0 = 'linz/struct_D0_'+f
str1 = 'linz/struct_D1_'+f
str2 = 'linz/struct_D2_'+f
str3 = 'linz/struct_D3_'+f
str4 = 'linz/struct_D4_'+f
str5 = 'linz/struct_D5_'+f
str6 = 'linz/struct_D6_'+f
image0=image_quick(str0, badch=badch)
image1=image_quick(str1, badch=badch)
image2=image_quick(str2, badch=badch)
image3=image_quick(str3, badch=badch)
image4=image_quick(str4, badch=badch)
image5=image_quick(str5, badch=badch)
image6=image_quick(str6, badch=badch)
;draw_image,-image
;loadct,5

map0 = rot_map( make_map(image0,dx=7.78,dy=7.78), rot0 )
map1 = rot_map( make_map(image1,dx=7.78,dy=7.78), rot1 )
map2 = rot_map( make_map(image2,dx=7.78,dy=7.78), rot2 )
map3 = rot_map( make_map(image3,dx=7.78,dy=7.78), rot3 )
map4 = rot_map( make_map(image4,dx=7.78,dy=7.78), rot4 )
map5 = rot_map( make_map(image5,dx=7.78,dy=7.78), rot5 )
map6 = rot_map( make_map(image6,dx=7.78,dy=7.78), rot6 )


;
; Trying again, starting from the Level 1 data
;

restore, 'data_2012/foxsi_level1_data.sav',/v

rot0 = 82.5
rot1 = 75.
rot2 = -67.5
rot3 = -75.
rot4 = 97.5
rot5 = 90.
rot6 = -60.

adcrange = [90.,900.]
thrn = 80.

image0 = foxsi_image_det( data_lvl1_d0, adcrange=adcrange, thr_n=thrn  )
image1 = foxsi_image_det( data_lvl1_d1, adcrange=adcrange, thr_n=thrn  )
image2 = foxsi_image_det( data_lvl1_d2, adcrange=adcrange, thr_n=thrn  )
image3 = foxsi_image_det( data_lvl1_d3, adcrange=adcrange, thr_n=thrn  )
image4 = foxsi_image_det( data_lvl1_d4, adcrange=adcrange, thr_n=thrn  )
image5 = foxsi_image_det( data_lvl1_d5, adcrange=adcrange, thr_n=thrn  )
image6 = foxsi_image_det( data_lvl1_d6, adcrange=adcrange, thr_n=thrn  )

ima = foxsi_image_det( data_lvl1_d4, adcrange=[90.,100.], thr_n=70.  )
imb = foxsi_image_det( data_lvl1_d4, adcrange=[100.,110.], thr_n=70.  )
imc = foxsi_image_det( data_lvl1_d4, adcrange=[110.,120.], thr_n=70.  )
imd = foxsi_image_det( data_lvl1_d4, adcrange=[120.,130.], thr_n=70.  )
mapa = rot_map( make_map(ima,dx=7.78,dy=7.78), rot4 )
mapb = rot_map( make_map(imb,dx=7.78,dy=7.78), rot4 )
mapc = rot_map( make_map(imc,dx=7.78,dy=7.78), rot4 )
mapd = rot_map( make_map(imd,dx=7.78,dy=7.78), rot4 )
!p.multi=[0,2,2]
plot_map, mapa, cen=[320,300], fov=3
plot_map, mapb, cen=[320,300], fov=3
plot_map, mapc, cen=[320,300], fov=3
plot_map, mapd, cen=[320,300], fov=3


map0 = rot_map( make_map(image0,dx=7.78,dy=7.78), rot0 )
map1 = rot_map( make_map(image1,dx=7.78,dy=7.78), rot1 )
map2 = rot_map( make_map(image2,dx=7.78,dy=7.78), rot2 )
map3 = rot_map( make_map(image3,dx=7.78,dy=7.78), rot3 )
map4 = rot_map( make_map(image4,dx=7.78,dy=7.78), rot4 )
map5 = rot_map( make_map(image5,dx=7.78,dy=7.78), rot5 )
map6 = rot_map( make_map(image6,dx=7.78,dy=7.78), rot6 )

plot_map, map6, cen=[320,300], fov=3

plot_map, raw6
window,0
plot_map, test6
window,1
plot_map, raw6 

;
; Compare images made using the two methods (using USB data)
;

f=file_search('data_2012/usb_lvl1*')
for i=0, 6 do restore, f[i]

tr = [-1.e10,1.e10]
adcrange = [90.,900.]
thrn = 70.

rot0 = 82.5
rot1 = 75.
rot2 = -67.5
rot3 = -75.
rot4 = 97.5
rot5 = 90.
rot6 = -60.

image0 = foxsi_image_det( usb_lvl1_d0, trange=tr, adcrange=adcrange, thr_n=thrn )
image1 = foxsi_image_det( usb_lvl1_d1, trange=tr, adcrange=adcrange, thr_n=thrn )
image2 = foxsi_image_det( usb_lvl1_d2, trange=tr, adcrange=adcrange, thr_n=thrn )
image3 = foxsi_image_det( usb_lvl1_d3, trange=tr, adcrange=adcrange, thr_n=thrn )
image4 = foxsi_image_det( usb_lvl1_d4, trange=tr, adcrange=adcrange, thr_n=thrn )
image5 = foxsi_image_det( usb_lvl1_d5, trange=tr, adcrange=adcrange, thr_n=thrn )
image6 = foxsi_image_det( usb_lvl1_d6, trange=tr, adcrange=adcrange, thr_n=thrn )

map0_corr = rot_map( make_map(image0,dx=7.78,dy=7.78), rot0 )
map1_corr = rot_map( make_map(image1,dx=7.78,dy=7.78), rot1 )
map2_corr = rot_map( make_map(image2,dx=7.78,dy=7.78), rot2 )
map3_corr = rot_map( make_map(image3,dx=7.78,dy=7.78), rot3 )
map4_corr = rot_map( make_map(image4,dx=7.78,dy=7.78), rot4 )
map5_corr = rot_map( make_map(image5,dx=7.78,dy=7.78), rot5 )
map6_corr = rot_map( make_map(image6,dx=7.78,dy=7.78), rot6 )

plot_map, map6_corr, /log, dmin=1., fov=20, title=D6

f=file_search('data_2012/usb_lvl2*')
for i=0, 6 do restore, f[i]

pix=10.
er=[4,70]
tr = [-1.e10,1.e10]

img0=foxsi_image_solar( usb_lvl2_d0, 0, ps=pix, er=er, tr=tr, thr_n=4.)
img1=foxsi_image_solar( usb_lvl2_d1, 1, ps=pix, er=er, tr=tr, thr_n=4.)
img2=foxsi_image_solar( usb_lvl2_d2, 2, ps=pix, er=er, tr=tr, thr_n=4.)
img3=foxsi_image_solar( usb_lvl2_d3, 3, ps=pix, er=er, tr=tr, thr_n=4.)
img4=foxsi_image_solar( usb_lvl2_d4, 4, ps=pix, er=er, tr=tr, thr_n=4.)
img5=foxsi_image_solar( usb_lvl2_d5, 5, ps=pix, er=er, tr=tr, thr_n=4.)
img6=foxsi_image_solar( usb_lvl2_d6, 6, ps=pix, er=er, tr=tr, thr_n=4.)

map0_10pix = make_map( img0, xcen=0., ycen=0., dx=pix, dy=pix, id='D0',time=anytim( anytim(t0)+tr[0], /yo))
map1_10pix = make_map( img1, xcen=0., ycen=0., dx=pix, dy=pix, id='D1',time=anytim( anytim(t0)+tr[0], /yo))
map2_10pix = make_map( img2, xcen=0., ycen=0., dx=pix, dy=pix, id='D2',time=anytim( anytim(t0)+tr[0], /yo))
map3_10pix = make_map( img3, xcen=0., ycen=0., dx=pix, dy=pix, id='D3',time=anytim( anytim(t0)+tr[0], /yo))
map4_10pix = make_map( img4, xcen=0., ycen=0., dx=pix, dy=pix, id='D4',time=anytim( anytim(t0)+tr[0], /yo))
map5_10pix = make_map( img5, xcen=0., ycen=0., dx=pix, dy=pix, id='D5',time=anytim( anytim(t0)+tr[0], /yo))
map6_10pix = make_map( img6, xcen=0., ycen=0., dx=pix, dy=pix, id='D6',time=anytim( anytim(t0)+tr[0], /yo))

!p.multi=[0,4,4]
popen, xsi=8, ysi=8
plot_map, map0_2pix, /log, fov=10, tit='D0 img method 1, pix=2';, dmin=1.
plot_map, map0_5pix, /log, fov=10, tit='D0 img method 1, pix=5', dmin=1.
plot_map, map0_10pix,/log, fov=10, tit='D0 img method 1, pix=10',dmin=1.
plot_map, map0_corr, /log, fov=10, tit='D0 img method 2', dmin=1.
plot_map, map1_2pix, /log, fov=10, tit='D1 img method 1, pix=2';, dmin=1.
plot_map, map1_5pix, /log, fov=10, tit='D1 img method 1, pix=5', dmin=1.
plot_map, map1_10pix,/log, fov=10, tit='D1 img method 1, pix=10',dmin=1.
plot_map, map1_corr, /log, fov=10, tit='D1 img method 2', dmin=1.
plot_map, map2_2pix, /log, fov=10, tit='D2 img method 1, pix=2';, dmin=1.
plot_map, map2_5pix, /log, fov=10, tit='D2 img method 1, pix=5', dmin=1.
plot_map, map2_10pix,/log, fov=10, tit='D2 img method 1, pix=10',dmin=1.
plot_map, map2_corr, /log, fov=10, tit='D2 img method 2', dmin=1.
plot_map, map3_2pix, /log, fov=10, tit='D3 img method 1, pix=2';, dmin=1.
plot_map, map3_5pix, /log, fov=10, tit='D3 img method 1, pix=5', dmin=1.
plot_map, map3_10pix,/log, fov=10, tit='D3 img method 1, pix=10',dmin=1.
plot_map, map3_corr, /log, fov=10, tit='D3 img method 2', dmin=1.
plot_map, map4_2pix, /log, fov=10, tit='D4 img method 1, pix=2';, dmin=1.
plot_map, map4_5pix, /log, fov=10, tit='D4 img method 1, pix=5', dmin=1.
plot_map, map4_10pix,/log, fov=10, tit='D4 img method 1, pix=10',dmin=1.
plot_map, map4_corr, /log, fov=10, tit='D4 img method 2', dmin=1.
plot_map, map5_2pix, /log, fov=10, tit='D5 img method 1, pix=2';, dmin=1.
plot_map, map5_5pix, /log, fov=10, tit='D5 img method 1, pix=5', dmin=1.
plot_map, map5_10pix,/log, fov=10, tit='D5 img method 1, pix=10',dmin=1.
plot_map, map5_corr, /log, fov=10, tit='D5 img method 2', dmin=1.
plot_map, map6_2pix, /log, fov=10, tit='D6 img method 1, pix=2';, dmin=1.
plot_map, map6_5pix, /log, fov=10, tit='D6 img method 1, pix=5', dmin=1.
plot_map, map6_10pix,/log, fov=10, tit='D6 img method 1, pix=10',dmin=1.
plot_map, map6_corr, /log, fov=10, tit='D6 img method 2', dmin=1.
pclose


