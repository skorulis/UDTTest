//  Created by Alexander Skorulis on 13/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "UDTReceiver.h"
#import "UDTFileReceive.h"
#import "UDTConstants.h"
#import "UDTConnection.h"
#include "udt.h"
#include <netdb.h>
#include <unistd.h>
#include <cstdlib>
#include <cstring>

@interface UDTReceiver ()

@property (nonatomic) NSThread* receiveThread;
@property (nonatomic) NSMutableArray* connections;

@end

@implementation UDTReceiver

- (instancetype) init {
    self = [super init];
    _connections = [[NSMutableArray alloc] init];
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
    setSocketParams(&serv);
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

        UDTConnection* conn = [[UDTConnection alloc] initWithSocket:new UDTSOCKET(recver)];
        conn.delegate = self.delegate;
        [self.connections addObject:conn];
    }
    
    UDT::close(serv);

}



@end
