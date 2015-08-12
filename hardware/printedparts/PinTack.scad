// Connectors

PinTack_Con_Def = [[0,0,0], [0,0,-1], 0,0,0];


module PinTack_STL(h=10) {

    printedPart(
        "printedparts/PinTack.scad",
        str("Pin Tack H",h),
        str("PinTack_STL(h=",h,")")
    ) {
        markdown("guide","Orient to print on the flat side, no brim.  You may need to sand the flat sides depending on the tolerances of your printer.");

        view(t=[0,0,0],r=[145,135,0],d=130);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(PinTack_Con_Def);
        }

        color(Level3PlasticColor) {
            // uses pins.scad library:
            pintack(h=h, bh=2, lh=2, r=PinDiameter/2-0.1);
        }
    }
}
