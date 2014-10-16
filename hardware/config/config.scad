//
// Config
//

// Coding-style
// ------------
// 
// Global variables are written in UpperCamelCase.
// A logical hierarchy should be indicated using underscores, for example:
//     StepperMotor_Connections_Axle
//
// Global short-hand references should be kept to a minimum to avoid name-collisions



// Global OpenSCAD variables - short-hand!
// 
eta = 0.01;                     // small fudge factor to stop CSG barfing on coincident faces.
$fa = 5;
$fs = 0.5;

// Printer specific parameters
//
Perim = 0.5;    // perim extrusion width for 0.2 or 0.3 layer height
Layers = 0.3;
2Perim = 2*Perim;
4Perim = 4*Perim;

// short-hand
perim = Perim;
layers = Layers;
2perim = 2Perim;
4perim = 4Perim;


include <colors.scad>
include <utils.scad>
include <vitamins.scad>
include <machine.scad>
include <assemblies.scad>