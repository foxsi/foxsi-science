;
; Example script for measuring FOXSI count rates in any target, time, or energy.
; Written Jan. 5 2016 to use as a starting point for quiet-Sun / axion analysis.
;

@foxsi-setup-script-2014

;
; Make a map to get an overall sense of what we're looking at.
; Example is 1st target after 2 pointing adjustments (target 1, position 2)
;

loadct, 7
reverse_ct
trange=[t1_pos2_start,t1_pos2_end]
m6 = foxsi_image_map( data_lvl2_d6, cen1_pos2, erange=[5.,10.], trange=trange, thr_n=4., /xycorr )
plot_map, m6, /limb, lcol=255, col=255, charsi=1.2, title=m6.id


;
; Select data for one detector in the desired energy band, time range, and location.
;

times = [t1_pos2_start,t1_pos2_end]
area_center = [-200.,-200.]
;area_center = [50.,-200.]			; use this one if you want a flare example for debugging.
area_radius = [100.]
energy_band = [5.,10.]

data = data_lvl2_d6

; area selection, including application of the XY offset (/xycorr)
data = area_cut( data, area_center, area_radius, /xycorr )

; time and energy selection
data = time_cut( data, times[0], times[1], energy=energy_band )


;
; Select only the cleanest events, and keep track of how many we're throwing away.
; The thrown-out events will go into an additional deadtime.
;

n_all = n_elements( data )
data  = data[ where( data.error_flag eq 0 ) ]
n_good = n_elements( data )
live = n_good / n_all
; Later, we should calculate a a more accurate livetime accounting for readout time.


;
; Some work to fill in:
; To do: Calculate # count per solar area per second per keV.
; To do: Calculate a statistical error on that value.
; To do: Divide by the instrument effective area to get the value in 
;                   photons / sec / keV / cm2 / cm2
;	To do: Repeat for several energies and locations.  Goal is to plot the rate vs radius 
;        for a few energy bands.
; Later, we'll look at setting limits based on these numbers using small-number statistics.

; Some code to help with the flux calculation:

area6 = get_foxsi_effarea( module_num=6, energy=energy_band )
area6_live = area6*live			; correct for livetime

