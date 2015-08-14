#include "PolarBot.h"

PolarBot::PolarBot(uint8_t lp1, uint8_t lp2, uint8_t lp3, uint8_t lp4, uint8_t rp1, uint8_t rp2, uint8_t rp3, uint8_t rp4) :
	_diffDrive(DifferentialStepper::HALF4WIRE, lp1, lp3, lp2, lp4, rp1, rp3, rp2, rp4)
{
	_buzzEnd = 0;
	_pauseEnd = 0;
	resetPosition();
}

void PolarBot::begin()
{
	_diffDrive.setMaxStepRate(800);
	_diffDrive.setAcceleration(400);
	_diffDrive.setBacklash(STEPS_OF_BACKLASH);
	_diffDrive.setInvertDirectionFor(1,true);
}

void PolarBot::initBuzzer(uint8_t pin)
{
	_pinBuzzer = pin;
	pinMode(_pinBuzzer, OUTPUT);
}

void PolarBot::initPenLift(uint8_t pin)
{
	_pinServo = pin;
	_penliftServo.attach(_pinServo);
	penUp();
}

bool PolarBot::isBusy()
{
	return (!_diffDrive.isQEmpty()) || (millis() < _pauseEnd);
}

bool PolarBot::isQFull() {
	// make sure we always have two blocks free, to allow space for driveTo commands that need two blocks!
	return _diffDrive.getQueueCapacity() < 3;
}

void PolarBot::playStartupJingle()
{
	for (uint8_t i = 0; i < 3; i++) {
		digitalWrite(_pinBuzzer, HIGH);
		delay(100);
		digitalWrite(_pinBuzzer, LOW);
		delay(25);
	}
}

void PolarBot::run()
{
	// do pause
	if (millis() < _pauseEnd) {
		// do nothing for a while
	} else {
		// Run steppers
		_diffDrive.run();
	}

	// Do buzzer
	if (millis() < _buzzEnd)
		digitalWrite(_pinBuzzer, HIGH);
	else
		digitalWrite(_pinBuzzer, LOW);


	// Disable motors when stopped to save power
	if (!isBusy())
		_diffDrive.disableOutputs();
}

void PolarBot::penUp()
{
	_penliftServo.write(90);
	pause(200);
	//_penliftServo.detach();
}

void PolarBot::penDown()
{
	//_penliftServo.attach(_pinServo);
	_penliftServo.write(10);
	pause(200);
	//_penliftServo.detach();
}

void PolarBot::pause(int len)
{
	// TODO: account for timer overflow
	_pauseEnd = millis() + len;
}

void PolarBot::buzz(int len)
{
	// TODO: account for timer overflow
	_buzzEnd = millis() + len;
}

void PolarBot::stop()
{
	_diffDrive.stop();
}

void PolarBot::emergencyStop()
{
	_diffDrive.emergencyStop();
}

void PolarBot::enableLookAhead(boolean v) {
	_diffDrive.enableLookAhead(v);
}

void PolarBot::polarDriveTo(float x, float y) {

	// calc string lengths for new position
	float right = sqrt(sq(WHEELSPACING-x) + sq(y));
	float left = sqrt(sq(x) + sq(y));

	// calc deltas
	float dr = right - state.right;
	float dl = left - state.left;

	// prime the move
	long sr = dr * STEPS_PER_MM;
	long sl = dl * STEPS_PER_MM;
	_diffDrive.queueMove(sl,sr);

/*
	Serial.print('C');
	Serial.print(x);
	Serial.print(',');
	Serial.println(y);

	Serial.print('D');
	Serial.print(dl);
	Serial.print(',');
	Serial.println(dr);

	Serial.print('S');
	Serial.print(sl);
	Serial.print(',');
	Serial.println(sr);
*/

	// update state
	state.left = left;
	state.right = right;
}

void PolarBot::drive(float distance)
{
	// calc cartesion change
	state.x += distance * cos(state.ang * DEGTORAD);
	state.y += distance * sin(state.ang * DEGTORAD);

	polarDriveTo(state.x,state.y);
}

void PolarBot::turn(float ang)
{
	// update state
	state.ang += ang;
	correctAngleWrap();
	// no need to actually move!
}

void PolarBot::drive(float leftDist, float rightDist) {
	//TODO: implement this!
}


void PolarBot::driveTo(float x, float y) {
  // calc angle
  double ang = atan2(y-state.y, x-state.x) * RADTODEG;
  // now angle delta
  ang = ang - state.ang;
  if (ang > 180)
    ang = -(360 - ang);
  if (ang < -180)
    ang = 360 + ang;

  // pretend we've turned
  turn(ang);

  polarDriveTo(x,y);
  state.x = x;
  state.y = y;
}

void PolarBot::arcTo (float x, float y)
{
    // cheat
	// TODO: do this properly!
	driveTo(x,y);
}

// Draw a circle size dia, direction = -1 clockwise, 1 anticlockwise
void PolarBot::circle(float dia, float direction)
{
	// TODO: implement circle
}

// position calcs
void PolarBot::resetPosition() {
	state.x = WHEELSPACING/2;
	state.y = -300;
	state.ang = 0;
	state.left = sqrt(sq(state.x) + sq(state.y));
	state.right = sqrt(sq(WHEELSPACING-state.x) + sq(state.y));
}

// correct wrap around
void PolarBot::correctAngleWrap()
{
	if (state.ang > 180) state.ang -= 360;
	if (state.ang < -180) state.ang += 360;
}
