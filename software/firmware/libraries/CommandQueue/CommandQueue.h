#ifndef CommandQueue_h
#define CommandQueue_h

#include <Arduino.h>

struct COMMAND {
	uint8_t cmdType;  // application defined
	String cmd;
};


class CommandQueue
{
public:
	CommandQueue(int length);
	boolean insert(String s, uint8_t cmdType);
	boolean enqueue(String s, uint8_t cmdType);
	uint8_t peekAtType();  // returns the cmdType of head command, or 0xff if queue is empty
	COMMAND * dequeue();
	boolean isFull();
	boolean isEmpty();
	void clear();
	int pending();
	void printCommandQ();

private:
	int queueLength;
	COMMAND *cmdQ;
	int qHead;
	int qSize;

};

#endif
