/*
    Vitamin: Terminal Block

    Local Frame:
*/

// Type Getters
function TerminalBlock_TypeSuffix(t)    = t[0];
function TerminalBlock_BodyWidth(t)     = t[1];
function TerminalBlock_BodyDepth(t)     = t[2];
function TerminalBlock_BodyHeight(t)    = t[3];
function TerminalBlock_Height(t)        = t[4];
function TerminalBlock_Pitch(t)         = t[5];

// Type table
//                    TypeSuffix  BodyW BodyD BodyH  H      Pitch
TerminalBlock_20A  = ["20A",      5,    16.2, 8,    15.2,  8       ];


// Type collection
TerminalBlock_Types = [
    TerminalBlock_20A
];


// Vitamin catalogue
module TerminalBlock_Catalogue() {
    for (t = TerminalBlock_Types) TerminalBlock(t);
}


// Connectors
TerminalBlock_Con_Def				= [ [0,0,0], [0,0,-1], 0, 0, 0];

// dynamic connector for poles
// side: true = y+ side,  false = y- side
function TerminalBlock_Con_Pole(t,n,side=false) = [
    [
        TerminalBlock_Pitch(t) * (n-1) + TerminalBlock_BodyWidth(t)/2,
        (side ? 1 : -1) * TerminalBlock_BodyDepth(t)/3,
        TerminalBlock_BodyHeight(t)/2
    ],
    [0,side?-1:1,0],
    0,0,0
];


module TerminalBlock(type=TerminalBlock_20A, poles=2) {

    ts = TerminalBlock_TypeSuffix(type);

    vitamin(
        "vitamins/TerminalBlock.scad",
        str(poles," Pole ",ts," Terminal Block"),
        str("TerminalBlock(type=TerminalBlock_",ts,",poles=",poles,")")
    ) {
        view(t=[6.9, 13.6, 10.3], r=[72,0,33], d=280);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(TerminalBlock_Con_Def);
        }

        // parts
        TerminalBlock_Body(type, poles);
    }
}

module TerminalBlock_Body(t, poles) {

    ts = TerminalBlock_TypeSuffix(t);
    bw = TerminalBlock_BodyWidth(t);
    bd = TerminalBlock_BodyDepth(t);
    bh = TerminalBlock_BodyHeight(t);
    h = TerminalBlock_Height(t);
    p = TerminalBlock_Pitch(t);

    if (DebugConnectors) {
        for (i=[1:poles]) {
            connector(TerminalBlock_Con_Pole(t,i,false));
            connector(TerminalBlock_Con_Pole(t,i,true));
        }
    }

    color([0.9,0.9,0.8]) {
        //render()
        union()
        for (i=[0:poles-1])
            translate([i*p, 0, 0]) {
                // body
                translate([0,-bd/2,0])
                    difference() {
                        cube([bw, bd, bh]);
                        translate([1, -1, 1])
                            cube([bw-2, bd+2, bh-2]);
                    }

                // barrels
                for (j=[0,1])
                    mirror([0,j,0])
                    translate([bw/2,bw/2+1,bh-eta])
                    tube(bw/2, bw/2*0.8, h=h-bh+eta, $fn=16, center=false);

                // bridge
                if (i < poles-1)
                    translate([bw-1,-bd/4,0])
                    cube([p-bw+2,bd/2,bh]);
            }

    }
}
