#include <stdio.h>
#include "queue.h"

#define TESTS_TO_TRY 3
#define CHECK_CONDITION(condition, message) if (!(condition)) { printf("%s\n", message); return 1; }

void print_queue(QueuePtr q) {
	QueuePtr currentElement = q;
	
	while(currentElement->next) {
		currentElement = currentElement->next;
		printf("\"%s\" ", currentElement->data);
	}
	printf("\n\n");
}

int checkQueue(QueuePtr q, const char *data[], const int order[], int startOffset, int qsize) {
	
	QueuePtr currentElement;
	int i = startOffset;
	if (size(q) != qsize) {
	  printf("Fel: längden stämmer inte\n");
		return 0;
	}
	for(currentElement = q->next; 
		currentElement; 
		currentElement = currentElement->next, ++i) {
		if (currentElement->data != data[order[i]]) {
			printf("Fel: element %d i kö ska vara \"%s\" men är \"%s\" ", i - startOffset, data[order[i]], currentElement->data);
			return 0;
		}
		// om vi kommer hit är size inte underhållen på rätt sätt.
		if (i - startOffset >= size(q)) {
			printf("Fel: längden stämmer inte\n");
			return 0;
		}
  }
  return 1;
}


int main(int argc, char *argv[]) {
    const char *daniel = "Daniel";
    const char *lisa = "Lisa";
    const char *a[] = {"Kalle", "Olle", "Eva", lisa, "Stina", 
                      "Peter", "Anna", daniel, "Johan", "Maria"};
    const int correctOrder1[] = {3, 7, 2, 6, 1, 5, 9, 0, 4, 8 };
    const int correctOrder2[] = {5, 4, 7, 3, 6};


	////////////////////////////////////////////////////////////////////////////
	// Kolla funktionen för att lägga till element
	////////////////////////////////////////////////////////////////////////////
#if TESTS_TO_TRY > 0
	
	QueuePtr q = new_queue();
    int i;
	
    for (i=0; i<10; i++) {
      add(q, i%4, a[i]); 
    }
	
	printf("------------------------------ TEST 1/3 ------------------------------\n");
    printf("Vi har lagt till 10 element. Storleken ska vara 10.\n");
    printf("Storlek = %d\n\n", size(q));
	printf("print_queue ska skriva ut 10 element: (\"%s\" först och \"%s\" sist)\n", a[3], a[8]);
	print_queue(q);
	
    CHECK_CONDITION(size(q) == 10, "Storleken är ej 10, vilket vi förväntar oss.");
    printf("get_first returnerar element = \"%s\"\n\n", get_first(q));
    CHECK_CONDITION(get_first(q) == a[3], "get_first() returnerar ett felaktigt data element\n.");
	CHECK_CONDITION(checkQueue(q, a, correctOrder1, 0, 10), "Ordningen är felaktig");  
#endif	
	////////////////////////////////////////////////////////////////////////////
	// Kolla funktionen för att ta bort element
	////////////////////////////////////////////////////////////////////////////
#if TESTS_TO_TRY > 1
	printf("\n------------------------------ TEST 2/3 ------------------------------\n");
    printf("Vi har anropat remove_first() och första elementet vara borttaget:\n"); 
	remove_first(q);
	print_queue(q);

    CHECK_CONDITION(size(q) == 9, "Storleken är ej 9, vilket vi förväntar oss.");
	CHECK_CONDITION(get_first(q) == a[7], "get_first() returnerar ett felaktigt data element\n.");
    CHECK_CONDITION(checkQueue(q, a, correctOrder1, 1, 9), "Ordningen var fel.");
	
    printf("Vi har anropat remove_first() ännu en gång och andra elementet ska \nvara borttaget:\n");
    remove_first(q);
    print_queue(q);
    CHECK_CONDITION(size(q) == 8, "Storleken är ej 8, vilket vi förväntar oss.");
	CHECK_CONDITION(get_first(q) == a[2], "get_first() returnerar ett felaktigt data element\n.");
    CHECK_CONDITION(checkQueue(q, a, correctOrder1, 2, 8), "Ordningen är fel.");
	
    for (i=1; i<=15; i++)
      remove_first(q);
	
    printf("Vi har anropat remove_firt() upprepade gånger. Storleken ska vara 0 \noch inga element skall skrivas \nut:\n");
    printf("Storlek = %d\n", size(q));
	print_queue(q);
    CHECK_CONDITION(size(q) == 0, "Storleken är inte 0 som den bör.");
	
	for (i=0; i<7; i++) {
      add(q, i%4, a[i]); 
    }
	clear(q);
	
	printf("Vi har lagt till element och sedan anropat clear(). Alla element ska \nvara borttagna (storleken lika med 0) och inga element skall skrivas ut:\n");
	printf("Storlek = %d\n", size(q));
	print_queue(q);
	CHECK_CONDITION(size(q) == 0, "Storleken är inte 0 som den bör.");
		
    for (i=3; i<8; i++)
      add(q, i%3, a[i]);
    printf("Vi har lagt till fem element. Första element ska vara \"%s\" och \nsista \"%s\":\n", a[5], a[6]);
    printf("Storlek = %d\n", size(q));
    print_queue(q);
    CHECK_CONDITION(size(q) == 5, "Storleken är inte 5 som den bör");
    CHECK_CONDITION(checkQueue(q, a, correctOrder2, 0, 5), "Felaktig ordning");
	
#endif
	
	////////////////////////////////////////////////////////////////////////////
	// Kolla att programmet inte läcker minne
	////////////////////////////////////////////////////////////////////////////
#if TESTS_TO_TRY > 2
	printf("\n------------------------------ TEST 3/3 ------------------------------\n");
	delete_queue(q);
    printf("Vi har anropat delete_queue. Kontrollera att ingen minnesläcka har \nuppstått med DrMemory enligt labbinstruktionerna.\n");
#endif

	printf("\n------------------------------ TEST KLAR -----------------------------\n");
    printf("Tryck på Enter för att avsluta: ");
    getchar();
    return 0;
}
