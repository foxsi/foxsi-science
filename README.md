foxsi-science
=============

# Flight Info

## FOXSI-1

type | value
-----| -----
launch date | 2012-11-2
obs time (UT) | 17:56:48 - 18:03:18

## FOXSI-2

type | value
-----| -----
launch date | 2014-12-11
obs time (UT) | 19:12:51 - 19:19:25

# INSTALL

    You need to have IDL and SSW previously installed

    Include this five lines in your personal IDL_STARTUP file

    setenv,'FOXSIPKG=My/personal/path/to/foxsi-science'
    setenv,'FOXSIDB=My/other/personal/path/to/foxsidb'
    add_path,'$FOXSIPKG',/expand
    add_path,'$FOXSIDB'
    @init_param


    FOXSI-Data-Base Directory (FOXSIDB)
    
    Create a new folder called 'foxsidb' in a convenient location for you.
    Should include:
        
        Folder      Files

        data_2012   foxsi_level2_data.sav

        data_2014   foxsi_level2_data.sav


    You can download these two files from 

    2012: ftp://apollo.ssl.berkeley.edu/pub/foxsi/data_2012/

    2014: ftp://apollo.ssl.berkeley.edu/pub/foxsi/data_2014/


    To know whether your installation was a success, run @image-example-1
    and you should get an image of the first target.


Run SSWIDL and start up FOXSI by

    foxsi,year

year = 2014 or 2012

Example:
    
    foxsi,2014



Analysis tools to reduce and analyze FOXSI data

Directory info:

Files:

	README.md				This file
	foxsi.pro       Setup	


Directories:

	calibration_data	data from the optics and detector calibration
	fermi		Script used for FOXSI-1 Fermi analysis (didn't find anything)
	ghost-rays	Routines and data used to make ghost-image analysis
	help		Documentation directory (guides and examples)
  	img		Imaging routines
  	ishikawa	Routines and scripts written by Ishikawa
  	linz		Lindsay's analysis directory, with many sample scripts. Use at own risk!
  	nustar		Data and scripts for Nustar analysis
  	old		Deprecated items
  	parameters	Set global parameters
  	proc		Routines to process data from raw form to the various levels.
  	psf		Some PSF code and plots from Steven
  	resp		Response and effective area routines
  	sam		Shared routines and scripts written by Säm
  	schriste	Steven's shared routines and scripts
  	spec		Spectral routines
  	util		utility IDL routines
  	vla		SAV files with VLA images
  	
Detailed directory listing:

	/proc/:
		wsmr_data_to_level0.pro			Process WSMR ground station data file into FOXSI Level 0 data.
		foxsi_level0_to_level1.pro		Process FOXSI Level 0 into Level 1 data.
		foxsi_level1_to_level2.pro		Process FOXSI Level 1 into Level 2 data.
		wsmr_data_to_hskp_level0.pro	Process WSMR ground station data file into Housekeeping data.
		read_sparcs_raw.pro				Read SPARCS pointing data file.
		load_sparcs_data.pro			Load/process SPARCS pointing information.
		formatter_data_to_level0.pro	Process CAL data (formatter-style) into FOXSI Level 0 data.
		usb_data_to_level0.pro			Process CAL data (USB-style) into FOXSI Level 0 data.


For a complete information about FOXSI data and FOXSI analisys procedures read:

	/help/:
		FOXSI Data Description V4.0.docx
		FOXSI Analysis Guide.docx
