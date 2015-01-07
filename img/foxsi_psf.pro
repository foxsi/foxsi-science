;+
; PURPOSE:
;      	Return the FOXSI-1 PSF based on a postflight measurement of the PSF.
;		Because this routine was written for analysis of the FOXSI-1 flare, the
;		routine returns the PSF for an OFF-AXIS POSITION OF 7 ARCMINUTES!
;
; INPUTS:
;		No required inputs.
;
; Keywords:
;		PIX				Pixel size (default 1 arcsec)
;		FOV				FOV of PSF map (default 4 arcmin)
;		PLATE_SCALE		Plate scale of CCD camera used for the measurement (defeault 1.3")
;		ROTATION		Rotation angle (default 0 degrees)
;		MEASURED_PSF	Use actual measured data instead of a triple-Gaussian fit to it.
;
; NOTES:
;
; HISTORY:
;		Linz  2014 aug 27		Wrote routine based on code from Steven and my deconv_foxsi.pro
;-

FUNCTION FOXSI_PSF, PIX=PIX, FOV=FOV, PLATE_SCALE=PLATE_SCALE, PSF_SMOOTH=PSF_SMOOTH, $
					ROTATION=ROTATION, MEASURED_PSF = MEASURED_PSF, STOP = STOP
					
	default, pix, 1.
	default, fov, 4.
	default, plate_scale, 1.3
	default, rotation, 0
	default, measured_psf, 0
	
	dim = fov*60./pix

	; Define a PSF map normalized to unity
	; Use either the X5 measured values for 7' off-axis or else the 3-component 
	; 2D Gaussian PSF that came from a fit to the measurement.
	
	 if keyword_set(measured_psf) then begin

		f=file_search('data_2012/45az*.fits')	; file containing measured PSF 7' offaxis
 		fits_read, f, data, ind
 
 		m0 = make_map( float(data[*,*,0]), dx=plate_scale, dy=plate_scale )
 		m1 = make_map( float(data[*,*,1]), dx=plate_scale, dy=plate_scale )
 		m2 = make_map( float(data[*,*,2]), dx=plate_scale, dy=plate_scale )
 		m3 = make_map( float(data[*,*,3]), dx=plate_scale, dy=plate_scale )
 		m4 = make_map( float(data[*,*,4]), dx=plate_scale, dy=plate_scale )
 		m5 = make_map( float(data[*,*,5]), dx=plate_scale, dy=plate_scale )
 		m6 = make_map( float(data[*,*,6]), dx=plate_scale, dy=plate_scale )
 		m7 = make_map( float(data[*,*,7]), dx=plate_scale, dy=plate_scale )
 		m8 = make_map( float(data[*,*,8]), dx=plate_scale, dy=plate_scale )
 		m9 = make_map( float(data[*,*,9]), dx=plate_scale, dy=plate_scale )
 		m=[m0,m1,m2,m3,m4,m5,m6,m7,m8,m9]
 		m_sum = m0
 		m_sum.data = total(m.data, 3)
 		med = median( m_sum.data )	; subtract a constant value.
 		m_sum.data = m_sum.data - med
 		for i=0, n_elements(m)-1 do begin
   			med = median(m[i].data)
   			m[i].data = m[i].data - med
 		endfor
 		; Switch PSF to center of a map.
 		cen = map_centroid( m_sum, thresh=1.e4 )
 		psf = shift_map( make_submap( m_sum, cen=cen, fov=fov ), -cen[0], -cen[1] )
 		psf = rot_map( psf, rotation )
 		psf = make_map( frebin( psf.data, dim, dim, /total ), dx=pix, dy=pix )
 		psf = rot_map( psf, -90 )
 		psf.roll_angle=0
  	
  	endif else begin
	
		; or, use a gaussian PSF
		params = [ 0.0, 0.0, 0.0, 0.9875, 0.218387, 0.0762158, 1.27836, 1.77492, 4.36214,$
		   7.21397, 47.5, 240.314, 0.0 ]	; parameters from Steven
		   	
		;psf1 = psf_gaussian( npix=[120,120], /double, st_dev=[1.27836, 1.77492]/pix )
		;psf2 = psf_gaussian( npix=[120,120], /double, $
		;					 st_dev=2.*[4.36214, 7.21397]/pix )*params[4]
		;psf3 = psf_gaussian( npix=[120,120], /double, $
		;					 st_dev=2.*[47.5, 240.314]/pix )*params[4]*params[5]
		psf1 = psf_gaussian( npix=[dim,dim], /double, st_dev=[1.27836, 1.77492]/pix )
		psf2 = psf_gaussian( npix=[dim,dim], /double, $
							 st_dev=2.*[4.36214, 7.21397]/pix )*params[4]
		psf3 = psf_gaussian( npix=[dim,dim], /double, $
							 st_dev=2.*[47.5, 240.314]/pix )*params[4]*params[5]
		psftest = make_map( psf1+psf2+psf3, dx=pix, dy=pix )
		psf = rot_map( psftest, -45 )
		psf = rot_map( psf, rotation )
 		psf.roll_angle=0.
 
 	endelse

 	psf.data = psf.data / total(psf.data)	; Renormalize
 	psf.id = 'FOXSI PSF 7 arcmin off'
 	
 	if keyword_set(stop) then stop

	return, psf
	
END 