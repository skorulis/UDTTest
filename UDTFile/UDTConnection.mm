//  Created by Alexander Skorulis on 14/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "UDTConnection.h"
#import "UDTFileReceive.h"
#import "UDTConstants.h"

@interface UDTConnection ()

@property UDTFileReceive* recvModel;
@property (nonatomic) NSThread* receiveThread;
@property UDTSOCKET* recver;

@end

@implementation UDTConnection

- (instancetype) initWithSocket:(UDTSOCKET*)recver {
    self = [super init];
    _recver = recver;
    _receiveThread = [[NSThread alloc] initWithTarget:self selector:@selector(handleData) object:nil];
    [_receiveThread start];
    return self;
}

- (void) handleData {
    char* buffer = new char[kUDTChunkSize];
    while (![[NSThread currentThread] isCancelled]) {
        @autoreleasepool {
            int rs = UDT::recv(*_recver, buffer, kUDTChunkSize, 0);
            
            if (UDT::ERROR == rs) {
                NSLog(@"RECV: %s",UDT::getlasterror().getErrorMessage());
                break;
            }
            
            NSData* chunk = [NSData dataWithBytes:(const void*)buffer length:rs];
            [self onReceive:chunk];
        }
    }
    
    delete [] buffer;
    UDT::close(*_recver);
}

- (void) onReceive:(NSData*)chunk {
    NSLog(@"Got data %d",(int)chunk.length);
    if(self.recvModel) {
        [self.recvModel didReceive:chunk];
    } else {
        self.recvModel = [[UDTFileReceive alloc] initWithInitialChunk:chunk];
    }
    
    if(self.recvModel.isFinished) {
        NSData* data = self.recvModel.getData;
        self.recvModel = nil;
        NSString* s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Got string %@",s);
    }
}

@end
