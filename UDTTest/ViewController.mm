//
//  ViewController.m
//  UDTTest
//
//  Created by Alexander Skorulis on 13/07/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.
//

#import "ViewController.h"
#include "udt.h"
#include <netdb.h>
#include <unistd.h>
#include <cstdlib>
#include <cstring>

@interface ViewController ()

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
    addrinfo hints;
    addrinfo* res;
    
    memset(&hints, 0, sizeof(struct addrinfo));
    
    hints.ai_flags = AI_PASSIVE;
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    
    std::string port("8345");
    
    if(getaddrinfo(NULL, port.c_str(), &hints, &res) != 0) {
        NSLog(@"Could not open port");
        return;
    }
    
    UDTSOCKET serv = UDT::socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    UDT::setsockopt(serv, 0, UDP_RCVBUF, new int(5590000), sizeof(int));
    if (UDT::ERROR == UDT::bind(serv, res->ai_addr, res->ai_addrlen)) {
        NSLog(@"bind error: %s",UDT::getlasterror().getErrorMessage());
        return;
    }
    
    freeaddrinfo(res);
    
    NSLog(@"Server active");
    
    if (UDT::ERROR == UDT::listen(serv, 10)) {
        NSLog(@"listen: %s",UDT::getlasterror().getErrorMessage());
        return;
    }
}

- (void) connectClient:(id)seender {
    
}


@end
