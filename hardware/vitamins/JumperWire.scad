/*
	Vitamin: JumperWire

	Model of 0.1inch pitch jumper wires.
	Supports a variety of pin types(male, female), colours and pin widths.
	Cabling is modelled as bezier curves.
	Supports attachments.
	
	Local Frame: 
		TBC
		
	Parameters:
	    type - type specifies pin types, no. of pins and colours
	    con1 - From connector; automatically attached; supports Explode
	    con2 - To connector; automatically attached; supports Explode
	    length - approx length, used to build bezier curve and append to type descriptor

*/

JumperWire_DefaultConnector1 = [[0,0,0], [-1,0,0], 0,0,0];
JumperWire_DefaultConnector2 = [[100,0,0], [1,0,0], 0,0,0];


//Pin Types

Pin_Male = "M";
Pin_Female = "F";

// JumperWire Types
// -----


//                    Type,  PinType1,   PinType2,   NumPins, Colors
JumperWire_MM2    = [ "MM2", Pin_Male,   Pin_Male,   2,       ["black","red"] ];
JumperWire_FF2    = [ "FF2", Pin_Female, Pin_Female, 2,       ["black","red"] ];
JumperWire_MF2    = [ "MF2", Pin_Male,   Pin_Female, 2,       ["black","red"] ];

JumperWire_FF3    = [ "FF3", Pin_Female, Pin_Female, 3,       ["black","red","white"] ];

JumperWire_FF4    = [ "FF4", Pin_Female, Pin_Female, 4,       ["red","orange","yellow","green"] ];
JumperWire_FM4    = [ "FM4", Pin_Female, Pin_Male,   4,       ["red","orange","yellow","green"] ];


// Type Getters
function JumperWire_TypeName(t)     = t[0];
function JumperWire_PinType1(t)     = t[1];
function JumperWire_PinType2(t)     = t[2];
function JumperWire_NumPins(t)      = t[3];
function JumperWire_Colors(t)       = t[4];



module JumperWire_Pin(type, con, ExplodeSpacing=20) {
    w = 2.54;
    h = 14;
    attach(con, DefConDown, ExplodeSpacing=ExplodeSpacing)
        
        if (type == Pin_Male) {
            color("gold")
                cylinder(r=1/2, h=h/2, $fn=6);
            color("black")
                translate([-w/2, -w/2, h/2])
                cube([w,w,h/2]);
        } else {
            color("black")
                translate([-w/2, -w/2, 0])
                cube([w,w,h]);
        }
}

module JumperWire(
    type = JumperWire_MM2,
    con1 = JumperWire_DefaultConnector1,
    con2 = JumperWire_DefaultConnector2,
    length = 100,
    conVec1 = [0,1,0],
    conVec2 = [0,1,0],
    midVec = [0,1,0],
    complex = false,
    midPoint = [0,0,0],
    midTanVec = [0,1,0],
    ExplodeSpacing = 20
) {
    Vitamin("JumperWire", JumperWire_TypeName(type));

    cons = [con1, con2];
    con1n = VNORM(con1[1]);
    con2n = VNORM(con2[1]);
    conVecs = [VNORM(conVec1), VNORM(conVec2)];
    numPins = JumperWire_NumPins(type);

    if (DebugCoordinateFrames) frame();

    if (DebugConnectors) {
        connector(con1);
        connector(con2);
    }

    // pins
    for (i=[0,1])
        for (p=[0:numPins-1])
            JumperWire_Pin(type[1+i], offsetConnector(cons[i], conVecs[i] * p * 2.54), ExplodeSpacing=ExplodeSpacing);

    mtv = VNORM(midTanVec);

    // cable
    if (complex) {
        ribbonCable(
            cables=numPins,
            cableRadius = 0.6,
            cableSpacing = 2.54,
            points= [
                con1[0] - con1n * (14 + ($Explode ? ExplodeSpacing : 0)),
                con1[0] - con1n * (length * 0.3 + ($Explode ? ExplodeSpacing : 0)),
                midPoint - mtv * length * 0.3,
                midPoint
            ],
            vectors = [
                conVecs[0],
                conVecs[0],
                midVec,
                midVec
            ],
            colors = JumperWire_Colors(type)
        );
        ribbonCable(
            cables=numPins,
            cableRadius = 0.6,
            cableSpacing = 2.54,
            points= [
                midPoint,
                midPoint + mtv * length * 0.3,
                con2[0] - con2n * (length * 0.3 + ($Explode ? ExplodeSpacing : 0)),
                con2[0] - con2n * (14 + ($Explode ? ExplodeSpacing : 0))
            ],
            vectors = [
                midVec,
                midVec,
                conVecs[1],
                conVecs[1]
            ],
            colors = JumperWire_Colors(type)
        );

    
    } else {
        ribbonCable(
            cables=numPins,
            cableRadius = 0.6,
            cableSpacing = 2.54,
            points= [
                con1[0] - con1n * (14 + ($Explode ? ExplodeSpacing : 0)),
                con1[0] - con1n * (length * 0.6 + ($Explode ? ExplodeSpacing : 0)),
                con2[0] - con2n * (length * 0.6 + ($Explode ? ExplodeSpacing : 0)),
                con2[0] - con2n * (14 + ($Explode ? ExplodeSpacing : 0))
            ],
            vectors = [
                conVecs[0],
                midVec,
                midVec,
                conVecs[1]
            ],
            colors = JumperWire_Colors(type)
        );
    }
} 

module JumperWire_View(type) {
    echo("400 300 51 5 2 41 0 29 438");    
}