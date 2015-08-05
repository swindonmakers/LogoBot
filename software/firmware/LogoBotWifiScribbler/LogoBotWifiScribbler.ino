#include "Configuration.h"
#include <DifferentialStepper.h>
#include <Bot.h>
#include <CommandQueue.h>
#include <LogobotText.h>
#include <Servo.h>

Bot bot(MOTOR_L_PIN_1, MOTOR_L_PIN_2, MOTOR_L_PIN_3, MOTOR_L_PIN_4, MOTOR_R_PIN_1, MOTOR_R_PIN_2, MOTOR_R_PIN_3, MOTOR_R_PIN_4);
CommandQueue cmdQ(20);
String text = ""; // buffered text to "write" using the pen
String cmd; // cmd received over serial - builds up char at a time

void setup()
{
  Serial.begin(9600);
  Serial.println("Logobot");
  bot.begin();
  bot.initBumpers(SWITCH_FL_PIN, SWITCH_FR_PIN, SWITCH_BL_PIN, SWITCH_BR_PIN, handleCollision);
  bot.initPenLift(SERVO_PIN);
  bot.initBuzzer(BUZZER_PIN);
  bot.playStartupJingle();
  LogobotText::begin(cmdQ);
}

void loop()
{
  // Parse Logo commands from Serial, add to cmdQ
  if (Serial.available()) {
    char c = Serial.read();
    if (c == '\r' || c == '\n') {
      if (cmd != "") {
        if (cmd == "STAT") {
          showStatus();
        } else if (cmdQ.isFull()) {
            Serial.println("BUSY");
        } else {
            if (cmd[0] == '!') {
                bot.emergencyStop();
                cmdQ.insert(cmd.substring(1));
            } else {
                cmdQ.enqueue(cmd);
            }
            Serial.println("OK:" + cmd);
        }

        cmd = "";
      }
    } else {
      cmd += c;
    }
  }

  bot.run();

  if (!bot.isBusy()) {
    if (cmdQ.isEmpty()) {

      // check the text writing buffer
      if (text.length() > 0) {
        char c = text[0];
        text = text.substring(1);  // lose the first character
        LogobotText::writeChar(c, bot.state.x, bot.state.y);
      }
    } else {
      // pop and process next command from queue
      doLogoCommand(cmdQ.dequeue());
    }
  }
}

static void handleCollision(byte collisionData)
{
	if (collisionData != 0) {
		// Just hit something, so stop and buzz
		bot.emergencyStop();
		bot.buzz(500);
	}

	// Insert some recovery based on which bumper was hit
	// Note since we are inserting at the head of the command queue, the first
	// command we insert will be run second.
	if (collisionData == 1) {
		cmdQ.insert("RT 30");
		cmdQ.insert("BK 20");
	} else if (collisionData == 2) {
		cmdQ.insert("LT 60");
		cmdQ.insert("BK 20");
	} else if (collisionData == 3) {
		cmdQ.insert("RT 90");
		cmdQ.insert("BK 20");
	}
}

static void showStatus()
{
  // Format: "X Y ang qSize"
  Serial.print(bot.state.x);
  Serial.print(" ");
  Serial.print(bot.state.y);
  Serial.print(" ");
  Serial.print(bot.state.ang);
  Serial.print(" ");
  Serial.println(cmdQ.pending());
}

static void doLogoCommand(String c)
{
  /* Official Logo Commands
       Implemented
         -FD, BK, LT, RT
         -PU - Pen Up
         -PD - Pen Down
         -ARC
   */
  /* Unofficial extensions
      BZ n - sound buzzer for n milliseconds
      ST - stop
      SE - emergency stop
	  FS - set font size
      SIG - sign Logobots name
      TO x y
    */

  if (c.startsWith("TO")) {
    // split out x and y co-ordinates
    int sp = c.indexOf(" ",3);
    bot.driveTo(c.substring(3,sp).toFloat(), c.substring(sp+1).toFloat());
  } else if (c.startsWith("ARC")) {
    // split out x and y co-ordinates
    int sp = c.indexOf(" ",4);
    bot.arcTo(c.substring(4,sp).toFloat(), c.substring(sp+1).toFloat());
  } else if (c.startsWith("FD")) {
    bot.drive(c.substring(3).toFloat());
  } else if (c.startsWith("BK")) {
    bot.drive(-c.substring(3).toFloat());
  } else if (c.startsWith("RT")) {
    bot.turn(-c.substring(3).toFloat());
  } else if (c.startsWith("LT")) {
    bot.turn(c.substring(3).toFloat());
  } else if (c.startsWith("ST")) {
    bot.stop();
  } else if (c.startsWith("SE")) {
    bot.emergencyStop();
  } else if (c.startsWith("BZ")) {
    bot.buzz(c.substring(3).toInt());
  } else if (c.startsWith("PU")) {
    bot.penUp();
  } else if (c.startsWith("PD")) {
    bot.penDown();
  } else if (c.startsWith("PF")) {  // Pause For
    bot.pause(c.substring(3).toInt());
  } else if (c.startsWith("FS")) {
	LogobotText::setFontSize(c.substring(3).toFloat());
  } else if (c.startsWith("SIG")) {
    writeText("Logobot");
  } else if (c.startsWith("WT")) {
    writeText(c.substring(3));
  } else if (c.startsWith("PQ")) {
    cmdQ.printCommandQ();
  }
}


void pushTo(float x, float y)
{
  String s = "TO ";
  s += x;
  s += " ";
  s += y;
  cmdQ.enqueue(s);
}

static void writeText(String s) {
  // overwrite write text
  text = s;
  text.toUpperCase();

  // reset current state
  bot.resetPosition();
}

float sqr(float v) {
  return v*v;
}
