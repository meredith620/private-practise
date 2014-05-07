#include <stdio.h>
#include <syslog.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/resource.h>
#include "daemonize.h"

volatile sig_atomic_t _running = 1;

void sigterm_handler(int arg)
{
	_running = 0;
}

sig_atomic_t can_run()
{
     return _running;
}

void daemonize()
{
	pid_t pid;
	struct rlimit rl;
	
	if (getrlimit(RLIMIT_NOFILE, &rl) < 0) {
		fprintf(stderr, "can't get file limiet\n");
		exit(1);
	}
	
	umask(0);

	if ((pid = fork()) < 0) {
		fprintf(stderr, "can't fork\n");
		exit(1);
	}
	else if (pid != 0)
		exit(0); //parent

	setsid();

	if (chdir("/") < 0) {
		fprintf(stderr, "can't change dir\n");
		exit(1);
	}

	if (rl.rlim_max == RLIM_INFINITY)
		rl.rlim_max = 65535;
	for (int i = 0; i <  rl.rlim_max; i++)
		close(i);

	signal(SIGTERM, sigterm_handler);
}

int allready_running(const char *file)
{
	int fd = open(file, O_RDWR|O_CREAT, LOCKMODE);
	if (fd < 0) {
		fprintf(stderr, "can't open lockfile: %s\n" ,file);
		exit(1);
	}
	if (lockfile(fd) < 0) {
		if (errno == EACCES || errno == EAGAIN) {
			close(fd);
			return 1;
		}
		else {
			fprintf(stderr, "can't open lockfile: %s\n" ,file);
			exit(1);
		}
	}
	
	return 0;
}

int lockfile(int fd)
{
	struct flock fl;
	fl.l_type = F_WRLCK;
	fl.l_start = 0;
	fl.l_whence = SEEK_SET;
	fl.l_len = 0;

	return(fcntl(fd, F_SETLK, &fl));
}

void debug_wrapper()
{
	int i = 0;
	while (i == 0) {
		fprintf(stderr, "in debug wrapper \n");
		sleep(1);
	}
}


