#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "mtimer.h"

/*
  ======= clock() ms timer =========
 */
void mstimer_init(mstimer *mstr, char *name)
{
	char defaultname[] = "timer";
	size_t str_sz;
	char *m_nameptr;
	if (strlen(name) > 0) {
		str_sz = strlen(name);
		m_nameptr = name;
	}
	else {
		str_sz = strlen(defaultname);
		m_nameptr = defaultname;
	}
	mstr->start_clk = 0;
	mstr->stop_clk = 0;
	mstr->pass_clk = 0;
	mstr->name = (char *)malloc(str_sz+1);
	strcpy(mstr->name, m_nameptr);
}

void mstimer_start(mstimer *mstr)
{
	mstr->start_clk = clock();
}

void mstimer_stop(mstimer *mstr)
{
	mstr->stop_clk = clock();
	mstr->pass_clk += (mstr->stop_clk - mstr->start_clk);
}

clock_t mstimer_pass(const mstimer *mstr)
{
	printf("[%s] pass: %ldms\n", mstr->name, mstr->pass_clk / (CLOCKS_PER_SEC/1000));
	return mstr->pass_clk;
}

void mstimer_destroy(mstimer *mstr)
{
	free(mstr->name);
}

/*
  ======= gettimeofday() us timer =========
 */

static double cycs_per_nsec = 0;

void mtimer_ajust()
{
	mtimer tmr;
	uint64_t cycs;
	int sleep_time = 10;
	mtimer_start(&tmr);
	sleep(sleep_time);
	mtimer_stop(&tmr);
	mtimer_cycpass(&tmr, &cycs);
	printf("get cyc: %lu\n", cycs);
	cycs_per_nsec = cycs * 1.0 / sleep_time / 1000 / 1000 / 1000 ;
	printf("cycpernse: %f\n", cycs_per_nsec);
}

void mtimer_clear(mtimer *tmr)
{
	tmr->tv_pass.tv_sec = 0;
	tmr->tv_pass.tv_usec = 0;
	tmr->hicyc_pass = tmr->locyc_pass = 0;
}

void access_tsc(uint32_t *hi, uint32_t *lo)
{
	uint32_t t_hi, t_lo;
	/* get cycle counter */
	__asm__ __volatile__(
		"RDTSC\n\t"
		: "=d"(t_hi), "=a"(t_lo)
		: /* no input */
		);
	*hi = t_hi;
	*lo = t_lo;
	// asm ("rdtsc; movl %%edx,%0; movel %%eax, %1"
	// 	: "=r" (*hi), "=r" (*lo)
	// 	: /* no input */
	// 	: "%edx", "%eax");
}

// #define access_tsc(hi, lo) {\
// 	__asm__ __volatile__(\
// 	"RDTSC\n\t"\
// 	:"=d"(hi),"=a"(lo)\
// 		:/* no input */\
// 		);\
// 	}\

void mtimer_start(mtimer *tmr)
{
	gettimeofday(&tmr->tv_start, NULL);
	access_tsc(&tmr->hicyc_start, &tmr->locyc_start);
}

void mtimer_stop(mtimer *tmr)
{
	access_tsc(&tmr->hicyc_stop, &tmr->locyc_stop);
	gettimeofday(&tmr->tv_stop, NULL);
	
	tmr->tv_pass.tv_sec += (tmr->tv_stop.tv_sec - tmr->tv_start.tv_sec);
	tmr->tv_pass.tv_usec += (tmr->tv_stop.tv_usec - tmr->tv_start.tv_usec);
	tmr->locyc_pass = tmr->locyc_stop - tmr->locyc_start;
	int borrow = (tmr->locyc_pass > tmr->locyc_stop);
	tmr->hicyc_pass = tmr->hicyc_stop - tmr->hicyc_start - borrow;
}

void mtimer_mspass(const mtimer *tmr, uint64_t *mspass)
{
	*mspass = tmr->tv_pass.tv_sec * 1000 + tmr->tv_pass.tv_usec / 1000;
}

void mtimer_uspass(const mtimer *tmr, uint64_t *uspass)
{
	*uspass = tmr->tv_pass.tv_sec * 1000 * 1000 + tmr->tv_pass.tv_usec;
}

void mtimer_cycpass(const mtimer *tmr, uint64_t *cycpass)
{
	*cycpass = tmr->hicyc_pass;
	*cycpass <<= 32;
	*cycpass += tmr->locyc_pass;
}

void mtimer_nspass(const mtimer *tmr, double *nspass)
{
	uint64_t cycs;
	mtimer_cycpass(tmr, &cycs);
	*nspass = cycs * 1.0 / cycs_per_nsec;
}


//=========test for mtimer============
int main()
{
	mtimer mtr;
	int sleep_time = 1;
	printf("before ajust\n");
	mtimer_ajust();
	printf("after ajust\n");
	
	mtimer_clear(&mtr);
	printf("sleep for %d start...\n", sleep_time);
	mtimer_start(&mtr);
	sleep(sleep_time);
	mtimer_stop(&mtr);
	printf("sleep for %d stop...\n", sleep_time);
	uint64_t mspass, uspass;
	double nspass;
	mtimer_mspass(&mtr, &mspass);
	mtimer_uspass(&mtr, &uspass);
	mtimer_nspass(&mtr, &nspass);
	printf("sleep for %d secs\n", sleep_time);
	printf("\tms: %lu\n", mspass);
	printf("\tus: %lu\n", uspass);
	printf("\tns: %f\n", nspass);
	
	return 0;
}
