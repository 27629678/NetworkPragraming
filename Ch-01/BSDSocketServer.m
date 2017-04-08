//
//  BSDSocketServer.m
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/7.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import "BSDSocketServer.h"

#import <sys/types.h>
#import <arpa/inet.h>

@interface BSDSocketServer ()

@property (nonatomic, assign) int listen_fd;

@end

@implementation BSDSocketServer

+ (instancetype)listenOnPort:(NSUInteger)port
{
    return [[self alloc] initWithPort:port];
}

- (void)startEchoServer
{
    [self echoWithListenDescriptor:self.listen_fd];
}

- (instancetype)initWithPort:(NSUInteger)port
{
    if (self = [super init]) {
        struct sockaddr_in server_addr;
        self.errCode = BSDServerErrorCodeNoERROR;
        
        if ((self.listen_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
            self.errCode = BSDServerErrorCodeSOCKETERROR;
            
            return self;
        }
        
        memset(&server_addr, 0, sizeof(server_addr));
        server_addr.sin_family = AF_INET;
        server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
        server_addr.sin_port = htons(port);
        char naddr[INET_ADDRSTRLEN];
        inet_ntop(AF_INET, &server_addr.sin_addr, naddr, sizeof naddr);
        NSLog(@"%@:%@", [NSString stringWithUTF8String:naddr], @(port));
        
        if (bind(self.listen_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
            self.errCode = BSDServerErrorCodeBINDERROR;
            
            return self;
        }
        
        if (listen(self.listen_fd, LISTENQ) < 0) {
            self.errCode = BSDServerErrorCodeLISTENERROR;
            
            return self;
        }
    }
    
    return self;
}

- (void)echoWithListenDescriptor:(int)fd
{
    NSLog(@"start listen using listen descriptor:%@", @(fd));
    
    int conn_fd;
    char buf[MAXLINE];
    socklen_t cli_len;
    struct sockaddr_in cli_addr;
    
    for (; ;) {
        cli_len = sizeof(cli_addr);
        if ((conn_fd = accept(fd, (struct sockaddr *)&cli_addr, &cli_len)) < 0) {
            if (errno != EINTR) {
                self.errCode = BSDServerErrorCodeACCEPTINGERROR;
                NSLog(@"Error Accepting Connection");
            }
        }
        else {
            self.errCode = BSDServerErrorCodeNoERROR;
            
            NSString *connStr = [NSString stringWithFormat:@"Connection from %s, port %d",
                                 inet_ntop(AF_INET, &cli_addr.sin_addr, buf, sizeof(buf)),
                                 ntohs(cli_addr.sin_port)];
            NSLog(@"%@", connStr);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [self strEchoServer:@(conn_fd)];
            });
        }
    }
}

- (void)strEchoServer:(NSNumber *)conn_fd_num
{
    ssize_t n;
    char buf[MAXLINE];
    int sock_fd = conn_fd_num.intValue;
    
    while ((n = recv(sock_fd, buf, MAXLINE - 1, 0)) > 0) {
        [self written:sock_fd char:buf size:n];
        buf[n]='\0';
        NSLog(@"%s",buf);
    }
    
    NSLog(@"Closing Socket");
    close(sock_fd);
}

- (ssize_t)written:(int)fd char:(const void *)vptr size:(size_t)n
{
    size_t nleft;
    ssize_t nwritten;
    const char *ptr;
    
    ptr = vptr;
    nleft = n;
    
    while (nleft > 0) {
        if ((nwritten = write(fd, ptr, nleft)) <= 0) {
            if (nwritten < 0 && errno == EINTR) {
                nwritten = 0;
            }
            else {
                return -1;
            }
        }
        
        nleft   -= nwritten;
        ptr     += nwritten;
    }
    
    return n;
}

@end
