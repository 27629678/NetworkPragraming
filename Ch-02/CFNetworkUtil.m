//
//  CFNetworkUtil.m
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/12.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import "CFNetworkUtil.h"

#if TARGET_OS_IPHONE

#import <CFNetwork/CFNetwork.h>

#else

#import <CoreServices/CoreServices.h>

#endif

#import "AddrInfo.h"

#import <netdb.h>
#import <sys/types.h>
#import <sys/socket.h>

@implementation CFNetworkUtil

+ (NSArray *)addressesForHost:(NSString *)host errCode:(CFNetworkErrorCode *)errCode
{
    if (errCode) {
        *errCode = CFNetworkErrorCodeNoError;
    }
    
    char ip_adr[INET6_ADDRSTRLEN];
    NSMutableArray *retAdrs = [NSMutableArray array];
    // kCFAllocatorDefault, This is a synonym for NULL
    CFHostRef hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)host);
    Boolean success = CFHostStartInfoResolution(hostRef, kCFHostAddresses, nil);
    if (!success) {
        if (errCode) {
            *errCode = CFNetworkErrorCodeHostResolutionError;
        }
        
        return nil;
    }
    
    CFArrayRef adrs = CFHostGetAddressing(hostRef, nil);
    if (adrs == nil) {
        if (errCode) {
            *errCode = CFNetworkErrorCodeHostResolutionError;
        }
        
        return nil;
    }
    
    for (CFIndex idx = 0; idx < CFArrayGetCount(adrs); idx ++) {
        const void *item = CFArrayGetValueAtIndex(adrs, idx);
        const UInt8 *bytes = CFDataGetBytePtr(item);
        struct sockaddr *adr = (struct sockaddr *)bytes;
        
        if (adr == nil) {
            continue;
        }
        
        getnameinfo(adr, adr->sa_len, ip_adr, INET6_ADDRSTRLEN, nil, 0, NI_NUMERICHOST);
        NSString *address = [[NSString alloc] initWithCString:ip_adr encoding:NSUTF8StringEncoding];
        if (address.length == 0) {
            continue;
        }
        
        [retAdrs addObject:address];
    }
    
    return retAdrs.copy;
}

+ (NSArray *)hostNamesForAddress:(NSString *)address errCode:(CFNetworkErrorCode *)errCode
{
    if (errCode) {
        *errCode = CFNetworkErrorCodeNoError;
    }
    
    struct addrinfo hints;
    struct addrinfo *result = NULL;
    
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;    // any solution for ipv4 or ipv6
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = 0;
    int status = getaddrinfo([address cStringUsingEncoding:NSASCIIStringEncoding],
                             NULL,
                             &hints,
                             &result);
    AddrInfo *info = [[AddrInfo alloc] init];
    [info addrWithSocketAddr:result->ai_addr];
    if (status != 0) {
        if (errCode) {
            *errCode = CFNetworkErrorCodeAddressSolutionError;
        }
        
        return nil;
    }
    
    CFDataRef adrRef = CFDataCreate(kCFAllocatorDefault,
                                    (UInt8 *)result->ai_addr,
                                    result->ai_addrlen);
    if (adrRef == nil) {
        if (errCode) {
            *errCode = CFNetworkErrorCodeAddressSolutionError;
        }
        
        return nil;
    }
    
    freeaddrinfo(result);
    
    CFHostRef hostRef = CFHostCreateWithAddress(kCFAllocatorDefault, adrRef);
    if (hostRef == nil) {
        if (errCode) {
            *errCode = CFNetworkErrorCodeAddressSolutionError;
        }
        
        return nil;
    }
    
    CFRelease(adrRef);
    
    CFStreamError error;
    Boolean success = CFHostStartInfoResolution(hostRef, kCFHostNames, &error);
    if (!success) {
        if (errCode) {
            *errCode = CFNetworkErrorCodeAddressSolutionError;
        }
        
        return nil;
    }
    
    NSMutableArray *names = [NSMutableArray array];
    CFArrayRef namesRef = CFHostGetNames(hostRef, NULL);
    for (CFIndex idx = 0; idx < CFArrayGetCount(namesRef); idx ++) {
        [names addObject:CFArrayGetValueAtIndex(namesRef, idx)];
    }
    
    return names.copy;
}

@end
