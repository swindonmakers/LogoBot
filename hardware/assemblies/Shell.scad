/*
	Assembly: ShellAssembly
	Shell assembly - bit of a dummy assembly for the basic shell

	Local Frame:
		Centred on the origin, same frame as the LogoBot base

*/


Shell_Con_Lid = [[0,0,ShellOpeningHeight], [0,0,-1], 0,0,0];


module ShellAssembly() {

    assembly("assemblies/Shell.scad", "Shell", str("ShellAssembly()")) {

        if (DebugCoordinateFrames) frame();

        // STL
        BasicShell_STL();

		step(1, "Clip the lid onto the top of the shell") {
			view();

			attach(Shell_Con_Lid, DefConDown)
				Lid_STL();
		}


	}
}
