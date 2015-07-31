#include <AccelStepper.h>
#include <Logo.h>
//#include <LogoCommandQueue.h>
#include <Servo.h>

// Maths stuff
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

// Initialize with pin sequence IN1-IN3-IN2-IN4 for using the AccelStepper with 28BYJ-48
AccelStepper stepperL(AccelStepper::HALF4WIRE, motorLPin1, motorLPin3, motorLPin2, motorLPin4);
AccelStepper stepperR(AccelStepper::HALF4WIRE, motorRPin1, motorRPin3, motorRPin2, motorRPin4);

#define STEPS_PER_MM 5000/232
#define STEPS_PER_DEG 3760.0 / 180.0
#define WHEELSPACING 110

// equivalent to 1.8 * STEPS_PER_MM
#define STEPS_OF_BACKLASH   39

//LogoCommandQueue cmdQ(20);

// logobot state info
struct STATE {
  float x;
  float y;
  float ang;
  byte colliding;  // 0 = not colliding, 1=left, 2=right, 3=both
};
STATE state;

Servo penliftServo;

unsigned long buzzEnd = 0;

// buffered text to "write" using the pen
String text = "";

// cmd received over serial - builds up char at a time
String cmd;

Logo::LogoParsedCommand lpc;

// position calcs
void resetPosition() {
  state.x = 0;
  state.y = 0;
  state.ang = 0;
}

void setup()
{
  Serial.begin(9600);
  Serial.println("Logobot");
  stepperL.setMaxSpeed(1000);
  stepperL.setAcceleration(2000);
  stepperL.setBacklash(STEPS_OF_BACKLASH);
  stepperL.setPinsInverted(true, true, false, false, false);

  stepperR.setMaxSpeed(1000);
  stepperR.setAcceleration(2000);
  stepperR.setBacklash(STEPS_OF_BACKLASH);

  pinMode(switchFL, INPUT_PULLUP);
  pinMode(switchFR, INPUT_PULLUP);

  pinMode(InternalLED, OUTPUT);

  //pinMode(LEDRED, OUTPUT);
  //pinMode(LEDGREEN, OUTPUT);
  //pinMode(LEDBLUE, OUTPUT);

  penliftServo.attach(11);
  //penUp();

  //LogobotText::begin(cmdQ);

  pinMode(buzzer, OUTPUT);

  for (int i = 0; i < 3; i++) {
    digitalWrite(buzzer, HIGH);
    delay(100);
    digitalWrite(buzzer, LOW);
    delay(25);
  }

  resetPosition();

  char *temp = "hello";

  lpc.type = Logo::FD;
  lpc.fp.f1 = 12.7;
  lpc.lp.l1 = 12;
  lpc.cp.c = temp;

  delete temp;
  #pragma message(lpc.type)
}

void loop()
{
  /*
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
                emergencyStop();
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

  handleCollisions();

  // Do buzzer
  if (millis() < buzzEnd)
    digitalWrite(buzzer, HIGH);
  else
    digitalWrite(buzzer, LOW);

  // Let steppers run
  stepperL.run();
  stepperR.run();

  // Disable motors when stopped to save power
  // Note that AccelStepper.disableOutputs doesn't seem to work
  // correctly when pins are inverted and leaves some outputs on.
  if (stepperL.distanceToGo() == 0 && stepperR.distanceToGo() == 0) {

    if (cmdQ.isEmpty()) {

      // check the text writing buffer
      if (text.length() > 0) {
        char c = text[0];
        text = text.substring(1);  // lose the first character
        //LogobotText::writeChar(c, state.x, state.y);

      } else {
        // take a breather
        digitalWrite(motorLPin1, LOW);
        digitalWrite(motorLPin2, LOW);
        digitalWrite(motorLPin3, LOW);
        digitalWrite(motorLPin4, LOW);
        digitalWrite(motorRPin1, LOW);
        digitalWrite(motorRPin2, LOW);
        digitalWrite(motorRPin3, LOW);
        digitalWrite(motorRPin4, LOW);
      }
    } else {
      // pop and process next command from queue
      doLogoCommand(cmdQ.dequeue());
    }
  }
  */
}

/*
static void doLogoCommand(String c)
{

  if (c.startsWith("TO")) {
    // split out x and y co-ordinates
    int sp = c.indexOf(" ",3);
    driveTo(c.substring(3,sp).toFloat(), c.substring(sp+1).toFloat());
  } else if (c.startsWith("ARC")) {
    // split out x and y co-ordinates
    int sp = c.indexOf(" ",4);
    arcTo(c.substring(4,sp).toFloat(), c.substring(sp+1).toFloat());
  } else if (c.startsWith("FD")) {
    drive(c.substring(3).toFloat());
  } else if (c.startsWith("BK")) {
    drive(-c.substring(3).toFloat());
  } else if (c.startsWith("RT")) {
    turn(-c.substring(3).toFloat());
  } else if (c.startsWith("LT")) {
    turn(c.substring(3).toFloat());
  } else if (c.startsWith("ST")) {
    stop();
  } else if (c.startsWith("SE")) {
    emergencyStop();
  } else if (c.startsWith("BZ")) {
    buzz(c.substring(3).toInt());
  } else if (c.startsWith("PU")) {
    penUp();
  } else if (c.startsWith("PD")) {
    penDown();
  } else if (c.startsWith("FS")) {
	//LogobotText::setFontSize(c.substring(3).toFloat());
  } else if (c.startsWith("SIG")) {
    //writeText("Logobot");
  } else if (c.startsWith("WT")) {
    writeText(c.substring(3));
  } else if (c.startsWith("PQ")) {
    cmdQ.printCommandQ();
  }
}

void stop() {
  stepperL.stop();
  stepperR.stop();
}

void emergencyStop() {
  stepperL.setCurrentPosition(stepperL.currentPosition());
  stepperL.setSpeed(0);
  stepperR.setCurrentPosition(stepperR.currentPosition());
  stepperR.setSpeed(0);
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
  float ang = atan2(y-state.y, x-state.x) * RADTODEG;
  // now angle delta
  ang = ang - state.ang;
  if (ang > 180)
    ang = -(360 - ang);
  if (ang < -180)
    ang = 360 + ang;

  turn(ang);

  // and distance
  float dist = sqrt(sqr(y-state.y) + sqr(x-state.x));
  String s = "FD ";
  s += dist;
  cmdQ.insert(s);
}

void drive(float distance)
{
  // update state
  state.x += distance * cos(state.ang * DEGTORAD);
  state.y += distance * sin(state.ang * DEGTORAD);

  // prime the move
  int steps = distance * STEPS_PER_MM;
  stepperL.move(steps);
  stepperR.move(steps);
}

void turn(float ang)
{
  // update state
  state.ang += ang;

  // correct wrap around
  if (state.ang > 180) state.ang -= 360;
  if (state.ang < -180) state.ang += 360;

  // prime the move
  int steps = ang * STEPS_PER_DEG;
  stepperR.move(steps);
  stepperL.move(-steps);
}


void arcTo (float x, float y) {

    if (y == 0) return;

    float cx1 = x - state.x;
    float cy1 = y - state.y;

    //v.rotate(degToRad(-this.state.angle));
    float ang = -state.ang * DEGTORAD;
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

    stepperL.move(dl * STEPS_PER_MM);
    stepperR.move(dr * STEPS_PER_MM);
}


void buzz(int len)
{
  buzzEnd = millis() + len;
}

void penUp()
{
  penliftServo.write(10);
}

void penDown()
{
  penliftServo.write(90);
}

static void writeText(String s) {
  // overwrite write text
  text = s;
  text.toUpperCase();

  // reset current state
  resetPosition();
}


long sqr(long v) {
  return v*v;
}
*/
