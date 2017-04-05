//
//  ByteOrder.m
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 05/04/2017.
//  Copyright © 2017 hzyuxiaohua. All rights reserved.
//

#import "ByteOrder.h"

@implementation ByteOrder

+ (EndianType)order
{
    union {
        short sNum;
        char cNum[sizeof(short)];
    } un;
    
    un.sNum = 0x0102;
    
    if (sizeof(short) == 2) {
        if (un.cNum[0] == 1 && un.cNum[1] == 2) {
            return EndianTypeBig;
        }
        
        if (un.cNum[0] == 2 && un.cNum[1] == 1) {
            return EndianTypeLittle;
        }
    }
    
    return EndianTypeUnknown;
}

@end
