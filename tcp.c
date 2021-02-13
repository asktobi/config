#!/usr/bin/tcc -run
// jon 2021
// bin/tcp
// tcp tunnel

#include <stdio.h>
#include <netdb.h> 
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include <sys/socket.h> 
#define MAX 80 
#define PORT 8080
#define SA struct sockaddr 

int main(int argc, char ** argv )
{
	int sockfd, connfd;
	struct sockaddr_in srvaddr, cliaddr;

	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if (sockfd == -1) 
	{
		fprintf(stderr,"[tcp] socket failed\n");
		exit(1);
	}
	bzero(&srvaddr,sizeof(srvaddr));
	srvaddr.sin_family = AF_INET;
	srvaddr.sin_addr.s_addr = inet_addr("127.0.0.1"); 
	srvaddr.sin_port = htons(PORT); 

	// connect the client socket to server socket 
	if (connect(sockfd, (SA*)&srvaddr, sizeof(srvaddr)) != 0) { 
		fprintf(stderr,"[tcp] Connection failed\n");
		exit(0); 
	} 
	else
		fprintf(stderr,"[tcp] Connection success\n");

	// function for chat 
	 

	// close the socket 
	close(sockfd); 
 
	return 0;
}
