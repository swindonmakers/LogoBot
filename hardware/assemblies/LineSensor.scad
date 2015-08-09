
module LineSensorAssembly () {

    assembly("assemblies/LineSensor.scad", "Line Sensor", str("LineSensorAssembly()")) {

    // base part
    LineSensorHolder_STL();

    // steps
    step(1, "Insert the two line sensor modules") {
            view(t=[0,0,0], r=[52,0,218], d=400);

            //left
            attach([[-12,40,-8],[0,0,1],0,0,0], LineSensor_Con_Def)
                LineSensor();

            //right
            attach([[12,40,-8],[0,0,1],0,0,0], LineSensor_Con_Def)
                LineSensor();
        }



    }
}
