#include <AccelStepper.h>

// Pin definitions

// Left motor driver
#define motorLPin1  2     // IN1 on the ULN2003 driver 1
#define motorLPin2  3     // IN2 on the ULN2003 driver 1
#define motorLPin3  4     // IN3 on the ULN2003 driver 1
#define motorLPin4  5     // IN4 on the ULN2003 driver 1

// Right motor driver
#define motorRPin1  6     // IN1 on the ULN2003 driver 1
#define motorRPin2  7     // IN2 on the ULN2003 driver 1
#define motorRPin3  8     // IN3 on the ULN2003 driver 1
#define motorRPin4  9     // IN4 on the ULN2003 driver 1


// Initialize with pin sequence IN1-IN3-IN2-IN4 for using the AccelStepper with 28BYJ-48
AccelStepper stepperL(AccelStepper::HALF4WIRE, motorLPin1, motorLPin3, motorLPin2, motorLPin4);
AccelStepper stepperR(AccelStepper::HALF4WIRE, motorRPin1, motorRPin3, motorRPin2, motorRPin4);


void setup()
{  
  stepperL.setMaxSpeed(1000);
  stepperL.setAcceleration(500);
  stepperL.moveTo(5000);

  stepperR.setMaxSpeed(1000);
  stepperR.setAcceleration(500);
  stepperR.moveTo(5000);
}

void loop()
{
    // If at the end of travel go to the other end
    if (stepperL.distanceToGo() == 0) {
      stepperL.moveTo(-stepperL.currentPosition());
      stepperR.moveTo(-stepperR.currentPosition());
    }

    stepperL.run();
    stepperR.run();
}
