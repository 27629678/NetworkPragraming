//
//  BSDSocketClient.m
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/8.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import "BSDSocketClient.h"

#import <netdb.h>
#import <sys/types.h>
#import <arpa/inet.h>

@interface BSDSocketClient ()

@property (nonatomic, assign) int sock_fd;

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
    const char *ptr = [message cStringUsingEncoding:NSUTF8StringEncoding];
    
    size_t nleft = sizeof(ptr);
    ssize_t nwriten;
    size_t n = nleft;
    while (nleft > 0) {
        if ((nwriten = write(self.sock_fd, ptr, nleft)) <= 0) {
            if (nwriten < 0 && errno == EINTR) {
                nwriten = 0;
            }
            else {
                self.error_code = BSDClientErrorCodeWriteError;
                return -1;
            }
        }
        
        nleft -= nwriten;
        ptr += nwriten;
    }
    
    return n;
}

- (NSString *)recvMessageWithMaxChar:(int)max
{
    ssize_t n;
    char recv_line[max];
    if ((n = recv(self.sock_fd, recv_line, max - 1, 0)) <= 0) {
        self.error_code = BSDClientErrorCodeReadError;
        
        return @"Server Terminated Prematurely";
    }
    
    recv_line[n] = '\0';
    
    return [NSString stringWithCString:recv_line encoding:NSUTF8StringEncoding];
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
    
    if (connect(self.sock_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        self.error_code = BSDClientErrorCodeConnectError;
        NSLog(@"%@", [NSString stringWithCString:gai_strerror(errno) encoding:NSASCIIStringEncoding]);
        
        return;
    }
    
    NSLog(@"Connection Success.");
}

@end
