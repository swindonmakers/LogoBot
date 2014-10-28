# Static Analysis Report

## Summary

**Fit to Publish:** Yes

Section    | OK  | Note | Warning | Error
---------- |:---:|:----:|:-------:|:-----:
Assemblies | 18  | 0    | 2       | 0    
Vitamins   | 21  | 0    | 7       | 0    
**Total**  | **39**  | **0**  | **9**  | **0** 

## Assemblies

File     | OK | Note | Warning | Error
------  | :---:  | :---:  | :---:  | :---: 
Wheel.scad | 4 | 0 | 0 | 0
MarbleCaster.scad | 4 | 0 | 0 | 0
Shell.scad | 4 | 0 | 0 | 0
Breadboard.scad | 2 | 0 | 2 | 0
LogoBot.scad | 4 | 0 | 0 | 0
**Total**  | **18**  | **0**  | **2**  | **0** 

### Breadboard.scad

* **Warnings**
  * Contains include statements - these should be in the relevant global config file
  * Contains use statements

## Vitamins

File     | OK | Note | Warning | Error
------  | :---:  | :---:  | :---:  | :---: 
ULN2003DriverBoard.scad | 2 | 0 | 0 | 0
Marble.scad | 2 | 0 | 0 | 0
MicroUSB.scad | 1 | 0 | 1 | 0
LED.scad | 2 | 0 | 0 | 0
BatteryPack.scad | 1 | 0 | 1 | 0
motor.scad | 0 | 0 | 2 | 0
Bolt.scad | 1 | 0 | 1 | 0
MicroSwitch.scad | 2 | 0 | 0 | 0
Breadboard.scad | 2 | 0 | 0 | 0
MicroServo.scad | 2 | 0 | 0 | 0
PlasticCaster.scad | 2 | 0 | 0 | 0
JumperWire.scad | 2 | 0 | 0 | 0
ArduinoPro.scad | 2 | 0 | 0 | 0
murata-piezos.scad | 0 | 0 | 2 | 0
**Total**  | **21**  | **0**  | **7**  | **0** 

### MicroUSB.scad

* **Warnings**
  * Vitamin module name does not match filename

### BatteryPack.scad

* **Warnings**
  * Vitamin module name does not match filename

### motor.scad

* **Warnings**
  * Filename is not in UpperCamelCase
  * Vitamin module name does not match filename

### Bolt.scad

* **Warnings**
  * Vitamin module name does not match filename

### murata-piezos.scad

* **Warnings**
  * Filename is not in UpperCamelCase
  * Vitamin module name does not match filename

