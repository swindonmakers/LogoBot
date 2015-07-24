#include <AccelStepper.h>
#include <Servo.h>

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

#define STEPS_PER_MM 5000/232;
#define STEPS_PER_DEG 3760.0 / 180.0;

#define MAX_CMD_LENGTH 10
#define QUEUE_LENGTH 20

// position state info
struct POSITION {
  float x;
  float y;
  float ang;
};
POSITION position;

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
  position.x = 0;
  position.y = 0;
  position.ang = 0; 
}


void setup()
{  
  Serial.begin(9600);
  Serial.println("Logobot");
  stepperL.setMaxSpeed(1000);
  stepperL.setAcceleration(2000);
  //stepperL.moveTo(5000);
  stepperL.setPinsInverted(true, true, false, false, false);

  stepperR.setMaxSpeed(1000);
  stepperR.setAcceleration(2000);
  //stepperR.moveTo(5000);
  
  pinMode(switchFL, INPUT_PULLUP);
  pinMode(switchFR, INPUT_PULLUP);
  
  pinMode(InternalLED, OUTPUT);
  
  //pinMode(LEDRED, OUTPUT);
  //pinMode(LEDGREEN, OUTPUT);
  //pinMode(LEDBLUE, OUTPUT);
  
  penliftServo.attach(11);
  penUp();
  
  pinMode(buzzer, OUTPUT);
  
  buzz(250);
  
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
        if (pushCmd(cmd))
          Serial.println("OK:" + cmd);
        else
          Serial.println("BUSY");
        cmd = "";
      }
    } else {
      cmd += c;
    }
  }
  
  // Check bump switches
  if (!digitalRead(switchFL) || !digitalRead(switchFR)) {
    buzz(250);
    stepperL.setCurrentPosition(stepperL.currentPosition());
    stepperR.setCurrentPosition(stepperR.currentPosition());
  }
    
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

void doLogoCommand(String c)
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
      SIG - sign Logobots name
      TO x y
    */  
  
  if (c.startsWith("TO")) {
    // split out x and y co-ordinates
    int sp = c.indexOf(" ",3);
    float x = c.substring(3,sp).toFloat();
    float y = c.substring(sp+1).toFloat();
    driveTo(x,y);
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
    stepperL.stop();
    stepperR.stop();
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
  }
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
  float ang = atan2(y-position.y, x-position.x) * 180 / PI;
  // now angle delta
  ang = ang - position.ang;
  turn(ang);
  
  // and distance
  float dist = sqrt(sqr(y-position.y) + sqr(x-position.x));
  String s = "FD ";
  s += dist;
  insertCmd(s);
}

void drive(float distance)
{ 
  // update state
  position.x += distance * cos(position.ang * PI / 180);
  position.y += distance * sin(position.ang * PI / 180);
  
  // prime the move
  int steps = distance * STEPS_PER_MM;
  stepperL.move(steps);
  stepperR.move(steps);
}

void turn(float ang)
{ 
  // update state
  position.ang += ang;
  
  // correct wrap around
  if (position.ang > 360) position.ang -= 360;
  if (position.ang < -360) position.ang += 360;
  
  // prime the move
  int steps = ang * STEPS_PER_DEG;
  stepperR.move(steps);
  stepperL.move(-steps);
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
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
  float w = fontSize * 0.5;

  pushTo(x + w / 2, y);
  pushCmd("PD");
  pushTo(x + w / 2, y + capHeight);
  NEXTLETTER
}

static void writeJ()
{
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x,y);
  pushTo(x + w, y);
  NEXTLETTER
}

static void writeM() 
{
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
  float w = fontSize * 0.5;

  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x + w, y);
  pushTo(x + w, y + capHeight);
  NEXTLETTER
}

static void writeO() 
{
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
  float w = fontSize * 0.5;
  
  pushTo(x, y + capHeight);
  pushCmd("PD");
  pushTo(x + w / 2, y);
  pushTo(x + w, y + capHeight);
  NEXTLETTER
}

static void writeW()
{
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
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
  float x = position.x;
  float y = position.y;
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
