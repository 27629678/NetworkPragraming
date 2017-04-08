//
//  AddrInfo.m
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 07/04/2017.
//  Copyright © 2017 hzyuxiaohua. All rights reserved.
//

#import "AddrInfo.h"

#import <netdb.h>
#import <arpa/inet.h>
#import <netinet/in.h>
#import <sys/socket.h>
#import <netinet6/in6.h>

@implementation AddrInfo

- (NSString *)errorString
{
    return [NSString stringWithCString:gai_strerror(self.errCode) encoding:NSASCIIStringEncoding];
}

- (void)addrWithSocketAddr:(struct sockaddr *)sa
{
    [self reset];
    
    char host[1024];
    char service[20];
    self.errCode = getnameinfo(sa, sizeof(sa), host, sizeof(host), service, sizeof(service), 0);
    
    self.host = [NSString  stringWithUTF8String:host];
    self.service = [NSString stringWithUTF8String:service];
}

- (void)addrWithHost:(NSString *)host service:(NSString *)service hints:(struct addrinfo *)hints
{
    [self reset];
    
    if (host.length * service.length == 0) {
        self.errCode = -1;
        return;
    }
    
    self.host = host;
    self.service = service;
    
    struct addrinfo* info;
    self.errCode = getaddrinfo(host.UTF8String, service.UTF8String, hints, &info);

    self.results = info;
}

+ (void)testWithHost:(NSString *)host service:(NSString *)service
{
    struct addrinfo hint;
    
    memset(&hint, 0, sizeof hint);
    
    hint.ai_family = AF_UNSPEC;
    hint.ai_socktype = SOCK_STREAM;
    
    AddrInfo *info = [AddrInfo new];
    
    [info addrWithHost:host service:service hints:&hint];
    
    if (info.errCode != 0) {
        return;
    }
    
    struct addrinfo *res;
    struct addrinfo *results = info.results;
    NSLog(@"populate host:%@:%@", host, service);
    for (res = results; res != NULL; res = res->ai_next) {
        void* addr;
        NSString *ipver = @"";
        char ipstr[INET6_ADDRSTRLEN];
        
        if (res->ai_family == AF_INET) {
            struct sockaddr_in *ipv4 = (struct sockaddr_in *)res->ai_addr;
            
            ipver = @"ipv4";
            addr = &(ipv4->sin_addr);
        }
        else if (res->ai_family == AF_INET6) {
            struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)res->ai_addr;
            
            ipver = @"ipv6";
            addr = &(ipv6->sin6_addr);
        }
        else {
            continue;
        }
        
        inet_ntop(res->ai_family, addr, ipstr, sizeof ipstr);
        NSLog(@"ver:%@, ip:%s", ipver, ipstr);
    }
    
    freeaddrinfo(results);
}

#pragma mark - private

- (void)reset
{
    self.host = @"";
    self.service = @"";
    self.errCode = 0;
}

- (void)setResults:(struct addrinfo *)results
{
    freeaddrinfo(self.results);
    _results = results;
}

@end
