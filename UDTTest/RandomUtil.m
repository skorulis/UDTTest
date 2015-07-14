//  Created by Alexander Skorulis on 6/04/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "RandomUtil.h"
#import <NSData+Base64/NSData+Base64.h>

@implementation RandomUtil

+ (NSString*) randomString:(int)bytes {
    NSMutableData* data = [[NSMutableData alloc] initWithCapacity:bytes];
    for(int i = 0; i < bytes; i+=4) {
        u_int32_t bits = arc4random();
        int length = MIN(4, bytes - i);
        [data appendBytes:(void*)&bits length:length];
    }
    return [data base64EncodedString];
}

+ (NSData*) randomData:(NSInteger)length {
    NSMutableData* data = [[NSMutableData alloc] init];
    for(NSInteger i = 0; i < length/4; ++i) {
        u_int32_t randomBits = arc4random();
        [data appendBytes:(void*)&randomBits length:4];
    }
    
    return data;
}


@end


@implementation NSArray (Random)

- (id) randomElement {
    NSUInteger myCount = [self count];
    return myCount ? self[arc4random_uniform((u_int32_t)myCount)] : nil;
}

@end


