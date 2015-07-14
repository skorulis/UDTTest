//  Created by Alexander Skorulis on 3/04/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DataBlobConnectionType) {
    DataBlobConnectionTypeWebRTC,
    DataBlobConnectionTypeMultipeer,
    DataBlobConnectionTypeWebsocket,
    DataBlobConnectionTypeUDT
};

@protocol DataBlobConnectionProtocol;

@protocol DataBlobConnectionDelegate <NSObject>

- (void)dataBlobConnection:(id<DataBlobConnectionProtocol>)conn receivedData:(NSData*)data;
- (void)dataBlobConnection:(id<DataBlobConnectionProtocol>)conn didClose:(NSError*)error;

@end

@protocol DataBlobConnectionProtocol <NSObject>

@property (nonatomic, weak) id<DataBlobConnectionDelegate> delegate;

- (void) sendData:(NSData*)data;
- (DataBlobConnectionType) connectionType;
- (NSInteger) maximumActiveTasks;
//- (BOOL) isConnected; //Should really have this available.

@end
