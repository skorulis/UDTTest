//  Created by Alexander Skorulis on 14/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import <Foundation/Foundation.h>
#import "udt.h"
#import "DataBlobConnectionProtocol.h"

@interface UDTConnection : NSObject <DataBlobConnectionProtocol>

@property (nonatomic,weak) id<DataBlobConnectionDelegate> delegate;

- (instancetype) initWithSocket:(UDTSOCKET*)recver;

@end
