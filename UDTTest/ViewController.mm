//
//  ViewController.m
//  UDTTest
//
//  Created by Alexander Skorulis on 13/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.
//

#import "ViewController.h"
#import "UDTReceiver.h"
#import "UDTSender.h"

@interface ViewController () <DataBlobConnectionDelegate>

@property (nonatomic) UDTReceiver* receiver;
@property (nonatomic) UDTSender* sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    UIButton* openSocketButton = [[UIButton alloc] init];
    [openSocketButton setTitle:@"start server" forState:UIControlStateNormal];
    [openSocketButton addTarget:self action:@selector(openSocket:) forControlEvents:UIControlEventTouchUpInside];
    openSocketButton.frame = CGRectMake(0, 100, 320, 50);
    
    [self.view addSubview:openSocketButton];
    
    UIButton* connectClientButton = [[UIButton alloc] init];
    [connectClientButton setTitle:@"connect client" forState:UIControlStateNormal];
    [connectClientButton addTarget:self action:@selector(connectClient:) forControlEvents:UIControlEventTouchUpInside];
    connectClientButton.frame = CGRectMake(0, 200, 320, 50);
    
    [self.view addSubview:connectClientButton];
    
}

- (void) openSocket:(id)sender {
    self.receiver = [[UDTReceiver alloc] init];
    self.receiver.delegate = self;
}

- (void) connectClient:(id)seender {
    self.sender = [[UDTSender alloc] init];
    UIImage* image = [UIImage imageNamed:@"IMG_0646.JPG"];
    NSData* imageData = UIImageJPEGRepresentation(image, 1);
    NSLog(@"Image %@",image);
    [self.sender sendData:imageData];
}

#pragma mark DataBlobConnectionDelegate

- (void)dataBlobConnection:(id<DataBlobConnectionProtocol>)conn receivedData:(NSData*)data {
    UIImage* image = [[UIImage alloc] initWithData:data];
    //NSString* s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"STRING %@",s);
    NSLog(@"Image %@",image);
}

- (void)dataBlobConnection:(id<DataBlobConnectionProtocol>)conn didClose:(NSError*)error {
    
}

@end
