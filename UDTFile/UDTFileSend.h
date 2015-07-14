//  Created by Alexander Skorulis on 14/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import <Foundation/Foundation.h>
#import "UDTConstants.h"

@interface UDTFileSend : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype) initWithData:(NSData*)data;

- (NSData*) nextChunk:(int)size;

@end
