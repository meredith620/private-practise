#ifndef DAEMONIZE_H
#define DAEMONIZE_H

#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/stat.h>
#include <signal.h>

#define LOCKMODE (S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH)
void sigterm_handler(int arg);
void daemonize();
int allready_running(const char *file);
int lockfile(int fd);
extern volatile sig_atomic_t _running;

inline sig_atomic_t can_run();

//for debug multi process
void debug_wrapper();

#endif //DAEMONIZE_H
