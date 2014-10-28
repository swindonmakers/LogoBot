# Static Analysis Report

## Summary

**Fit to Publish:** Yes

Section    | OK  | Note | Warning | Error
---------- |:---:|:----:|:-------:|:-----:
[Assemblies](#assemblies) | 29  | 0    | 1       | 0    
[Vitamins  ](#vitamins  ) | 44  | 0    | 12      | 0    
**Total**  | **73**  | **0**  | **13**  | **0** 

## Assemblies

File     | OK | Note | Warning | Error
------  | :---:  | :---:  | :---:  | :---: 
[Wheel.scad](#wheelscad) | 6 | 0 | 0 | 0
[MarbleCaster.scad](#marblecasterscad) | 6 | 0 | 0 | 0
[Shell.scad](#shellscad) | 5 | 0 | 1 | 0
[Breadboard.scad](#breadboardscad) | 6 | 0 | 0 | 0
[LogoBot.scad](#logobotscad) | 6 | 0 | 0 | 0
**Total**  | **29**  | **0**  | **1**  | **0** 

### Shell.scad

* **Warnings**
  * 2 supplementary modules do not comply with naming convention (BasicShell_STL, BasicShell_STL_View)

## Vitamins

File     | OK | Note | Warning | Error
------  | :---:  | :---:  | :---:  | :---: 
[ULN2003DriverBoard.scad](#uln2003driverboardscad) | 4 | 0 | 0 | 0
[Marble.scad](#marblescad) | 4 | 0 | 0 | 0
[MicroUSB.scad](#microusbscad) | 3 | 0 | 1 | 0
[LED.scad](#ledscad) | 4 | 0 | 0 | 0
[BatteryPack.scad](#batterypackscad) | 2 | 0 | 2 | 0
[motor.scad](#motorscad) | 1 | 0 | 3 | 0
[Bolt.scad](#boltscad) | 2 | 0 | 2 | 0
[MicroSwitch.scad](#microswitchscad) | 3 | 0 | 1 | 0
[Breadboard.scad](#breadboardscad) | 4 | 0 | 0 | 0
[MicroServo.scad](#microservoscad) | 4 | 0 | 0 | 0
[PlasticCaster.scad](#plasticcasterscad) | 4 | 0 | 0 | 0
[JumperWire.scad](#jumperwirescad) | 4 | 0 | 0 | 0
[ArduinoPro.scad](#arduinoproscad) | 4 | 0 | 0 | 0
[murata-piezos.scad](#murata-piezosscad) | 1 | 0 | 3 | 0
**Total**  | **44**  | **0**  | **12**  | **0** 

### MicroUSB.scad

* **Warnings**
  * Vitamin module name does not match filename

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
  * 1 supplementary modules do not comply with naming convention (terminal)

### murata-piezos.scad

* **Warnings**
  * Filename is not in UpperCamelCase
  * Vitamin module name does not match filename
  * 25 supplementary modules do not comply with naming convention (murata_7BB_12_9, murata_7BB_15_6, murata_7BB_20_3, murata_7BB_20_6, murata_7BB_20_6L0, murata_7BB_27_4, murata_7BB_27_4L0, murata_7BB_35_3, murata_7BB_35_3L0, murata_7BB_41_2, murata_7BB_41_2L0, murata_7NB_31R2_1, murata_7BB_20_6C, murata_7BB_20_6CL0, murata_7BB_27_4C, murata_7BB_27_4CL0, murata_7BB_35_3C, murata_7BB_35_3CL0, murata_7BB_41_2C, murata_7BB_41_2CL0, murata_7SB_34R7_3C, murata_7series, murata_PKM12EPYH4002_B0, murata_PKM17EPP_2002_B0, murata_PKM_cyl_type)

