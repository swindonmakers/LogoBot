/*
    Vitamin: Hook and Loop Tape

    Local Frame:
    Centred in XY, sits on Z=0
*/


// Connectors
HookAndLoopTape_Con_Def				= [ [0,0,0], [0,0,-1], 0, 0, 0];


module HookAndLoopTape(length=40,width=25) {

    vitamin(
        "vitamins/HookAndLoopTape.scad",
        str("Hook and Loop Tape ",length,"x",width,"mm"),
        str("HookAndLoopTape(length=",length,", width=",width,")")
    ) {
        view(d=200);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(HookAndLoopTape_Con_Def);
        }

        // bottom
        color("white")
            translate([-length/2, -width/2, 0])
            cube([length, width, 0.5]);

        // middle
        color(Grey20)
            translate([-(length-2)/2, -(width-2)/2, 0.5])
            cube([length-2, width-2, 2]);

        // top
        color("white")
            translate([-length/2, -width/2, 3-0.5])
            cube([length, width, 0.5]);
    }
}
