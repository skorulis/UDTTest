//  Created by Alexander Skorulis on 13/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "UDTSender.h"
#import "UDTFileSend.h"
#include "udt.h"
#include <netdb.h>
#include <unistd.h>
#include <cstdlib>
#include <cstring>

@interface UDTSender () {
    UDTSOCKET _client;
    NSMutableArray* _sendQueue;
    NSCondition* _sendCondition;
}

@property NSThread* sendThread;
@property BOOL sendActive;

@end

@implementation UDTSender

- (instancetype) init {
    self = [super init];
    [self start];
    _sendQueue = [[NSMutableArray alloc] init];
    _sendCondition = [[NSCondition alloc] init];
    self.sendThread = [[NSThread alloc] initWithTarget:self selector:@selector(runSend) object:nil];
    [self.sendThread start];
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
    setSocketParams(&_client);
    
    freeaddrinfo(local);
    
    if (0 != getaddrinfo("192.168.1.2", "8345", &hints, &peer)) {
        NSLog(@"incorrect server/peer address");
        return;
    }
    
    if (UDT::ERROR == UDT::connect(_client, peer->ai_addr, peer->ai_addrlen)) {
        NSLog(@"Connect: %s",UDT::getlasterror().getErrorMessage());
        return;
    }
    
    freeaddrinfo(peer);
}

- (void) runSend {
    while (![[NSThread currentThread] isCancelled]) {
        @autoreleasepool {
            [_sendCondition lock];
            while(!self.sendActive) {
                [_sendCondition wait];
            }
            [_sendCondition unlock];
            UDTFileSend* send;
            
            @synchronized(_sendQueue) {
                NSParameterAssert(_sendQueue.count > 0);
                send = _sendQueue[0];
            }
            
            int bufferFill; int size;

            UDT::getsockopt(_client, 0, UDT_SNDDATA, &bufferFill, &size);
            NSLog(@"SEND BUFFER %d : %d",bufferFill,size);
            
            
            NSData* chunk = [send nextChunk:kUDTChunkSize];
            int ss = UDT::send(_client, (char*)chunk.bytes, (int)chunk.length, 0);
            
            if (UDT::ERROR == ss) {
                NSLog(@"send: %s", UDT::getlasterror().getErrorMessage());
            }
            if(send.isFinished) {
                @synchronized(_sendQueue) {
                    [_sendQueue removeObjectAtIndex:0];
                    if(_sendQueue.count == 0) {
                        self.sendActive = false;
                    }
                }
            }
            [NSThread sleepForTimeInterval:0.01];
            
        }
    }
}

- (void) sendString:(NSString*)text {
    NSData* data = [text dataUsingEncoding:NSUTF8StringEncoding];
    [self sendData:data];
}

- (void) sendData:(NSData*)data {
    NSLog(@"Sending data size %d",(int)data.length);
    UDTFileSend* send = [[UDTFileSend alloc] initWithData:data];
    @synchronized(_sendQueue) {
        [_sendQueue addObject:send];
        self.sendActive = true;
    }
    
    [_sendCondition lock];
    [_sendCondition signal];
    [_sendCondition unlock];
}

@end
