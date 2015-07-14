//  Created by Alexander Skorulis on 14/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "UDTConstants.h"

int const kUDTContentLengthSize = 4;
const int kUDTChunkSize = 65536;
const int kUDTRCVBufferSize = 1048576;

static const int kUDPRCVBufferSize = 1548576;
static const int kUDPSENDBufferSize = 100000;

static const int kUDTMSS = 1500;
static const int64_t kUDTMaxBandwidth = 1000000;


void setSocketParams(UDTSOCKET* socket) {
    UDT::setsockopt(*socket, 0, UDP_RCVBUF, &kUDPRCVBufferSize, sizeof(int));
    //UDT::setsockopt(*socket, 0, UDT_RCVBUF, &kUDTRCVBufferSize, sizeof(int));
    //UDT::setsockopt(*socket, 0, UDT_SNDBUF, &kUDTChunkSize, sizeof(int));
    
    //UDT::setsockopt(*socket, 0, UDP_SNDBUF, &kUDPSENDBufferSize, sizeof(int));
    //UDT::setsockopt(*socket, 0, UDT_MAXBW, &kUDTMaxBandwidth, sizeof(int64_t));
    
    //UDT::setsockopt(*socket, 0, UDT_MSS, &kUDTMSS, sizeof(int));
}