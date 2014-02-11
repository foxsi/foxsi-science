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

image0 = foxsi_image_det( data_lvl1_d0 )
image1 = foxsi_image_det( data_lvl1_d1 )
image2 = foxsi_image_det( data_lvl1_d2 )
image3 = foxsi_image_det( data_lvl1_d3 )
image4 = foxsi_image_det( data_lvl1_d4 )
image5 = foxsi_image_det( data_lvl1_d5 )
image6 = foxsi_image_det( data_lvl1_d6 )

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
