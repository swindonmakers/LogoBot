/*

    Collection of optional parts and design variants for LogoBot

*/

include <config/config.scad>

STLPath = "printedparts/stl/";
VitaminSTL = "vitamins/stl/";

DebugCoordinateFrames = 0;
DebugConnectors = false;

machine("OptionalExtras.scad","OptionalExtras") {

    view(size=[1024,768], t=[5, -1, 34], r=[78, 0, 215], d=749);

    // optional extras go here... try to make the layout pretty :)
    SimpleBase_STL();

}
