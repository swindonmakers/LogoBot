#ifndef LogobotText_h
#define LogobotText_h
#include <Arduino.h>
#include <CommandQueue.h>

static const float fontSize = 20;  // =em, equal to line spacing (between baselines), text sizes derived from this
static const float capHeight = fontSize * 0.7;
static const float letterSpacing = fontSize * 0.1;
static const float w = fontSize * 0.5;

class LogobotText
{
public:
	LogobotText(CommandQueue& cmdQ);
	void writeChar(char c, float x, float y);
private:
	CommandQueue& _cmdQ;

	void pushCmd(String c);
	void pushTo(float x, float y);

	void writeA(float x, float y);
	void writeB(float x, float y);
	void writeC(float x, float y);
	void writeD(float x, float y);
	void writeE(float x, float y);
	void writeF(float x, float y);
	void writeG(float x, float y);
	void writeH(float x, float y);
	void writeI(float x, float y);
	void writeJ(float x, float y);
	void writeK(float x, float y);
	void writeL(float x, float y);
	void writeM(float x, float y);
	void writeN(float x, float y);
	void writeO(float x, float y);
	void writeP(float x, float y);
	void writeQ(float x, float y);
	void writeR(float x, float y);
	void writeS(float x, float y);
	void writeT(float x, float y);
	void writeU(float x, float y);
	void writeV(float x, float y);
	void writeW(float x, float y);
	void writeX(float x, float y);
	void writeY(float x, float y);
	void writeZ(float x, float y);
};
#endif
