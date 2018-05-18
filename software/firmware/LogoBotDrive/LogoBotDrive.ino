#include "Configuration.h"
#include <DifferentialStepper.h>
#include <Bot.h>
#include <Servo.h>
#include <Wire.h>
#include <SPI.h>
#include <Adafruit_PN532.h>
#include <dmtimer.h>
#include <MFRC522.h>


Bot bot(MOTOR_L_PIN_1, MOTOR_L_PIN_2, MOTOR_L_PIN_3, MOTOR_L_PIN_4, MOTOR_R_PIN_1, MOTOR_R_PIN_2, MOTOR_R_PIN_3, MOTOR_R_PIN_4);
String cmd; // cmd received over serial - builds up char at a time
Adafruit_PN532 nfc(PN532_SCK, PN532_MISO, PN532_MOSI, PN532_SS);
//MFRC522 mfrc522(PN532_SS);  // Create MFRC522 instance
DMTimer cardTimer(2000000);
char tokenStr[14]; // token as hex string

void updateTokenStr(const uint8_t *data, const uint32_t numBytes) {
  const char * hex = "0123456789abcdef";
  uint8_t b = 0;
  for (uint8_t i = 0; i < numBytes; i++) {
        tokenStr[b] = hex[(data[i]>>4)&0xF];
        b++;
        tokenStr[b] = hex[(data[i])&0xF];
        b++;
  }

  // null remaining bytes in string
  for (uint8_t i=numBytes; i < 7; i++) {
        tokenStr[b] = 0;
        b++;
        tokenStr[b] = 0;
        b++;
  }
}

void setup()
{
    //initLEDs();
    //setLEDColour(0,0,1);  // Blue, as we get started

    Serial.begin(9600);
    Serial.println("Logobot");
    bot.begin();
    SPI.begin();      // Init SPI bus
//    mfrc522.PCD_Init();   // Init MFRC522
//    mfrc522.PCD_DumpVersionToSerial();  // Show details of PCD - MFRC522 Card Reader details
    nfc.begin();
    nfc.SAMConfig();
    //nfc.setPassiveActivationRetries(1);
    bot.enableLookAhead(true);
//    bot.initBumpers(SWITCH_FL_PIN, SWITCH_FR_PIN, SWITCH_BL_PIN, SWITCH_BR_PIN, handleCollision);

    //initBuzzer();
    //playStartupJingle();
}

void loop()
{
    // keep the bot moving (this triggers the stepper motors to move, so needs to be called frequently, i.e. >1KHz)
    bot.run();

    if ( cardTimer.isTimeReached()) {
      Serial.println("timeout");
 //     if( mfrc522.PICC_IsNewCardPresent()) {
 //       if ( mfrc522.PICC_ReadCardSerial() ) {
          uint8_t* uid = readNFC();
          //updateTokenStr(mfrc522.uid.uidByte, mfrc522.uid.size);
          Serial.print("Found token:");
          Serial.println(String(*uid));
          bot.stop();
        //}
      //}
    } else
    if (!bot.isQFull()) {  // fill up the move queue to get the speed up
        //setLEDColour(0,1,0); // Green, because we are happily doing something
        // keep it moving, until it hits something
        bot.drive(10);
    }
}


uint8_t* readNFC() {
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
    Serial.print("  UID Value: ");
    nfc.PrintHex(uid, uidLength);
    Serial.println("");   
  }
  return uid;
}

static void handleCollision(byte collisionData)
{
    if (collisionData != 0) {
        // Just hit something, so stop, buzz and backoff
        //setLEDColour(1,0,0);  // Red, because we hit something
        Serial.println("Ouch!");
        bot.emergencyStop();
        bot.buzz(500);
        bot.drive(-20);
        //playGrumpy();
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



