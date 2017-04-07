//
//  BSDSocketServer.h
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/7.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

// This constant will be the maximum number of pending connections
// that can be queued up at any given time before the sockets stop
// accepting new connection requests.
#define LISTENQ 1024

// maximum length of the inbound string for the echo server
#define MAXLINE 4096

typedef NS_ENUM(NSUInteger, BSDServerErrorCode) {
    BSDServerErrorCodeNoERROR,
    BSDServerErrorCodeSOCKETERROR,
    BSDServerErrorCodeBINDERROR,
    BSDServerErrorCodeLISTENERROR,
    BSDServerErrorCodeACCEPTINGERROR
};

@interface BSDSocketServer : NSObject

@property (nonatomic, assign) BSDServerErrorCode errCode;

+ (instancetype)listenOnPort:(NSUInteger)port;

- (void)startEchoServer;

@end
