//  Created by Alexander Skorulis on 13/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "UDTReceiver.h"
#include "udt.h"
#include <netdb.h>
#include <unistd.h>
#include <cstdlib>
#include <cstring>

@interface UDTReceiver ()

@property (nonatomic) NSThread* receiveThread;

@end

@implementation UDTReceiver

- (instancetype) init {
    self = [super init];
    _receiveThread = [[NSThread alloc] initWithTarget:self selector:@selector(startListening) object:nil];
    [_receiveThread start];
    return self;
}

- (void) startListening {
    addrinfo hints;
    addrinfo* res;
    
    memset(&hints, 0, sizeof(struct addrinfo));
    
    hints.ai_flags = AI_PASSIVE;
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    
    std::string port("8345");
    
    if(getaddrinfo(NULL, port.c_str(), &hints, &res) != 0) {
        NSLog(@"Could not open port");
        return;
    }
    
    UDTSOCKET serv = UDT::socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    UDT::setsockopt(serv, 0, UDP_RCVBUF, new int(1590000), sizeof(int));
    if (UDT::ERROR == UDT::bind(serv, res->ai_addr, res->ai_addrlen)) {
        NSLog(@"bind error: %s",UDT::getlasterror().getErrorMessage());
        return;
    }
    
    freeaddrinfo(res);
    
    NSLog(@"Server active");
    
    if (UDT::ERROR == UDT::listen(serv, 10)) {
        NSLog(@"listen: %s",UDT::getlasterror().getErrorMessage());
        return;
    }
    
    sockaddr_storage clientaddr;
    int addrlen = sizeof(clientaddr);
    
    UDTSOCKET recver;
    
    while (![[NSThread currentThread] isCancelled]) {
        NSLog(@"Event");
        if (UDT::INVALID_SOCK == (recver = UDT::accept(serv, (sockaddr*)&clientaddr, &addrlen))) {
            NSLog(@"ACCEPT: %s",UDT::getlasterror().getErrorMessage());
            return;
        }
        
        char clienthost[NI_MAXHOST];
        char clientservice[NI_MAXSERV];
        getnameinfo((sockaddr *)&clientaddr, addrlen, clienthost, sizeof(clienthost), clientservice, sizeof(clientservice), NI_NUMERICHOST|NI_NUMERICSERV);
        
        NSLog(@"new connection: %s %s",clienthost, clientservice);

        pthread_t rcvthread;
        pthread_create(&rcvthread, NULL, recvdata, new UDTSOCKET(recver));
        pthread_detach(rcvthread);
        
    }
    
    UDT::close(serv);

}

void* recvdata(void* usocket) {
    NSLog(@"RECV");
    UDTSOCKET recver = *(UDTSOCKET*)usocket;
    delete (UDTSOCKET*)usocket;
    
    char* data;
    int size = 5;
    data = new char[size];
    
    while (true) {
        int rsize = 0;
        int rs;
        while (rsize < size) {
            int rcv_size;
            int var_size = sizeof(int);
            UDT::getsockopt(recver, 0, UDT_RCVDATA, &rcv_size, &var_size);
            rs = UDT::recv(recver, data, size, 0);
            NSString* s = [[NSString alloc] initWithBytes:data length:rs encoding:NSUTF8StringEncoding];
            NSLog(@"Packet %d %@",rs,s);
            
            if (UDT::ERROR == rs) {
                NSLog(@"RECV: %s",UDT::getlasterror().getErrorMessage());
                break;
            }
            
            rsize += rs;
        }
        
        if (rsize < size)
            break;
    }
    
    delete [] data;
    
    UDT::close(recver);
    
    return NULL;
}


@end
