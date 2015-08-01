/*
	Assembly: ShellAssembly
	Shell assembly - bit of a dummy assembly for the basic shell

	Local Frame:
		Centred on the origin, same frame as the LogoBot base

*/


Shell_Con_Lid = [[0,0,ShellOpeningHeight], [0,0,-1], 0,0,0];


module ShellAssembly(lid=true) {

    assembly("assemblies/Shell.scad", "Shell", str("ShellAssembly()")) {

        if (DebugCoordinateFrames) frame();

        // STL
        BasicShell_STL();

		if (lid)
		step(1, "Clip the lid onto the top of the shell") {
			view(t=[-29,70,0],r=[68,0,27],d=500);

			attach(Shell_Con_Lid, DefConDown)
				Lid_STL();
		}


	}
}
