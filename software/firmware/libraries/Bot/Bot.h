#ifndef Bot_h
#define Bot_h

#include <Arduino.h>
#include <AccelStepper.h>
#include <Servo.h>

// Bot tuning and sizing parameters
#define STEPS_PER_MM 5000/232
#define STEPS_PER_DEG 3760.0 / 180.0
#define WHEELSPACING 110
// equivalent to 1.8 * STEPS_PER_MM
#define STEPS_OF_BACKLASH 39

// Math stuff
#define DEGTORAD  PI/180.0
#define RADTODEG  180.0/PI

// logobot state info
struct STATE {
	float x;
	float y;
	float ang;
	byte colliding;  // 0 = not colliding, 1=left, 2=right, 3=both
};

class Bot
{
public:
	Bot(int lp1, int lp2, int lp3, int lp4, int rp1, int rp2, int rp3, int rp4);
	void begin();
	
	void initBuzzer(int pin);
	void initBumpers(int fl, int fr, int bl, int br, void (*pFunc)(byte collisionData));
	void initPenLift(int pin);

	void playStartupJingle();
	bool isMoving();

	void run();

	void penUp();
	void penDown();

	void buzz(int len);

	void stop();
	void emergencyStop();
	void drive(float distance);
	void turn(float ang);

	STATE state;
	void resetPosition();

private:
	unsigned long _buzzEnd;
	void (*bumperCallback)(byte collisionData);

	int _pinBuzzer;
	int _switchFL;
	int _switchFR;
	int _switchBL;
	int _switchBR;
	int _pinStepper[8];

	AccelStepper _stepperL;
	AccelStepper _stepperR;
	Servo _penliftServo;

};

#endif
