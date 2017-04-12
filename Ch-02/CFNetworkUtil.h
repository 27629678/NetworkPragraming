//
//  CFNetworkUtil.h
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/12.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CFNetworkErrorCode) {
    CFNetworkErrorCodeNoError,
    CFNetworkErrorCodeHostResolutionError,
    CFNetworkErrorCodeAddressSolutionError,
};

@interface CFNetworkUtil : NSObject

+ (NSArray *)addressesForHost:(NSString *)host errCode:(CFNetworkErrorCode *)errCode;

+ (NSArray  *)hostNamesForAddress:(NSString *)address errCode:(CFNetworkErrorCode *)errCode;

@end
