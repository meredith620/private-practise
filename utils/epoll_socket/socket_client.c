#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

#define  SERVER_ADDR "127.0.0.1"
#define  SERVER_PORT 8888  //  define the defualt connect port id 
#define  LENGTH_OF_LISTEN_QUEUE 10  // length of listen queue in server 
#define  BUFFER_SIZE 1024
#define HELLO_MSG "client hello\n"

int main(int argc, char *argv[])
{
     int serv_fd;
     struct sockaddr_in serv_addr;

     memset(&serv_addr, 0, sizeof(serv_addr));
     serv_addr.sin_family = AF_INET;
     serv_addr.sin_addr.s_addr = inet_addr(SERVER_ADDR);
     serv_addr.sin_port = htons(SERVER_PORT);

     serv_fd = socket(AF_INET, SOCK_STREAM, 0);
     if (connect(serv_fd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
          perror("connect error");
          exit(1);
     }
     char buf[BUFFER_SIZE];
     write(serv_fd, HELLO_MSG, strlen(HELLO_MSG));
     read(serv_fd, buf, BUFFER_SIZE);
     printf("get echo: %s\n", buf);
     close(serv_fd);
     return 0;
}
