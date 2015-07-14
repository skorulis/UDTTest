//  Created by Alexander Skorulis on 14/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import <Foundation/Foundation.h>

@interface UDTFileReceive : NSObject

- (instancetype) initWithInitialChunk:(NSData*)chunk;
- (instancetype) initWithContentSize:(int)length;

- (void) didReceive:(NSData*)chunk;

- (BOOL) isFinished;

- (NSData*) getData;

@end
