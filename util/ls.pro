pro ls
;+
; NAME
;   ls.pro   
; PURPOSE
;   To spawn the Unix ls comand to see contents of current 
;   working directory
;
; CALLING SEQUENCE
;  ls
;
; INPUT
;  none
;
; OPTIONAL OUTPUT
;  none
;
; OPTIONAL KEYWORD INPUT
;  none
;
; RESTRICTION
;  Unix only.
;
; HISTORY
;  Written CAF 2 MAY 96 : caf@mssl.ucl.ac.uk
;-
cd, curr=curr
  SPAWN_CMD = 'ls '+ curr +'/'
  SPAWN, SPAWN_CMD
end