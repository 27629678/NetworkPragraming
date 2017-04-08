//
//  NetworkInterfaceAddress.m
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/5.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import "NetworkInterfaceAddress.h"

@implementation NetworkInterfaceAddress

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n{"
            @"\n\tname: %@,"
            @"\n\tver: %@,"
            @"\n\tip: %@,"
            @"\n\tmask: %@,"
            @"\n\tgate: %@"
            @"\n}",
            self.name, @(self.version), self.address, self.mask, self.gate];
}

@end
