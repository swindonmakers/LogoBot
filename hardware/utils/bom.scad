//
// Derived from Mendel90 - utils/bom.scad
//
// GNU GPL v2
// nop.head@gmail.com
// hydraraptor.blogspot.com
//

// BOM generation
//

module Assembly(name) {                 // start an assembly
    if(BOMLevel > 0)
        echo(str(name, "/"));
}

module End(name) {                      // end an assembly
    if(BOMLevel > 0)
        echo(str("/",name));
}

module STL(name) {                      // name an stl
    if(BOMLevel > 0)
        echo(str(name,".stl"));
}

module Vitamin(name,typeName) {                  // name a vitamin
    if(BOMLevel > 1)
        echo(str(name,"_",typeName));
}