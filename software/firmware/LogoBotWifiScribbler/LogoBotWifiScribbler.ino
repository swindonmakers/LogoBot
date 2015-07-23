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

#define dlcs doLogoCommandSync

// Initialize with pin sequence IN1-IN3-IN2-IN4 for using the AccelStepper with 28BYJ-48
AccelStepper stepperL(AccelStepper::HALF4WIRE, motorLPin1, motorLPin3, motorLPin2, motorLPin4);
AccelStepper stepperR(AccelStepper::HALF4WIRE, motorRPin1, motorRPin3, motorRPin2, motorRPin4);

#define STEPS_PER_MM 5000/232;
#define STEPS_PER_DEG 3760.0 / 180.0;

#define MAX_CMD_LENGTH 10
#define QUEUE_LENGTH 20

// position state info
struct POSITION {
  long x;
  long y;
  long ang;
};
POSITION position;

Servo penliftServo;

long buzzEnd = 0;

// buffered text to "write" using the pen
String text = "";

// cmd received over serial - builds up char at a time
String cmd;

struct COMMAND {
  String cmd;
};

COMMAND cmdQ[QUEUE_LENGTH];
int qHead = 0;
int qSize = 0;


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
        Serial.println("OK:" + cmd);
        //doLogoCommand(cmd);
        pushCmd(cmd);
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
  
  Serial.println(c);
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
    */  
  
  if (c.startsWith("TO")) {
    // split out x and y co-ordinates
    int sp = c.indexOf(" ",3);
    int x = c.substring(3,sp).toInt();
    int y = c.substring(sp+1).toInt();
    driveTo(x,y);
  } else if (c.startsWith("FD")) {
    int dist = c.substring(3).toInt();
    drive(dist);
  } else if (c.startsWith("BK")) {
    int dist = c.substring(3).toInt();
    drive(-dist);
  } else if (c.startsWith("RT")) {
    int angle = c.substring(3).toInt();
    turn(-angle);
  } else if (c.startsWith("LT")) {
    int angle = c.substring(3).toInt();
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
    writeLogobot();
  } else if (c.startsWith("WT")) {
    writeText(c.substring(3));
  }
}

void doLogoCommandSync(String cmd)
{
  doLogoCommand(cmd);
 
  // Nasty, really needs to run the main loop.
  while (stepperL.distanceToGo() != 0 || stepperR.distanceToGo() != 0) {
    stepperL.run();
    stepperR.run();
  }
}

void driveTo(long x, long y) {
  // calc angle
  long ang = atan2(y-position.y, x-position.x) * 180 / PI;
  // now angle delta
  ang = ang - position.ang;
  turn(ang);
  
  // and distance
  long dist = sqrt(sqr(y-position.y) + sqr(x-position.x));
  drive(dist);
}

void drive(long distance)
{ 
  // update state
  position.x += distance * cos(position.ang * PI / 180);
  position.y += distance * sin(position.ang * PI / 180);
  
  // prime the move
  distance *= STEPS_PER_MM;
  stepperL.move(distance);
  stepperR.move(distance);
}

void turn(long ang)
{ 
  // update state
  position.ang += ang;
  
  // correct wrap around
  if (position.ang > 360) position.ang -= 360;
  if (position.ang < -360) position.ang += 360;
  
  // prime the move
  ang *= STEPS_PER_DEG;
  stepperR.move(ang);
  stepperL.move(-ang);
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

void writeChar(char c) {
    switch(c) {
        case 'L':
          pushCmd("FD 100");
          pushCmd("PD");
          pushCmd("BK 100");
          pushCmd("RT 90");
          pushCmd("FD 80");
          pushCmd("PU");
          
          pushCmd("FD 50");
          break;
        
        default:
          pushCmd("BZ 500");
          break;
    }
}

void writeText(String s) {
  // overwrite write text
  text = s; 
  
  // reset current state
  resetPosition();
}

void writeLogobot()
{
  // L
  dlcs("FD 100");
  dlcs("PD");
  dlcs("BK 100");
  dlcs("RT 90");
  dlcs("FD 80");
  dlcs("PU");
  
  dlcs("FD 50");
  
  // O
  dlcs("PD");
  dlcs("FD 80");
  dlcs("LT 90");
  dlcs("FD 100");
  dlcs("LT 90");
  dlcs("FD 80");
  dlcs("LT 90");
  dlcs("FD 100");
  dlcs("PU");
  
  dlcs("LT 90");
  dlcs("FD 130");
  
  // G
  dlcs("FD 80");
  dlcs("LT 90");
  dlcs("FD 100");
  dlcs("LT 90");
  dlcs("PD");
  dlcs("FD 80");
  dlcs("LT 90");
  dlcs("FD 100");
  dlcs("LT 90");
  dlcs("FD 80");
  dlcs("LT 90");
  dlcs("FD 60");
  dlcs("PU");
  
  dlcs("BK 60");
  dlcs("RT 90");
  dlcs("FD 50");
  
  // O
  dlcs("PD");
  dlcs("FD 80");
  dlcs("LT 90");
  dlcs("FD 100");
  dlcs("LT 90");
  dlcs("FD 80");
  dlcs("LT 90");
  dlcs("FD 100");
  dlcs("PU");
  
  dlcs("LT 90");
  dlcs("FD 130");

  // B
  dlcs("PD");
  dlcs("FD 80");
  dlcs("LT 90");
  dlcs("FD 40");
  dlcs("LT 50");
  dlcs("FD 40");
  dlcs("RT 100");
  dlcs("FD 40");
  dlcs("LT 50");
  dlcs("FD 40");
  dlcs("LT 90");
  dlcs("FD 80");
  dlcs("LT 90");
  dlcs("FD 100");
  dlcs("PU");
  
  dlcs("LT 90");
  dlcs("FD 130");

  // O
  dlcs("PD");
  dlcs("FD 80");
  dlcs("LT 90");
  dlcs("FD 100");
  dlcs("LT 90");
  dlcs("FD 80");
  dlcs("LT 90");
  dlcs("FD 100");
  dlcs("PU");
  
  dlcs("LT 90");
  dlcs("FD 170");

  // T
  dlcs("LT 90");
  dlcs("PD");
  dlcs("FD 150");
  dlcs("LT 90");
  dlcs("PU");
  dlcs("BK 40");
  dlcs("PD");
  dlcs("FD 400");
  dlcs("PU");
  
  // Get out of the way
  dlcs("RT 45");
  dlcs("FD 2000");
  
}

long sqr(long v) {
  return v*v;
}
