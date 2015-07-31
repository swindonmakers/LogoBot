#ifndef Logo_h
#define Logo_h

#include <Arduino.h>

namespace Logo
{
    // public types

    // built-in procedures
    typedef enum {
        FD =0,
        BK =1,
        LT =2,
        RT =3
    } LogoProcedureTypes;

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
        uint8_t type;

        union {
            LogoFloatParamters fp;
            LogoLongParamters lp;
            LogoCharParamters cp;
        };
    };


	// public methods
};

#endif
