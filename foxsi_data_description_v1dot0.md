# FOXSI Data Description, version 1.0

## Overview

Description of the FOXSI data files and level data. This file created with [Mou](http://mouapp.com) (The missing markdown editor for web developers).

### Recorded Data Files
Recorded flight data is in two formats:

1. File recorded on FOXSI GSE computer: a binary file identical in format to the calibration files with the formatter interface.  Each data frame is 256 words starting with the second sync word 0xF628. `Filename:  data_121102_114631.dat.`
2. File recorded by WSMR ground station: the official data record.  This binary file contains our data frames with 3 additional words inserted between the second sync word (F628) and the start of our housekeeping data.  The three extra words contain time and sync lock info from the ground station.  This file was recorded upstream of our GSE computer and thus has fewer opportunities for sync problems. `Filename:  36.255_TM2_Flight_2012-11-02.log`

**Note that some dropouts and sync problems are present in both files, on the order of 0.1% of the frames.** 

###IDL Structures
The data volume is sufficiently small that data can be stored as IDL structures in IDL save files, as opposed to fits files.

#### Level 0
The FOXSI level 0 data structure captures all the unprocessed, raw data, organized with each element representing one event (trigger) in one detector.  Thus not all data frames have events, and there can be more than one event (in multiple detectors) per frame.  For convenience, the “hit” ASIC, strip, and ADC values are specifically called out for the two sides– these are determined by identifying which ASIC or strip had the maximum value.  However all the detector data, including the “un-hit” strips and channel masks, are included in the structure.  Together with the housekeeping structure, the level 0 data carries all of the information from the file, and the file should no longer be needed.
**Note that the time from WSMR is in UT and has microsecond precision BUT time delays of transmission from 100-300km limit this to ~ms precision without some additional calculation.  Millisecond precision should be sufficient for FOXSI data analysis.**

Tags

* Frame number
* Time (in seconds-of-day, from WSMR)
* Frame time
* Detector number
* Trigger time
* Hit ASIC # [p-side, n-side]
* Hit strip # [p-side, n-side]
* Hit ADC value [p-side, n-side]
* 3-strip value (all ASICs), 4x3 array
* Common mode values (all ASICs) 4x1 array
* Channel masks (all ASICs) 4x1 array with each mask encoded in a 64-bit long

####Level 1
The intention of level 1 data is to include higher-level information but to exclude any processing steps that are expected to change later (i.e. detector response, payload pointing, etc).  ASIC and strip numbers are replaced with 2D position information in payload coordinates, using a system similar to the GSE.  Frame and trigger times are replaced with a livetime value.  Within each event, strip values are classified as (a) “hit” (highest value for that side of the detector), (b) “associated” (values came from the hit ASIC), and (c) “unrelated” (values from the other ASIC).**Coarse** payload coordinates means that the design-specified geometric rotation of each detector is taken into account.  A position in **fine** payload coordinates is subject to coregistration and so will be part of the next level.

Tags

* Frame number
* Time (in seconds-of-day)
* Detector number
* Livetime
* Hit ADC values [p-side, n-side]
* Hit 2D position in detector coordinates
* Hit 2D position in coarse payload coordinates
* Associated ADC values, 3x3x2 array (includes hit!) (last dim is p- or n-side)
* Associated positions, 3x3x2 (includes hit! Hit should always be in center of the block, but this tag is included just in case for some reason it’s not.)
* Associated common mode values [p-side, n-side]
* Unrelated ADC values, 3x3x2 array (includes hit!) (last dim is p- or n-side)
* Unrelated positions, 3x3x2
* Unrelated common mode values [p-side, n-side]

**I’m ditching the channel mask since we don’t expect to use it.  If you object, speak up!!**
####Level 2
This should include some of the important calibration steps, including (1) replacing ADC values with energies (diagonal matrix elements only), (2) coregistering the detectors to provide better payload coordinates, (3) incorporating SPARCS pointing information to translate coordinates into heliocentric.  Tags to be determined later…
###Housekeeping Data
Housekeeping data is stored separately from the event data because it arrives regularly either every frame (voltages) or every fourth frame (temperatures), instead of sporadically like the detector events do.  (If desired, some of this information could be incorporated into the regular data structure.  Again, speak up!)####Level 0:Tags:
1.	Frame #2.	Time (in seconds-of-day)3.	High voltage value (verbatim from the frame including status bits)4. All voltages (raw values)5. All temperatures (raw values)####Level 1:The level 1 housekeeping data structure is identical to the level 0 structure except that all values are converted into volts and degrees.