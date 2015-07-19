/*
	Assembly: Pen Lift
	Pen slider, pen holder, pen and microswitch, plus pins to attach
*/

module PenLiftAssembly()
{
	assembly("assemblies/PenLift.scad", "PenLift", str("PenLiftAssembly()")) {

		if (DebugCoordinateFrames) frame();
		if (DebugConnectors) { }

		PenLiftSlider_STL();
		step(1,  "Place the pen holder into the pen slider plate.  Ensure they move freely, the two parts should fall apart easily.  Lightly file or sand the pen holder part if they dont.  Fit an elastic band in the lower grooves and over the top of the mechanism so that it pulls the pen holder down in the slider mechanism.") {
            view(t=[-7.85, 24.1, 5.63], r=[43.8, 0, 319.9], d=192);

			attach(PenLiftSlider_Con_Holder, PenLiftHolder_Con_Default)
				PenLiftHolder_STL();
		}

		step(2, "Use a small elastic band to securely fasten the pen to the holder.  Make sure that the pen is held vertically and that the nib of the pen will be touching the ground when the slider is almost, but not quite, fully down.") {
			view(t=[-7.85, 24.1, 5.63], r=[43.8, 0, 319.9], d=192);

			translate([10, 0, -15])
				Pen();
		}
	}
}
