include <../config/config.scad>

DebugCoordinateFrames = false;
DebugConnectors = false;


// To view this example, turn on View -> Animate in OpenSCADm
// then set the FPS to around 5 and Steps to 110 at the bottom of the screen


$AnimateExplode = true;
$ShowStep = floor(map($t, [0,1], [1,11]));
$AnimateExplodeT = map($t, [0,1], [1,11]) - $ShowStep;

LogoBotAssembly();

