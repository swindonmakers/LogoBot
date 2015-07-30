#include "LogobotText.h"

LogobotText::LogobotText(CommandQueue& cmdQ)
	: _cmdQ(cmdQ)
{
}

void LogobotText::pushCmd(String cmd)
{
	_cmdQ.enqueue(cmd);
}

void LogobotText::pushTo(float x, float y)
{
	String s = "TO ";
	s += x;
	s += " ";
	s += y;
	pushCmd(s);
}

// Alphabet
void LogobotText::writeA(float x, float y)
{
  pushCmd("PD");
  pushTo(x + w/2, y + capHeight);
  pushTo(x + w, y);
  pushCmd("PU");
  pushTo(x + w / 4, y + capHeight / 2);
  pushCmd("PD");
  pushTo(x + 3 * w / 4, y + capHeight / 2 );
}

void LogobotText::writeB(float x, float y)
{
  pushCmd("PD");
  pushTo(x + 2 * w / 3, y);
  pushTo(x + w, y + capHeight / 4);
  pushTo(x + 2 * w / 3, y + capHeight / 2);
  pushTo(x + w, y + 3 * capHeight / 4);
  pushTo(x + 2 * w / 3, y + capHeight);
  pushTo(x, y + capHeight);
  pushTo(x, y);
}

void LogobotText::writeC(float x, float y)
{
  pushTo(x + w, y + capHeight);
  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x, y);
  pushTo(x + w, y);
}

void LogobotText::writeD(float x, float y)
{
  pushCmd("PD");
  pushTo(x + 3 * w / 4, y);
  pushTo(x + w, y + capHeight / 4);
  pushTo(x + w, y + 3 * capHeight / 4);
  pushTo(x + 3 * w / 4, y + capHeight);
  pushTo(x, y + capHeight);
  pushTo(x, y);
}

void LogobotText::writeE(float x, float y)
{
	writeC(x, y);
  pushCmd("PU");
  pushTo(x, y + capHeight / 2);
  pushCmd("PD");
  pushTo(x + w, y + capHeight /2);
}

void LogobotText::writeF(float x, float y)
{
  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x + w, y + capHeight);
  pushCmd("PU");
  pushTo(x + w, y + capHeight / 2);
  pushCmd("PD");
  pushTo(x, y + capHeight / 2);
}

void LogobotText::writeG(float x, float y)
{
  pushTo(x + w, y + capHeight);
  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x, y);
  pushTo(x + w, y);
  pushTo(x + w, y + capHeight/3);
  pushTo(x + w/3, y + capHeight/3);
}

void LogobotText::writeH(float x, float y)
{
	pushCmd("PD");
	pushTo(x, y + capHeight);
	pushTo(x, y + capHeight / 2);
	pushTo(x + w, y + capHeight / 2);
	pushTo(x + w, y + capHeight);
	pushTo(x + w, y);
}

void LogobotText::writeI(float x, float y)
{
  pushTo(x + w / 2, y);
  pushCmd("PD");
  pushTo(x + w / 2, y + capHeight);
}

void LogobotText::writeJ(float x, float y)
{
  pushTo(x, y + capHeight / 4);
  pushCmd("PD");
  pushTo(x, y);
  pushTo(x + w, y);
  pushTo(x + w, y + capHeight);
}

void LogobotText::writeK(float x, float y)
{
  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushCmd("PU");
  pushTo(x + w, y + capHeight);
  pushCmd("PD");
  pushTo(x, y + capHeight / 2);
  pushTo(x + w, y);
}

void LogobotText::writeL(float x, float y)
{
  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x,y);
  pushTo(x + w, y);
}

void LogobotText::writeM(float x, float y)
{
	pushCmd("PD");
	pushTo(x, y + capHeight);
	pushTo(x + w / 2, y + capHeight / 2);
	pushTo(x + w, y + capHeight);
	pushTo(x + w, y);
}

void LogobotText::writeN(float x, float y)
{
  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x + w, y);
  pushTo(x + w, y + capHeight);

}

void LogobotText::writeO(float x, float y)
{
  pushCmd("PD");
  pushTo(x + w, y);
  pushTo(x + w, y + capHeight);
  pushTo(x, y + capHeight);
  pushTo(x, y);
}

void LogobotText::writeP(float x, float y)
{
  pushCmd("PD");
  pushTo(x, y + capHeight);
  pushTo(x + w, y + capHeight);
  pushTo(x + w, y + capHeight / 2);
  pushTo(x, y + capHeight / 2);
}

void LogobotText::writeQ(float x, float y)
{
  pushCmd("PD");
  pushTo(x + w / 2, y);
  pushTo(x + w, y + capHeight / 2);
  pushTo(x + w, y + capHeight);
  pushTo(x, y + capHeight);
  pushTo(x, y);
  pushCmd("PU");
  pushTo(x + w / 2, y + capHeight / 2);
  pushCmd("PD");
  pushTo(x + w, y);
}

void LogobotText::writeR(float x, float y)
{
	writeP(x, y);
  pushTo(x + w, y);
}

void LogobotText::writeS(float x, float y)
{
  pushCmd("PD");
  pushTo(x + w, y);
  pushTo(x + w, y + capHeight / 2);
  pushTo(x, y + capHeight / 2);
  pushTo(x, y + capHeight);
  pushTo(x + w, y + capHeight);
}

void LogobotText::writeT(float x, float y)
{
  pushTo(x + w/2, y);
  pushCmd("PD");
  pushTo(x + w/2, y + capHeight);
  pushTo(x, y + capHeight);
  pushTo(x + w, y + capHeight);
}

void LogobotText::writeU(float x, float y)
{
  pushTo(x, y + capHeight);
  pushCmd("PD");
  pushTo(x, y);
  pushTo(x + w, y);
  pushTo(x + w, y + capHeight);
}

void LogobotText::writeV(float x, float y)
{
  pushTo(x, y + capHeight);
  pushCmd("PD");
  pushTo(x + w / 2, y);
  pushTo(x + w, y + capHeight);
}

void LogobotText::writeW(float x, float y)
{
	pushTo(x, y + capHeight);
	pushCmd("PD");
	pushTo(x + w / 4, y);
	pushTo(x + w / 2, y + capHeight / 2);
	pushTo(x + 3 * w / 4, y);
	pushTo(x + w, y + capHeight);
}

void LogobotText::writeX(float x, float y)
{
	pushCmd("PD");
	pushTo(x + w, y + capHeight);
	pushCmd("PU");
	pushTo(x, y + capHeight);
	pushCmd("PD");
	pushTo(x + w, y);
}

void LogobotText::writeY(float x, float y)
{
  pushCmd("PD");
  pushTo(x + w, y + capHeight);
  pushCmd("PU");
  pushTo(x, y + capHeight);
  pushCmd("PD");
  pushTo(x + w / 2, y + capHeight / 2);
}


void LogobotText::writeZ(float x, float y)
{
  pushTo(x, y + capHeight);
  pushCmd("PD");
  pushTo(x + w, y + capHeight);
  pushTo(x, y);
  pushTo(x + w, y);
}


void LogobotText::writeChar(char c, float x, float y) {

	switch (c) {
	case 'A':
		writeA(x, y);
		break;
	case 'B':
		writeB(x, y);
		break;
	case 'C':
		writeC(x, y);
		break;
	case 'D':
		writeD(x, y);
		break;
	case 'E':
		writeE(x, y);
		break;
	case 'F':
		writeF(x, y);
		break;
	case 'G':
		writeG(x, y);
		break;
	case 'H':
		writeH(x, y);
		break;
	case 'I':
		writeI(x, y);
		break;
	case 'J':
		writeJ(x, y);
		break;
	case 'K':
		writeK(x, y);
		break;
	case 'L':
		writeL(x, y);
		break;
	case 'M':
		writeM(x, y);
		break;
	case 'N':
		writeN(x, y);
		break;
	case 'O':
		writeO(x, y);
		break;
	case 'P':
		writeP(x, y);
		break;
	case 'Q':
		writeQ(x, y);
		break;
	case 'R':
		writeR(x, y);
		break;
	case 'S':
		writeS(x, y);
		break;
	case 'T':
		writeT(x, y);
		break;
	case 'U':
		writeU(x, y);
		break;
	case 'V':
		writeV(x, y);
		break;
	case 'W':
		writeW(x, y);
		break;
	case 'X':
		writeX(x, y);
		break;
	case 'Y':
		writeY(x, y);
		break;
	case 'Z':
		writeZ(x, y);
		break;
	case ' ':
		// nothing to do, just move to next letter
		break;

	default:
		pushCmd("BZ 500");
		return;
	}

	pushCmd("PU");
	pushTo(x + w + letterSpacing, y);
}