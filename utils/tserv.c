#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/time.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/wait.h>
#include <fcntl.h> 
// #include "daemon/daemonize.h"


#define MYPORT 7788
#define BACKLOG 10

int init_serv(int port)
{
     int serv_fd = socket(AF_INET, SOCK_STREAM, 0);
     if (serv_fd == -1) {
          perror("socket");
          exit(1);
     }
     struct sockaddr_in my_addr;
     my_addr.sin_family = AF_INET;
     my_addr.sin_port = htons(port);
     my_addr.sin_addr.s_addr = INADDR_ANY;
     bzero(&(my_addr.sin_zero), 8);

     if (bind(serv_fd, (struct sockaddr *) &my_addr, sizeof(struct sockaddr)) == -1) {
          perror("bind");
          exit(1);
     }
     if (listen(serv_fd, BACKLOG) == -1) {
          perror("listen");
          exit(1);
     }
     return serv_fd;
}

void close_serv(int fd)
{
     printf("close fd\n");
     close(fd);
}

void handle_msg(int new_fd)
{     
     if (send(new_fd, "hello~\n", 8, 0) == -1)
          perror("send");
     close(new_fd);     
}

// void service_use_thread(int fd)
// {
//      int new_fd;
//      struct sockaddr_in their_addr;
//      socklen_t sin_size = sizeof(struct sockaddr_in);

//      // signal(SIGTERM, sigterm_handler);
//      while(/* can_run() */ 1 ) {
//           if (( new_fd = accept(serv_fd, (struct sockaddr *) &their_addr, &sin_size)) == -1 ) {
//                perror("accpet");
//                continue;
//           }
//           printf("server got connection from %s \n", inet_ntoa(their_addr.sin_addr));
//           // if(fork() == 0) {//child
//           //      handle_msg(new_fd);
//           //      exit(0);
//           // }  TODO
//           close(new_fd);
//           while(waitpid(-1, NULL, WNOHANG) > 0) {}
//      }   
// }

void service_use_fork(int serv_fd)
{
     int new_fd;
     struct sockaddr_in their_addr;
     socklen_t sin_size = sizeof(struct sockaddr_in);

     // signal(SIGTERM, sigterm_handler);
     while(/* can_run() */ 1 ) {
          if (( new_fd = accept(serv_fd, (struct sockaddr *) &their_addr, &sin_size)) == -1 ) {
               perror("accpet");
               continue;
          }
          printf("server got connection from %s \n", inet_ntoa(their_addr.sin_addr));
          if(fork() == 0) {//child
               if (send(new_fd, "hello~\n", 8, 0) == -1)
                    perror("send");
               close(new_fd);
               exit(0);
          }
          close(new_fd);
          while(waitpid(-1, NULL, WNOHANG) > 0) {}
     }
}

// void service_use_select(int fd)
// {
//      fcntl(fd, F_SETFL, O_NONBLOCK);
//      while (1) {
//           struct timeval tv;
//           tv.tv_sec = 1;
//           tv.tv_usec = 0;
//           fd_set readfds;
//           FD_ZERO(&readfds);
//           FD_SET(fd, &readfds);
//           select(fd+1, &readfds, NULL, NULL, /*&tv*/ NULL);
//           if (FD_ISSET(fd, &freads)) {
               
//           }
          
//      }
// }

// #define MAXEVENTS = 1
// void service_use_epoll(int fd)
// {     
//      struct epoll_event event;
//      struct epoll_event events[MAXEVENTS];

//      int efd = epoll_create(0);
//      event.data.fd = fd;
//      event.events = EPOLLIN | EPOLLET;
//      if (epoll_ctl(efd, EPOLL_CTL_ADD, fd, &event) == -1) {
//           perror("epoll_ctl");
//           exit(1);
//      }
//      while (1) {
//           if (epoll_wait(efd, events, MAXEVENTS, -1) == -1)  
//                {  
//                     perror("epoll_wait");  
//                     break; 
//                } 
//           for (int i = 0 ; i < MAXEVENTS; ++i) {
//                if (events[n].events & EPOLLERR ||
//                    events[n].events & EPOLLHUP ||
//                    events[m].events & EPOLLLIN) {
//                     fprintf(stderr, "epoll error\n");
//                     close(events[i].data.fd);
//                }
//                else if (fd == events[i].data.fd) {
                    
//                }
               
//           }
//      }
// }

int main(int argc, char * argv[])
{
     int serv_fd = init_serv(MYPORT);

     // handle service use fork
     service_use_fork(serv_fd);

     // // handle service use select
     // service_use_select(serv_fd);
     
     close_serv(serv_fd);
     return 0;
}
