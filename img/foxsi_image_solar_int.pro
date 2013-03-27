;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FUNCTION FOXSI_IMAGE_SOLAR_INT, D0, D1, D2, D3, D4, D5, D6, ERANGE = ERANGE, $
								TRANGE = TRANGE, CENTER = CENTER, PSIZE = PSIZE, $
								SIZE = SIZE, INDEX = INDEX, RATE = RATE, XYCOR = XYCOR, $
								THR_N = THR_N, NOWIN = NOWIN
;
; written March 2013 by Ishikawa, modified by Lindsay
;        
; This routine computes a 2D intensity array for multiple detectors at a time.
; Requires foxsi_image_solar_int.pro
;
; Inputs:
;	D0-D6	FOXSI Level 2 data structures for all 7 detectors
;	ERANGE	Energy range to include in image (in keV)
;	TRANGE	Time range to include in image (in seconds *from launch*)
;	CENTER	Center of image (arcseconds)
;	PSIZE	Image pixel size (arcseconds)
;	SIZE	Image size in pixels
;	INDEX	7-element array specifying which detectors to include.
;	RATE	Divide intensity by time interval to return a rate.
;	XYCOR	Correct for detector and payload offsets.
;			These values are hardcoded in FOXSI_IMAGE_SOLAR.pro and were obtained by
;			comparing the flare centroid with RHESSI's.
;	THR_N	Threshold to use for n-side data.
;	NOWIN	If set, do not draw a window and plot the data.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if not keyword_set(erange) then erange=[4.,15.]   ; energy range in keV
if not keyword_set(trange) then trange=[108.3,498.3]   ; time range in seconds (from the launch)
if not keyword_set(center) then center=[0.0, 0.0]   ; image center position in arcseconds
if not keyword_set(psize) then psize=7.735   ; image pixel size (arcseconds/imagepixel)
if not keyword_set(size) then size=[300,300]   ; size in image pixel numbers
if not keyword_set(index) then index=[1,1,1,1,1,1,1]

img=fltarr(size[0],size[1])

if index[0] eq 1 then $
    img = img + foxsi_image_solar(d0, 0,erange=erange, trange=trange, center=center, $
    			psize=psize, size=size, xycor=xycor, thr_n=thr_n)  
if index[1] eq 1 then $
    img = img + foxsi_image_solar(d1,1,erange=erange, trange=trange, center=center, $
    			psize=psize, size=size, xycor=xycor, thr_n=thr_n)  
if index[2] eq 1 then $
    img = img+foxsi_image_solar(d2,2,erange=erange, trange=trange, center=center, $
    			psize=psize, size=size, xycor=xycor, thr_n=thr_n)  
if index[3] eq 1 then $
    img = img+foxsi_image_solar(d3,3,erange=erange, trange=trange, center=center, $
    			psize=psize, size=size, xycor=xycor, thr_n=thr_n)  
if index[4] eq 1 then $
    img = img+foxsi_image_solar(d4,4,erange=erange, trange=trange, center=center, $
    			psize=psize, size=size, xycor=xycor, thr_n=thr_n)  
if index[5] eq 1 then $
    img = img+foxsi_image_solar(d5,5,erange=erange, trange=trange, center=center, $
    			psize=psize, size=size, xycor=xycor, thr_n=thr_n)  
if index[6] eq 1 then $
    img = img+foxsi_image_solar(d6,6,erange=erange, trange=trange, center=center, $
    			psize=psize, size=size, xycor=xycor, thr_n=thr_n)  
  
if not keyword_set(nowin) then begin
	wdef,800,800
  	image_cont, alog(img+1)
  	print, 'max pixel count = ',max(img)
  	print, 'max pixel count rate = ', max(img)/(trange[1]-trange[0])
  	print, 'total count = ',total(img)
  	print, 'total count rate = ', total(img)/(trange[1]-trange[0])
endif

if keyword_set(rate) then return, img/(trange[1]-trange[0]) else return, img

END
