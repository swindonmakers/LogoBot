#ifndef Logo_h
#define Logo_h

#include <Arduino.h>
#include <avr/pgmspace.h>

// maximum characters in a Logo procedure name
#define LOGO_PROCEDURE_NAME_MAX_LENGTH  5

namespace Logo
{
    // public types

    // built-in procedures
    typedef enum {
        FD =0,
        BK =1,
        LT =2,
        RT =3,
        NUM_PROCEDURES=4
    } LogoProcedureTypes;

    // procedure name declarations - needed to store them in PROGMEM
    const char PROC_FD[] PROGMEM = "FD";
    const char PROC_BK[] PROGMEM = "BK";
    const char PROC_LT[] PROGMEM = "LT";
    const char PROC_RT[] PROGMEM = "RT";

    // procedure names - indices must match LogoProcedureTypes enum
    const char* const PROC_NAMES[] PROGMEM  = {
        PROC_FD,
        PROC_BK,
        PROC_LT,
        PROC_RT
    };

    // command parameter structures
    struct LogoFloatParamters {
        float f1;
        float f2;
    };
    struct LogoLongParamters {
        long l1;
        long l2;
    };
    struct LogoCharParamters {
        uint8_t clen;  // char array length
        char * c;
    };


    // structure to hold parsed commands
    struct LogoParsedCommand {
        uint8_t type;  // 0xff represents undefined

        union {
            LogoFloatParamters fp;
            LogoLongParamters lp;
            LogoCharParamters cp;
        };
    };


	/*
        Public Methods
    */

    // Prints list of procedure names to Serial
    void printProcedures();

    void parseCommand(String cmd, LogoParsedCommand *pc);
};

#endif
