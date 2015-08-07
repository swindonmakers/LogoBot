#include "Configuration.h"
#include <DifferentialStepper.h>
#include <Bot.h>
#include <Servo.h>

Bot bot(MOTOR_L_PIN_1, MOTOR_L_PIN_2, MOTOR_L_PIN_3, MOTOR_L_PIN_4, MOTOR_R_PIN_1, MOTOR_R_PIN_2, MOTOR_R_PIN_3, MOTOR_R_PIN_4);

void setup()
{
  Serial.begin(9600);
  Serial.println("Logobot");
  bot.begin();
  bot.initBumpers(SWITCH_FL_PIN, SWITCH_FR_PIN, SWITCH_BL_PIN, SWITCH_BR_PIN, handleCollision);
  bot.initBuzzer(BUZZER_PIN);
  //bot.lookAheadEnable(true);
  bot.playStartupJingle();
}

void loop()
{

  // keep the bot moving (this triggers the stepper motors to move, so needs to be called frequently, i.e. >1KHz)
  //bot.run();

  // check sensor value, report on Serial
  delay(500);
  Serial.println(digitalRead(IR_LEFT_PIN));
}

static void handleCollision(byte collisionData)
{
	if (collisionData != 0) {
		// Just hit something, so stop and buzz
		bot.emergencyStop();  // this will be called by parseLogoCommand
		bot.buzz(500);
	}

	// Insert some recovery based on which bumper was hit
	bot.drive(-20);
	if (collisionData == 1) {
        bot.turn(-30);
	} else if (collisionData == 2) {
        bot.turn(60);
	} else {
        bot.turn(-90);
	}
}
