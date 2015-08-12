/*

    PolarGraph variant

    Re-uses most of the LogoBot vitamins and printed parts to make a basic polar graph drawing machine

*/

// Master include statement, causes everything else for the model to be included
include <config/config.scad>

STLPath = "printedparts/stl/";
VitaminSTL = "vitamins/stl/";

DebugCoordinateFrames = 0;
DebugConnectors = false;

machine("LogoBotPolarGraph.scad","LogoBot Polar Graph") {

    markdown("introduction", "Re-uses most of the LogoBot vitamins and printed parts to make a basic polar graph drawing machine");

    view(size=[1024,768], t=[5, -1, 34], r=[78, 0, 215], d=850);

    LogoBotPolarGraphAssembly();

}
