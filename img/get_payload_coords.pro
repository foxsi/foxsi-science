;+
;  This function takes a 2D position (or [2,N] array of positions) in detector pixel coordinates
;  and transforms it to payload coordinates.  For each detector, the origin is in its center.
; The returned coordinates account for the individual detector rotation as designed.
; Rotations or translations due to misalignments in the assembly are not included.
; 
; INPUTS:
;         COORDS:                A 2xN array containing [x,y] positions in detector pixel coordinates
;         DETECTOR:        Specifies the detector.  Each detector has a different rotation.
;
; RETURN VALUE:         A 2XN array containing [x,y] positions in payload coordinates (arcseconds).
;                        The reference frame is the same as that on the GSE.
;         
;--  

FUNCTION GET_PAYLOAD_COORDS, COORDS, DETECTOR, STOP=STOP

        case detector of
                0: rotation =  82.5
                1: rotation =  75.0
                2: rotation = -67.5
                3: rotation = -75.0
                4: rotation =  97.5
                5: rotation =  90.0
                6: rotation = -60.0
        else: begin
                print, 'Detector number out of range (0-6).'
                return, -1
              end
        endcase
        
        ; Transform pixel coordinates into arcseconds. Angular size of one strip is Tan-1(75um/2m)=7.735"
        ; Also recenter the coordinates so the origin is in the middle of the detector and the pixel numbers
        ; are tied to the middle of the strips.
        pix_arcsec = 7.735
        x = ( coords[0,*] - 63.5 )*pix_arcsec
        y = ( coords[1,*] - 63.5 )*pix_arcsec

        if keyword_set(stop) then stop

        ; Transform to payload coordinates by applying the relevant rotation.
        rotation = rotation*!pi/180        ; switch to radians
        x_arc = x*cos( rotation ) - y*sin( rotation )
        y_arc = x*sin( rotation ) + y*cos( rotation )
        
        ; Kluge to fix the vertical reflection problem found during post-flight alignment check
        y_arc = (-1)*y_arc

        return, reform([x_arc,y_arc],[2,n_elements(x_arc)])

END