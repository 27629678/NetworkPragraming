//
//  BSDSocketClient.h
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/8.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BSDClientErrorCode) {
    BSDClientErrorCodeNoError,
    BSDClientErrorCodeSocketError,
    BSDClientErrorCodeConnectError,
    BSDClientErrorCodeReadError,
    BSDClientErrorCodeWriteError,
};

@interface BSDSocketClient : NSObject

@property (nonatomic, assign) NSInteger error_code;

+ (instancetype)connectTo:(NSString *)ip port:(NSUInteger)port;

- (ssize_t)sendData:(NSData *)data;
- (ssize_t)sendMessage:(NSString *)message;

- (NSString *)recvMessageWithMaxChar:(int)max;

@end
