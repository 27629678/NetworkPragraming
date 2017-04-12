//
//  CFSocketServer.h
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/12.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CFBSDServerErrorCode) {
    CFBSDServerErrorCodeNoError,
    CFBSDServerErrorCodeSocketError,
    CFBSDServerErrorCodeBindError,
    CFBSDServerErrorCodeListenError,
    CFBSDServerErrorCodeCreateError,
    CFBSDServerErrorCodeAcceptError,
};

@interface CFSocketServer : NSObject

@property (nonatomic, readonly) CFBSDServerErrorCode errCode;

- (void)listenOnPort:(int)port;

@end
