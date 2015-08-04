// Connectors

PinTack_Con_Def = [[0,0,0], [0,0,-1], 0,0,0];


module PinTack_STL(h=10, r=PinDiameter/2, lh=3, lt=1, t=0.2, bh=3, br=6, side=false) {

    printedPart(
        "printedparts/PinTack.scad",
        str("Pin Tack H",h," BH",bh),
        str("PinTack_STL(side=",side,",h=",h,",bh=",bh,")")
    ) {

        view(t=[0,0,0],r=[72,0,130],d=400);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(PinTack_Con_Def);
        }

        color(Level3PlasticColor) {
            pintack(h=h,r=r,lh=lh,lt=lt,t=t,bh=bh,br=br,side=side);
        }
    }
}
