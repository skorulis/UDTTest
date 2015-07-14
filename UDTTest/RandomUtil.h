//  Created by Alexander Skorulis on 6/04/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import <Foundation/Foundation.h>

@interface RandomUtil : NSObject

+ (NSString*) randomString:(int)bytes;
+ (NSData*) randomData:(NSInteger)length;

@end

@interface NSArray (Random)

- (id) randomElement;

@end
