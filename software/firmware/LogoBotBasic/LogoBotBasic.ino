#include "Configuration.h"
#include <DifferentialStepper.h>
#include <Bot.h>
#include <Servo.h>

Bot bot(MOTOR_L_PIN_1, MOTOR_L_PIN_2, MOTOR_L_PIN_3, MOTOR_L_PIN_4, MOTOR_R_PIN_1, MOTOR_R_PIN_2, MOTOR_R_PIN_3, MOTOR_R_PIN_4);
String cmd; // cmd received over serial - builds up char at a time

void setup()
{
    initLEDs();
    setLEDColour(0,0,1);  // Blue, as we get started

    Serial.begin(9600);
    Serial.println("Logobot");
    bot.begin();
    bot.initBumpers(SWITCH_FL_PIN, SWITCH_FR_PIN, SWITCH_BL_PIN, SWITCH_BR_PIN, handleCollision);

    initBuzzer();
    playStartupJingle();
}

void loop()
{
    // keep the bot moving (this triggers the stepper motors to move, so needs to be called frequently, i.e. >1KHz)
    bot.run();

    if (!bot.isBusy()) {  // See if the bot has finished whatever it's doing...
        setLEDColour(0,1,0); // Green, because we are happily going forwards
        // keep it moving, until it hits something
        bot.drive(50);
    }
}

static void handleCollision(byte collisionData)
{
    if (collisionData != 0) {
        // Just hit something, so stop, buzz and backoff
        Serial.println("Ouch!");
        bot.emergencyStop();
        bot.buzz(500);
        bot.drive(-20);
        setLEDColour(1,0,0);  // Red, because we hit something
        playGrumpy();
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

static void initBuzzer() {
    pinMode(BUZZER_PIN, OUTPUT);
}

static void playStartupJingle() {
    for (byte i=0; i<3; i++) {
        analogWrite(BUZZER_PIN, 100 + i*50);
        delay(200 + i*50);
    }

    analogWrite(BUZZER_PIN, 0);
}

static void playGrumpy() {
    for (byte i=0; i<2; i++) {
        analogWrite(BUZZER_PIN, 250 - i*100);
        delay(100 + i*100);
    }

    analogWrite(BUZZER_PIN, 0);
}
