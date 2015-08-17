/*

    Collection of optional parts and design variants for LogoBot

*/

include <config/config.scad>

STLPath = "printedparts/stl/";
VitaminSTL = "vitamins/stl/";

DebugCoordinateFrames = 0;
DebugConnectors = false;

machine("OptionalExtras.scad","OptionalExtras") {

    view(size=[1024,768], t=[50, 14, -14], r=[52, 0, 17], d=400);

    // optional extras go here... try to make the layout pretty :)
    SimpleBase_STL();

    translate([100,0,0])
        LegoLid_STL();
}
