#include "Configuration.h"
#include <DifferentialStepper.h>
#include <PolarBot.h>
#include <CommandQueue.h>
#include <LogobotText.h>
#include <Servo.h>

// left and right are inverted vs normal LogoBot wiring
// orientations are when looking at the drawing surface from the front
PolarBot bot(MOTOR_R_PIN_1, MOTOR_R_PIN_2, MOTOR_R_PIN_3, MOTOR_R_PIN_4, MOTOR_L_PIN_1, MOTOR_L_PIN_2, MOTOR_L_PIN_3, MOTOR_L_PIN_4);
CommandQueue cmdQ(15);
CommandQueue textQ(20);
String cmd; // cmd received over serial - builds up char at a time
float lineY;  //  stores current line position to allow for writing lines of text

void setup()
{
  Serial.begin(9600);
  Serial.println("Logobot Polar Graph");
  bot.begin();
  bot.initPenLift(SERVO_PIN);
  //bot.initBuzzer(BUZZER_PIN);
  bot.enableLookAhead(true);
  //bot.playStartupJingle();
  LogobotText::begin(textQ);

  // bot will initialise at 260,-300

  // Move to top left of writing window (100, -200)
  //cmdQ.enqueue("", LOGO_CMD_CS);
  lineY = bot.state.y;
}

void loop()
{
  // Parse Logo commands from Serial
  if (Serial.available()) {
    char c = Serial.read();
    
    if (c == '\r' || c == '\n') {  // if found a line end
      if (cmd != "") {  // check the command isn't blank
        if (cmd == "STAT") { // handle status commands: execute immediately, no need to parse and/or queue
          showStatus();
        } else if (cmdQ.isFull()) {
            Serial.println("BUSY");
        } else {
            parseLogoCommand(cmd);
            Serial.println("OK:" + cmd);
        }

        // reset the command buffer
        cmd = "";
      }
    } else {
      cmd += c;  // append the character onto the command buffer
    }
  }

  // keep the bot moving (this triggers the stepper motors to move, so needs to be called frequently, i.e. >1KHz)
  bot.run();

  // dequeue commands from textQ, then cmdQ
  // textQ will be emptied before processing anything in cmdQ
  if (dequeueFrom(textQ))
    dequeueFrom(cmdQ);
}

static boolean dequeueFrom(CommandQueue q) {
  if (!q.isEmpty()) {
    // see if we can queue the next command to the bot...  two situations where we can dequeue:
    //   1) if the next command is a movement command, and the bots motion queue isn't full
    //   2) the bot has finished whatever it was doing
    if ( 
        ( q.peekAtType() <= LOGO_MOVE_CMDS && !bot.isQFull() )
        ||
        !bot.isBusy()
    ) {
        // dequeue and process next command - ultimately passing it over to the bot object for execution
        doLogoCommand(q.dequeue());
    }
  }
  // return true when this queue is empty
  return q.isEmpty();
}

static void showStatus()
{
  // Format: "X Y ang qSize"
  Serial.print((int)bot.state.x);
  Serial.print(',');
  Serial.print((int)bot.state.y);
  Serial.print(',');
  Serial.print((int)bot.state.ang);
  Serial.print(' ');
  Serial.print((int)bot.state.left);
  Serial.print(',');
  Serial.print((int)bot.state.right);
  Serial.print(' ');
  Serial.println(cmdQ.pending());
}


static void parseLogoCommand(String c) {
    // parse and queue/insert
    uint8_t cmdType = 0xff;

    // check for urgent commands
    boolean doNow = false;
    if (cmd[0] == '!') {
        doNow = true;
        c = c.substring(1);
    }

    // parse the command type
    if (c.startsWith("TO")) {
        cmdType = LOGO_CMD_TO;
    } else if (c.startsWith("ARC")) {
        cmdType = LOGO_CMD_ARC;
	} else if (c.startsWith("CIRC")) {
		cmdType = LOGO_CMD_CIRC;
    } else if (c.startsWith("FD")) {
        cmdType = LOGO_CMD_FD;
    } else if (c.startsWith("BK")) {
        cmdType = LOGO_CMD_BK;
    } else if (c.startsWith("RT")) {
        cmdType = LOGO_CMD_RT;
    } else if (c.startsWith("LT")) {
        cmdType = LOGO_CMD_LT;
    } else if (c.startsWith("ST")) {
        cmdType = LOGO_CMD_ST;
    } else if (c.startsWith("SE")) {
        cmdType = LOGO_CMD_SE;
    } else if (c.startsWith("BZ")) {
        cmdType = LOGO_CMD_BZ;
    } else if (c.startsWith("PU")) {
        cmdType = LOGO_CMD_PU;
    } else if (c.startsWith("PD")) {
        cmdType = LOGO_CMD_PD;
    } else if (c.startsWith("PF")) {
        cmdType = LOGO_CMD_PF;
    } else if (c.startsWith("FS")) {
        cmdType = LOGO_CMD_FS;
    } else if (c.startsWith("SIG")) {
        cmdType = LOGO_CMD_SIG;
    } else if (c.startsWith("WT")) {
        cmdType = LOGO_CMD_WT;
    } else if (c.startsWith("PQ")) {
        cmdType = LOGO_CMD_PQ;
    } else if (c.startsWith("CS")) {
		    cmdType = LOGO_CMD_CS;
	  } else if (c.startsWith("NL")) {
        cmdType = LOGO_CMD_NL;
    }

    // give up if command not recognised
    if (cmdType == 0xff) return;

    // lose the command name, keep the parameters
    int sp = c.indexOf(' ');
    if (sp > -1) {
        c = c.substring(sp+1);
    } else {
        c = "";
    }

    // insert/queue the command
    if (doNow) {
        bot.emergencyStop();  // stop the bot, clear any internally queued movement commands
        cmdQ.insert(c, cmdType);  // insert the new command at the head of the command queue
    } else {
        cmdQ.enqueue(c, cmdType);
    }

    // debug what bot is up to
    /*
    Serial.print("CQ Peek: ");
    Serial.println(cmdQ.peekAtType());
    Serial.print("bot.isQFull:");
    Serial.println(bot.isQFull());
    */
}

static void doLogoCommand(COMMAND *c)
{
    if (c == NULL) return;

    /* Official Logo Commands
    Implemented
    -FD, BK, LT, RT
    -PU - Pen Up
    -PD - Pen Down
	-CS - Clear screen - resets logobots position state to x=0, y=0, ang=0
    */
    /* Unofficial extensions
    BZ n - sound buzzer for n milliseconds
    PF n - pause for n milliseconds
    ST - stop
    SE - emergency stop
    FS - set font size
    SIG - sign Logobots name
    TO x y   - straight line to co-ordinates x y
    ARC x y  - smooth arc to co-ordinates x y
	CIRC dia dir - circle dia in dir (dir +ve = anticlockwise)
    */

    // Parse out parameter values
    int sp = c->cmd.indexOf(' ');
    float f1 = 0;
    float f2 = 0;
    if (sp > -1 && c->cmdType != LOGO_CMD_WT) {
        f1 = c->cmd.substring(0,sp).toFloat();
        f2 = c->cmd.substring(sp+1).toFloat();
    } else if (c->cmdType != LOGO_CMD_WT) {
        f1 = c->cmd.toFloat();
    }

    /*
    Serial.print("Do: ");
    Serial.print(c->cmdType);
    Serial.print(' ');
    Serial.print(f1);
    Serial.print(',');
    Serial.print(f2);
    Serial.print(' ');
    Serial.println(c->cmd);
    */

    // Handle each command type
    switch(c->cmdType) {
        case LOGO_CMD_TO:
            bot.driveTo(f1,f2);
            break;
        case LOGO_CMD_ARC:
            bot.arcTo(f1,f2);
            break;
		case LOGO_CMD_CIRC:
			bot.circle(f1, f2);
			break;
        case LOGO_CMD_FD:
            bot.drive(f1);
            break;
        case LOGO_CMD_BK:
            bot.drive( - f1);
            break;
        case LOGO_CMD_LT:
            bot.turn(f1);
            break;
        case LOGO_CMD_RT:
            bot.turn( - f1);
            break;
        case LOGO_CMD_ST:
            bot.stop();
            break;
        case LOGO_CMD_SE:
            bot.emergencyStop();
            break;
        case LOGO_CMD_BZ:
            bot.buzz(f1);
            break;
        case LOGO_CMD_PU:
            bot.penUp();
            break;
        case LOGO_CMD_PD:
            bot.penDown();
            break;
        case LOGO_CMD_PF:
            bot.pause(f1);
            break;
        case LOGO_CMD_FS:
            LogobotText::setFontSize(f1);
            break;
        case LOGO_CMD_SIG:
            writeText("LOGOBOT");
            break;
        case LOGO_CMD_WT:
            writeText(c->cmd);
            break;
        case LOGO_CMD_PQ:
            cmdQ.printCommandQ();
            break;
        case LOGO_CMD_CS:
           bot.driveTo(100,-200);
           lineY = -200;
           break;
        case LOGO_CMD_NL:
           lineY -= LogobotText::getFontSize();
           if (lineY < -600) lineY = -200;
           bot.driveTo(100, lineY);
           break;
    }
}

static void writeText(String s) {
  if (s.length() > 0) {
    char c = s[0];  // grab the next character to write
    
    // put the rest of the command back at the beginning of the queue
    cmdQ.insert(s.substring(1), LOGO_CMD_WT);

    // use the LogobotText library to write the letter
    LogobotText::writeChar(c, bot.state.x, bot.state.y);  
  } 
}
