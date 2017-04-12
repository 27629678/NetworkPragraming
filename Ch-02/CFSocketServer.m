//
//  CFSocketServer.m
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/12.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

#import "CFSocketServer.h"

#import <netinet/in.h>
#import <sys/socket.h>
#import <CoreFoundation/CFSocket.h>

#define LISTENQ 1024

void receiveData(CFSocketRef sRef,
                 CFSocketCallBackType cType,
                 CFDataRef address,
                 const void *data,
                 void *info)
{
    CFDataRef dataRef = (CFDataRef)data;
    long len = CFDataGetLength(dataRef);
    if (len <= 0) {
        return;
    }
    
    NSString *text = [[NSString alloc] initWithData:(__bridge NSData *)data encoding:NSUTF8StringEncoding];
    NSLog(@"ReceiveText:%@", text);
    
    CFSocketSendData(sRef, address, dataRef, 0);
}

void acceptConnection(CFSocketRef sRef,
                      CFSocketCallBackType cType,
                      CFDataRef address,
                      const void *data,
                      void *info)
{
    CFSocketNativeHandle sock = *(CFSocketNativeHandle *)data;
    const CFSocketContext context = { 0, NULL, NULL, NULL, NULL};
    CFSocketRef sockRef = CFSocketCreateWithNative(kCFAllocatorDefault,
                                                   sock,
                                                   kCFSocketDataCallBack,
                                                   receiveData,
                                                   &context);
    CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, sockRef, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    CFRelease(source);
    CFRelease(sockRef);
}

@interface CFSocketServer ()

@property (nonatomic, assign) int socketfd;
@property (nonatomic, readwrite) CFBSDServerErrorCode errCode;

@end

@implementation CFSocketServer

- (void)listenOnPort:(int)port
{
    self.errCode = CFBSDServerErrorCodeNoError;
    
    // create
    self.socketfd = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
    if (self.socketfd < 0) {
        self.errCode = CFBSDServerErrorCodeSocketError;
        return;
    }
    
    // bind
    struct sockaddr_in serverAdr;
    memset(&serverAdr, 0, sizeof(serverAdr));
    serverAdr.sin_family = AF_INET;
    serverAdr.sin_port = htons(port);
    serverAdr.sin_addr.s_addr = htonl(INADDR_ANY);
    
    if (bind(self.socketfd, (struct sockaddr *)&serverAdr, sizeof(serverAdr)) < 0) {
        self.errCode = CFBSDServerErrorCodeBindError;
        return;
    }
    
    // listen
    if (listen(self.socketfd, LISTENQ) < 0) {
        self.errCode = CFBSDServerErrorCodeListenError;
        return;
    }
    
    // accept
    const CFSocketContext context = { 0, NULL, NULL, NULL, NULL };
    CFSocketRef sockRef = CFSocketCreateWithNative(kCFAllocatorDefault,
                                                   self.socketfd,
                                                   kCFSocketAcceptCallBack,
                                                   acceptConnection,
                                                   &context);
    if (sockRef == nil) {
        self.errCode = CFBSDServerErrorCodeAcceptError;
        return;
    }
    
    // run loop
    CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, sockRef, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    CFRelease(source);
    CFRunLoopRun();
}

@end
