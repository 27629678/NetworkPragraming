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

@property (nonatomic, assign) BSDClientErrorCode error_code;

+ (_Nonnull instancetype)connectTo:(NSString *_Nullable)ip port:(NSUInteger)port;

- (ssize_t)sendMessage:(NSString *_Nullable)message;

- (NSString * _Nonnull )recvMessageWithMaxChar:(int)max;

@end
