/*

    Collection of optional parts and design variants for LogoBot

*/

include <config/config.scad>

STLPath = "printedparts/stl/";
VitaminSTL = "vitamins/stl/";

DebugCoordinateFrames = 0;
DebugConnectors = false;

machine("OptionalExtras.scad","OptionalExtras") {

    view(size=[1024,768], t=[90, 50, 35], r=[59, 0, 17], d=500);

    // optional extras go here... try to make the layout pretty :)
    SimpleBase_STL();

    translate([100,0,0])
        LegoLid_STL();

    translate([0,130,0])
        VoronoiShell_STL(type=1);

    translate([150,130,0])
        VoronoiShell_STL(type=2);
}
