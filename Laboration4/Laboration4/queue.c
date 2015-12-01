#include "queue.h"
#include <stdlib.h>

/* Creates a new (empty) queue */
QueuePtr new_queue() {
    QueuePtr queue = 0;
    return queue;
}


void delete_queue(QueuePtr q);          	// tar bort kön helt och hållet
void clear(QueuePtr q);                 	// tar bort köelementen men behåller kön
int  size(QueuePtr q);						// räknar köns aktuella längd
void add(QueuePtr q, int prio, DataPtr d);	// lägger in d på rätt plats 
DataPtr get_first(QueuePtr q);				// avläser första dataelementet 
void remove_first(QueuePtr q);				// tar bort första köelementet