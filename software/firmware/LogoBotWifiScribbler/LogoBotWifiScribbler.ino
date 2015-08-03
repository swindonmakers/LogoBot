#include <AccelStepper.h>
#include <Bot.h>
#include <CommandQueue.h>
#include <LogobotText.h>
#include <Servo.h>

Bot bot;
CommandQueue cmdQ(20);
String text = ""; // buffered text to "write" using the pen
String cmd; // cmd received over serial - builds up char at a time

void setup()
{
  Serial.begin(9600);
  Serial.println("Logobot");
  bot.begin();
  bot.setBumperCallback(handleCollision);
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

  if (!bot.isMoving()) {
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
		cmdQ.insert("RT 45");
		cmdQ.insert("BK 20");
	} else if (collisionData == 2) {
		cmdQ.insert("LT 45");
		cmdQ.insert("BK 20");
	} else if (collisionData == 3) {
		cmdQ.insert("RT 120");
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
    driveTo(c.substring(3,sp).toFloat(), c.substring(sp+1).toFloat());
  } else if (c.startsWith("ARC")) {
    // split out x and y co-ordinates
    int sp = c.indexOf(" ",4);
    arcTo(c.substring(4,sp).toFloat(), c.substring(sp+1).toFloat());
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

static void driveTo(float x, float y) {
  // calc angle
  float ang = atan2(y-bot.state.y, x-bot.state.x) * RADTODEG;
  // now angle delta
  ang = ang - bot.state.ang;
  if (ang > 180)
    ang = -(360 - ang);
  if (ang < -180)
    ang = 360 + ang;

  bot.turn(ang);

  // and distance
  float dist = sqrt(sqr(y-bot.state.y) + sqr(x-bot.state.x));
  String s = "FD ";
  s += dist;
  cmdQ.insert(s);
}

void arcTo (float x, float y) {

    if (y == 0) return;

    float cx1 = x - bot.state.x;
    float cy1 = y - bot.state.y;

    //v.rotate(degToRad(-this.state.angle));
    float ang = -bot.state.ang * DEGTORAD;
    float ca = cos(ang);
    float sa = sin(ang);
    float cx = cx1 * ca - cy1 * sa;
    float cy = cx1 * sa + cy1 * ca;

    float m = -cx / cy;

    // calc centre of arc
    // from equation
    // y - y1 = m (x - x1)
    // rearranged to find y axis intersection
    // x = (-y1)/m + x1
    float x1 = -(cy/2.0) / m + (cx/2.0);

    float dl = 0, dr = 0;
    float targetAng;
    float cl, cr;

    if (x1 < 0) {
        targetAng = atan2(cy, -x1 + cx) * RADTODEG;

        cl = 2.0 * PI * (-WHEELSPACING/2.0 - x1);
        dl = cl * targetAng/360.0;

        cr = 2.0 * PI * (WHEELSPACING/2.0 - x1);
        dr = cr * targetAng/360.0;

    } else {
        targetAng = atan2(cy, x1 - cx) * RADTODEG;

        cl = 2.0 * PI * (x1 + WHEELSPACING/2.0 );
        dl = cl * targetAng/360.0;

        cr = 2.0 * PI * (x1 - WHEELSPACING/2.0);
        dr = cr * targetAng/360.0;
    }

    //stepperL.move(dl * STEPS_PER_MM);
    //stepperR.move(dr * STEPS_PER_MM);
}

static void writeText(String s) {
  // overwrite write text
  text = s;
  text.toUpperCase();

  // reset current state
  bot.resetPosition();
}

long sqr(long v) {
  return v*v;
}
