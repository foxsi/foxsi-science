; Script to generate images of the 64 channels for each of the 
; Silicon detector which flew
; run on IDL as @script00


Dir='../../../calibration_data/'

plot_spline64,Dir+'peaks_det101.sav',0,xrange=[0,300],yrange=[0,40]
plot_spline64,Dir+'peaks_det101.sav',1,xrange=[0,300],yrange=[0,40]
plot_spline64,Dir+'peaks_det101.sav',2,xrange=[0,300],yrange=[0,40]
plot_spline64,Dir+'peaks_det101.sav',3,xrange=[0,300],yrange=[0,40]

plot_spline64,Dir+'peaks_det102.sav',0,xrange=[0,300],yrange=[0,40]
plot_spline64,Dir+'peaks_det102.sav',1,xrange=[0,300],yrange=[0,40]
plot_spline64,Dir+'peaks_det102.sav',2,xrange=[0,300],yrange=[0,40]
plot_spline64,Dir+'peaks_det102.sav',3,xrange=[0,300],yrange=[0,40]

plot_spline64,Dir+'peaks_det104.sav',0,xrange=[0,300],yrange=[0,40]
plot_spline64,Dir+'peaks_det104.sav',1,xrange=[0,300],yrange=[0,40]
plot_spline64,Dir+'peaks_det104.sav',2,xrange=[0,300],yrange=[0,40]
plot_spline64,Dir+'peaks_det104.sav',3,xrange=[0,300],yrange=[0,40]

plot_spline64,Dir+'peaks_det105.sav',0,xrange=[0,300],yrange=[0,40]
plot_spline64,Dir+'peaks_det105.sav',1,xrange=[0,300],yrange=[0,40]
plot_spline64,Dir+'peaks_det105.sav',2,xrange=[0,300],yrange=[0,40]
plot_spline64,Dir+'peaks_det105.sav',3,xrange=[0,300],yrange=[0,40]

plot_spline64,Dir+'peaks_det108.sav',0,xrange=[0,300],yrange=[0,40]
plot_spline64,Dir+'peaks_det108.sav',1,xrange=[0,300],yrange=[0,40]
plot_spline64,Dir+'peaks_det108.sav',2,xrange=[0,300],yrange=[0,40]
plot_spline64,Dir+'peaks_det108.sav',3,xrange=[0,300],yrange=[0,40]
