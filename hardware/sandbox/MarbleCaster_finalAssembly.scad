include <../config/config.scad>
UseSTL=false;
UseVitaminSTL=true;
DebugConnectors=true;
DebugCoordinateFrames=true;

translate([0, 0, GroundClearance]) {

            // Default Design Elements
            // -----------------------

            // Base
            LogoBotBase_STL();

            // Caster
            
            attach(LogoBot_Con_Caster, MarbleCaster_Con_Default, ExplodeSpacing=15) {
             
             
             
                MarbleCasterAssembly();
                
                
            }
            
            
            attach(offsetConnector(invertConnector(LogoBot_Con_Caster), [0,0,dw]), MarbleCaster_Con_Default, ExplodeSpacing=15)
                    pintack(side=false, h=dw+0.6+2+1.5, lh=2, bh=2);
            

        }


MarbleCasterAssembly();