;+
; PURPOSE:
;  computes the quartiles of a data set
;
; INPUTS:
;  data: An array
;
; OUTPUTS:
;  An array of min, 25th, 50th, 75th percentile, and max of the array
;-
function quartile, data, sample = sample

  if keyword_set(sample) && sample lt n_elements(data) then begin
     ind = randomu(seed, sample) * n_elements(data)
     d = data[ind]
     d = d[sort(d)]
     return, d[[0, .25 * sample, .5 * sample, .75 * sample, sample-1]]
  endif else begin
     s = sort(data)
     num = n_elements(data)
     return, data[s[[0, .25 * num, .5 * num, .75 * num, num - 1]]]
  endelse

end
