/*

    LogoBot Scribbler 
    
    This variant of LogoBot includes a servo penlift and a wifi UART module
    
	The master project file, open this in OpenSCAD to view the complete robot.

*/

// Master include statement, causes everything else for the model to be included
include <config/config.scad>

STLPath = "printedparts/stl/";
VitaminSTL = "vitamins/stl/";

DebugCoordinateFrames = 0;
DebugConnectors = false;

machine("LogoBotScribbler.scad","LogoBotScribbler") {
    
    view(size=[1024,768], t=[5, -1, 34], r=[78, 0, 215], d=749);
    
    markdown(section="introduction", markdown="
## Introduction
\n
\nThe LogoBot Scribbler build is broken down into sub-assemblies that can be worked on sequentially by one person, or in parallel if there is more than one person building.
\n
\nYou'll also need a laptop with the right software to control the finished robot
\n
\n### General Build Tips
\n
\n* X if left/right, Y is forwards/backwards, Z is up.down
\n
\n### Tools Required
\n
\n* None so far!

");
    FakeGroundShadow()
        LogoBotAssembly(PenLift=true);
    
}




