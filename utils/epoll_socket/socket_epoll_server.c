#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <sys/epoll.h>

#define  SERVER_PORT 8888  //  define the defualt connect port id 
#define  LENGTH_OF_LISTEN_QUEUE 10  // length of listen queue in server 
#define  BUFFER_SIZE 1024

#define EP_EVENUM 100

#define PRINT_MACRO(x) printf(#x": %d\n", x)
void print_events()
{
     PRINT_MACRO(EPOLLIN);
     PRINT_MACRO(EPOLLOUT);
     PRINT_MACRO(EPOLLPRI);
     PRINT_MACRO(EPOLLERR);
     PRINT_MACRO(EPOLLHUP);
}
int main(int argc, char *argv[])
{
     int server_fd, client_fd;
     int client_len;
     struct sockaddr_in server_addr, client_addr;
     
     memset(&server_addr, 0, sizeof(server_addr));
     memset(&client_addr, 0, sizeof(client_addr));

     if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
          perror("socket error");
          exit(1);
     }
     int on = 1;
     setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on));

     server_addr.sin_family = AF_INET;
     server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
     server_addr.sin_port = htons(SERVER_PORT);

     if (bind(server_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
          perror("bind error");
          exit(1);
     }

     if (listen(server_fd, LENGTH_OF_LISTEN_QUEUE) < 0) {
          perror("listen error");
          exit(1);
     }

     printf("serv listening on %d\n", SERVER_PORT);

     int ep_fd = epoll_create(1); //any positive num
     if (ep_fd < 0) {
          perror("epoll_create error");
          exit(1);
     }
     struct epoll_event ev, ep_events[EP_EVENUM];
     ev.data.fd = server_fd;
     ev.events = EPOLLIN | EPOLLET;
     epoll_ctl(ep_fd, EPOLL_CTL_ADD, server_fd, &ev);
     char buf[BUFFER_SIZE];
     print_events();
     for (;;) {
          printf("epoll_wait\n");
          int nfds = epoll_wait(ep_fd, ep_events, EP_EVENUM, -1);
          for (int i = 0; i < nfds; i++) {
               printf("for event %d, fd: %d, ev: %d\n", i, ep_events[i].data.fd, ep_events[i].events);
               if (ep_events[i].data.fd == server_fd) {
                    client_fd = accept(server_fd, (struct sockaddr *)&client_addr, &client_len);
                    printf("serv, ip: %s, port: %d, fd: %d \n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port), client_fd);
                    ev.data.fd = client_fd;
                    ev.events = EPOLLIN | EPOLLET;
                    epoll_ctl(ep_fd, EPOLL_CTL_ADD, client_fd, &ev);
               }
               else if (ep_events[i].events & EPOLLERR || ep_events[i].events & EPOLLRDHUP) {
                    epoll_ctl(ep_fd, EPOLL_CTL_DEL, ep_events[i].data.fd, NULL);
                    close(ep_events[i].data.fd);
                    printf("client close,fd: %d,because of err \n", ep_events[i].data.fd);
               }
               else if (ep_events[i].events & EPOLLIN) {
                    memset(buf, 0, BUFFER_SIZE);
                    client_fd = ep_events[i].data.fd;
                    int slen = recv(client_fd, buf, BUFFER_SIZE, 0);
                    /* ev.data.fd = client_fd; */
                    /* ev.events = EPOLLOUT | EPOLLET; */
                    /* epoll_ctl(ep_fd, EPOLL_CTL_MOD, client_fd, &ev); */
                    printf("on fd: %d, read %s\n", client_fd, buf);
               }
               else if (ep_events[i].events & EPOLLOUT) {
                    client_fd = ep_events[i].data.fd;                    
                    send(client_fd, buf, strlen(buf), 0);
                    ev.data.fd = client_fd;
                    ev.events = EPOLLIN | EPOLLET;
                    epoll_ctl(ep_fd, EPOLL_CTL_MOD, client_fd, &ev);
                    printf("on fd: %d, write %s\n", client_fd, buf);
                    memset(buf, 0, BUFFER_SIZE);
               }
               else {
                    printf("fd: %d, ev: %d, in else...\n", ep_events[i].data.fd, ep_events[i].events);
               }
               printf("finish\n");
          }
     }

     /* while(true) { */
     /*      char buf[BUFFER_SIZE]; */
     /*      client_fd = accept(server_fd, (struct sockaddr *)&client_addr, &client_len); */

     /*      printf("serv, ip: %s, port: %d \n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port)); */
          
     /*      int slen = read(client_fd, buf, BUFFER_SIZE); */
     /*      write(client_fd, buf, slen); */
     /*      close(client_fd); */

     /*      /\* if (strncmp(buf, "quit", 4) == 0) { *\/ */
     /*      /\*      printf("recive quit cmd\n"); *\/ */
     /*      /\*      break; *\/ */
     /*      /\* } *\/ */
     /* } */

     close(server_fd);
     return 0;
}
