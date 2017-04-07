//
//  AddrInfo.h
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 07/04/2017.
//  Copyright © 2017 hzyuxiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <netdb.h>
#import <sys/socket.h>

@interface AddrInfo : NSObject

@property (nonatomic, copy) NSString *host, *service;
@property (nonatomic) struct addrinfo *results;
@property (nonatomic) struct sockaddr *sa;
@property (nonatomic, assign) int errCode;

- (NSString *)errorString;

- (void)addrWithSocketAddr:(struct sockaddr *)sa;

- (void)addrWithHost:(NSString *)host service:(NSString *)service hints:(struct addrinfo *)hints;

+ (void)testWithHost:(NSString *)host service:(NSString *)service;

@end
