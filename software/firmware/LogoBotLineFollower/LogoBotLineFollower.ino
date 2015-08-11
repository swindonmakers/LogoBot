#include "Configuration.h"
#include <DifferentialStepper.h>

#define STEPS_PER_MM 5000/232

// differntial stepper drive
DifferentialStepper diffDrive(
    DifferentialStepper::HALF4WIRE,
    MOTOR_L_PIN_1, MOTOR_L_PIN_3, MOTOR_L_PIN_2, MOTOR_L_PIN_4,
    MOTOR_R_PIN_1, MOTOR_R_PIN_3, MOTOR_R_PIN_2, MOTOR_R_PIN_4
);

long nextLeft, nextRight;
int leftBaseline = 0, rightBaseline = 0;
int leftThreshold = 50, rightThreshold = 50;

void setup()
{
  Serial.begin(9600);
  Serial.println("Logobot Line Follower");

  diffDrive.setMaxStepRate(1000);
  diffDrive.setAcceleration(2000);
  diffDrive.enableLookAhead(true);
  diffDrive.setInvertDirectionFor(0,true);

  nextLeft = 10;
  nextRight = 10;

  setBaselines();
}

void loop()
{

  diffDrive.run();

  if (diffDrive.isQEmpty()) {

      // check sensors
      int lv  = analogRead(IR_LEFT_PIN);
      int rv = analogRead(IR_RIGHT_PIN);

      if (lv > leftThreshold) {
          nextLeft = -5;
      }
      if (rv > rightThreshold) {
          nextRight = -5;
      }

      Serial.print(lv);
      Serial.print(',');
      Serial.println(rv);

      // decide what to do next
      diffDrive.queueMove(nextLeft * STEPS_PER_MM, nextRight * STEPS_PER_MM);

      // reset next
      nextLeft = 10;
      nextRight = 10;
  }
}


void setBaselines() {
  int lv;
  int rv;
  leftBaseline = 0;
  rightBaseline = 0;
  for (int i =0; i<32; i++) {
      lv  = analogRead(IR_LEFT_PIN);
      rv = analogRead(IR_RIGHT_PIN);

      leftBaseline += lv;
      rightBaseline += rv;
      delay(2);
  }
  leftBaseline = leftBaseline / 32;
  rightBaseline = rightBaseline / 32;

  leftThreshold = leftBaseline + 10;
  rightThreshold = rightBaseline + 10;
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
