#include <AccelStepper.h>
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

#define MAX_CMD_LENGTH 10
#define QUEUE_LENGTH 20

// logobot state info
struct STATE {
  float x;
  float y;
  float ang;
  byte colliding;  // 0 = not colliding, 1=left, 2=right, 3=both
};
STATE state;

Servo penliftServo;

long buzzEnd = 0;

// buffered text to "write" using the pen
String text = "";
float fontSize = 20;  // =em, equal to line spacing (between baselines), text sizes derived from this
float capHeight = fontSize * 0.7;
float letterSpacing = fontSize * 0.1;

// cmd received over serial - builds up char at a time
String cmd;

struct COMMAND {
  String cmd;
};

COMMAND cmdQ[QUEUE_LENGTH];
int qHead = 0;
int qSize = 0;

boolean insertCmd(String s) {
  // inserts s at head of queue
  // return true if inserted ok, false if buffer full

  if (!isQFull()) {
    qHead--;
    if (qHead < 0) qHead += QUEUE_LENGTH;

    cmdQ[qHead].cmd = String(s);

    qSize++;

    return true;
  } else
    return false;
}

boolean pushCmd(String s) {
  // push s onto tail of queue
  // return true if pushed ok, false if buffer full

  if (!isQFull()) {
    int next = qHead + qSize;
    if (next >= QUEUE_LENGTH) next -= QUEUE_LENGTH;

    cmdQ[next].cmd = String(s);

    qSize++;

    return true;
  } else
    return false;
}

String popCmd() {
  // pops head of queue
  if (qSize > 0) {
    String s = cmdQ[qHead].cmd;
    qSize--;
    qHead++;
    if (qHead >= QUEUE_LENGTH) qHead -= QUEUE_LENGTH;
    return s;
  } else
    return "";
}

boolean isQFull() {
  // returns true if full
  return qSize == QUEUE_LENGTH;
}

boolean isQEmpty() {
  return qSize == 0;
}

void printCommandQ()
{
  Serial.print("cmdQ:");
  Serial.print(qHead);
  Serial.print(":");
  Serial.println(qSize);

  for (int i=0; i<qSize; i++) {
    Serial.print(i);
    Serial.print(":");
    int j = qHead + i;
    if (j > QUEUE_LENGTH) j-= QUEUE_LENGTH;
    Serial.println(cmdQ[j].cmd);
  }
}

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
  penUp();

  pinMode(buzzer, OUTPUT);

  for (int i = 0; i < 3; i++) {
    digitalWrite(buzzer, HIGH);
    delay(100);
    digitalWrite(buzzer, LOW);
    delay(25);
  }

  resetPosition();
}

int progStep = 0;


void loop()
{
  // Parse Logo commands from Serial, add to cmdQ
  if (Serial.available()) {
    char c = Serial.read();
    if (c == '\r' || c == '\n') {
      if (cmd != "") {
        if (cmd == "STAT") {
          showStatus();
        } else if (isQFull()) {
            Serial.println("BUSY");
        } else {
            if (cmd[0] == '!') {
                emergencyStop();
                insertCmd(cmd.substring(1));
            } else {
                pushCmd(cmd);
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

    if (isQEmpty()) {

      // check the text writing buffer
      if (text.length() > 0) {
        char c = text[0];
        text = text.substring(1);  // lose the first character
        writeChar(c);

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
      doLogoCommand(popCmd());
    }
  }
}


static void handleCollisions() {
  byte nowColliding = 0;
  if (!digitalRead(switchFL)) nowColliding = 1;
  if (!digitalRead(switchFR)) nowColliding += 2;

  if (nowColliding != state.colliding) {
    // collision state has changed, do something sensible

    if (nowColliding != 0) {
      // Just hit something, so stop and buzz
      emergencyStop();
      buzz(500);
    }

    // Insert some recovery based on which bumper was hit
    // Note since we are inserting at the head of the command queue, the first
    // command we insert will be run second.
    if (nowColliding == 1) {
      insertCmd("RT 45");
      insertCmd("BK 20");
    } else if (nowColliding == 2) {
      insertCmd("LT 45");
      insertCmd("BK 20");
    } else if (nowColliding == 3) {
      insertCmd("RT 120");
      insertCmd("BK 20");
    }

    state.colliding = nowColliding;
  }
}

static void showStatus() 
{
  // Format: "X Y ang qSize"
  Serial.print(state.x);
  Serial.print(" ");
  Serial.print(state.y);
  Serial.print(" ");
  Serial.print(state.ang);
  Serial.print(" ");
  Serial.println(qSize);
}

static void doLogoCommand(String c)
{
  /* Official Logo Commands
       Implemented
         -FD, BK, LT, RT
       Todo
         -PU - Pen Up
         -PD - Pen Down
         -ARC
   */
  /* Unofficial extensions
      BZ n - sound buzzer for n milliseconds
      ST - stop
      SE - emergency stop
      SIG - sign Logobots name
      TO x y
    */

  if (c.startsWith("TO")) {
    // split out x and y co-ordinates
    int sp = c.indexOf(" ",3);
    float x = c.substring(3,sp).toFloat();
    float y = c.substring(sp+1).toFloat();
    driveTo(x,y);
  } else if (c.startsWith("ARC")) {
      // split out x and y co-ordinates
      int sp = c.indexOf(" ",4);
      float x = c.substring(4,sp).toFloat();
      float y = c.substring(sp+1).toFloat();
      arcTo(x,y);
  } else if (c.startsWith("FD")) {
    float dist = c.substring(3).toFloat();
    drive(dist);
  } else if (c.startsWith("BK")) {
    float dist = c.substring(3).toFloat();
    drive(-dist);
  } else if (c.startsWith("RT")) {
    float angle = c.substring(3).toFloat();
    turn(-angle);
  } else if (c.startsWith("LT")) {
    float angle = c.substring(3).toFloat();
    turn(angle);
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
  } else if (c.startsWith("SIG")) {
    writeText("LOGOBOT");
  } else if (c.startsWith("WT")) {
    writeText(c.substring(3));
  } else if (c.startsWith("PQ")) {
    printCommandQ();
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
  pushCmd(s);
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
  insertCmd(s);
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

static void writeChar(char c) {

    switch(c) {
      case 'A':
        writeA();
        break;
      case 'B':
        writeB();
        break;
      case 'C':
        writeC();
        break;
      case 'D':
        writeD();
        break;
      case 'E':
        writeE();
        break;
      case 'F':
        writeF();
        break;
      case 'G':
        writeG();
        break;
      case 'H':
        writeH();
        break;
      case 'I':
        writeI();
        break;
      case 'J':
        writeJ();
        break;
      case 'K':
        writeK();
        break;
      case 'L':
        writeL();
        break;
      case 'M':
        writeM();
        break;
      case 'N':
        writeN();
        break;
      case 'O':
        writeO();
        break;
      case 'P':
        writeP();
        break;
      case 'Q':
        writeQ();
        break;
      case 'R':
        writeR();
        break;
      case 'S':
        writeS();
        break;
      case 'T':
        writeT();
        break;
      case 'U':
        writeU();
        break;
      case 'V':
        writeV();
        break;
      case 'W':
        writeW();
        break;
      case 'X':
        writeX();
        break;
      case 'Y':
        writeY();
        break;
      case 'Z':
        writeZ();
        break;

      default:
        pushCmd("BZ 500");
        break;
    }
}

static void writeText(String s) {
  // overwrite write text
  text = s;
  text.toUpperCase();

  // reset current state
  resetPosition();
}


// Alphabet

#define NEXTLETTER nextLetter(x + w + letterSpacing, y);

static void nextLetter(float x, float y)
{
  pushCmd("PU");
  pushTo(x, y);
}

static void writeA()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x + w/2, y + capHeight);
  pushTo(x + w, y);
  pushCmd("PU");
  pushTo(x + w / 4, y + capHeight / 2);
  pushCmd("PD");
  pushTo(x + 3 * w / 4, y + capHeight / 2 );
  NEXTLETTER
}

static void writeB()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x + 2 * w / 3, y);
  pushTo(x + w, y + capHeight / 4);
  pushTo(x + 2 * w / 3, y + capHeight / 2);
  pushTo(x + w, y + 3 * capHeight / 4);
  pushTo(x + 2 * w / 3, y + capHeight);
  pushTo(x, y + capHeight);
  pushTo(x, y);
  NEXTLETTER
}

static void writeC()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushTo(x + w, y + capHeight);
  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x, y);
  pushTo(x + w, y);
  NEXTLETTER
}

static void writeD()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x + 3 * w / 4, y);
  pushTo(x + w, y + capHeight / 4);
  pushTo(x + w, y + 3 * capHeight / 4);
  pushTo(x + 3 * w / 4, y + capHeight);
  pushTo(x, y + capHeight);
  pushTo(x, y);
  NEXTLETTER
}

static void writeE()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x + w, y + capHeight);
  pushCmd("PU");
  pushTo(x + w, y + capHeight / 2);
  pushCmd("PD");
  pushTo(x, y + capHeight / 2);
  pushTo(x, y);
  pushTo(x + w, y);
  NEXTLETTER
}

static void writeF()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x + w, y + capHeight);
  pushCmd("PU");
  pushTo(x + w, y + capHeight / 2);
  pushCmd("PD");
  pushTo(x, y + capHeight / 2);
  NEXTLETTER
}

static void writeG()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushTo(x + w, y + capHeight);
  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x, y);
  pushTo(x + w, y);
  pushTo(x + w, y + capHeight/3);
  pushTo(x + w/3, y + capHeight/3);
  NEXTLETTER
}

static void writeH()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x, y + capHeight / 2);
  pushTo(x + w, y + capHeight / 2);
  pushTo(x + w, y + capHeight);
  pushTo(x + w, y);
  NEXTLETTER
}

static void writeI()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushTo(x + w / 2, y);
  pushCmd("PD");
  pushTo(x + w / 2, y + capHeight);
  NEXTLETTER
}

static void writeJ()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushTo(x, y + capHeight / 4);
  pushCmd("PD");
  pushTo(x, y);
  pushTo(x + w, y);
  pushTo(x + w, y + capHeight);
  NEXTLETTER
}

static void writeK()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushCmd("PU");
  pushTo(x + w, y + capHeight);
  pushCmd("PD");
  pushTo(x, y + capHeight / 2);
  pushTo(x + w, y);
  NEXTLETTER
}

static void writeL()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x,y);
  pushTo(x + w, y);
  NEXTLETTER
}

static void writeM()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x + w / 2, y + capHeight / 2);
  pushTo(x + w, y + capHeight);
  pushTo(x + w, y);
  NEXTLETTER
}

static void writeN()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x + w, y);
  pushTo(x + w, y + capHeight);
  NEXTLETTER
}

static void writeO()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x + w, y);
  pushTo(x + w, y + capHeight);
  pushTo(x, y + capHeight);
  pushTo(x, y);
  NEXTLETTER
}

static void writeP()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x + w, y + capHeight);
  pushTo(x + w, y + capHeight / 2);
  pushTo(x, y + capHeight / 2);
  NEXTLETTER
}

static void writeQ()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x + w / 2, y);
  pushTo(x + w, y + capHeight / 2);
  pushTo(x + w, y + capHeight);
  pushTo(x, y + capHeight);
  pushTo(x, y);
  pushCmd("PU");
  pushTo(x + w / 2, y + capHeight / 2);
  pushCmd("PD");
  pushTo(x + w, y);
  NEXTLETTER
}

static void writeR()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x + w, y + capHeight);
  pushTo(x + w, y + capHeight / 2);
  pushTo(x, y + capHeight / 2);
  pushTo(x + w, y);
  NEXTLETTER
}

static void writeS()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x + w, y);
  pushTo(x + w, y + capHeight / 2);
  pushTo(x, y + capHeight / 2);
  pushTo(x, y + capHeight);
  pushTo(x + w, y + capHeight);
  NEXTLETTER
}

static void writeT()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;
  pushTo(x + w/2, y);
  pushCmd("PD");
  pushTo(x + w/2, y + capHeight);
  pushTo(x, y + capHeight);
  pushTo(x + w, y + capHeight);
  NEXTLETTER
}

static void writeU()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushTo(x, y + capHeight);
  pushCmd("PD");
  pushTo(x, y);
  pushTo(x + w, y);
  pushTo(x + w, y + capHeight);
  NEXTLETTER
}

static void writeV()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushTo(x, y + capHeight);
  pushCmd("PD");
  pushTo(x + w / 2, y);
  pushTo(x + w, y + capHeight);
  NEXTLETTER
}

static void writeW()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushTo(x, y + capHeight);
  pushCmd("PD");
  pushTo(x + w / 4, y);
  pushTo(x + w / 2, y + capHeight / 2);
  pushTo(x + 3 * w / 4, y);
  pushTo(x + w, y + capHeight);
  NEXTLETTER
}

static void writeX()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x + w, y + capHeight);
  pushCmd("PU");
  pushTo(x, y + capHeight);
  pushCmd("PD");
  pushTo(x + w, y);
  NEXTLETTER
}

static void writeY()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x + w, y + capHeight);
  pushCmd("PU");
  pushTo(x, y + capHeight);
  pushCmd("PD");
  pushTo(x + w / 2, y + capHeight / 2);
  NEXTLETTER
}


static void writeZ()
{
  float x = state.x;
  float y = state.y;
  float w = fontSize * 0.5;

  pushTo(x, y + capHeight);
  pushCmd("PD");
  pushTo(x + w, y + capHeight);
  pushTo(x, y);
  pushTo(x + w, y);
  NEXTLETTER
}


long sqr(long v) {
  return v*v;
}
