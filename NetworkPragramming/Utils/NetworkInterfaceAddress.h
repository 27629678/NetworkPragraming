//
//  NetworkInterfaceAddress.h
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/5.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IPVersion) {
    IPVersionUnknown = -1,
    IPVersion4 = 4,
    IPVersion6 = 6,
};

@interface NetworkInterfaceAddress : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *mask;
@property (nonatomic, copy) NSString *gate;
@property (nonatomic, assign) IPVersion version;

@end
