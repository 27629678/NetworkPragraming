//
//  HostUtil.m
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/11.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import "HostUtil.h"

@implementation HostUtil

+ (NSHost *)currentHost
{
    return [NSHost currentHost];
}

+ (NSArray *)addresses
{
    return [[HostUtil currentHost] addresses];
}

@end
