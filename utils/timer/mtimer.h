#ifndef MTIMER_H
#define MTIMER_H

#include <time.h>
#include <sys/time.h>
#include <stdint.h>
/*
  ======= clock() ms timer =========
 */

typedef struct {
	clock_t start_clk;
	clock_t stop_clk;
	clock_t pass_clk;
	char *name;
}mstimer;

void mstimer_init(mstimer *mstr, char *name);
void mstimer_start(mstimer *mstr);
void mstimer_stop(mstimer *mstr);
clock_t mstimer_pass(const mstimer *mstr);
void mstimer_destroy(mstimer *mstr);

/*
  ======= gettimeofday() us timer =========
 */ 

typedef struct {
	//for u seconds
	struct timeval tv_start;
	struct timeval tv_stop;
	struct timeval tv_pass; //sum of many pass
	//for nano seconds
	uint32_t hicyc_start, locyc_start;
	uint32_t hicyc_stop, locyc_stop;
	uint32_t hicyc_pass, locyc_pass; //sum of many pass
}mtimer;

void mtimer_ajust();
void mtimer_clear(mtimer *tmr);
void mtimer_start(mtimer *tmr);
void mtimer_stop(mtimer *tmr);

void mtimer_mspass(const mtimer *tmr, uint64_t *mspass);
void mtimer_uspass(const mtimer *tmr, uint64_t *uspass);
void mtimer_cycpass(const mtimer *tmr, uint64_t *cycpass);
void mtimer_nspass(const mtimer *tmr, double *nspass);

#endif //MTIMER_H
