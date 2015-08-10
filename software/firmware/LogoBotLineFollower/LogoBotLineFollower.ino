#include "Configuration.h"
#include <DifferentialStepper.h>

// differntial stepper drive
DifferentialStepper diffDrive(
    DifferentialStepper::HALF4WIRE,
    MOTOR_L_PIN_1, MOTOR_L_PIN_2, MOTOR_L_PIN_3, MOTOR_L_PIN_4,
    MOTOR_R_PIN_1, MOTOR_R_PIN_2, MOTOR_R_PIN_3, MOTOR_R_PIN_4
);

int nextLeft, nextRight;

void setup()
{
  Serial.begin(9600);
  Serial.println("Logobot Line Follower");

  diffDrive.setMaxStepRate(1000);
  diffDrive.setAcceleration(2000);
  diffDrive.setBacklash(STEPS_OF_BACKLASH);
  diffDrive.setInvertDirectionFor(0,true);

  nextLeft = 5;
  nextRight = 5;
}

void loop()
{

  diffDrive.run();

  // check sensors
  if (!digitalRead(IR_LEFT_PIN)) {
      nextLeft = 1;
  }
  if (!digitalRead(IR_RIGHT_PIN)) {
      nextRight = 1;
  }

  if (diffDrive.isQEmpty()) {
      // decide what to do next
      diffDrive.queueMove(nextLeft, nextRight);

      // reset next
      nextLeft = 5;
      nextRight = 5;
  }
}



/*

Test program


const int analogInPin = A0;

int sensorValue = 0;
int refValue = 0;

void setup() {
  Serial.begin(9600);

  setRef();
  Serial.print("ref = " );
  Serial.println(refValue);
}

void setRef() {
  long v = 0;
  int sv;
  for (int i =0; i<32; i++) {
    sv = analogRead(analogInPin);
    v += sv;
    delay(2);
  }
  refValue = v / 32;
}

void loop() {
  sensorValue = analogRead(analogInPin);

  if (sensorValue > refValue + 5) {
    Serial.print("sensor = " );
    Serial.println(sensorValue);
    delay(200);
  }

  delay(5);
}



*/
