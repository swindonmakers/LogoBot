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

// Type Getters
function JumperWire_TypeName(t)     = t[0];
function JumperWire_PinType1(t)     = t[1];
function JumperWire_PinType2(t)     = t[2];
function JumperWire_NumPins(t)      = t[3];
function JumperWire_Colors(t)       = t[4];



module JumperWire_Pin(type, con) {
    w = 2.54;
    h = 14;
    attach(con, DefConDown)
        
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
    midVec = [0,1,0]
) {
    cons = [con1, con2];
    conVecs = [conVec1, conVec2];
    numPins = JumperWire_NumPins(type);

    if (DebugCoordinateFrames) frame();

    if (DebugConnectors) {
        connector(con1);
        connector(con2);
    }

    // pins
    for (i=[0,1])
        for (p=[0:numPins-1])
            JumperWire_Pin(type[1+i], offsetConnector(cons[i], conVecs[i] * p * 2.54));

    // cable
    ribbonCable(
        cables=numPins,
        cableRadius = 2.54/2,
        points= [
            con1[0] - con1[1] * 14,
            con1[0] - con1[1] * length * 0.5,
            con2[0] - con2[1] * length * 0.5,
            con2[0] - con2[1] * 14
        ],
        vectors = [
            conVec1,
            midVec,
            midVec,
            conVec2
        ],
        colors = JumperWire_Colors(type)
    );
} 