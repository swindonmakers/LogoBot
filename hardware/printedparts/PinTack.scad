// Connectors

PinTack_Con_Def = [[0,0,0], [0,0,-1], 0,0,0];


module PinTack_STL(h=10) {

    printedPart(
        "printedparts/PinTack.scad",
        str("Pin Tack H",h),
        str("PinTack_STL(h=",h,")")
    ) {

        view(t=[0,0,0],r=[72,0,130],d=400);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(PinTack_Con_Def);
        }

        color(Level3PlasticColor) {
            // uses pins.scad library:
            pintack(h=h, bh=2, lh=2);
        }
    }
}
