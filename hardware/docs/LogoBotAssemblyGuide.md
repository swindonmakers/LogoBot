# LogoBot Assembly Guide

![view](../images/LogoBot_view.png)

## Introduction

The LogoBot build is broken down into sub-assemblies that can be worked on sequentially by one person, or in parallel if there is more than one person building.

All the diagrams can be viewed in OpenSCAD allowing real time zooming, rotating and panning to get the best view.

### General Build Tips

* X if left/right, Y is backwards/forwards, Z is up.down

### Tools Required

* Screwdriver ?

## Bill of Materials

Make sure you have all of the following parts before you begin.

### Vitamins

Qty | Vitamin | Image
--- | --- | ---
1 | [Breadboard 170]() | ![](../vitamins/images/Breadboard170_view.png) | 
2 | [JumperWire Female to Male 4pin 100mm]() | ![](../vitamins/images/JumperWireFemaletoMale4pin100mm_view.png) | 
1 | [16mm Marble]() | ![](../vitamins/images/16mmMarble_view.png) | 

### Printed Parts

Qty | Part Name | Image
--- | --- | ---
1 | [Base](../printedparts/stl/Base.stl) | ![](../printedparts/images/Base_view.png) | 
2 | [Wheel](../printedparts/stl/Wheel.stl) | ![](../printedparts/images/Wheel_view.png) | 
1 | [Caster Housing](../printedparts/stl/CasterHousing.stl) | ![](../printedparts/images/CasterHousing_view.png) | 
1 | [Basic Shell](../printedparts/stl/BasicShell.stl) | ![](../printedparts/images/BasicShell_view.png) | 


## Brain

### Vitamins

Qty | Vitamin | Image
--- | --- | ---
1 | [Breadboard 170]() | ![](../vitamins/images/Breadboard170_view.png) | 

### Assembly Steps

1. Push the Arduino onto the breadboard - make sure you position it correctly,                  as it's a tight fit with the Robot base!
![](../assemblies/images/Brain_step1_view.png)


## Drive Wheel (x2)

### Printed Parts

Qty | Part Name | Image
--- | --- | ---
2 | [Wheel](../printedparts/stl/Wheel.stl) | ![](../printedparts/images/Wheel_view.png) | 

### Assembly Steps

1. Push the wheel onto the motor shaft 
**Optional:** add a rubber band to wheel for extra grip.
![](../assemblies/images/DriveWheel_step1_view.png)


## Rear Caster

### Vitamins

Qty | Vitamin | Image
--- | --- | ---
1 | [16mm Marble]() | ![](../vitamins/images/16mmMarble_view.png) | 

### Printed Parts

Qty | Part Name | Image
--- | --- | ---
1 | [Caster Housing](../printedparts/stl/CasterHousing.stl) | ![](../printedparts/images/CasterHousing_view.png) | 

### Assembly Steps

1. Insert the marble into the printed housing
![](../assemblies/images/RearCaster_step1_view.png)


## Final Assembly

### Vitamins

Qty | Vitamin | Image
--- | --- | ---
2 | [JumperWire Female to Male 4pin 100mm]() | ![](../vitamins/images/JumperWireFemaletoMale4pin100mm_view.png) | 

### Printed Parts

Qty | Part Name | Image
--- | --- | ---
1 | [Base](../printedparts/stl/Base.stl) | ![](../printedparts/images/Base_view.png) | 
1 | [Basic Shell](../printedparts/stl/BasicShell.stl) | ![](../printedparts/images/BasicShell_view.png) | 

### Sub-Assemblies

Qty | Name 
--- | --- 
1 | Brain
2 | Drive Wheel
1 | Rear Caster

### Assembly Steps

1. Connect the breadboard assembly to the underside of the base
![](../assemblies/images/FinalAssembly_step1_view.png)
2. Connect the two bumper assemblies
![](../assemblies/images/FinalAssembly_step2_view.png)
3. Push the two motor drivers onto the mounting posts
![](../assemblies/images/FinalAssembly_step3_view.png)
4. Clip the two wheels assemblies onto the base and                     connect the motor leads to the the motor drivers
![](../assemblies/images/FinalAssembly_step4_view.png)
5. Connect the jumper wires between the motor drivers and the Arduino
![](../assemblies/images/FinalAssembly_step5_view.png)
![](../assemblies/images/FinalAssembly_step5_plan.png)
6. Clip in the battery pack
![](../assemblies/images/FinalAssembly_step6_view.png)
7. Clip the LED into place
![](../assemblies/images/FinalAssembly_step7_view.png)
8. Clip the piezo sounder into place
![](../assemblies/images/FinalAssembly_step8_view.png)
9. Push the caster assembly into the base so that it snaps into place
![](../assemblies/images/FinalAssembly_step9_view.png)
10. Push the shell down onto the base and twist to lock into place
![](../assemblies/images/FinalAssembly_step10_view.png)


