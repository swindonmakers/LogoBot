#include "Bot.h"
#include <AccelStepper.h>
#include <Servo.h>

Servo penliftServo;
// Initialize with pin sequence IN1-IN3-IN2-IN4 for using the AccelStepper with 28BYJ-48
AccelStepper stepperL(AccelStepper::HALF4WIRE, motorLPin1, motorLPin3, motorLPin2, motorLPin4);
AccelStepper stepperR(AccelStepper::HALF4WIRE, motorRPin1, motorRPin3, motorRPin2, motorRPin4);

Bot::Bot()
{
	buzzEnd = 0;
	resetPosition();
}

void Bot::begin()
{
	stepperL.setMaxSpeed(1000);
	stepperL.setAcceleration(2000);
	stepperL.setBacklash(STEPS_OF_BACKLASH);
	stepperL.setPinsInverted(true, true, false, false, false);

	stepperR.setMaxSpeed(1000);
	stepperR.setAcceleration(2000);
	stepperR.setBacklash(STEPS_OF_BACKLASH);

	pinMode(switchFL, INPUT_PULLUP);
	pinMode(switchFR, INPUT_PULLUP);

	pinMode(InternalLED, OUTPUT);

	//pinMode(LEDRED, OUTPUT);
	//pinMode(LEDGREEN, OUTPUT);
	//pinMode(LEDBLUE, OUTPUT);
  
	pinMode(buzzer, OUTPUT);

	penliftServo.attach(11);
	penUp();
}

void Bot::setBumperCallback(void (*pFunc)(byte collisionData))
{
	bumperCallback = *pFunc;
}

bool Bot::isMoving()
{
	return stepperL.distanceToGo() != 0 || stepperR.distanceToGo() != 0;
}

void Bot::playStartupJingle()
{
	for (int i = 0; i < 3; i++) {
		digitalWrite(buzzer, HIGH);
		delay(100);
		digitalWrite(buzzer, LOW);
		delay(25);
	}
}

void Bot::run()
{
	// Run steppers
	stepperL.run();
	stepperR.run();

	// Do buzzer
	if (millis() < buzzEnd)
		digitalWrite(buzzer, HIGH);
	else
		digitalWrite(buzzer, LOW);

	// Collisions
	byte nowColliding = 0;
	if (!digitalRead(switchFL)) nowColliding = 1;
	if (!digitalRead(switchFR)) nowColliding += 2;

	if (nowColliding != state.colliding) {
		// collision state has changed
		if (bumperCallback)
			bumperCallback(nowColliding);

		state.colliding = nowColliding;
	}

	
	// Disable motors when stopped to save power
	// Note that AccelStepper.disableOutputs doesn't seem to work
	// correctly when pins are inverted and leaves some outputs on.
	if (!isMoving()) {
        digitalWrite(motorLPin1, LOW);
        digitalWrite(motorLPin2, LOW);
        digitalWrite(motorLPin3, LOW);
        digitalWrite(motorLPin4, LOW);
        digitalWrite(motorRPin1, LOW);
        digitalWrite(motorRPin2, LOW);
        digitalWrite(motorRPin3, LOW);
        digitalWrite(motorRPin4, LOW);
	}
}

void Bot::penUp()
{
	penliftServo.write(10);
}

void Bot::penDown()
{
	penliftServo.write(90);
}

void Bot::buzz(int len)
{
  buzzEnd = millis() + len;
}

void Bot::stop() 
{
	stepperL.stop();
	stepperR.stop();
}

void Bot::emergencyStop() 
{
	stepperL.setCurrentPosition(stepperL.currentPosition());
	stepperL.setSpeed(0);
	stepperR.setCurrentPosition(stepperR.currentPosition());
	stepperR.setSpeed(0);
}

void Bot::drive(float distance)
{
	// update state
	state.x += distance * cos(state.ang * DEGTORAD);
	state.y += distance * sin(state.ang * DEGTORAD);

	// prime the move
	int steps = distance * STEPS_PER_MM;
	stepperL.move(steps);
	stepperR.move(steps);
}

void Bot::turn(float ang)
{
	// update state
	state.ang += ang;

	// correct wrap around
	if (state.ang > 180) state.ang -= 360;
	if (state.ang < -180) state.ang += 360;

	// prime the move
	int steps = ang * STEPS_PER_DEG;
	stepperR.move(steps);
	stepperL.move(-steps);
}

// position calcs
void Bot::resetPosition() {
  state.x = 0;
  state.y = 0;
  state.ang = 0;
}