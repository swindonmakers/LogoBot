// testing section() module
include <../config/config.scad>


section()
    sphere(50);

sectionPlaneConnector = [[0,0,20], [0,0,1], 0,0,0];

translate([100,0,0])
    section(sectionPlaneConnector)
    sphere(50);
