//
//  BSDSocketClient.m
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/8.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import "BSDSocketClient.h"

#import <sys/types.h>
#import <arpa/inet.h>

@interface BSDSocketClient ()

@property (nonatomic, assign) NSInteger sock_fd;

@end

@implementation BSDSocketClient

+ (instancetype)connectTo:(NSString *)ip port:(NSUInteger)port
{
    BSDSocketClient *client = [BSDSocketClient new];
    [client connectTo:ip port:port];
    
    return client;
}

- (ssize_t)sendMessage:(NSString *)message
{
    return [self sendData:[message dataUsingEncoding:NSUTF8StringEncoding]];
}

- (ssize_t)sendData:(NSData *)data
{
    return 0;
}

- (NSString *)recvMessageWithMaxChar:(int)max
{
    return @"";
}

#pragma mark - private

- (void)connectTo:(NSString *)ip port:(NSUInteger)port
{
    NSLog(@"%@:%@", ip, @(port));
    self.error_code = BSDClientErrorCodeNoError;
    
    if ((self.sock_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        self.error_code = BSDClientErrorCodeSocketError;
        
        return;
    }
    
    struct sockaddr_in server_addr;
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);
    inet_pton(AF_INET, [ip cStringUsingEncoding:NSUTF8StringEncoding], &server_addr.sin_addr);
    
    if (connect(AF_INET, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        self.error_code = BSDClientErrorCodeConnectError;
    }
    
    NSLog(@"Connection Success.");
}

@end
