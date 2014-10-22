/*

	File: LogoBot.scad

	The master project file, open this in OpenSCAD to view the complete robot.

*/

// Master include statement, causes everything else for the model to be included
include <config/config.scad>

STLPath = "stl/";
VitaminSTL = "vitamins/stl/";

// Master assembly
//   Defined within: assemblies/LogoBot.scad
LogoBotAssembly();




