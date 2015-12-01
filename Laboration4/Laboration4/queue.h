// Filen queue.h
// Datatyp definierar typen för datan som skall läggas i kön.
#ifndef QUEUE_H
#define QUEUE_H

#define MAX_PRIO 100
typedef const char *DataPtr;
 
struct QueueElement {       					// typen för ett köelement 
	struct QueueElement *next; 					// pekare till nästa köelement 
	int prio;     							// prioritet (ger köns ordning)
	DataPtr data;		  					// pekare till dataelement
}; 

typedef struct QueueElement *QueuePtr;

QueuePtr new_queue();						// Skapar en ny (tom) kö
void delete_queue(QueuePtr q);          	// tar bort kön helt och hållet
void clear(QueuePtr q);                 	// tar bort köelementen men behåller kön
int  size(QueuePtr q);						// räknar köns aktuella längd
void add(QueuePtr q, int prio, DataPtr d);	// lägger in d på rätt plats 
DataPtr get_first(QueuePtr q);				// avläser första dataelementet 
void remove_first(QueuePtr q);				// tar bort första köelementet

#endif
