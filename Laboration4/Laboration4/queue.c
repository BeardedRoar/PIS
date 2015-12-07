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

/* Removes the entire queue */
void delete_queue(QueuePtr q) {
    clear(q);
    free(q);
}

/* Clears all elements, but keeps the queue. */ 
void clear(QueuePtr q) {
    while(q->next) {
        remove_first(q);
    }
}

/* Calculates the size of the queue */
int size(QueuePtr q) {
    int size = 0;
    
    while (q->next) {
        size++;
        q = q->next;
    }
    return size;
}

/* Adds the new data in the correct place in the queue */
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

/* Returns the first data element of the queue */
DataPtr get_first(QueuePtr q) {
	if(q->next) {
		return q->next->data;
	} else {
		return 0;
	}
}

/* Removes the first queue element */
void remove_first(QueuePtr q) {
    if (q->next) {
        QueuePtr first = q->next;
        
        q->next = first->next;
        free(first);
    }
}