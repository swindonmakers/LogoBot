#include "Configuration.h"
#include <DifferentialStepper.h>
#include <Bot.h>
#include <Servo.h>

enum Activity
{
  Idle,
  Bored,
  Seek,
  Turn,
  Advance,
  Retreat
};

#define SCAN_SPEED 25 // speed eyes turn, lower is faster.  (delay in ms between moves)
#define DIST_CLOSE 140 // distance in mm for an object to warrant investigation
#define DIST_TOO_CLOSE 70 // distance in mm that bot is too close and should back off
static int lookAng = 90; // current angle bot is looking 0 -> right, 180 -> left, 90 -> straight ahead
static int scanDir = 1; // direction we are panning the servo in - 1 or -1.
static long lastScanMove = 0; // last time we moved the servo
static Activity action = Idle; // current activity the bot is doing

#define BORDEM_THRESHOLD 2 // how long before the bot gets bored and makes a random move
static int blankScanCount = 0; // number of scans with no interaction

Bot bot(MOTOR_L_PIN_1, MOTOR_L_PIN_2, MOTOR_L_PIN_3, MOTOR_L_PIN_4, MOTOR_R_PIN_1, MOTOR_R_PIN_2, MOTOR_R_PIN_3, MOTOR_R_PIN_4);
Servo lidServo;

void setup()
{
    initLEDs();
    setLEDColour(0,0,1);  // Blue, as we get started

    Serial.begin(9600);
    Serial.println("Logobot");
    bot.begin(true);
    bot.enableLookAhead(true);
    bot.initBumpers(SWITCH_FL_PIN, SWITCH_FR_PIN, SWITCH_BL_PIN, SWITCH_BR_PIN, handleCollision);
    bot.initBuzzer(BUZZER_PIN);
    bot.playStartupJingle();

    lidServo.attach(SERVO_PIN);
    lookAt(90);
    
    pinMode(IR_PIN, INPUT);
}

void loop()
{
    // keep the bot moving (this triggers the stepper motors to move, so needs to be called frequently, i.e. >1KHz)
    bot.run();

    // scan servo and check for interaction every so often
    if (lastScanMove < millis()) {
      float dist = readDistance();

      if (dist < DIST_CLOSE) {
        // object close, turn to face or drive towards if already facing
        blankScanCount = 0;
        
        if (lookAng < 90) {
          action = Turn;
          bot.turn(-1);
          lookAng += 1;
          
        } else if (lookAng > 90) {
          action = Turn;
          bot.turn(1);
          lookAng -= 1;
          
        } else if (lookAng == 90) {
          // bot is facing the object
          if (dist < DIST_TOO_CLOSE) {
            // too close!  back off
            if (action != Retreat) bot.stop();
            action = Retreat;
            bot.buzz(10);
            bot.drive(-10);
            
          } else {
            // head for object
            if (action != Advance) bot.stop();
            action = Advance;
            bot.drive(10);
          }
        }
      } else {
        // keep scanning for objects
        if (action != Seek) bot.stop();
        action = Seek;
        lookAng += scanDir;
        
        // switch scan direction if end of servo travel reached
        if (lookAng > 180) {
          scanDir = -1;
        }
        if (lookAng < 0) {
          scanDir = 1;
          blankScanCount++;
        }
      }
      
      lastScanMove = millis() + SCAN_SPEED;
    }

    // Update Servo position
    lookAt(lookAng);
    
    // Update LED
    switch(action) {
      case Idle:
      case Bored:
        setLEDColour(0, 0, 0);
        break;
      case Seek:
        setLEDColour(0, 0, 1);
        break;
      case Turn:
      case Advance:
        setLEDColour(0, 1, 0);
        break;
      case Retreat:
        setLEDColour(1, 0, 0);
        break;
    }

    // Bored, nothing much to see here, wander around a bit in the hope of finding something
    if (action == Seek && blankScanCount > BORDEM_THRESHOLD) {
      action = Bored;
      lookAng = 90;
      if (random(0, 100) > 35)
        bot.driveTo(random(-50, 50), random(-50, 50));
      else
        bot.arcTo(random(-50, 50), random(-50, 50));
      blankScanCount = 0;
      lastScanMove = millis() + 5000;
    }
}

// returns distance in mm
static float readDistance()
{
  return 123438.5 * pow(analogRead(IR_PIN), -1.15);
}

static void handleCollision(byte collisionData)
{
    if (collisionData != 0) {
        // Just hit something, so stop, buzz and backoff
        Serial.println("Ouch!");
        action = Retreat;
        lastScanMove = millis() + 5000;
        bot.emergencyStop();
        bot.buzz(250);
    }

    // Insert some recovery based on which bumper was hit
    // Queue the moves directly to bot, don't bother with Logo command queue
    if (collisionData == 1) { // Front Left
        lookAng=135;
        bot.drive(-20);
        bot.turn(-175);
    } else if (collisionData == 2) { // Front Right
        lookAng=45;
        bot.drive(-20);
        bot.turn(165);
    } else if (collisionData == 4) { // Back left
        lookAng=180;
        bot.drive(20);
        bot.turn(150);
    } else if (collisionData == 8) { // Back right
        lookAng=0;
        bot.drive(20);
        bot.turn(-165);
    } else if (collisionData != 0) {
        bot.turn(-90);
    }
}

static void initLEDs() {
    // LED setup
    pinMode(LED_RED_PIN, OUTPUT);
    pinMode(LED_GREEN_PIN, OUTPUT);
    pinMode(LED_BLUE_PIN, OUTPUT);
    setLEDColour(0,0,0);
}

static void setLEDColour(byte r, byte g, byte b) {
    digitalWrite(LED_RED_PIN, r);
    digitalWrite(LED_GREEN_PIN, g);
    digitalWrite(LED_BLUE_PIN, b);
}

static void lookAt(int ang)
{
    lidServo.write(ang);
}

