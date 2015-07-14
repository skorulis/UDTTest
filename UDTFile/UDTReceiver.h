//  Created by Alexander Skorulis on 13/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import <Foundation/Foundation.h>
#import "DataBlobConnectionProtocol.h"

@interface UDTReceiver : NSObject

@property (nonatomic, weak) id<DataBlobConnectionDelegate> delegate;

@end
