#include "Configuration.h"
#include <DifferentialStepper.h>
#include <Bot.h>
#include <Servo.h>

Bot bot(MOTOR_L_PIN_1, MOTOR_L_PIN_2, MOTOR_L_PIN_3, MOTOR_L_PIN_4, MOTOR_R_PIN_1, MOTOR_R_PIN_2, MOTOR_R_PIN_3, MOTOR_R_PIN_4);
String cmd; // cmd received over serial - builds up char at a time

void setup()
{
  Serial.begin(9600);
  Serial.println("Logobot");
  bot.begin();
  bot.initBumpers(SWITCH_FL_PIN, SWITCH_FR_PIN, SWITCH_BL_PIN, SWITCH_BR_PIN, handleCollision);
  bot.initBuzzer(BUZZER_PIN);
  bot.playStartupJingle();
}

void loop()
{
  // keep the bot moving (this triggers the stepper motors to move, so needs to be called frequently, i.e. >1KHz)
  bot.run();

  if (!bot.isBusy()) {  // See if the bot has finished whatever it's doing...
    // keep it moving, until it hits something
    bot.drive(50);
  }
}

static void handleCollision(byte collisionData)
{
	if (collisionData != 0) {
		// Just hit something, so stop, buzz and backoff
		bot.emergencyStop();
		bot.buzz(500);
		bot.drive(-20);
	}

	// Insert some recovery based on which bumper was hit
	// Queue the moves directly to bot, don't bother with Logo command queue
	if (collisionData == 1) {
        bot.turn(-30);
	} else if (collisionData == 2) {
        bot.turn(60);
	} else if (collisionData != 0) {
        bot.turn(-90);
	}
}
