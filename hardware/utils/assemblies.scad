// Utility functions for handling complex assemblies


// Control visibility and explosion of assembly steps
module step(stepNum=1, stepDescription="", stepView="400 300 0 0 0 55 0 25 500") {
    echo(str("Step_",stepNum,": ",stepDescription));
    echo(str("View_",stepNum,": ",stepView));
    
    if (stepNum <= $ShowStep) {
        assign($Explode= stepNum == $ShowStep ? true : false, $ShowStep=100)
            children();
    }
}
