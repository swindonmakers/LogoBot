#ifndef LogobotText_h
#define LogobotText_h

#include <CommandQueue.h>

namespace LogobotText
{
	void begin(CommandQueue& cmdQ);
	void writeChar(char c, float x, float y);
	void setFontSize(float size);
};

#endif
