# firmware

This directory contains the Arduino and ESP8266 firmwares and supporting libraries.
The source files are well commented and should be fairly self-explanatory.


## Build Notes

To build the various firmwares, set your Arduino IDE Sketchbook path to point to this (firmware) directory (restart required).  The various sketches can then be loaded from the File -> Sketchbook menu.

To easily program the ESP8266 firmwares, you'll need need Arduino IDE v1.6.4 or newer.  Then add ESP support via Board Manager.  Testing has been done using ESP8266-01 modules, but other variants should work as well.


## Contents
--------------
* libraries - various reusable libraries for developing LogoBot firmwares, some 3rd party
* LogoBotBasic - Arduino firmware for the basic LogoBot - start here!
* LogoBotEsp8266 - ESP8266 firmware to complement the LogoBotWifiScribbler firmware
* LogoBotIRSeeker - Arduino firmware for the IR Seeker variant
* LogoBotLineFollower - Arduino firmware for the Line Follower variant
* LogoBotPolarGraph - Arduino firmware for the Polar Graph variant
* LogoBotWifiScribbler - Arduino firmware for the Scribbler variant
