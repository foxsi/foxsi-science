foxsi-science
=============

INSTALL:
    
    Include this five lines in your personal IDL_STARTUP file

    COMMON FOXSI,FOXSIPKG,FOXSIDB
    FOXSIPKG='path/to/your/foxsi-science'
    FOXSIDB='path/to/your/foxsi-data/directory/foxsidb'
    add_path,FOXSIPKG,/expand
    add_path,FOXSIDB
    restore,FOXSIDB+'/data_2014/flight2014-parameters.sav'


    FOXSI-Data-Base Directory (FOXSIDB)
    
    Should include at leats:
        
        Folder      Files

        data_2012   flight2012-parameters.sav
                    foxsi_level2_data.sav

        data_2014   flight2014-parameters.sav
                    foxsi_level2_data.sav


Run SSWIDL and start up FOXSI by

    foxsi,year

year = 2014 or 2012

Example:
    
    foxsi,2014



Analysis tools to reduce and analyze FOXSI data

Directory info:

Files:

	README.md				This file
	foxsi.pro               Setup	

Directories:

	calibration_data	data from the optics and detector calibration
	data_2012:	contains FOXSI flight data files and processed data.
			**This directory is ignored by git through .gitignore!**
			All files are available for download on the FOXSI FTP site.
	data_2014:	ditto, for FOXSI-2 data.  Also ignored by .gitignore
	fermi		Script used for FOXSI-1 Fermi analysis (didn't find anything)
	help		Documentation directory (guides and examples)
  	img			Imaging routines
  	ishikawa	Routines and scripts written by Ishikawa
  	linz		Lindsay's analysis directory, with many sample scripts. Use at own risk!
  	milo		Milo's directory
  	old			Deprecated items
  	plots		Partial compilation of plots
  	proc		Routines to process data from raw form to the various levels.
  	psf			Some PSF code and plots from Steven
  	resp		Response and effective area routines
  	sam			Shared routines and scripts written by Säm
  	schriste	Steven's shared routines and scripts
  	spec		Spectral routines
  	util		utility IDL routines
  	vla			SAV files with VLA images
  	
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
