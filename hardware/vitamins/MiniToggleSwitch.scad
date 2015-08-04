/*
    Vitamin: Mini Toggle Switch

    Local Frame:
        Switch is centred in XY
        Toggle is pointing up Z+
        Mounting face lies in XY plane at Z=0
*/


// Type Getters
function MiniToggleSwitch_TypeSuffix(t)    = t[0];
function MiniToggleSwitch_BodyWidth(t)     = t[1];
function MiniToggleSwitch_BodyDepth(t)     = t[2];
function MiniToggleSwitch_BodyHeight(t)    = t[3];
function MiniToggleSwitch_BarrelOD(t)      = t[4];
function MiniToggleSwitch_BarrelLength(t)  = t[5];
function MiniToggleSwitch_WasherOD(t)      = t[6];

// Type table
//                          TypeSuffix  BodyW BodyD BodyH BarrelOD BarrelL WasherOD
MiniToggleSwitch_SPST6A  = ["SPST6A",   12.5, 8,    10,   5,       9,      12       ];


// Type collection
MiniToggleSwitch_Types = [
    MiniToggleSwitch_SPST6A
];


// Vitamin catalogue
module MiniToggleSwitch_Catalogue() {
    for (t = MiniToggleSwitch_Types) MiniToggleSwitch(t);
}


// Connectors

MiniToggleSwitch_Con_Def				= [ [0,0,0], [0,0,1], 0, 0, 0];



module MiniToggleSwitch(type=MiniToggleSwitch_SPST6A, showWasher=true, washerOffset=3) {

    ts = MiniToggleSwitch_TypeSuffix(type);

    vitamin(
        "vitamins/MiniToggleSwitch.scad",
        str(ts," Mini Toggle Switch"),
        str("MiniToggleSwitch(MiniToggleSwitch_",ts,")")
    ) {
        view(t=[0,0,0], r=[55,0,25], d=140);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(MiniToggleSwitch_Con_Def);
        }

        // parts
        MiniToggleSwitch_Body(type, showWasher, washerOffset);
    }
}

module MiniToggleSwitch_Body(t, showWasher=true, washerOffset=3) {
    ts = MiniToggleSwitch_TypeSuffix(t);

    // local shortcuts
    bw = MiniToggleSwitch_BodyWidth(t);
    bd = MiniToggleSwitch_BodyDepth(t);
    bh = MiniToggleSwitch_BodyHeight(t);
    bod = MiniToggleSwitch_BarrelOD(t);
    bl = MiniToggleSwitch_BarrelLength(t);
    wod = MiniToggleSwitch_WasherOD(t);

    // light metal bits
    color([0.8, 0.8, 0.8]) {
        // toggle
        // Assume half the barrel OD, and same length
        translate([0,0,bl- bod/2])
            rotate([0,15,0])
            cylinder(r=bod/4, h=bl+ bod/2);


        // threaded barrel
        cylinder(r=bod/2, h=bl);

        // body
        translate([-bw/2, -bd/2, -0.5])
            cube([bw,bd,0.5]);
        translate([-(bw-2)/2, -(bd+0.5)/2, -bh/2])
            cube([(bw-2),(bd+0.5), bh/2]);

        // terminals
        // TODO: parameterise this to account for diff terminal layouts/sizes
        for (i=[-1,0])
            translate([i* 4, -bd/6, -bh-4])
            cube([0.5, bd/3, 4]);

        if (showWasher) {
            // washer
            translate([0,0,washerOffset])
                tube(wod/2, bod/2, 1, center=false);

            // nut
            translate([0,0,washerOffset + 1])
                cylinder(r=bod/2 + 2, h=1.5, $fn=6);
        }

    }

    // plastic bits
    color([0.2, 0.6, 1]) {
        // body
        translate([-bw/2, -bd/2, -bh])
            cube([bw,bd,bh-0.5]);
    }
}
