//
//  ByteOrder.h
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 05/04/2017.
//  Copyright © 2017 hzyuxiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EndianType) {
    EndianTypeUnknown = 0,      // 仅该算法不支持计算端类型
    EndianTypeLittle,           // 便于计算机处理
    EndianTypeBig,              // 人类思维的数字记录方式
};

@interface ByteOrder : NSObject

+ (EndianType)order;

@end
