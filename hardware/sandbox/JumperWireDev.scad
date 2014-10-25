include <../config/config.scad>
include <../vitamins/JumperWire.scad>


DebugConnectors = true;
DebugCoordinateFrames = false;

$Explode=false;
//$ShowStep = 10;


JumperWire();

JumperWire(
    type = JumperWire_MM2,
    con1 = [[0,10,0], [0,0,-1], 0,0,0],
    con2 = [[0,50,0], [0,0,-1], 0,0,0],
    length = 100,
    conVec1 = [0,1,0],
    conVec2 = [0,1,0],
    midVec = [1,0,0]
);


JumperWire(
    type = JumperWire_MM2,
    con1 = [[-10,0,0], [0,0,-1], 0,0,0],
    con2 = [[-70,0,50], [-1,0,0], 0,0,0],
    length = 100,
    conVec1 = [0,1,0],
    conVec2 = [0,1,0],
    midVec = [0,1,0]
);

JumperWire(
    type = JumperWire_MM2,
    con1 = [[0,-20,0], [1,0,0], 0,0,0],
    con2 = [[-50,-20,30], [0,0,-1], 0,0,0],
    length = 100,
    conVec1 = [0,1,0],
    conVec2 = [0,1,0],
    midVec = [0,1,0],
    complex = true,
    midPoint = [-30,-20,40],
    midTanVec = [0.5,0,1],
    ExplodeSpacing = 50
);


JumperWire(
    type = JumperWire_MM2,
    con1 = [[-10,10,0], [1,-1,0], 45,0,0],
    con2 = [[10,10,0], [-1,-1,0], 45,0,0],
    length = 200,
    conVec1 = [1,1,0],
    conVec2 = [-1,1,0],
    midVec = [0,0,1]
);

translate([0,-20,0])
    JumperWire(type = JumperWire_FF3);

translate([0,-40,0])
    JumperWire(type = JumperWire_FF4);
    
    