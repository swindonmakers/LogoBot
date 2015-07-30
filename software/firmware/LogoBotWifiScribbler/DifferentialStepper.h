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

#define DIFFERENTIALSTEPPER_COMMAND_QUEUE_LENGTH  8

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

    typedef enum
    {
        DIRECTION_FWD   = true,
        DIRECTION_BACK  = false
    } Direction;

    typedef enum
    {
        MOTOR_LEFT      = 0,
        MOTOR_RIGHT     = 1
    } WhichMotor;

    struct Motor {
        boolean       direction;
        uint8_t         pin[4];
        uint8_t         pinInverted[4];
        long            currentPos;  // in steps
        bool           enableInverted;  /// Is the enable pin inverted?
        uint8_t        enablePin;   /// Enable pin for stepper driver, or 0xFF if unused.

    };

    // Defines a motion command in the queue
    struct Command {
        unsigned long leftSteps, rightSteps;  // steps per motor
        uint8_t directionBits;  // direction bit for each motor, left=0, right=1, 1=fwd, 0=back
        unsigned long totalSteps;  // max(abs(leftSteps),abs(rightSteps))
        unsigned long accelerateUntil; // The index of the step event on which to stop acceleration
        unsigned long decelerateAfter; // The index of the step event on which to start decelerating

        //maxEntrySpeed;
        boolean busy; // set to true once bresenham initialised and active

    };



    /*
        Constructor
        NOTE: Steppers will initially be disabled
    */
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

    void enableOutputs();
    void disableOutputs();

    /// Sets the inversion for 2, 3 and 4 wire stepper pins
    /// \param[in] pin1Invert True for inverted pin1, false for non-inverted
    /// \param[in] pin2Invert True for inverted pin2, false for non-inverted
    /// \param[in] pin3Invert True for inverted pin3, false for non-inverted
    /// \param[in] pin4Invert True for inverted pin4, false for non-inverted
    /// \param[in] enableInvert    True for inverted enable pin, false (default) for non-inverted
    void    setPinsInvertedFor(uint8_t motor, bool pin1Invert, bool pin2Invert, bool pin3Invert, bool pin4Invert, bool enableInvert);

    /// Sets the number of steps needed to correct backlash in drive train
    void    setBacklash(unsigned int steps);

    void step(Motor *motor);

    void setMaxStepRate(unsigned long speed);
    void setMinStepRate(unsigned long speed);

    void setAcceleration(float acceleration);

    boolean isQFull();
    boolean isQEmpty();

    void reset();  // empty queue, immediate stop, no change in enable/disable status

    //void stop();  // graceful stop with deacceleration
    void stopAfter();  // stop after current move command completes

    boolean queueMove(long leftPos, long rightPos);

    boolean run();  // return true if still moving

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







private:
    uint8_t     _interface; // See MotorInterfaceType
    boolean     _enabled;
    Motor       _motors[2];

    unsigned long   _maxStepRate;  // in steps/sec
    unsigned long   _minStepRate;  // in steps/sec
    float           _acceleration;  // in steps/sec2
    unsigned long   _accelDist;  // distance required for acceleration to fullspeed (or stop), given _minStepRate, _maxStepRate and _


    unsigned int    _minPulseWidth;
    unsigned int    _backlash;

    Command         _q[DIFFERENTIALSTEPPER_COMMAND_QUEUE_LENGTH];
    uint8_t         _qHead = 0;
    uint8_t         _qSize = 0;

    // step control
    long            _counterLeft, _counterRight;
    unsigned long   _stepsCompleted;
    unsigned long   _lastStepTime;
    unsigned long   _stepInterval;
    float           _stepRate;  // in steps per second


    void enableOutputsFor(Motor *motor);
    void disableOutputsFor(Motor *motor);

    void setOutputPinsFor(Motor *motor, uint8_t mask);

    void step1(Motor *motor);
    void step2(Motor *motor);
    void step3(Motor *motor);
    void step4(Motor *motor);
    void step6(Motor *motor);
    void step8(Motor *motor);

    void calculateAccelDist();

    void dequeue();  // removes head of queue
    Command *getCurrentCommand();  // return pointer to current command (head of queue)
};


#endif
