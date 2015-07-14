//  Created by Alexander Skorulis on 13/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "UDTFileSend.h"
#import "RandomUtil.h"
#import "UDTConstants.h"

@interface UDTTestTests : XCTestCase

@end

@implementation UDTTestTests


- (void) testFileSend1 {
    NSData* data = [RandomUtil randomData:100];
    UDTFileSend* send = [[UDTFileSend alloc] initWithData:data];
    NSData* chunk1 = [send nextChunk:50];
    
    int i;
    [chunk1 getBytes: &i length: sizeof(i)];
    XCTAssertEqual(i, 100);
    XCTAssertEqual(send.isFinished, false);
    XCTAssertEqual(chunk1.length, 50);
    
    NSData* chunk2 = [send nextChunk:50];
    XCTAssertEqual(chunk2.length, 50);
    XCTAssertEqual(send.isFinished, false);
    
    NSData* chunk3 = [send nextChunk:50];
    XCTAssertEqual(chunk3.length, 4);
    XCTAssertEqual(send.isFinished, true);
}

@end
