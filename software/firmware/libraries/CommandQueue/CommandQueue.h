#ifndef CommandQueue_h
#define CommandQueue_h

#include <Arduino.h>

struct COMMAND {
	String cmd;
};


class CommandQueue
{
public:
	CommandQueue(int length);
	boolean insert(String s);
	boolean enqueue(String s);
	String dequeue();
	boolean isFull();
	boolean isEmpty();
	int pending();
	void printCommandQ();

private:
	int queueLength;
	COMMAND *cmdQ;
	int qHead;
	int qSize;

};

#endif