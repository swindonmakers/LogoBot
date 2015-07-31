#include <DifferentialStepper.h>

/*
    Basic
    -----

    Illustrates basic usage of the DifferentialStepper class.
    loop() will repeatedly queue random movements
*/

// Pin definitions
// Left motor driver
#define motorLPin1  2     // IN1 on the ULN2003 driver 1
#define motorLPin2  3     // IN2 on the ULN2003 driver 1
#define motorLPin3  4     // IN3 on the ULN2003 driver 1
#define motorLPin4  5     // IN4 on the ULN2003 driver 1

// Right motor driver
#define motorRPin1  6     // IN1 on the ULN2003 driver 1
#define motorRPin2  7     // IN2 on the ULN2003 driver 1
#define motorRPin3  8     // IN3 on the ULN2003 driver 1
#define motorRPin4  9     // IN4 on the ULN2003 driver 1

// calibration info
#define STEPS_PER_MM 5000/232
#define STEPS_PER_DEG 3760.0 / 180.0
#define WHEELSPACING 110

// create diffDrive object
DifferentialStepper diffDrive(
    DifferentialStepper::HALF4WIRE,
    motorLPin1,motorLPin3,motorLPin2,motorLPin4,
    motorRPin1,motorRPin3,motorRPin2,motorRPin4
);

void setup()
{
    // invert the direction of the left motor
    diffDrive.setInvertDirectionFor(0, true);

    // set acceleration in steps per second ^ 2
    diffDrive.setAcceleration(100);

    // queue up an initial move, approx 10mm forward on both wheels
    diffDrive.queueMove(10 * STEPS_PER_MM, 10 * STEPS_PER_MM);
}

void loop()
{
    // call this regularly (at least 1kHz) to drive the motors
    diffDrive.run();

    // see if the queued moves have finished
    if (diffDrive.isQEmpty()) {
        // queue up a random move, between -25mm and 25mm for each wheel
        diffDrive.queueMove(
            (random(0,50)-25) * STEPS_PER_MM,
            (random(0,50)-25) * STEPS_PER_MM
        );
    }
}
