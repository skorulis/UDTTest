//  Created by Alexander Skorulis on 14/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "UDTFileSend.h"

@interface UDTFileSend ()

@property (nonatomic, readonly) NSData* fileData;
@property (nonatomic) NSInteger position;

@end

@implementation UDTFileSend

- (instancetype) initWithData:(NSData*)data {
    self = [super init];
    NSParameterAssert(data.length > 0);
    _position = -1; //Has not yet sent content length
    _fileData = data;
    return self;
}

- (NSData*) nextChunk:(int)size {
    NSParameterAssert(size > kUDTContentLengthSize);
    if(self.position < 0) {
        int contentLength = (int)_fileData.length;
        NSParameterAssert(sizeof(contentLength) == kUDTContentLengthSize);
        NSData *data = [NSData dataWithBytes: &contentLength length: sizeof(contentLength)];
        self.position = 0;
        NSData* chunk = [self nextChunk:size - kUDTContentLengthSize];
        NSMutableData* mutableData = [[NSMutableData alloc] initWithCapacity:size];
        [mutableData appendData:data];
        [mutableData appendData:chunk];
        return mutableData;
    }
    int remaining = (int) (self.fileData.length - self.position);
    NSInteger oldPosition = self.position;
    
    if(remaining <= size) {
        self.position = self.fileData.length;
        if(oldPosition == 0) {
            return _fileData;
        } else {
            return [_fileData subdataWithRange:NSMakeRange(oldPosition, remaining)];
        }
    }
    self.position += size;
    return [_fileData subdataWithRange:NSMakeRange(oldPosition, size)];
    
}

- (BOOL) isFinished {
    return self.position >= _fileData.length;
}

@end
