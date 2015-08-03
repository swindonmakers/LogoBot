#ifndef Bot_h
#define Bot_h

#include <Arduino.h>

// Bot tuning and sizing parameters
#define STEPS_PER_MM 5000/232
#define STEPS_PER_DEG 3760.0 / 180.0
#define WHEELSPACING 110
// equivalent to 1.8 * STEPS_PER_MM
#define STEPS_OF_BACKLASH 39

// Math stuff
#define DEGTORAD  PI/180.0
#define RADTODEG  180.0/PI


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

// Piezo buzzer
#define buzzer      10

// Microswitches
#define switchFL    A0
#define switchFR    A1
#define switchBL    A2
#define switchBR    A3

// LED
#define InternalLED         13
#define LEDRED      11
#define LEDGREEN    12
#define LEDBLUE     13

// Servo for Pen Lift (Note same as LED for now)
#define SERVO       11

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
	Bot();
	void begin();
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

	void setBumperCallback(void (*pFunc)(byte collisionData));

private:
	unsigned long buzzEnd;
	void (*bumperCallback)(byte collisionData);
};

#endif