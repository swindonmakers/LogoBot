#include "CommandQueue.h"

CommandQueue::CommandQueue(int length)
{
	cmdQ = new COMMAND[length];
	queueLength = length;
	qHead = 0;
	qSize = 0;
}

boolean CommandQueue::insert(String s) {
	// inserts s at head of queue
	// return true if inserted ok, false if buffer full

	if (!isFull()) {
		qHead--;
		if (qHead < 0) qHead += queueLength;

		cmdQ[qHead].cmd = String(s);

		qSize++;

		return true;
	}
	else
		return false;
}

boolean CommandQueue::enqueue(String s) {
	// push s onto tail of queue
	// return true if pushed ok, false if buffer full

	if (!isFull()) {
		int next = qHead + qSize;
		if (next >= queueLength) next -= queueLength;

		cmdQ[next].cmd = String(s);

		qSize++;

		return true;
	}
	else
		return false;
}

String CommandQueue::dequeue() {
	// pops head of queue
	if (qSize > 0) {
		String s = cmdQ[qHead].cmd;
		qSize--;
		qHead++;
		if (qHead >= queueLength) qHead -= queueLength;
		return s;
	}
	else
		return "";
}

boolean CommandQueue::isFull() {
	// returns true if full
	return qSize == queueLength;
}

boolean CommandQueue::isEmpty() {
	return qSize == 0;
}

int CommandQueue::pending() {
	return qSize;
}

void CommandQueue::printCommandQ()
{
	Serial.print("cmdQ:");
	Serial.print(qHead);
	Serial.print(":");
	Serial.println(qSize);

	for (int i = 0; i<qSize; i++) {
		Serial.print(i);
		Serial.print(":");
		int j = qHead + i;
		if (j > queueLength) j -= queueLength;
		Serial.println(cmdQ[j].cmd);
	}
}
