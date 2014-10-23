//
// Assemblies
//

// Add list of include statements like this:
//include <../assemblies/myassembly.scad>

// Order the include statements such that the lowest sub-assemblies are first



include <../assemblies/Breadboard.scad>
include <../assemblies/MarbleCaster.scad>
include <../assemblies/Wheel.scad>

// this one goes last!
include <../assemblies/LogoBot.scad>