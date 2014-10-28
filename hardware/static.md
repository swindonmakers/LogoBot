# Static Analysis Report

## Summary

**Fit to Publish:** Yes

Section    | OK  | Note | Warning | Error
---------- |:---:|:----:|:-------:|:-----:
[Assemblies](#assemblies) | 28  | 0    | 2       | 0    
[Vitamins  ](#vitamins  ) | 36  | 0    | 20      | 0    
**Total**  | **64**  | **0**  | **22**  | **0** 

## Assemblies

File     | OK | Note | Warning | Error
------  | :---:  | :---:  | :---:  | :---: 
[Wheel.scad](#wheelscad) | 6 | 0 | 0 | 0
[MarbleCaster.scad](#marblecasterscad) | 5 | 0 | 1 | 0
[Shell.scad](#shellscad) | 5 | 0 | 1 | 0
[Breadboard.scad](#breadboardscad) | 6 | 0 | 0 | 0
[LogoBot.scad](#logobotscad) | 6 | 0 | 0 | 0
**Total**  | **28**  | **0**  | **2**  | **0** 

### MarbleCaster.scad

* **Warnings**
  * 1 functions do not comply with naming convention (MarbleCastor_Con_Ball)

### Shell.scad

* **Warnings**
  * 2 supplementary modules do not comply with naming convention (BasicShell_STL, BasicShell_STL_View)

## Vitamins

File     | OK | Note | Warning | Error
------  | :---:  | :---:  | :---:  | :---: 
[ULN2003DriverBoard.scad](#uln2003driverboardscad) | 3 | 0 | 1 | 0
[Marble.scad](#marblescad) | 3 | 0 | 1 | 0
[MicroUSB.scad](#microusbscad) | 3 | 0 | 1 | 0
[LED.scad](#ledscad) | 3 | 0 | 1 | 0
[BatteryPack.scad](#batterypackscad) | 2 | 0 | 2 | 0
[motor.scad](#motorscad) | 1 | 0 | 3 | 0
[Bolt.scad](#boltscad) | 2 | 0 | 2 | 0
[MicroSwitch.scad](#microswitchscad) | 3 | 0 | 1 | 0
[Breadboard.scad](#breadboardscad) | 3 | 0 | 1 | 0
[MicroServo.scad](#microservoscad) | 3 | 0 | 1 | 0
[PlasticCaster.scad](#plasticcasterscad) | 3 | 0 | 1 | 0
[JumperWire.scad](#jumperwirescad) | 3 | 0 | 1 | 0
[ArduinoPro.scad](#arduinoproscad) | 3 | 0 | 1 | 0
[murata-piezos.scad](#murata-piezosscad) | 1 | 0 | 3 | 0
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

