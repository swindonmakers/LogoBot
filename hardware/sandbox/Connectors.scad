// Playground for connectors and attach module

include <../config/config.scad>


// connector definitions
con_parent = [[10, 5, 5], [-1,0,0], 45, 0, 0];
con_child = [[0,0,0], [0,0,-1], 0, 0, 0];


con_parent_top = [[5,5,10], [0,0,-1], 0,0,0];
con_child_sideOfFlag = [[5,0,17.5], [0,1,0], 0,0,0];


// parts

module child_part() {
    // Debug connector
    connector(con_child);
    connector(con_child_sideOfFlag);
    
    // show local coordinate frame
    frame();
    
    %cylinder(r=1, h=20, $fn=16);
    translate([0,-1/2,15])
        cube([10,1,5]);
}


module parent_part() {

    // Debug connector
    connector(con_parent);
    connector(con_parent_top);
    
    // show local coordinate frame
    frame();
    
    %cube([10,10,10]);
}



// put it all together...

// using attach module, which includes ability to draw explode vector
translate([0,30,0]) {
    // Parent part
    parent_part();

    // Child part
    attach(con_parent, con_child)
        child_part();
    
}

// using the attachMatrix function to build an equivalent transformation matrix
// Parent part
translate([0,0,0]) {
    parent_part();

    // Child part
    multmatrix(m=attachMatrix(con_parent, con_child))
        child_part();
}
 
    
// child part on its own, translated along y-
translate([0,-30,0])
    child_part();
    
    
    
// connect a jumper wire to the parent_top and child_sideOfFlag

JumperWire(
    type = JumperWire_FF2,
    con1 = con_parent_top,
    con2 = attachedConnector(con_parent, con_child, con_child_sideOfFlag),
    length = 100,
    conVec1 = [0,1,0],
    conVec2 = attachedDirection(con_parent, con_child, [0,[1,0,0]]),
    midVec = [1,1,0]
);






    
