include <../config/config.scad>
UseSTL=false;
UseVitaminSTL=true;
DebugConnectors=false;
DebugCoordinateFrames=false;

*BasicShell_STL();

LogoBotBase_STL();
attach(Shell_Con_Lid, DefConDown) {
	render() LidIR_STL();

	attach(LidIR_Con_Servo, MicroServo_Con_Horn) {
		MicroServo();
		attach(MicroServo_Con_Horn, ServoHorn_Con_Default)
			ServoHorn();
	}
}


translate([0, (7.1+4.4)/2, 76])
rotate([90, 0, 0])
	Sharp2Y0A21();

translate([0, 0, 2]) {
	IRServoBracket_STL();
	attach(IRServoBracket_Con_Left, DefConDown)
		 render() PinTack_STL(h=6.5);
	attach(IRServoBracket_Con_Right, DefConDown)
		 render() PinTack_STL(h=6.5);
}

