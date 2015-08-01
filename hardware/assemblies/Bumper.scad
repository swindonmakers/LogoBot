/*
	Assembly: Bumper
	Bumper and Microswitch assembly

	Local Frame:


*/

module BumperAssembly()
{
	assembly("assemblies/Bumper.scad", "Bumpers", str("BumperAssembly()")) {

		if (DebugCoordinateFrames) frame();
		if (DebugConnectors) { }

		Bumper_STL();

		step(1,  "Place the Microswitches into the holders.  Make sure to get them the right way round so the bumper hits the metal lever.  Repeat for the second bumper.") {
            view(t=[-7.85, 24.1, 5.63], r=[43.8, 0, 319.9], d=400);

			attach(Bumper_Con_LeftMicroSwitch, DefConUp, ExplodeSpacing = -20)
				MicroSwitch();
			attachWithOffset(Bumper_Con_RightMicroSwitch, DefConDown, [0, 0, 5.8], ExplodeSpacing = -20)
				MicroSwitch();
        }
	}
}
