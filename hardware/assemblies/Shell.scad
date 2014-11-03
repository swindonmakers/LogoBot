/*
	Assembly: ShellAssembly
	Shell assembly - bit of a dummy assembly for the basic shell
	
	Local Frame: 
		Centred on the origin, same frame as the LogoBot base

*/


module ShellAssembly() {

    assembly("assemblies/Shell.scad", "Shell", str("ShellAssembly()")) {
    
        if (DebugCoordinateFrames) frame();
    
        // STL
        BasicShell_STL();
    
        
	}
}

