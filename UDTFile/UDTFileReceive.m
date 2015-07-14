//  Created by Alexander Skorulis on 14/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "UDTFileReceive.h"
#import "UDTConstants.h"

@interface UDTFileReceive ()

@property (nonatomic, readonly) int contentSize;
@property (nonatomic, readonly) NSMutableData* data;

@end

@implementation UDTFileReceive

- (instancetype) initWithInitialChunk:(NSData*)chunk {
    self = [super init];
    [chunk getBytes: &_contentSize length: sizeof(_contentSize)];
    _data = [[NSMutableData alloc] initWithCapacity:_contentSize];
    [_data appendData:[chunk subdataWithRange:NSMakeRange(kUDTContentLengthSize, chunk.length - kUDTContentLengthSize)]];
    return self;
}

- (instancetype) initWithContentSize:(int)length {
    self = [super init];
    _contentSize = length;
    _data = [[NSMutableData alloc] initWithCapacity:_contentSize];
    return self;
}

- (void) didReceive:(NSData*)chunk {
    NSParameterAssert(!self.isFinished);
    [_data appendData:chunk];
}

- (BOOL) isFinished {
    NSParameterAssert(_data.length <= _contentSize);
    return _data.length == _contentSize;
}

- (NSData*) getData {
    NSParameterAssert(self.isFinished);
    return _data;
}

@end
