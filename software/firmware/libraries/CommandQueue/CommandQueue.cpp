#include "CommandQueue.h"

CommandQueue::CommandQueue(int length)
{
	cmdQ = new COMMAND[length];
	queueLength = length;
	qHead = 0;
	qSize = 0;
}

boolean CommandQueue::insert(String s, uint8_t cmdType) {
	// inserts s at head of queue
	// return true if inserted ok, false if buffer full

	if (!isFull()) {
		qHead--;
		if (qHead < 0) qHead += queueLength;

		cmdQ[qHead].cmd = String(s);
		cmdQ[qHead].cmdType = cmdType;

		qSize++;

		return true;
	}
	else
		return false;
}

boolean CommandQueue::enqueue(String s, uint8_t cmdType) {
	// push s onto tail of queue
	// return true if pushed ok, false if buffer full

	if (!isFull()) {
		int next = qHead + qSize;
		if (next >= queueLength) next -= queueLength;

		cmdQ[next].cmd = String(s);
		cmdQ[next].cmdType = cmdType;

		qSize++;

		return true;
	}
	else
		return false;
}

uint8_t CommandQueue::peekAtType() {
	if (qSize > 0) {
		return cmdQ[qHead].cmdType;
	} else
		return 0xff;
}

COMMAND * CommandQueue::dequeue() {
	// pops head of queue
	if (qSize > 0) {
		COMMAND * res = &cmdQ[qHead];
		//String s = cmdQ[qHead].cmd;
		qSize--;
		qHead++;
		if (qHead >= queueLength) qHead -= queueLength;
		return res;
	}
	else
		return NULL;
}

boolean CommandQueue::isFull() {
	// returns true if full
	return qSize == queueLength;
}

boolean CommandQueue::isEmpty() {
	return qSize == 0;
}

void CommandQueue::clear() {
	qSize = 0;
}

int CommandQueue::pending() {
	return qSize;
}

void CommandQueue::printCommandQ()
{
	Serial.print("cmdQ:");
	Serial.print(qHead);
	Serial.print(':');
	Serial.println(qSize);

	// No longer very helpful, as the cmdType is not human readable
	// and would take too much code storage to translate back...
	/*
	for (int i = 0; i<qSize; i++) {
		Serial.print(i);
		Serial.print(':');
		int j = qHead + i;
		if (j > queueLength) j -= queueLength;
		Serial.println(cmdQ[j].cmd);
	}
	*/
}
