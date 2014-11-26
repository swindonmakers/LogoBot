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

// Piezo buzzer
#define buzzer      10

// Microswitches
#define switchFL    11
#define switchFR    12

// LED
#define InternalLED         13
#define LEDRED      A0
#define LEDGREEN    A1
#define LEDBLUE     A2

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
  
  pinMode(switchFL, INPUT_PULLUP);
  pinMode(switchFR, INPUT_PULLUP);
  
  pinMode(InternalLED, OUTPUT);
  
  pinMode(LEDRED, OUTPUT);
  pinMode(LEDGREEN, OUTPUT);
  pinMode(LEDBLUE, OUTPUT);
  
  pinMode(buzzer, OUTPUT);
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
    
    // check microswitches
    if (!digitalRead(switchFL) || !digitalRead(switchFR)) {
       digitalWrite(InternalLED, HIGH);
       
       // buzz
       digitalWrite(LEDRED, HIGH);
       analogWrite(buzzer, 125);
       delay(250);
       
       digitalWrite(LEDGREEN, HIGH);
       digitalWrite(LEDRED, LOW);
       analogWrite(buzzer, 150);
       delay(250);
       
       digitalWrite(LEDBLUE, HIGH);
       digitalWrite(LEDGREEN, LOW);
       analogWrite(buzzer, 180);
       delay(250);
    } else {
       // led off
       digitalWrite(InternalLED, LOW); 
       
       digitalWrite(LEDRED, LOW); 
       digitalWrite(LEDGREEN, LOW); 
       digitalWrite(LEDBLUE, LOW); 
       
       // stop buzz
       digitalWrite(buzzer,LOW);
    }
}
