//  Created by Alexander Skorulis on 14/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import <Foundation/Foundation.h>
#import "udt.h"

extern int const kUDTContentLengthSize;
extern const int kUDTChunkSize;
extern const int kUDTRCVBufferSize;


void setSocketParams(UDTSOCKET* socket);