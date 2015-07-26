// DifferentialStepper library
// borrowing elements from AccelStepper, marlin and others

#ifndef DifferentialStepper_h
#define DifferentialStepper_h

#include <stdlib.h>
#if ARDUINO >= 100
#include <Arduino.h>
#else
#include <WProgram.h>
#include <wiring.h>
#endif


class DifferentialStepper
{
public:

    typedef enum
    {
    	FUNCTION  = 0, ///< Use the functional interface, implementing your own driver functions (internal use only)
    	DRIVER    = 1, ///< Stepper Driver, 2 driver pins required
    	FULL2WIRE = 2, ///< 2 wire stepper, 2 motor pins required
    	FULL3WIRE = 3, ///< 3 wire stepper, such as HDD spindle, 3 motor pins required
            FULL4WIRE = 4, ///< 4 wire full stepper, 4 motor pins required
    	HALF3WIRE = 6, ///< 3 wire half stepper, such as HDD spindle, 3 motor pins required
    	HALF4WIRE = 8  ///< 4 wire half stepper, 4 motor pins required
    } MotorInterfaceType;




    // NOTE: Steppers will initially be disabled
    DifferentialStepper(
        uint8_t interface = DifferentialStepper::FULL4WIRE,
        uint8_t pinL1 = 2,
        uint8_t pinL2 = 3,
        uint8_t pinL3 = 4,
        uint8_t pinL4 = 5,
        uint8_t pinR1 = 6,
        uint8_t pinR2 = 7,
        uint8_t pinR3 = 8,
        uint8_t pinR4 = 9
    );

    /*
    void    moveTo(long absolute);

    void    move(long relative);

    boolean run();

    void    setMaxSpeed(float speed);

    void    setAcceleration(float acceleration);

    float   speed();

    long    distanceToGo();

    long    targetPosition();

    long    currentPosition();

    void    setCurrentPosition(long position);

    void stop();

    virtual void    disableOutputs();

    virtual void    enableOutputs();

    void    setMinPulseWidth(unsigned int minWidth);

    /// Sets the number of steps needed to correct backlash in drive train
    void    setBacklash(unsigned long steps);
    */


protected:

    typedef enum
    {
        DIRECTION_FWD   = true,
        DIRECTION_BACK  = false
    } Direction;

    typedef enum
    {
        MOTOR_LEFT = 0,
        MOTOR_RIGHT = 1
    } WhichMotor;

    struct Motor {
        Direction _direction = DIRECTION_FWD;
    };





private:
    uint8_t     _interface;          // 0, 1, 2, 4, 8, See MotorInterfaceType

    Motor       motors[2];


};


#endif
