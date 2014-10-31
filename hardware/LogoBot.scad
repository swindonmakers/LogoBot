/*

	File: LogoBot.scad

	The master project file, open this in OpenSCAD to view the complete robot.

*/

// Master include statement, causes everything else for the model to be included
include <config/config.scad>

STLPath = "printedparts/stl/";
VitaminSTL = "vitamins/stl/";

DebugCoordinateFrames = 0;
DebugConnectors = false;

machine("LogoBot.scad","LogoBot") {
    
    view(size=[1024,768], t=[5, -1, 34], r=[78, 0, 215], d=749);
    
    markdown(section="introduction", markdown="
## Introduction
\n
\nThe LogoBot build is broken down into sub-assemblies that can be worked on sequentially by one person, or in parallel if there is more than one person building.
\n
\nAll the diagrams can be viewed in OpenSCAD allowing real time zooming, rotating and panning to get the best view.
\n
\n### General Build Tips
\n
\n* X if left/right, Y is backwards/forwards, Z is up.down
\n
\n### Tools Required
\n
\n* Screwdriver ?

");
    
    LogoBotAssembly(PenLift=true);
    
}




