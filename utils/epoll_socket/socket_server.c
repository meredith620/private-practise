#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define  SERVER_PORT 8888  //  define the defualt connect port id 
#define  LENGTH_OF_LISTEN_QUEUE 10  // length of listen queue in server 
#define  BUFFER_SIZE 1024

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
     while(true) {
          char buf[BUFFER_SIZE];
          client_fd = accept(server_fd, (struct sockaddr *)&client_addr, &client_len);

          printf("serv, ip: %s, port: %d \n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));
          
          int slen = read(client_fd, buf, BUFFER_SIZE);
          write(client_fd, buf, slen);
          close(client_fd);

          /* if (strncmp(buf, "quit", 4) == 0) { */
          /*      printf("recive quit cmd\n"); */
          /*      break; */
          /* } */
     }

     close(server_fd);
     return 0;
}
