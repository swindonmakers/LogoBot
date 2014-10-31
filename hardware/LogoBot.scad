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
    
    LogoBotAssembly(PenLift=true);
    
}




