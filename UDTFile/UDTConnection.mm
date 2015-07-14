//  Created by Alexander Skorulis on 14/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "UDTConnection.h"
#import "UDTFileReceive.h"
#import "UDTConstants.h"

static const int kUDTBufferSize = 65536;

@interface UDTConnection ()

@property UDTFileReceive* recvModel;
@property (nonatomic) NSThread* receiveThread;
@property UDTSOCKET* recver;

@end

@implementation UDTConnection

- (instancetype) initWithSocket:(UDTSOCKET*)recver {
    self = [super init];
    _recver = recver;
    setSocketParams(_recver);
    _receiveThread = [[NSThread alloc] initWithTarget:self selector:@selector(handleData) object:nil];
    [_receiveThread start];
    return self;
}

- (void) handleData {
    char* buffer = new char[kUDTBufferSize];
    while (![[NSThread currentThread] isCancelled]) {
        @autoreleasepool {
            int rs = UDT::recv(*_recver, buffer, kUDTChunkSize, 0);
            
            //int bufferFill; int size;
            //UDT::getsockopt(*_recver, 0, UDT_RCVDATA, &bufferFill, &size);
            //NSLog(@"RCV BUFFER %d : %d",bufferFill,size);
            
            if (UDT::ERROR == rs) {
                NSLog(@"RECV: %s",UDT::getlasterror().getErrorMessage());
                break;
            }
            
            NSData* chunk = [NSData dataWithBytes:(const void*)buffer length:rs];
            [self onReceive:chunk];
            
            UDT::TRACEINFO info;
            UDT::perfmon(*_recver, &info);
            
            //NSLog(@"RECV %d %lld %lld",info.pktRcvLossTotal, info.pktRecvTotal,info.pktSentTotal);
            //NSLog(@"RTT %f / %f",info.mbpsSendRate,info.mbpsRecvRate);
        }
    }
    
    delete [] buffer;
    UDT::close(*_recver);
}

- (void) onReceive:(NSData*)chunk {
    //NSLog(@"Got data %d",(int)chunk.length);
    if(self.recvModel) {
        [self.recvModel didReceive:chunk];
    } else {
        self.recvModel = [[UDTFileReceive alloc] initWithInitialChunk:chunk];
    }
    
    if(self.recvModel.isFinished) {
        NSData* data = self.recvModel.getData;
        NSData* extra = self.recvModel.extraData;
        self.recvModel = nil;
        [self.delegate dataBlobConnection:self receivedData:data];
        if(extra) {
            [self onReceive:extra];
        }
    }
}

- (void) sendData:(NSData*)data {
    
}

- (DataBlobConnectionType) connectionType {
    return DataBlobConnectionTypeUDT;
}

- (NSInteger) maximumActiveTasks {
    return 1;
}

@end
