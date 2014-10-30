include <../config/config.scad>


machine("sandbox/damian_playground2.scad","LogoBot Basic Robot")
    attr("z","z");

    assembly("assemblies/LogoBot.scad", "Final Assembly", "LogoBotAssembly(PenLift=false)")
        attr("note","this is a little note\n\n");

        assembly("Wheel", "Left Wheel", "Wheel()");
    
            step(1, "Fit the wheel") {
            
                view();
            
                vitamin("Wheel", "Wheel", "Wheel_STL()") { 
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
                
                vitamin("Motor", "Motor", "Motor()") { 
                    attr("author","damo");
                    attr("src","http://ebay.com");
                    attr("cost","0.89");
                }
            
            }
        

        end();

        assembly("Wheel", "Right Wheel", "Wheel()");

        end();
    
    end();
    
end();
