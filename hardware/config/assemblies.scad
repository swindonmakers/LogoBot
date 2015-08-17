//
// Assemblies
//

// Add list of include statements like this:
//include <../assemblies/myassembly.scad>

// Order the include statements such that the lowest sub-assemblies are first



include <../assemblies/Breadboard.scad>
include <../assemblies/Bumper.scad>
include <../assemblies/MarbleCaster.scad>
include <../assemblies/Wheel.scad>
include <../assemblies/PenLift.scad>
include <../assemblies/Shell.scad>
include <../assemblies/LineSensor.scad>
include <../assemblies/Capstan.scad>

// these go last!
include <../assemblies/LogoBot.scad>
include <../assemblies/LogoBotLineFollower.scad>
include <../assemblies/LogoBotPolarGraph.scad>
include <../assemblies/Gondola.scad>
include <../assemblies/LogoBotIRSeeker.scad>
include <../assemblies/LidIR.scad>
