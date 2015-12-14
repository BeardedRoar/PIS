typedef volatile unsigned char port8;
typedef port8 * port8ptr;

// Input, output address for ML4 (dipswitch + hexdisplay)
#define ML4OUT_ADDRESS 0x400
#define ML4OUT *((port8ptr) ML4OUT_ADDRESS)

#define ML4IN_ADDRESS 0x600
#define ML4IN *((port8ptr) ML4IN_ADDRESS)

// Drill status address
#ifdef SIMULATOR
	#define DRILLSTATUS_ADDRESS 0x401
#else
	#define DRILLSTATUS_ADDRESS 0x600
#endif

// Inport ML15 keyboard
#define ML15IN_ADDRESS 0x9C0
#define	ML15IN *((port8ptr) ML15IN_ADDRESS)

//Addresses to ML3 (display)
#define ML3MODE_ADDRESS 0x9C2
#define	ML3MODE *((port8ptr) ML3MODE_ADDRESS)
#define ML3DISPLAY_ADDRESS 0x9C3
#define	ML3DISPLAY *((port8ptr) ML3DISPLAY_ADDRESS)

typedef void (*voidfuncptr) (void);
typedef voidfuncptr* vector;

//Clock adress
#define CLOCKVECTOR_ADDRESS 0x3FF0
#define CLOCKVECTOR *((vector) CLOCKVECTOR_ADDRESS)
