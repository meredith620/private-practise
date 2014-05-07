#include <stdio.h>
#include "file_lock.h"

int lock_reg(int fd, int cmd, int type, off_t offset, int whence, off_t len)
{
	struct flock lock;

	lock.l_type = type;
	lock.l_start = offset;
	lock.l_whence = whence;
	lock.l_len = len;

	return (fcntl(fd, cmd, &lock));
}

// int lock_reg_str(const char *filename, int cmd, int type, off_t offset, int whence, off_t len)
// {
// 	int fd = open(filename, O_RDWR|O_CREAT, LOCKMODE);
// 	struct flock lock;

// 	lock.l_type = type;
// 	lock.l_start = offset;
// 	lock.l_whence = whence;
// 	lock.l_len = len;

// 	return (fcntl(fd, cmd, &lock));
// }
