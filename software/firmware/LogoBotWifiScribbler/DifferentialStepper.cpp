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
    _interface = interface;
    _maxSpeed = 1000;
    _minPulseWidth = 1;

    // pins
    _motors[MOTOR_LEFT]._pin[0] = pinL1;
    _motors[MOTOR_LEFT]._pin[1] = pinL2;
    _motors[MOTOR_LEFT]._pin[2] = pinL3;
    _motors[MOTOR_LEFT]._pin[3] = pinL4;

    _motors[MOTOR_RIGHT]._pin[0] = pinR1;
    _motors[MOTOR_RIGHT]._pin[1] = pinR2;
    _motors[MOTOR_RIGHT]._pin[2] = pinR3;
    _motors[MOTOR_RIGHT]._pin[3] = pinR4;

    // init both motors
    int m, i;
    for (m=0; m<2; m++) {
        _motors[m]._currentPos       = 0;
        _motors[m]._direction        = DIRECTION_FWD;
        _motors[m]._enablePin        = 0xff;
        _motors[m]._enableInverted   = false;

        for (i = 0; i < 4; i++)
            _motors[m]._pinInverted[i] = 0;
    }
}

void DifferentialStepper::enableOutputs() {
    if (! _interface) return;

    for (int i=0; i<2; i++)
        enableOutputsFor(&_motors[i]);
}

void DifferentialStepper::enableOutputsFor(Motor *motor) {
    if (! _interface) return;

    pinMode(motor->_pin[0], OUTPUT);
    pinMode(motor->_pin[1], OUTPUT);
    if (_interface == FULL4WIRE || _interface == HALF4WIRE)
    {
        pinMode(motor->_pin[2], OUTPUT);
        pinMode(motor->_pin[3], OUTPUT);
    }
    else if (_interface == FULL3WIRE || _interface == HALF3WIRE)
    {
        pinMode(motor->_pin[2], OUTPUT);
    }

    if (motor->_enablePin != 0xff)
    {
        pinMode(motor->_enablePin, OUTPUT);
        digitalWrite(motor->_enablePin, HIGH ^ motor->_enableInverted);
    }
}

// Prevents power consumption on the outputs
void DifferentialStepper::disableOutputs() {
    if (! _interface) return;

    for (int i=0; i<2; i++)
        disableOutputsFor(&_motors[i]);
}

void DifferentialStepper::disableOutputsFor(Motor *motor) {
    setOutputPinsFor(motor, 0); // Handles inversion automatically
    if (motor->_enablePin != 0xff)
        digitalWrite(motor->_enablePin, LOW ^ motor->_enableInverted);
}

// bit 0 of the mask corresponds to _pin[0]
// bit 1 of the mask corresponds to _pin[1]
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
        digitalWrite(motor->_pin[i], (mask & (1 << i)) ? (HIGH ^ motor->_pinInverted[i]) : (LOW ^ motor->_pinInverted[i]));
}

void DifferentialStepper::setPinsInvertedFor(uint8_t motor, bool pin1Invert, bool pin2Invert, bool pin3Invert, bool pin4Invert, bool enableInvert)
{
    _motors[motor]._pinInverted[0] = pin1Invert;
    _motors[motor]._pinInverted[1] = pin2Invert;
    _motors[motor]._pinInverted[2] = pin3Invert;
    _motors[motor]._pinInverted[3] = pin4Invert;
    _motors[motor]._enableInverted = enableInvert;
}

void DifferentialStepper::setBacklash(unsigned int steps) {
    _backlash = steps;
}

void DifferentialStepper::step(Motor *motor, long step) {
    switch (_interface)
    {
        case DRIVER:
            step1(motor, step);
            break;
        case FULL2WIRE:
            step2(motor, step);
            break;
        case FULL3WIRE:
            step3(motor, step);
            break;
        case FULL4WIRE:
            step4(motor, step);
            break;
        case HALF3WIRE:
            step6(motor, step);
            break;
        case HALF4WIRE:
            step8(motor, step);
            break;
    }
}

// 1 pin step function (ie for stepper drivers)
// This is passed the current step number (0 to 7)
// Subclasses can override
void DifferentialStepper::step1(Motor *motor, long step)
{
    // _pin[0] is step, _pin[1] is direction
    setOutputPinsFor(motor, motor->_direction ? 0b10 : 0b00); // Set direction first else get rogue pulses
    setOutputPinsFor(motor, motor->_direction ? 0b11 : 0b01); // step HIGH
    // Caution 200ns setup time
    // Delay the minimum allowed pulse width
    delayMicroseconds(_minPulseWidth);
    setOutputPinsFor(motor, motor->_direction ? 0b10 : 0b00); // step LOW

}


// 2 pin step function
// This is passed the current step number (0 to 7)
// Subclasses can override
void DifferentialStepper::step2(Motor *motor, long step)
{
    switch (step & 0x3)
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
void DifferentialStepper::step3(Motor *motor,long step)
{
    switch (step % 3)
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
void DifferentialStepper::step4(Motor *motor,long step)
{
    switch (step & 0x3)
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
void DifferentialStepper::step6(Motor *motor,long step)
{
    switch (step % 6)
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
void DifferentialStepper::step8(Motor *motor,long step)
{
    switch (step & 0x7)
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

void DifferentialStepper::setMaxSpeed(float speed) {
    if (speed <0) speed = 0;
    _maxSpeed = speed;
}

void DifferentialStepper::setAcceleration(float acceleration) {
    if (acceleration <= 0) return;
    _acceleration = acceleration;
}


boolean DifferentialStepper::run() {
    return false;
}
