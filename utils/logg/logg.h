#ifndef LOGG_H
#define LOGG_H
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <pthread.h>
#include <sys/time.h>

/* #define eprintf(format, ...) fprintf (stderr, format, ##__VA_ARGS__) */

#ifdef __cplusplus /* If this is a C++ compiler, use C linkage */
extern "C" {
#endif //__cplusplus
#define LOGG_MAX_LOGMSG_LEN    4096 /* Default maximum length of syslog messages */
     // return 0:success, -1:error
     int logg_construct();
     void logg_destruct();
     int logg_file_open(const char *filename);
     // ============inner============     
     void logg_file_unsafe_close(); //use when open a file, you can ignore it if you use stdoutw
     int mutex_init();
     int mutex_destroy();
     void logg_func(const char* file, int line, const char* szFormat, ...);

     enum LoggLevelEnum {
          LOGG_LEVEL_ALL = 0,
          LOGG_LEVEL_DEBUG = 10,
          LOGG_LEVEL_INFO = 20,
          LOGG_LEVEL_WARN = 30,
          LOGG_LEVEL_ERROR = 40,
          LOGG_LEVEL_FATAL = 50,
          LOGG_LEVEL_OFF = 10000,
          LOGG_LEVEL_DEFAULT = LOGG_LEVEL_DEBUG
     };     
     enum LoggLevelEnum get_logg_level();
     extern enum LoggLevelEnum logg_level;
     // =========end inner===========
#define LOGG_ENV_LEVEL_VAL "LOGG_LEVEL"
#define LOGG_ABOVE_LEVEL(l, m, ...) do {               \
          if (LOGG_LEVEL_##l < logg_level)             \
               break;                                  \
          logg_func(__FILE__, __LINE__, "["#l"]: " m, ## __VA_ARGS__); \
     } while(0)
     
#define LOGG_DEBUG(m, ...) LOGG_ABOVE_LEVEL(DEBUG, m, ## __VA_ARGS__)
#define LOGG_INFO(m, ...) LOGG_ABOVE_LEVEL(INFO, m, ## __VA_ARGS__)
#define LOGG_WARN(m, ...) LOGG_ABOVE_LEVEL(WARN, m, ## __VA_ARGS__)
#define LOGG_ERROR(m, ...) LOGG_ABOVE_LEVEL(ERROR, m, ## __VA_ARGS__)
#define LOGG_FATAL(m, ...) LOGG_ABOVE_LEVEL(FATAL, m, ## __VA_ARGS__)
     
#ifdef __cplusplus /* If this is a C++ compiler, end C linkage */
}
#endif //__cplucplus

#endif //LOGG_H
