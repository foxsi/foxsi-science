foxsi-science
=============

Analysis tools to reduce and analyze FOXSI data

# Flight Info

## FOXSI-1

## FOXSI-2

type | value
-----| -----
launch date | 2014-12-11
obs time (UT) | 19:12:51 - 19:19:25


### Coordinated Observations

observatory | time (UT) | targets
------------| -----| -------
IRIS | 16:10 - 21:46 | overview [observation summary](http://iris.lmsal.com/health-safety/timeline/iris_tim_archive/2014/12/11/iris_tim_20141211.V01) 
IRIS | 2014-12-11 16:19:06-16:53:49 | QS raster OBS 3803106096 (Very large dense raster)[link](http://www.lmsal.com/hek/hcr?cmd=view-event&event-id=ivo%3A%2F%2Fsot.lmsal.com%2FVOEvent%23VOEvent_IRIS_20141211_161906_3803106096_2014-12-11T16%3A19%3A062014-12-11T16%3A19%3A06.xml)
IRIS | 2014-12-11 17:59:04-18:16:08 | AR scans OBS 3803104095 (Very large coarse 64-step raster) [link](http://www.lmsal.com/hek/hcr?cmd=view-event&event-id=ivo%3A%2F%2Fsot.lmsal.com%2FVOEvent%23VOEvent_IRIS_20141211_175904_3803104095_2014-12-11T17%3A59%3A042014-12-11T17%3A59%3A04.xml)
IRIS | 2014-12-11 18:29:04-18:33:21 | AR scans OBS 3803105278 (Very large sparse 8-step raster) [link](http://www.lmsal.com/hek/hcr?cmd=view-event&event-id=ivo%3A%2F%2Fsot.lmsal.com%2FVOEvent%23VOEvent_IRIS_20141211_182904_3803105278_2014-12-11T18%3A29%3A042014-12-11T18%3A29%3A04.xml)
IRIS | 2014-12-11 19:12-19:39 | AR scans OBS 3803105278 (Very large sparse 8-step raster) [link](http://www.lmsal.com/hek/hcr?cmd=view-event&event-id=ivo%3A%2F%2Fsot.lmsal.com%2FVOEvent%23VOEvent_IRIS_20141211_191222_3803105278_2014-12-11T19%3A12%3A222014-12-11T19%3A12%3A22.xml) 
IRIS | 2014-12-11 19:50-20:10 | AR scans OBS 3803104095 (Very large coarse 64-step raster) [link](http://www.lmsal.com/hek/hcr?cmd=view-event&event-id=ivo%3A%2F%2Fsot.lmsal.com%2FVOEvent%23VOEvent_IRIS_20141211_195004_3803104095_2014-12-11T19%3A50%3A042014-12-11T19%3A50%3A04.xml)
IRIS | 2014-12-11 21:12-21:46 | QS raster OBS 3803106096 (Very large dense raster) [link](http://www.lmsal.com/hek/hcr?cmd=view-event&event-id=ivo%3A%2F%2Fsot.lmsal.com%2FVOEvent%23VOEvent_IRIS_20141211_211206_3803106096_2014-12-11T21%3A12%3A062014-12-11T21%3A12%3A06.xml)



## Directory info

File | Description
-----| -----------
FOXSI Data Description	| Description of all FOXSI data
README.md | This file

### Directories

name | descrition 
-----| ----------
data_2012 | contains FOXSI flight data files and processed data (This directory is ignored by git through .gitignore All files are available for download on the FOXSI FTP site.
data_2014 |	ditto, for FOXSI-2 data.  Also ignored by .gitignore
calibration_data | data from the optics calibration
detector_data |	data from the detector calibration plus extra auxiliary data
img | Imaging routines
ishikawa | Routines and scripts written by Ishikawa
linz |Lindsay's analysis directory
old | Deprecated items
plots | Some of the plots that have been generated
proc | Routines to process data from raw form to the various levels.
resp | Response and effective area routines
sam | Routines and scripts written by Säm
spec | Spectral routines
util | utility IDL routines
  	
### Detailed directory listing:

directory | filename | description
----------| ---------| -----------
/proc/ | wsmr_data_to_level0.pro | Process WSMR ground station data file into FOXSI Level 0 data
		| foxsi_level0_to_level1.pro | Process FOXSI Level 0 into Level 1 data.
		| foxsi_level1_to_level2.pro | Process FOXSI Level 1 into Level 2 data.
	| wsmr_data_to_hskp_level0.pro | Process WSMR ground station data file into Housekeeping data.
| read_sparcs_raw.pro | Read SPARCS pointing data file.
| load_sparcs_data.pro | Load/process SPARCS pointing information.
| formatter_data_to_level0.pro	Process | CAL data (formatter-style) into FOXSI Level 0 data.
| usb_data_to_level0.pro| Process CAL data (USB-style) into FOXSI Level 0 data.

