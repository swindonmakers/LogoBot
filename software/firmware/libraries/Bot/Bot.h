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
	Bot(uint8_t lp1, uint8_t lp2, uint8_t lp3, uint8_t lp4, uint8_t rp1, uint8_t rp2, uint8_t rp3, uint8_t rp4);
	void begin();
	
	void initBuzzer(uint8_t pin);
	void initBumpers(uint8_t pinFL, uint8_t pinFR, uint8_t pinBL, uint8_t pinBR, void (*pFunc)(byte collisionData));
	void initPenLift(uint8_t pin);

	void playStartupJingle();
	bool isMoving();

	void run();

	void penUp();
	void penDown();

	void buzz(uint8_t len);

	void stop();
	void emergencyStop();
	void drive(float distance);
	void turn(float ang);

	STATE state;
	void resetPosition();

private:
	unsigned long _buzzEnd;
	void (*bumperCallback)(byte collisionData);

	uint8_t _pinBuzzer;
	uint8_t _pinSwitchFL;
	uint8_t _pinSwitchFR;
	uint8_t _pinSwitchBL;
	uint8_t _pinSwitchBR;
	uint8_t _pinStepper[8];

	AccelStepper _stepperL;
	AccelStepper _stepperR;
	Servo _penliftServo;

};

#endif
