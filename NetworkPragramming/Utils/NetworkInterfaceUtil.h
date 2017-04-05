//
//  NetworkInterfaceUtil.h
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/5.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NetworkInterfaceAddress.h"

@interface NetworkInterfaceUtil : NSObject

+ (NSArray<NetworkInterfaceAddress *> *)allActiveInterfaceAddresses;

@end    // NetworkInterfaceUtil
