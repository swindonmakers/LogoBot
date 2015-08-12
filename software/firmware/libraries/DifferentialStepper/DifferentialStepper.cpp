#include "DifferentialStepper.h"

DifferentialStepper::DifferentialStepper(
    uint8_t interface,
    uint8_t pinL1,
    uint8_t pinL2,
    uint8_t pinL3,
    uint8_t pinL4,
    uint8_t pinR1,
    uint8_t pinR2,
    uint8_t pinR3,
    uint8_t pinR4
) {
    _enabled = false;
    _interface = interface;
    _maxStepRate = 1000;
    _minStepRate = 100;
    _minPulseWidth = 1;
    _stepRate = _minStepRate;
    _acceleration = 500;

    _replanNeeded=false;
    _lookAheadEnabled = false;
    calculateAccelDist();

    // pins
    _motors[MOTOR_LEFT].pin[0] = pinL1;
    _motors[MOTOR_LEFT].pin[1] = pinL2;
    _motors[MOTOR_LEFT].pin[2] = pinL3;
    _motors[MOTOR_LEFT].pin[3] = pinL4;

    _motors[MOTOR_RIGHT].pin[0] = pinR1;
    _motors[MOTOR_RIGHT].pin[1] = pinR2;
    _motors[MOTOR_RIGHT].pin[2] = pinR3;
    _motors[MOTOR_RIGHT].pin[3] = pinR4;

    // init both motors
    int m, i;
    for (m=0; m<2; m++) {
        _motors[m].currentPos       = 0;
        _motors[m].direction        = DIRECTION_FWD;
        _motors[m].enablePin        = 0xff;
        _motors[m].enableInverted   = false;
        _motors[m].invertDirection  = false;

        for (i = 0; i < 4; i++)
            _motors[m].pinInverted[i] = 0;
    }
}

void DifferentialStepper::enableOutputs() {
    if (! _interface || _enabled) return;

    for (int i=0; i<2; i++)
        enableOutputsFor(&_motors[i]);
    _enabled = true;
}

void DifferentialStepper::enableOutputsFor(Motor *motor) {
    if (! _interface) return;

    pinMode(motor->pin[0], OUTPUT);
    pinMode(motor->pin[1], OUTPUT);
    if (_interface == FULL4WIRE || _interface == HALF4WIRE)
    {
        pinMode(motor->pin[2], OUTPUT);
        pinMode(motor->pin[3], OUTPUT);
    }
    else if (_interface == FULL3WIRE || _interface == HALF3WIRE)
    {
        pinMode(motor->pin[2], OUTPUT);
    }

    if (motor->enablePin != 0xff)
    {
        pinMode(motor->enablePin, OUTPUT);
        digitalWrite(motor->enablePin, HIGH ^ motor->enableInverted);
    }
}

// Prevents power consumption on the outputs
void DifferentialStepper::disableOutputs() {
    if (! _interface || !_enabled) return;

    for (int i=0; i<2; i++)
        disableOutputsFor(&_motors[i]);
    _enabled = false;
}

void DifferentialStepper::disableOutputsFor(Motor *motor) {
    setOutputPinsFor(motor, 0); // Handles inversion automatically
    if (motor->enablePin != 0xff)
        digitalWrite(motor->enablePin, LOW ^ motor->enableInverted);
}

// bit 0 of the mask corresponds to pin[0]
// bit 1 of the mask corresponds to pin[1]
// ....
void DifferentialStepper::setOutputPinsFor(Motor *motor, uint8_t mask) {
    uint8_t numpins = 2;
    if (_interface == FULL4WIRE || _interface == HALF4WIRE) {
        numpins = 4;
    } else if (_interface == FULL3WIRE || _interface == HALF3WIRE) {
        numpins = 3;
    }
    uint8_t i;
    for (i = 0; i < numpins; i++)
        digitalWrite(motor->pin[i], (mask & (1 << i)) ? (HIGH ^ motor->pinInverted[i]) : (LOW ^ motor->pinInverted[i]));
}

void DifferentialStepper::setPinsInvertedFor(uint8_t motor, bool pin1Invert, bool pin2Invert, bool pin3Invert, bool pin4Invert, bool enableInvert)
{
    _motors[motor].pinInverted[0] = pin1Invert;
    _motors[motor].pinInverted[1] = pin2Invert;
    _motors[motor].pinInverted[2] = pin3Invert;
    _motors[motor].pinInverted[3] = pin4Invert;
    _motors[motor].enableInverted = enableInvert;
}

void DifferentialStepper::setInvertDirectionFor(uint8_t motor, bool inv) {
    _motors[motor].invertDirection = inv;
}

void DifferentialStepper::setBacklash(unsigned int steps) {
    _backlash = steps;
}

void DifferentialStepper::step(Motor *motor) {
    switch (_interface)
    {
        case DRIVER:
            step1(motor);
            break;
        case FULL2WIRE:
            step2(motor);
            break;
        case FULL3WIRE:
            step3(motor);
            break;
        case FULL4WIRE:
            step4(motor);
            break;
        case HALF3WIRE:
            step6(motor);
            break;
        case HALF4WIRE:
            step8(motor);
            break;
    }
}

// 1 pin step function (ie for stepper drivers)
// This is passed the current step number (0 to 7)
// Subclasses can override
void DifferentialStepper::step1(Motor *motor)
{
    // pin[0] is step, pin[1] is direction
    setOutputPinsFor(motor, motor->direction ? 0b10 : 0b00); // Set direction first else get rogue pulses
    setOutputPinsFor(motor, motor->direction ? 0b11 : 0b01); // step HIGH
    // Caution 200ns setup time
    // Delay the minimum allowed pulse width
    delayMicroseconds(_minPulseWidth);
    setOutputPinsFor(motor, motor->direction ? 0b10 : 0b00); // step LOW

}


// 2 pin step function
// This is passed the current step number (0 to 7)
// Subclasses can override
void DifferentialStepper::step2(Motor *motor)
{
    switch (motor->currentPos & 0x3)
    {
	case 0: /* 01 */
	    setOutputPinsFor(motor,0b10);
	    break;

	case 1: /* 11 */
	    setOutputPinsFor(motor,0b11);
	    break;

	case 2: /* 10 */
	    setOutputPinsFor(motor,0b01);
	    break;

	case 3: /* 00 */
	    setOutputPinsFor(motor,0b00);
	    break;
    }
}
// 3 pin step function
// This is passed the current step number (0 to 7)
// Subclasses can override
void DifferentialStepper::step3(Motor *motor)
{
    switch (motor->currentPos % 3)
    {
	case 0:    // 100
	    setOutputPinsFor(motor,0b100);
	    break;

	case 1:    // 001
	    setOutputPinsFor(motor,0b001);
	    break;

	case 2:    //010
	    setOutputPinsFor(motor,0b010);
	    break;

    }
}

// 4 pin step function for half stepper
// This is passed the current step number (0 to 7)
// Subclasses can override
void DifferentialStepper::step4(Motor *motor)
{
    switch (motor->currentPos & 0x3)
    {
	case 0:    // 1010
	    setOutputPinsFor(motor,0b0101);
	    break;

	case 1:    // 0110
	    setOutputPinsFor(motor,0b0110);
	    break;

	case 2:    //0101
	    setOutputPinsFor(motor,0b1010);
	    break;

	case 3:    //1001
	    setOutputPinsFor(motor,0b1001);
	    break;
    }
}

// 3 pin half step function
// This is passed the current step number (0 to 7)
// Subclasses can override
void DifferentialStepper::step6(Motor *motor)
{
    switch (motor->currentPos % 6)
    {
	case 0:    // 100
	    setOutputPinsFor(motor,0b100);
            break;

        case 1:    // 101
	    setOutputPinsFor(motor,0b101);
            break;

	case 2:    // 001
	    setOutputPinsFor(motor,0b001);
            break;

        case 3:    // 011
	    setOutputPinsFor(motor,0b011);
            break;

	case 4:    // 010
	    setOutputPinsFor(motor,0b010);
            break;

	case 5:    // 011
	    setOutputPinsFor(motor,0b110);
            break;

    }
}

// 4 pin half step function
// This is passed the current step number (0 to 7)
// Subclasses can override
void DifferentialStepper::step8(Motor *motor)
{
    switch (motor->currentPos & 0x7)
    {
	case 0:    // 1000
	    setOutputPinsFor(motor,0b0001);
            break;

        case 1:    // 1010
	    setOutputPinsFor(motor,0b0101);
            break;

	case 2:    // 0010
	    setOutputPinsFor(motor,0b0100);
            break;

        case 3:    // 0110
	    setOutputPinsFor(motor,0b0110);
            break;

	case 4:    // 0100
	    setOutputPinsFor(motor,0b0010);
            break;

        case 5:    //0101
	    setOutputPinsFor(motor,0b1010);
            break;

	case 6:    // 0001
	    setOutputPinsFor(motor,0b1000);
            break;

        case 7:    //1001
	    setOutputPinsFor(motor,0b1001);
            break;
    }
}

void DifferentialStepper::setMaxStepRate(unsigned int speed) {
    if (speed < _minStepRate) speed = _minStepRate;
    _maxStepRate = speed;
    calculateAccelDist();
}

void DifferentialStepper::setMinStepRate(unsigned int speed) {
    if (speed < 10) speed = 10;
    _minStepRate = speed;
    calculateAccelDist();
}

void DifferentialStepper::setAcceleration(float acceleration) {
    if (acceleration <= 0) return;
    _acceleration = acceleration;
    calculateAccelDist();
}

void DifferentialStepper::enableLookAhead(boolean v) {
    _lookAheadEnabled = v;
    _replanNeeded = true;
}

float DifferentialStepper::calculateAccelDistByAccelAndVel(float v1, float v2) {
    // distance required for acceleration to fullspeed (or stop)
    return (float) ((v2*v2) - (v1*v1))
                 /
                 ( 2.0 * _acceleration);
}

void DifferentialStepper::calculateAccelDist() {
    _accelDist = calculateAccelDistByAccelAndVel(_minStepRate, _maxStepRate);
    _replanNeeded = true;
}

float DifferentialStepper::calculateVelocityByAccelAndDist(float v1, float d) {
    return sqrt(v1*v1 + 2*_acceleration*d);
}

boolean DifferentialStepper::isQFull() {
    return _qSize == DIFFERENTIALSTEPPER_COMMAND_QUEUE_LENGTH;
}

boolean DifferentialStepper::isQEmpty() {
    return _qSize == 0;
}

uint8_t DifferentialStepper::getQueueCapacity() {
    return DIFFERENTIALSTEPPER_COMMAND_QUEUE_LENGTH - _qSize;
}

void DifferentialStepper::reset() {
    _qSize = 0;
    _stepRate = _minStepRate;
}

void DifferentialStepper::stopAfter() {
    if (_qSize > 1) _qSize = 1;
    _replanNeeded = true;
}

void DifferentialStepper::emergencyStop() {
    reset();
}

void DifferentialStepper::stop() {
    // recalc current block to stop ASAP
    Command *c = getCurrentCommand();
    if (c == NULL) return;

    // recalc minimum deceleration distance
    c->decelerateAfter = max(c->totalSteps >> 1, c->totalSteps - _accelDist);

    // if already deaccelerating, then just clear the rest of the queue
    if (_stepsCompleted > c->decelerateAfter) {
        _qSize = 1;
        return;
    }

    // force immediate deacceleration
    _stepsCompleted = c->decelerateAfter;
}

void DifferentialStepper::dequeue() {
    if (_qSize > 0) {
        _qSize--;
        _qHead++;
        if (_qHead >= DIFFERENTIALSTEPPER_COMMAND_QUEUE_LENGTH)
            _qHead -= DIFFERENTIALSTEPPER_COMMAND_QUEUE_LENGTH;
    }
}

DifferentialStepper::Command *DifferentialStepper::getCommand(uint8_t index) {
    if (isQEmpty() || index >= _qSize) {
        return NULL;
    } else {
        index += _qHead;
        if (index >= DIFFERENTIALSTEPPER_COMMAND_QUEUE_LENGTH)
            index -= DIFFERENTIALSTEPPER_COMMAND_QUEUE_LENGTH;
        return &_q[index];
    }
}

DifferentialStepper::Command *DifferentialStepper::getCurrentCommand() {
    if (isQEmpty()) {
        return NULL;
    } else {
        return &_q[_qHead];
    }
}

boolean DifferentialStepper::queueMove(long leftSteps, long rightSteps) {
    if (!isQFull()) {
        uint8_t next = _qHead + _qSize;
        if (next >= DIFFERENTIALSTEPPER_COMMAND_QUEUE_LENGTH)
            next -= DIFFERENTIALSTEPPER_COMMAND_QUEUE_LENGTH;

        Command *c = &_q[next];

        c->busy = false;
        //c->planned = true;
        c->dirChange = false;
        c->leftSteps = abs(leftSteps);
        c->rightSteps = abs(rightSteps);
        c->totalSteps = max(c->leftSteps, c->rightSteps);

        // set direction bits
        c->directionBits = 0;
        if (leftSteps > 0)  c->directionBits |= 1;
        if (rightSteps > 0) c->directionBits |= (1<<1);

		// these will be replaced by replan() if look ahead is enabled
        c->entryStepRate = _minStepRate;
        c->accelerateUntil = min(_accelDist, c->totalSteps >> 1);
        c->decelerateAfter = max(c->totalSteps >> 1, c->totalSteps - _accelDist);

        if (c->accelerateUntil == _accelDist)
            c->accelerateTo = _maxStepRate;
        else
            c->accelerateTo = calculateVelocityByAccelAndDist(c->entryStepRate, c->accelerateUntil);

        _qSize++;

        _replanNeeded = true;

        return true;
    } else
        return false;
}

void DifferentialStepper::replan() {
    if (!_lookAheadEnabled) return;

    Command *c;
    uint8_t i;
    uint8_t lastDirBits = 0;
    unsigned long lastStepRate = _stepRate;  // init with current stepRate

    unsigned long dist = 0; // accumulated distance in steps
    unsigned long accelDistRemaining = _accelDist;
    uint8_t stopAt = 0;

/*
    Serial.println("");
    Serial.println("replan");
    Serial.print("lastStepRate: ");
    Serial.println(lastStepRate);
    Serial.print("lastDirBits: ");
    Serial.println(lastDirBits, BIN);
*/

    // forward pass
    // determine if dirChanged between blocks
    // set accel values
    for (i=0; i< _qSize; i++) {
        c = getCommand(i);

        // check direction bits - not relevant if this is the first move in the queue
        if (i>0)
            c->dirChange = c->directionBits ^ lastDirBits;
        else
            c->dirChange = false;
        lastDirBits = c->directionBits;

/*
        Serial.print("db: ");
        Serial.println(c->directionBits, BIN);
        Serial.print("dc: ");
        Serial.println(c->dirChange);
*/

        // set entry speed
        c->entryStepRate = lastStepRate;

        // keep accelerating if we're not yet at top speed
        c->accelerateUntil = min(accelDistRemaining, c->totalSteps);
        accelDistRemaining -= c->accelerateUntil;

        // calculate local speed reached
        if (accelDistRemaining == 0) {
            c->accelerateTo = _maxStepRate;
        } else
            c->accelerateTo = calculateVelocityByAccelAndDist(c->entryStepRate, c->accelerateUntil);
        lastStepRate = c->accelerateTo;

        stopAt = i;

        // update cumulative steps
        dist += c->totalSteps;
/*
        Serial.print(i);
        Serial.print('>');
        Serial.print(c->totalSteps);
        Serial.print(' ');
        Serial.print(c->entryStepRate);
        Serial.print(' ');
        Serial.print(c->accelerateUntil);
        Serial.print(',');
        Serial.print(c->accelerateTo);
        Serial.print(' ');
        Serial.println(dist);
*/
        // stop at first direction change, no point planning beyond there
        if (c->dirChange) {
            //Serial.println("dirChanged");
            break;
        }
    }


    // 2nd pass
    // work back from last command, setting decel values
    // accel dist is at most half of total dist, or accel dist to minStepRate given current step rate
    accelDistRemaining = min(calculateAccelDistByAccelAndVel(_minStepRate, lastStepRate), dist >> 1);

/*
    Serial.print("decel dist: ");
    Serial.println(accelDistRemaining);
*/
    unsigned long decelFor = 0;
    for (i=stopAt+1; i>0; i--) {
        c = getCommand(i-1);

        decelFor = min(accelDistRemaining, c->totalSteps);
        c->decelerateAfter = c->totalSteps - decelFor;

        accelDistRemaining -= decelFor;
        //c->planned = true;

/*
        Serial.print(i-1);
        Serial.print('>');
        Serial.print(c->totalSteps);
        Serial.print(' ');
        Serial.print(decelFor);
        Serial.print(' ');
        Serial.println(c->decelerateAfter);
        */
    }

    _replanNeeded = false;
}


boolean DifferentialStepper::run() {

    Command *c = getCurrentCommand();
    if (c == NULL) return false;

    // check enabled
    if (!_enabled) enableOutputs();

    // check for replan
    //if (!c->planned || _replanNeeded) replan();
    if (_replanNeeded) replan();

    // check timing
    unsigned long time = micros();

	if (!c->busy) {
		c->busy = true;
        _counterLeft = - (c->totalSteps >> 1);
		_counterRight = _counterLeft;
		_motors[0].direction = c->directionBits & 1;
		_motors[1].direction = c->directionBits & (1<<1);
		_stepsCompleted = 0;
		_stepRate = c->entryStepRate; // calculated by planner

		_lastStepTime = time;
		_stepInterval = 1000000 / _stepRate;

        /*
        Serial.print("_accelDist:"); Serial.println(_accelDist);
        Serial.print("totalSteps:"); Serial.println(c->totalSteps);
        Serial.print("accUntil:"); Serial.println(c->accelerateUntil);
        Serial.print("decelAfter:"); Serial.println(c->decelerateAfter);
        Serial.print("maxStepRate:"); Serial.println(_maxStepRate);
        Serial.print("minStepRate:"); Serial.println(_minStepRate);
        Serial.print("accel:"); Serial.println(_acceleration);
        Serial.println();
        */
	}

	//delay(1);

    // detect and correct for wrapping of nextStepTime or time
    if (_lastStepTime + _stepInterval < _lastStepTime) {
        _lastStepTime = 0;  // hack
    }

    long stepTime = time - _lastStepTime;

    if ( stepTime >= _stepInterval ) {
        // it's time to step...

        // do steps for each motor, using Bresenham algo
        _counterLeft += c->leftSteps;
        if (_counterLeft > 0) {
            _motors[0].currentPos += _motors[0].direction ^ _motors[0].invertDirection ? 1 : -1;
            step(&_motors[0]);
            _counterLeft -= c->totalSteps;
        }

        _counterRight += c->rightSteps;
        if (_counterRight > 0) {
			_motors[1].currentPos += _motors[1].direction ^ _motors[1].invertDirection ? 1 : -1;
            step(&_motors[1]);
            _counterRight -= c->totalSteps;
        }

        _stepsCompleted++;


        // update _stepRate
        float accelDelta = _acceleration * stepTime / 1000000.0;
        //if (accelDelta < 1) accelDelta = 1;

        //if (_stepsCompleted < c->accelerateUntil && _stepRate < _maxStepRate)

        if (_stepsCompleted >= c->decelerateAfter) {
            if (_stepRate > _minStepRate) _stepRate -= accelDelta;
            if (_stepRate < _minStepRate) _stepRate = _minStepRate;
        } else if (_stepRate < c->accelerateTo && _stepRate < _maxStepRate)
            _stepRate += accelDelta;

        // calculate time for next step
        _stepInterval = 1000000.0 / _stepRate;

		//if (_stepsCompleted % 50 == 0)
		//	Serial.println(_stepRate);


        // see if we've finished
        if (_stepsCompleted >= c->totalSteps) {
            //Serial.println("done");
            dequeue();
        }

        _lastStepTime = time;
    } else {
        // too soon, come back later
    }
}
