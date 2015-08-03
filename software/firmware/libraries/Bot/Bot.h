#ifndef Bot_h
#define Bot_h

#include <Arduino.h>

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