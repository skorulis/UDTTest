//  Created by Alexander Skorulis on 13/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "UDTSender.h"
#include "udt.h"
#include <netdb.h>
#include <unistd.h>
#include <cstdlib>
#include <cstring>

@interface UDTSender () {
    UDTSOCKET _client;
}



@end

@implementation UDTSender

- (instancetype) init {
    self = [super init];
    [self start];
    return self;
}

- (void) start {
    struct addrinfo hints, *local, *peer;
    memset(&hints, 0, sizeof(struct addrinfo));
    
    hints.ai_flags = AI_PASSIVE;
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    
    if (0 != getaddrinfo(NULL, "8345", &hints, &local)) {
        NSLog(@"incorrect network address");
        return;
    }
    
    _client = UDT::socket(local->ai_family, local->ai_socktype, local->ai_protocol);
    UDT::setsockopt(_client, 0, UDP_RCVBUF, new int(1590000), sizeof(int));
    
    freeaddrinfo(local);
    
    if (0 != getaddrinfo("192.168.1.3", "8345", &hints, &peer)) {
        NSLog(@"incorrect server/peer address");
        return;
    }
    
    if (UDT::ERROR == UDT::connect(_client, peer->ai_addr, peer->ai_addrlen)) {
        NSLog(@"Connect: %s",UDT::getlasterror().getErrorMessage());
        return;
    }
    
    freeaddrinfo(peer);
    
    
}

- (void) sendString:(NSString*)text {
    const char* data = [text UTF8String];
    int len = strlen(data);
    int ss;
    
    if (UDT::ERROR == (ss = UDT::send(_client, data, len, 0))) {
        NSLog(@"send: %s", UDT::getlasterror().getErrorMessage());
    }
}

@end
