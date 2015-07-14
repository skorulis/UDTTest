//  Created by Alexander Skorulis on 13/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import <Foundation/Foundation.h>

@interface UDTSender : NSObject

- (void) sendString:(NSString*)text;
- (void) sendData:(NSData*)data;

- (void) printStats;

@end
