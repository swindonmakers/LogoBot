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

Servo penliftServo;

long buzzEnd = 0;


void setup()
{  
  Serial.begin(9600);
  Serial.println("Logobot");
  stepperL.setMaxSpeed(1000);
  stepperL.setAcceleration(500);
  //stepperL.moveTo(5000);
  stepperL.setPinsInverted(true, true, false, false, false);

  stepperR.setMaxSpeed(1000);
  stepperR.setAcceleration(500);
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
}

int progStep = 0;

String cmd;

void loop()
{
  // Process Logo commands from Serial
  if (Serial.available()) {
    char c = Serial.read();
    if (c == '\r' || c == '\n') {
      if (cmd != "") {
        Serial.println("OK:" + cmd);
        doLogoCommand(cmd);
        cmd = "";
      }
    } else {
      cmd += c;
    }
  }

  // Check bump switches
  if (!digitalRead(switchFL) || !digitalRead(switchFR)) {
    buzz(250);
    stepperL.stop();
    stepperR.stop();
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
      digitalWrite(motorLPin1, LOW);
      digitalWrite(motorLPin2, LOW);
      digitalWrite(motorLPin3, LOW);
      digitalWrite(motorLPin4, LOW);
      digitalWrite(motorRPin1, LOW);
      digitalWrite(motorRPin2, LOW);
      digitalWrite(motorRPin3, LOW);
      digitalWrite(motorRPin4, LOW);
  }
}

void doLogoCommand(String cmd)
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
    */  
  
  if (cmd.startsWith("FD")) {
    int dist = cmd.substring(3).toInt();
    driveForward(dist);
  } else if (cmd.startsWith("BK")) {
    int dist = cmd.substring(3).toInt();
    driveBackward(dist);
  } else if (cmd.startsWith("RT")) {
    int angle = cmd.substring(3).toInt();
    rightTurn(angle * 3760.0 / 180.0);
  } else if (cmd.startsWith("LT")) {
    int angle = cmd.substring(3).toInt();
    leftTurn(angle * 3760.0 / 180.0);
  } else if (cmd.startsWith("ST")) {
    stepperL.stop();
    stepperR.stop();
  } else if (cmd.startsWith("BZ")) {
    buzz(cmd.substring(3).toInt());
  } else if (cmd.startsWith("PU")) {
    penUp();
  } else if (cmd.startsWith("PD")) {
    penDown();
  } else if (cmd.startsWith("SIG")) {
    sign();
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

void driveForward(long distance)
{
  stepperL.move(distance);
  stepperR.move(distance);
}

void driveBackward(long distance)
{
  stepperL.move(-distance);
  stepperR.move(-distance);
}

void leftTurn(long distance)
{
  stepperR.move(distance);
  stepperL.move(-distance);
}

void rightTurn(long distance)
{
  stepperR.move(-distance);
  stepperL.move(distance);
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

void sign()
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
