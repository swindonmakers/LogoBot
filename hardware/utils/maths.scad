// Compilation of maths routines from various sources, noted as appropriate
//


/*
    Super Simple Stuff
*/


function sqr(a) = a*a;


/*
    Geometry - Circle
*/

function circumference(radius) = 2 * PI * radius;
function arcLength(radius, theta) = PI * radius * theta / 180;
function chordLength(radius, theta) = radius * sqrt(2 - 2*cos(theta));
function segmentHeight(radius, theta) = radius - sqrt(sqr(radius) - sqr(chordLength(radius, theta))/4);
function segmentDistance(radius,theta) = radius - segmentHeight(radius,theta);



/*
    Matrices - Affine Transformations
*/

// OpenSCAD transformation matrix function library.
// Henry Baker, Santa Barbara, CA, 7/2013.
// Extended by Damian Axford for the LogoBot project

function scale(v)=[[v[0],0,0,0],
                   [0,v[1],0,0],
                   [0,0,v[2],0],
                   [0,0,0,1]];

function rotatex(a)=[[1,0,0,0],
                     [0,cos(a),-sin(a),0],
                     [0,sin(a),cos(a),0],
                     [0,0,0,1]];

function rotatey(a)=[[cos(a),0,sin(a),0],
                     [0,1,0,0],
                     [-sin(a),0,cos(a),0],
                     [0,0,0,1]];

function rotatez(a)=[[cos(a),-sin(a),0,0],
                     [sin(a),cos(a),0,0],
                     [0,0,1,0],
                     [0,0,0,1]];

// From Wikipedia.
function rotatea(c,s,l,m,n)=[[l*l*(1-c)+c,m*l*(1-c)-n*s,n*l*(1-c)+m*s,0],
                             [l*m*(1-c)+n*s,m*m*(1-c)+c,n*m*(1-c)-l*s,0],
                             [l*n*(1-c)-m*s,m*n*(1-c)+l*s,n*n*(1-c)+c,0],
                             [0,0,0,1]];

function rotateanv(a,nv)=rotatea(cos(a),sin(a),nv[0],nv[1],nv[2]);

function rotate(a,v, normV=true)=(v==undef)?rotatez(a[2])*rotatey(a[1])*rotatex(a[0]):
                     normV ? rotateanv(a,v/sqrt(v*v)) : rotateanv(a,v);


function translate(v)=[[1,0,0,v[0]],
                       [0,1,0,v[1]],
                       [0,0,1,v[2]],
                       [0,0,0,1]];

// From Wikipedia.
function mirrorabc(a,b,c)=[[1-2*a*a,-2*a*b,-2*a*c,0],
                           [-2*a*b,1-2*b*b,-2*b*c,0],
                           [-2*a*c,-2*b*c,1-2*c*c,0],
                           [0,0,0,1]];

function mirrornv(nv)=mirrorabc(nv[0],nv[1],nv[2]);

function mirror(v)=mirrornv(v/sqrt(v*v));


// Example of the use of these functions.
// The following two commands both do the same thing.
// Note that the order of transformations in both versions is the same!

*multmatrix(m=translate([20,0,0])*rotate([0,10,0])*translate([10,0,0])) cube(size=[1,2,3],center=false);

*translate([20,0,0]) rotate([0,10,0]) translate([10,0,0]) cube(size=[1,2,3],center=false);
