#ifndef FILE_LOCK_H
#define FILE_LOCK_H
#include <fcntl.h>
#include <sys/stat.h>

#define LOCKMODE (S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH)

int lock_reg(int fd, int cmd, int type, off_t offset, int whence, off_t len);
//*_lock(fd, 0, SEEK_SET, 0) -> lock or unlock the whole file
#define read_lock(fd, offset, whence, len)   \
	lock_reg((fd), F_SETLK, F_RDLCK, (offset), (whence), (len))
#define readw_lock(fd, offset, whence, len)  \
	lock_reg((fd), F_SETLKW, F_RDLCK, (offset), (whence), (len))
#define write_lock(fd, offset, whence, len)  \
	lock_reg((fd), F_SETLK, F_WRLCK, (offset), (whence), (len))	
#define writew_lock(fd, offset, whence, len)	\
	lock_reg((fd), F_SETLKW, F_WRLCK, (offset), (whence), (len))
#define un_lock(fd, offset, whence, len)     \
	lock_reg((fd), F_SETLKW, F_UNLCK, (offset), (whence), (len))

// int lock_reg_str(const char *filename, int cmd, int type, off_t offset, int whence, off_t len);

// #define read_lock_str(filename, offset, whence, len)   \
// 	lock_reg_str((filename), F_SETLK, F_RDLCK, (offset), (whence), (len))
// #define readw_lock_str(filename, offset, whence, len)  \
// 	lock_reg_str((filename), F_SETLKW, F_RDLCK, (offset), (whence), (len))
// #define write_lock_str(filename, offset, whence, len)  \
// 	lock_reg_str((filename), F_SETLK, F_WRLCK, (offset), (whence), (len))
// #define writew_lock_str(filename, offset, whence, len) \
// 	lock_reg_str((filename), F_SETLKW, F_WRLCK, (offset), (whence), (len))
// #define un_lock_str(filename, offset, whence, len)	\
// 	lock_reg_str((filename), F_SETLK, F_UNLCK, (offset), (whence), (len))	
	


#endif
