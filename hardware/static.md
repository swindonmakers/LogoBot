# Static Analysis Report

## Summary

**Fit to Publish:** Yes

Section    | OK  | Note | Warning | Error
---------- |:---:|:----:|:-------:|:-----:
Assemblies | 26  | 0    | 4       | 0    
Vitamins   | 36  | 0    | 20      | 0    
**Total**  | **62**  | **0**  | **24**  | **0** 

## Assemblies

File     | OK | Note | Warning | Error
------  | :---:  | :---:  | :---:  | :---: 
Wheel.scad | 6 | 0 | 0 | 0
MarbleCaster.scad | 5 | 0 | 1 | 0
Shell.scad | 5 | 0 | 1 | 0
Breadboard.scad | 4 | 0 | 2 | 0
LogoBot.scad | 6 | 0 | 0 | 0
**Total**  | **26**  | **0**  | **4**  | **0** 

### MarbleCaster.scad

* **Warnings**
  * 1 functions do not comply with naming convention (MarbleCastor_Con_Ball)

### Shell.scad

* **Warnings**
  * 2 supplementary modules do not comply with naming convention (BasicShell_STL, BasicShell_STL_View)

### Breadboard.scad

* **Warnings**
  * Contains include statements - these should be in the relevant global config file
  * Contains use statements

## Vitamins

File     | OK | Note | Warning | Error
------  | :---:  | :---:  | :---:  | :---: 
ULN2003DriverBoard.scad | 3 | 0 | 1 | 0
Marble.scad | 3 | 0 | 1 | 0
MicroUSB.scad | 3 | 0 | 1 | 0
LED.scad | 3 | 0 | 1 | 0
BatteryPack.scad | 2 | 0 | 2 | 0
motor.scad | 1 | 0 | 3 | 0
Bolt.scad | 2 | 0 | 2 | 0
MicroSwitch.scad | 3 | 0 | 1 | 0
Breadboard.scad | 3 | 0 | 1 | 0
MicroServo.scad | 3 | 0 | 1 | 0
PlasticCaster.scad | 3 | 0 | 1 | 0
JumperWire.scad | 3 | 0 | 1 | 0
ArduinoPro.scad | 3 | 0 | 1 | 0
murata-piezos.scad | 1 | 0 | 3 | 0
**Total**  | **36**  | **0**  | **20**  | **0** 

### ULN2003DriverBoard.scad

* **Warnings**
  * 1 supplementary modules do not comply with naming convention (ULN2003DriverBoard)

### Marble.scad

* **Warnings**
  * 1 supplementary modules do not comply with naming convention (Marble)

### MicroUSB.scad

* **Warnings**
  * Vitamin module name does not match filename

### LED.scad

* **Warnings**
  * 1 supplementary modules do not comply with naming convention (LED)

### BatteryPack.scad

* **Warnings**
  * Vitamin module name does not match filename
  * 3 supplementary modules do not comply with naming convention (battery, battery_pack_linear, battery_pack_double)

### motor.scad

* **Warnings**
  * Filename is not in UpperCamelCase
  * Vitamin module name does not match filename
  * 1 supplementary modules do not comply with naming convention (logo_motor)

### Bolt.scad

* **Warnings**
  * Vitamin module name does not match filename
  * 3 supplementary modules do not comply with naming convention (HexHeadScrew, HexHeadBolt, Nut)

### MicroSwitch.scad

* **Warnings**
  * 2 supplementary modules do not comply with naming convention (MicroSwitch, terminal)

### Breadboard.scad

* **Warnings**
  * 1 supplementary modules do not comply with naming convention (Breadboard)

### MicroServo.scad

* **Warnings**
  * 1 supplementary modules do not comply with naming convention (MicroServo)

### PlasticCaster.scad

* **Warnings**
  * 1 supplementary modules do not comply with naming convention (PlasticCaster)

### JumperWire.scad

* **Warnings**
  * 1 supplementary modules do not comply with naming convention (JumperWire)

### ArduinoPro.scad

* **Warnings**
  * 1 supplementary modules do not comply with naming convention (ArduinoPro)

### murata-piezos.scad

* **Warnings**
  * Filename is not in UpperCamelCase
  * Vitamin module name does not match filename
  * 25 supplementary modules do not comply with naming convention (murata_7BB_12_9, murata_7BB_15_6, murata_7BB_20_3, murata_7BB_20_6, murata_7BB_20_6L0, murata_7BB_27_4, murata_7BB_27_4L0, murata_7BB_35_3, murata_7BB_35_3L0, murata_7BB_41_2, murata_7BB_41_2L0, murata_7NB_31R2_1, murata_7BB_20_6C, murata_7BB_20_6CL0, murata_7BB_27_4C, murata_7BB_27_4CL0, murata_7BB_35_3C, murata_7BB_35_3CL0, murata_7BB_41_2C, murata_7BB_41_2CL0, murata_7SB_34R7_3C, murata_7series, murata_PKM12EPYH4002_B0, murata_PKM17EPP_2002_B0, murata_PKM_cyl_type)

