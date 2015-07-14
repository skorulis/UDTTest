//  Created by Alexander Skorulis on 14/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "UDTConstants.h"

int const kUDTContentLengthSize = 4;
const int kUDTChunkSize = 65536;
const int kUDTRCVBufferSize = 1590000;

void setSocketParams(UDTSOCKET* socket) {
    UDT::setsockopt(*socket, 0, UDP_RCVBUF, new int(kUDTRCVBufferSize), sizeof(int));
    UDT::setsockopt(*socket, 0, UDP_SNDBUF, new int(kUDTChunkSize), sizeof(int));
}