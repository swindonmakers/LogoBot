include <../config/config.scad>


machine("sandbox/damian_playground2.scad","LogoBot Basic Robot", customAttrs=true) {
    attr("z","z");
    
    contains() {
        assembly("assemblies/LogoBot.scad", "Final Assembly", "LogoBotAssembly(PenLift=false)", customAttrs=true) {
            attr("note","this is a little note\n\n");

            contains() {
                assembly("Wheel", "Left Wheel", "Wheel()") {
    
                    step(1, "Fit the wheel") {
            
                        view();
            
                        vitamin("Wheel", "Wheel", "Wheel_STL()", customAttrs=true) { 
                            attr("author","damo");
                            attr("src","http://ebay.com");
                            attr("cost","0.89");
            
                            attrArray("authors") {
                                object()
                                    attr("author","damo");
                                object()
                                    attr("author","fred");
                                object()
                                    attr("author","bob");
                            }
                        }
                
                        vitamin("Motor", "Motor", "Motor()", customAttrs=true) { 
                            attr("author","damo");
                            attr("src","http://ebay.com");
                            attr("cost","0.89");
                        }
            
                    }
        

                }

                assembly("Wheel", "Right Wheel", "Wheel()") {
                    cube([10,10,10]);
                }
            
            }
    
        }    
    }
    
}
