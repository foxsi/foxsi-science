PRO	DRAW_TARGET_CHANGE_TIMES, YRANGE=YRANGE, THICK=THICK
	COMMON PARAM
	; Only works for FOXSI-2 so far!

	default, yrange, [0.,100]
	default, thick, 2

	restore, '$FOXSIDB'+'/data_2014/flight2014-parameters.sav'

	hsi_linecolors
	outplot, anytim(t1_pos0_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=6, thick=thick
	outplot, anytim(t1_pos0_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=7, thick=thick
	outplot, anytim(t1_pos1_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=6, thick=thick
	outplot, anytim(t1_pos1_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=7, thick=thick
	outplot, anytim(t1_pos2_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=6, thick=thick
	outplot, anytim(t1_pos2_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=7, thick=thick
	outplot, anytim(t2_pos0_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=6, thick=thick
	outplot, anytim(t2_pos0_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=7, thick=thick
	outplot, anytim(t2_pos1_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=6, thick=thick
	outplot, anytim(t2_pos1_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=7, thick=thick
	outplot, anytim(t3_pos0_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=6, thick=thick
	outplot, anytim(t3_pos0_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=7, thick=thick
	outplot, anytim(t3_pos1_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=6, thick=thick
	outplot, anytim(t3_pos1_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=7, thick=thick
	outplot, anytim(t3_pos2_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=6, thick=thick
	outplot, anytim(t3_pos2_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=7, thick=thick
	outplot, anytim(t4_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=6, thick=thick
	outplot, anytim(t4_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=7, thick=thick
	outplot, anytim(t_shtr_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=4, thick=thick
	outplot, anytim(t_shtr_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=4, thick=thick
	outplot, anytim(t5_start*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=6, thick=thick
	outplot, anytim(t5_end*[1.,1.]+tlaunch+anytim('2014-dec-11'), /yo),yrange, col=7, thick=thick
	
END
