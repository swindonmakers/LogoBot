#include "Bot.h"

Bot::Bot(int lp1, int lp2, int lp3, int lp4, int rp1, int rp2, int rp3, int rp4) : 
	_stepperL(AccelStepper::HALF4WIRE, lp1, lp2, lp3, lp4),
	_stepperR(AccelStepper::HALF4WIRE, rp1, rp2, rp3, rp4)
{
	_pinStepper[0] = lp1;
	_pinStepper[1] = lp2;
	_pinStepper[2] = lp3;
	_pinStepper[3] = lp4;
	_pinStepper[4] = rp1;
	_pinStepper[5] = rp2;
	_pinStepper[6] = rp3;
	_pinStepper[7] = rp4;

	_buzzEnd = 0;
	resetPosition();
}

void Bot::begin()
{
	_stepperL.setMaxSpeed(1000);
	_stepperL.setAcceleration(2000);
	_stepperL.setBacklash(STEPS_OF_BACKLASH);
	_stepperL.setPinsInverted(true, true, false, false, false);

	_stepperR.setMaxSpeed(1000);
	_stepperR.setAcceleration(2000);
	_stepperR.setBacklash(STEPS_OF_BACKLASH);
}

void Bot::initBuzzer(int pin)
{
	_pinBuzzer = pin;
	pinMode(_pinBuzzer, OUTPUT);
}

void Bot::initBumpers(int fl, int fr, int bl, int br, void (*pFunc)(byte collisionData))
{
	_switchFL = fl;
	_switchFR = fr;
	_switchBL = bl;
	_switchBR = br;

	pinMode(_switchFL, INPUT_PULLUP);
	pinMode(_switchFR, INPUT_PULLUP);
	pinMode(_switchBL, INPUT_PULLUP);
	pinMode(_switchBR, INPUT_PULLUP);

	bumperCallback = *pFunc;
}

void Bot::initPenLift(int pin)
{
	_penliftServo.attach(pin);
	penUp();
}

bool Bot::isMoving()
{
	return _stepperL.distanceToGo() != 0 || _stepperR.distanceToGo() != 0;
}

void Bot::playStartupJingle()
{
	for (int i = 0; i < 3; i++) {
		digitalWrite(_pinBuzzer, HIGH);
		delay(100);
		digitalWrite(_pinBuzzer, LOW);
		delay(25);
	}
}

void Bot::run()
{
	// Run steppers
	_stepperL.run();
	_stepperR.run();

	// Do buzzer
	if (millis() < _buzzEnd)
		digitalWrite(_pinBuzzer, HIGH);
	else
		digitalWrite(_pinBuzzer, LOW);

	// Collisions
	byte nowColliding = 0;
	if (!digitalRead(_switchFL)) nowColliding = 1;
	if (!digitalRead(_switchFR)) nowColliding += 2;
	if (!digitalRead(_switchBL)) nowColliding += 4;
	if (!digitalRead(_switchBR)) nowColliding += 8;

	if (nowColliding != state.colliding) {
		// collision state has changed
		if (bumperCallback)
			bumperCallback(nowColliding);

		state.colliding = nowColliding;
	}
	
	// Disable motors when stopped to save power
	// Note that AccelStepper.disableOutputs doesn't seem to work
	// correctly when pins are inverted and leaves some outputs on.
	if (!isMoving())
		for (int i = 0; i < 8; i++)
			digitalWrite(_pinStepper[i], LOW);
}

void Bot::penUp()
{
	_penliftServo.write(10);
}

void Bot::penDown()
{
	_penliftServo.write(90);
}

void Bot::buzz(int len)
{
	_buzzEnd = millis() + len;
}

void Bot::stop() 
{
	_stepperL.stop();
	_stepperR.stop();
}

void Bot::emergencyStop() 
{
	_stepperL.setCurrentPosition(_stepperL.currentPosition());
	_stepperL.setSpeed(0);
	_stepperR.setCurrentPosition(_stepperR.currentPosition());
	_stepperR.setSpeed(0);
}

void Bot::drive(float distance)
{
	// update state
	state.x += distance * cos(state.ang * DEGTORAD);
	state.y += distance * sin(state.ang * DEGTORAD);

	// prime the move
	int steps = distance * STEPS_PER_MM;
	_stepperL.move(steps);
	_stepperR.move(steps);
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
	_stepperR.move(steps);
	_stepperL.move(-steps);
}

// position calcs
void Bot::resetPosition() {
	state.x = 0;
	state.y = 0;
	state.ang = 0;
}
