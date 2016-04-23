#include "Configuration.h"
#include <DifferentialStepper.h>
#include <Bot.h>
#include <Servo.h>

Bot bot(MOTOR_L_PIN_1, MOTOR_L_PIN_2, MOTOR_L_PIN_3, MOTOR_L_PIN_4, MOTOR_R_PIN_1, MOTOR_R_PIN_2, MOTOR_R_PIN_3, MOTOR_R_PIN_4);
String cmd; // cmd received over serial - builds up char at a time

#define LOCKOUT_TIME 2000
unsigned long lockoutUntil = 0; // time to lockout controls until

void setup()
{
    Serial.begin(9600);

    initLEDs();
    setLEDColour(0,0,1);  // Blue, as we get started

    bot.begin();
    bot.enableLookAhead(true);
    bot.initBumpers(SWITCH_FL_PIN, SWITCH_FR_PIN, SWITCH_BL_PIN, SWITCH_BR_PIN, handleCollision);
    bot.initBuzzer(BUZZER_PIN);
    bot.playStartupJingle();
}

void loop()
{
    // keep the bot moving (this triggers the stepper motors to move, so needs to be called frequently, i.e. >1KHz)
    bot.run();

    // Parse remote control data from Serial
    if (Serial.available()) {
      char c = Serial.read();
      if (c == '\r' || c == '\n') {  // if found a line end
        if (cmd != "") {  // check the command isn't blank
          if (cmd.startsWith("[WSc][js]")) { 
            // command is a joystick position
            reactToJoystick(cmd);
          }
          // reset the command buffer
          cmd = "";
        }
      } else {
        cmd += c;  // append the character onto the command buffer
      }
    }

}

static bool lockedOut()
{
  return millis() < lockoutUntil;
}

static void reactToJoystick(String c)
{
  // Expected message : [WSc][js]991,375,0,0
  // X, Y, B1, B2

  // Remove [WSc][js] header
  c = c.substring(9);

  int com1 = c.indexOf(',');
  int com2 = c.indexOf(',', com1 + 1);
  int com3 = c.indexOf(',', com2 + 1);

  if (com1 == -1 || com2 == -1 || com3 == -1)
    return; // bad data

  int x = c.substring(0, com1).toInt();
  int y = c.substring(com1 + 1, com2).toInt();
  int b1 = c.substring(com2 + 1, com3).toInt();
  int b2 = c.substring(com3 + 1).toInt();

  // TODO drive!
  int spd = 0;
  int turn = 0;
  // y: 0 is forward, 1023 back, center ~ 500
  // x: 0 is left, 1023 is right, center ~500

  if (y < 350 || y > 650) // center dead zone
    spd = -map(y, 0, 1023, -100, 100); // maps speed into range -100...100
  if (x < 350 || x > 650) // center dead zone
    turn = -map(x, 0, 1023, -45, 45); // map turn into and angle -45...45

  if (!lockedOut()) {
    if (spd != 0) { // drive takes priority
      bot.drive(spd);
    }
    else if (turn != 0) { // then turn
      bot.turn(turn);
    }
    else { // or stop if all centered
      bot.stop();
    }
  }
}

static void handleCollision(byte collisionData)
{
    if (collisionData != 0) {
        // Just hit something, so stop, buzz and backoff
        setLEDColour(1,0,0);  // Red, because we hit something
        Serial.println("Ouch!");
        bot.emergencyStop();
        bot.buzz(500);
        bot.drive(-20);
        playGrumpy();
        lockoutUntil = millis() + LOCKOUT_TIME;
    }

    // Insert some recovery based on which bumper was hit
    // Queue the moves directly to bot, don't bother with Logo command queue
    if (collisionData == 1) {
        bot.turn(-30);
    } else if (collisionData == 2) {
        bot.turn(60);
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

static void playGrumpy() {
    for (byte i=0; i<2; i++) {
        analogWrite(BUZZER_PIN, 250 - i*100);
        delay(100 + i*100);
    }

    analogWrite(BUZZER_PIN, 0);
}
