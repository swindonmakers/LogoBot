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
byte colliding = 0;
float leftReading = 0, rightReading = 0;  // time averaged values to remove some noise

void setup()
{
  Serial.begin(9600);
  Serial.println("Logobot Polar Graph");

  diffDrive.setMaxStepRate(1000);
  diffDrive.setAcceleration(2000);
  diffDrive.enableLookAhead(true);
  diffDrive.setInvertDirectionFor(0,true);
  
  pinMode(SERVO_PIN, OUTPUT);
  
  for (int i=0; i<10; i++) {
     analogWrite(SERVO_PIN, 100);
    delay(500);
    
    analogWrite(SERVO_PIN, 180);
    delay(500);
  }
  
  pinMode(SERVO_PIN, INPUT);
}

void loop()
{
  static int iterations = 0;
  
  diffDrive.run();

  if (diffDrive.isQEmpty() && iterations<5) {
      iterations++;
      delay(500);
      // queue up straight moves to fill buffer
      diffDrive.queueMove((long)100 * STEPS_PER_MM, (long)100 * STEPS_PER_MM);
      diffDrive.queueMove((long)-100 * STEPS_PER_MM, (long)-100 * STEPS_PER_MM);
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
