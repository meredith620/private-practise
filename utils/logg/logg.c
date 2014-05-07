#include <stdlib.h>
#include <stdarg.h>
#include "logg.h"

static FILE *logg_file_ptr = NULL;
static pthread_mutex_t *logg_mutex = NULL;
static struct tm t;
static struct timeval tval;
enum LoggLevelEnum logg_level;

int logg_construct() {
     logg_file_ptr = stderr;
     logg_level = get_logg_level();
     
     if (mutex_init() != 0) {
          return -1;
     }
}
void logg_destruct() {
     logg_file_unsafe_close();
     mutex_destroy();
}


int logg_file_open(const char *filename) {
     int ret = 0;
     if (!logg_mutex && (mutex_init() != 0)) { // init error
          fprintf(stderr, "ERROR in %s:%d init mutex err\n", __FILE__, __LINE__);
          return -1;
     }
     
     pthread_mutex_lock(logg_mutex);     
     logg_file_unsafe_close(); //close last opened file
     if (!filename || !(logg_file_ptr = fopen(filename, "a"))) { //open new file
          fprintf(stderr, "ERROR in %s:%d open file err\n", __FILE__, __LINE__);
          ret = -1;
     }
     pthread_mutex_unlock(logg_mutex);
     return ret;
}

void logg_file_unsafe_close() {
     if (logg_file_ptr != stderr)
          fclose(logg_file_ptr);
     logg_file_ptr = stderr;
}


int mutex_init() {
     if (logg_mutex) { // already init
          fprintf(stderr, "ERROR in %s:%d logg_mutex init already\n", __FILE__, __LINE__);
          return -1;
     }
     logg_mutex = (pthread_mutex_t *)malloc(sizeof(pthread_mutex_t *));
     return pthread_mutex_init(logg_mutex, NULL);
}

int mutex_destroy() {
     int ret = pthread_mutex_destroy(logg_mutex);
     free(logg_mutex);
     logg_mutex = NULL;
     return ret;
}

void logg_func(const char *file, int line, const char* szFormat, ...) {
     // struct tm t;
     // struct timeval tval;
     pthread_mutex_lock(logg_mutex);
     
	/* static char msg[LOGG_MAX_LOGMSG_LEN]; */
     char *szMessage;
	va_list vaArguments;

	va_start(vaArguments, szFormat);
     vasprintf(&szMessage, szFormat, vaArguments);
	/* vsnprintf(msg, sizeof(msg), szFormat, vaArguments); */
	va_end(vaArguments);

     gettimeofday(&tval, NULL);
	localtime_r(&tval.tv_sec, &t);
	fprintf(logg_file_ptr, "[P%u:T%u][%04d-%02d-%02d %02d:%02d:%02d,%03d][%s:%d]%s\n", (unsigned int)getpid(), (unsigned int)pthread_self() ,t.tm_year + 1900, t.tm_mon + 1, t.tm_mday, t.tm_hour, t.tm_min, t.tm_sec, tval.tv_usec, file, line, szMessage);
	fflush(logg_file_ptr);
	free(szMessage);
     
     pthread_mutex_unlock(logg_mutex);
}

enum LoggLevelEnum get_logg_level() {
     enum LoggLevelEnum the_level;
     char *level = getenv(LOGG_ENV_LEVEL_VAL);
     printf("get debug level: %s\n", level);
     if(level == NULL){
          the_level = LOGG_LEVEL_DEFAULT;
     }else if(strncasecmp(level, "ALL", 3) == 0){
          the_level = LOGG_LEVEL_ALL;
     }else if(strncasecmp(level, "DEBUG", 5) == 0){
          the_level = LOGG_LEVEL_DEBUG;
     }else if(strncasecmp(level, "INFO", 4) == 0){
          the_level = LOGG_LEVEL_INFO;
     }else if(strncasecmp(level, "WARN", 4) == 0){
          the_level = LOGG_LEVEL_WARN;
     }else if(strncasecmp(level, "ERROR", 5) == 0){
          printf("find error\n");
          the_level = LOGG_LEVEL_ERROR;
     }else if(strncasecmp(level, "FATAL", 5) == 0){
          the_level = LOGG_LEVEL_FATAL;
     }else{
          the_level = LOGG_LEVEL_DEFAULT;
     }
     return the_level;
}

//===========test=============
int main(int argc, char *argv[]) {
     logg_construct();
     /* logg_file_open("logfile"); //use this if log to file */
     LOGG_DEBUG("log pure strings");
     int a = 10;
     LOGG_DEBUG("a=%d", a);
     LOGG_INFO("a=%d", a);
     LOGG_WARN("a=%d", a);
     LOGG_ERROR("a=%d", a);
     LOGG_FATAL("a=%d", a);

     /* eprintf("success!\n"); */
     logg_destruct();
     
     return 0;
}
