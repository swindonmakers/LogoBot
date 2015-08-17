
module LidIRAssembly () {

    assembly("assemblies/LidIR.scad", "Lid IR", str("LidIRAssembly()")) {

        // base part
    	LidIR_STL();

        // steps
        step(1, "Push fit the micro servo horn into the base of the lid") {
            view(t=[0,0,0], r=[52,0,218], d=250);

            attach(LidIR_Con_Servo, MicroServo_Con_Horn) {
        		MicroServo();
        		attach(MicroServo_Con_Horn, ServoHorn_Con_Default)
        			ServoHorn();
        	}
        }

        step(2, "Fit the distance sensor into the top of the shell, threading the cable down through the lid") {
            view(t=[0,0,0], r=[52,0,218], d=250);

            attach([[0, (7.1+4.4)/2, 15.5],[0,0,-1],0,0,0], DefConBack)
                Sharp2Y0A21();
        }

    }
}
