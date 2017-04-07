//
//  NetworkInterfaceUtil.m
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/5.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import "NetworkInterfaceUtil.h"

#import <ifaddrs.h>

#import <arpa/inet.h>

#import <sys/types.h>
#import <sys/socket.h>

#import <netinet/in.h>

@implementation NetworkInterfaceUtil

+ (NSArray<NetworkInterfaceAddress *> *)allActiveInterfaceAddresses
{
    NSMutableArray *ifs = [NSMutableArray array];
    struct ifaddrs *ifa = NULL;
    int success = getifaddrs(&ifa);
    
    struct ifaddrs *interface = ifa;
    while (interface != NULL && success != -1) {
        char naddr[INET6_ADDRSTRLEN];
        char nmask[INET6_ADDRSTRLEN];
        char ngate[INET6_ADDRSTRLEN];
        
        IPVersion ip_ver = IPVersionUnknown;
        if (interface->ifa_addr->sa_family == AF_INET) {
            ip_ver = IPVersion4;
            inet_ntop(AF_INET, &((struct sockaddr_in *)interface->ifa_addr)->sin_addr, naddr, INET_ADDRSTRLEN);
            if (interface->ifa_netmask != NULL) {
                inet_ntop(AF_INET, &((struct sockaddr_in *)interface->ifa_netmask)->sin_addr, nmask, INET_ADDRSTRLEN);
            }
            if (interface->ifa_dstaddr != NULL) {
                inet_ntop(AF_INET, &((struct sockaddr_in *)interface->ifa_dstaddr)->sin_addr, ngate, INET_ADDRSTRLEN);
            }
        }
        else if (interface->ifa_addr->sa_family == AF_INET6) {
            ip_ver = IPVersion6;
            inet_ntop(AF_INET6, &((struct sockaddr_in *)interface->ifa_addr)->sin_addr, naddr, INET6_ADDRSTRLEN);
            if (interface->ifa_netmask != NULL) {
                inet_ntop(AF_INET, &((struct sockaddr_in *)interface->ifa_netmask)->sin_addr, nmask, INET6_ADDRSTRLEN);
            }
            if (interface->ifa_dstaddr != NULL) {
                inet_ntop(AF_INET, &((struct sockaddr_in *)interface->ifa_dstaddr)->sin_addr, ngate, INET6_ADDRSTRLEN);
            }
        }
        else {
            interface = interface->ifa_next;
            
            continue;
        }
        
        NetworkInterfaceAddress *addr = [NetworkInterfaceAddress new];
        addr.name = [NSString stringWithUTF8String:interface->ifa_name];
        addr.address = [NSString stringWithUTF8String:naddr];
        addr.mask = [NSString stringWithUTF8String:nmask];
        addr.gate = [NSString stringWithUTF8String:ngate];
        addr.version = ip_ver;
        
        [ifs addObject:addr];
        
        interface = interface->ifa_next;
    }
    
    freeifaddrs(ifa);
    
    return ifs.copy;
}

@end
