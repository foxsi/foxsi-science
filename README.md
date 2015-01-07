foxsi-science
=============

Analysis tools to reduce and analyze FOXSI data

Directory info:

Files:

	FOXSI Data Description	Description of all FOXSI data.
	README.md				This file

Directories:

	data_2012:	contains FOXSI flight data files and processed data.
			**This directory is ignored by git through .gitignore!**
			All files are available for download on the FOXSI FTP site.
	data_2014:	ditto, for FOXSI-2 data.  Also ignored by .gitignore
	calibration_data	data from the optics calibration
	detector_data		data from the detector calibration plus extra auxiliary data
  	img			Imaging routines
  	ishikawa	Routines and scripts written by Ishikawa
  	linz		Lindsay's analysis directory
  	old			Deprecated items
  	plots		Some of the plots that have been generated
  	proc		Routines to process data from raw form to the various levels.
  	resp		Response and effective area routines
  	sam			Routines and scripts written by Säm
  	spec		Spectral routines
  	util		utility IDL routines
  	
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

