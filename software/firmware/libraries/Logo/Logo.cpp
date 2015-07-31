#include "Logo.h"

namespace Logo
{
	// Namespace containing private functions
	namespace
	{
		// private variables


        // private functions


	}
	// End private namespace functions


	/*
        Public Methods
    */

    void printProcedures() {
        Serial.println(F("Procedures:"));
        Serial.println(NUM_PROCEDURES);

        char buffer[LOGO_PROCEDURE_NAME_MAX_LENGTH];

        uint8_t len;
        for(uint8_t i=0; i<NUM_PROCEDURES; i++) {
            strcpy_P(buffer, (char*)pgm_read_word(&(PROC_NAMES[i])));
            Serial.println(buffer);
        }
    };

    uint8_t procNameToID(char * procName, uint8_t procNameLen) {
        uint8_t type = 0xff;  // default
        char buffer[LOGO_PROCEDURE_NAME_MAX_LENGTH];

        // look through procedures, see if one matches
        for(uint8_t i=0; i<NUM_PROCEDURES; i++) {
            strcpy_P(buffer, (char*)pgm_read_word(&(PROC_NAMES[i])));
            if (strcmp(buffer, procName) == 0) {
                type = i;
                break;
            }
        }

        return type;
    }

    void parseCommand(String cmd, LogoParsedCommand *pc) {
        // basic token parser
        char procName[LOGO_PROCEDURE_NAME_MAX_LENGTH];
        uint8_t procNameLen = 0;
        char c;

        // reset type on pc
        pc->type = 0xff;

        enum ParseState {
            PROCNAME,
            PARAMS
        };
        ParseState parseState = PROCNAME;

        for (uint8_t i=0; i<cmd.length(); i++) {
            c = cmd[i];

            switch (parseState) {
                case PROCNAME:
                    if (c != ' ') {
                        procName[procNameLen] = toupper(c);
                        procNameLen++;
                    } else {
                        // tack a null on the end of the procName
                        procName[procNameLen] = '\0';
                        pc->type = procNameToID((char*)&procName, procNameLen);
                        parseState = PARAMS;
                    }
                    break;
            }
        }
    };
}
