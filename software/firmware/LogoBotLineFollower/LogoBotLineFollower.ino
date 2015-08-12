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
  Serial.println("Logobot Line Follower");

  diffDrive.setMaxStepRate(1000);
  diffDrive.setAcceleration(2000);
  diffDrive.enableLookAhead(true);
  diffDrive.setInvertDirectionFor(0,true);

  nextLeft = 10;
  nextRight = 10;

  // wait a sec to give us time to put the bot down
  delay(1000);

  setBaselines();
}

void loop()
{
  diffDrive.run();

  handleSensors();

  if (!diffDrive.isQFull()) {
      // queue up straight moves to fill buffer
      diffDrive.queueMove((long)10 * STEPS_PER_MM, (long)10 * STEPS_PER_MM);
  }
}

void handleSensors() {
    // check sensors
    leftReading =  (leftReading * 15 + analogRead(IR_LEFT_PIN)) / 16;
    rightReading =  (rightReading * 15 + analogRead(IR_RIGHT_PIN)) / 16;

    byte nowColliding = 0;
    if (leftReading > leftThreshold) nowColliding = 1;
    if (rightReading > rightThreshold) nowColliding += 2;

	if (nowColliding != colliding) {
		// collision state has changed
		handleCollision(nowColliding);

		colliding = nowColliding;
	}
}

void handleCollision(byte nowColliding) {
    Serial.print("Collision: ");
    Serial.println(nowColliding);

    if (nowColliding == 0 || nowColliding == 3) return;

    // stop bot, and thereby empty queue buffer
    diffDrive.stop();

    // queue up a recovery move
    if (nowColliding == 1) // hit left, so turn left
        diffDrive.queueMove((long)1 * STEPS_PER_MM, (long)15 * STEPS_PER_MM);
    else // hit right, so turn right
        diffDrive.queueMove((long)15 * STEPS_PER_MM, (long)1 * STEPS_PER_MM);
}


void setBaselines() {
  int lv;
  int rv;
  Serial.println("Gathering sensor baseline...");
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
  Serial.print("Baselines: ");
  Serial.print(leftBaseline);
  Serial.print(',');
  Serial.println(rightBaseline);
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
