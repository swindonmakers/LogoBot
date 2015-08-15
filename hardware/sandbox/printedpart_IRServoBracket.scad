include <../config/config.scad>
UseSTL=false;
UseVitaminSTL=true;
DebugConnectors=false;
DebugCoordinateFrames=false;

LogoBotBase_STL();

translate([0, 0, 2]) {
	IRServoBracket_STL();
	attach(IRServoBracket_Con_Left, DefConDown)
		 PinTack_STL(h=6.5);
	attach(IRServoBracket_Con_Right, DefConDown)
		 PinTack_STL(h=6.5);
}
