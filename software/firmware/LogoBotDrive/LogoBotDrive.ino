#include "Configuration.h"
#include <DifferentialStepper.h>
#include <Bot.h>
#include <Servo.h>
#include <Wire.h>
#include <SPI.h>
#include <dmtimer.h>
#include <Adafruit_PN532.h>

Bot bot(MOTOR_L_PIN_1, MOTOR_L_PIN_2, MOTOR_L_PIN_3, MOTOR_L_PIN_4, MOTOR_R_PIN_1, MOTOR_R_PIN_2, MOTOR_R_PIN_3, MOTOR_R_PIN_4);
String cmd; // cmd received over serial - builds up char at a time
Adafruit_PN532 nfc(PN532_SCK, PN532_MISO, PN532_MOSI, PN532_SS);
DMTimer checkTimer(2000000);
uint32_t cardval;
uint32_t oldcardval = 0;
bool bot_drive = 1;


void setup()
{
    //initLEDs();
    //setLEDColour(0,0,1);  // Blue, as we get started

    Serial.begin(9600);
    Serial.println("Logobot");
    bot.begin();
    nfc.begin();
    nfc.setPassiveActivationRetries(1);
    nfc.SAMConfig();
    bot.enableLookAhead(true);
    bot.initBumpers(SWITCH_FL_PIN, SWITCH_FR_PIN, SWITCH_BL_PIN, SWITCH_BR_PIN, handleCollision);

    //initBuzzer();
    //playStartupJingle();
}

void loop()
{
    // keep the bot moving (this triggers the stepper motors to move, so needs to be called frequently, i.e. >1KHz)
    bot.run();

    if(checkTimer.isTimeReached()) {
        Serial.println("timeout");
        checkCardAndDirectBot();
    }

    if (!bot.isQFull()) {  // fill up the move queue to get the speed up
        //setLEDColour(0,1,0); // Green, because we are happily doing something
        // keep it moving, until it hits something
        //bot.drive(10);
    }
    
}

void checkCardAndDirectBot() {
  cardval = readNFC();
  Serial.println(cardval);

  if( cardval != oldcardval) {
    oldcardval = cardval;
    Serial.println("card change");
    // different card

    switch(cardval) {
      case 0xFF1E7256: // "56721eff":
      Serial.println("stop card");
      bot_drive = 0;
      break;
    case 0xFF1A4F56:
      Serial.println("
      bot_drive = 1;
      break;
    case 0xFDBB6236: // "3662bbfd":
    case 0xff286476:
      Serial.println("turn -90 card");
      bot.turn(-90);
      break;
    case 0xFDC11086: // "8610c1fd":
    case 0x2d42cff3:
      Serial.println("turn 90 card");
      bot.turn(90);
      break;
    default:
      bot.drive(40);
    }
    
  } else {
    if(bot_drive) {
      bot.drive(10);
    } else {
      bot.stop();
    }
  }
}

uint32_t readNFC() {
  uint8_t success;
  uint8_t uid[] = { 0, 0, 0, 0, 0, 0, 0 };  // Buffer to store the returned UID
  uint8_t uidLength;                        // Length of the UID (4 or 7 bytes depending on ISO14443A card type)
    
  // Wait for an ISO14443A type cards (Mifare, etc.).  When one is found
  // 'uid' will be populated with the UID, and uidLength will indicate
  // if the uid is 4 bytes (Mifare Classic) or 7 bytes (Mifare Ultralight)
  success = nfc.readPassiveTargetID(PN532_MIFARE_ISO14443A, uid, &uidLength);
  
  if (success) {
    // Display some basic information about the card
    //Serial.println("Found an ISO14443A card");
    //Serial.print("  UID Length: ");Serial.print(uidLength, DEC);Serial.println(" bytes");
    //Serial.print("  UID Value: ");
    //nfc.PrintHex(uid, uidLength);
    uint32_t val = *(uint32_t *)uid;
    Serial.println(val, HEX);
    Serial.println("");
    return val;
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
