#include "queue.h"
#include <stdlib.h>

/* Creates a new (empty) queue */
QueuePtr new_queue() {
	QueuePtr queueP = (QueuePtr)malloc(sizeof(struct QueueElement));
	
	queueP->data = NULL;
	queueP->prio = MAX_PRIO;
	queueP->next = NULL;
    return queueP;
}

// tar bort kön helt och hållet
void delete_queue(QueuePtr q) {
         	
}
void clear(QueuePtr q);                 	// tar bort köelementen men behåller kön
int  size(QueuePtr q);						// räknar köns aktuella längd

// lägger in d på rätt plats 
void add(QueuePtr q, int prio, DataPtr d) {
	while(q->next && q->next->prio > prio) {
		q = q->next;
	}
	QueuePtr nextP = (QueuePtr)malloc(sizeof(struct QueueElement));
	nextP->data = d;
	nextP->next = q->next;
	nextP->prio = prio;
	q->next = nextP;
}

// avläser första dataelementet 
DataPtr get_first(QueuePtr q) {
	if(q->next) {
		return q->next->data;
	} else {
		return 0;
	}
}
void remove_first(QueuePtr q);				// tar bort första köelementet