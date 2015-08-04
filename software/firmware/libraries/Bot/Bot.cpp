#include "Bot.h"

Bot::Bot(uint8_t lp1, uint8_t lp2, uint8_t lp3, uint8_t lp4, uint8_t rp1, uint8_t rp2, uint8_t rp3, uint8_t rp4) : 
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

void Bot::initBuzzer(uint8_t pin)
{
	_pinBuzzer = pin;
	pinMode(_pinBuzzer, OUTPUT);
}

void Bot::initBumpers(uint8_t pinFL, uint8_t pinFR, uint8_t pinBL, uint8_t pinBR, void (*pFunc)(byte collisionData))
{
	_pinSwitchFL = pinFL;
	_pinSwitchFR = pinFR;
	_pinSwitchBL = pinBL;
	_pinSwitchBR = pinBR;

	pinMode(_pinSwitchFL, INPUT_PULLUP);
	pinMode(_pinSwitchFR, INPUT_PULLUP);
	pinMode(_pinSwitchBL, INPUT_PULLUP);
	pinMode(_pinSwitchBR, INPUT_PULLUP);

	bumperCallback = *pFunc;
}

void Bot::initPenLift(uint8_t pin)
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
	for (uint8_t i = 0; i < 3; i++) {
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
	if (!digitalRead(_pinSwitchFL)) nowColliding = 1;
	if (!digitalRead(_pinSwitchFR)) nowColliding += 2;
	if (!digitalRead(_pinSwitchBL)) nowColliding += 4;
	if (!digitalRead(_pinSwitchBR)) nowColliding += 8;

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
		for (uint8_t i = 0; i < 8; i++)
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

void Bot::buzz(uint8_t len)
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
	uint8_t steps = distance * STEPS_PER_MM;
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
	uint8_t steps = ang * STEPS_PER_DEG;
	_stepperR.move(steps);
	_stepperL.move(-steps);
}

// position calcs
void Bot::resetPosition() {
	state.x = 0;
	state.y = 0;
	state.ang = 0;
}
