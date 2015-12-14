#define SIMULATOR

typedef unsigned long int time_type;

void init_clock(void);
void clock_inter(void);
time_type get_time(void);
void hold(time_type);

//CRG registers
typedef struct sCRG {
   volatile unsigned char synr;
   volatile unsigned char refdv;
   volatile unsigned char ctflg;
   volatile unsigned char crgflg;
   volatile unsigned char crgint;
   volatile unsigned char clksel;
   volatile unsigned char pllctl;
   volatile unsigned char rtictl;
   volatile unsigned char copctl;
   volatile unsigned char forbyp;
   volatile unsigned char ctctl;
   volatile unsigned char armcop;
} CRG, *CRGptr;

