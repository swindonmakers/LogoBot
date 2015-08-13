#ifndef PolarBot_h
#define PolarBot_h

#include <Arduino.h>
#include <DifferentialStepper.h>
#include <Servo.h>

// PolarBot tuning and sizing parameters
#define WHEELDIAMETER 30
#define WHEELCIRCUMFERENCE (PI * WHEELDIAMETER)
#define STEPS_PER_MM 4076 / WHEELCIRCUMFERENCE
#define WHEELSPACING 520
// equivalent to 1.8 * STEPS_PER_MM
#define STEPS_OF_BACKLASH 39

// Math stuff
#define DEGTORAD  PI/180.0
#define RADTODEG  180.0/PI

// logoPolarBot state info
struct STATE {
	// cartesian co-ordinates
	double x;
	double y;
	// fake angle to support various Logo commands
	double ang;

	// string lengths - from capstan to gondola
	float left, right;
};

class PolarBot
{
public:
	PolarBot(uint8_t lp1, uint8_t lp2, uint8_t lp3, uint8_t lp4, uint8_t rp1, uint8_t rp2, uint8_t rp3, uint8_t rp4);
	void begin();

	void initBuzzer(uint8_t pin);
	void initPenLift(uint8_t pin);

	void playStartupJingle();
	bool isBusy();
	bool isQFull();

	void run();

	void penUp();
	void penDown();

	void pause(int len);
	void buzz(int len);

	void stop();
	void emergencyStop();
	void enableLookAhead(boolean v);

    void polarDriveTo(float x, float y);

	void drive(float distance);
	void turn(float ang);
	void drive(float leftDist, float rightDist);
	void driveTo(float x, float y);
	void arcTo(float x, float y);
	void circle(float dia, float direction);


	STATE state;
	void resetPosition();
	void correctAngleWrap();

	DifferentialStepper _diffDrive;

private:
	unsigned long _buzzEnd;
	unsigned long _pauseEnd;

	uint8_t _pinBuzzer;
	uint8_t _pinServo;


	Servo _penliftServo;

};

#endif
