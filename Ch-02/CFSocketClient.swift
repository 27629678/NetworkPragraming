//
//  CFSocketClient.swift
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/13.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

import Darwin
import Foundation
import CoreFoundation

enum CFSocketClientErrorCode: Int {
    case noError = 0, socketError, connectError, readError, writeError
}

class CFSocketClient: NSObject {
    
    var sockfd: CFSocket? = nil
    var errCode: CFSocketClientErrorCode = .noError
    
    open func connect(to ip: String, port: UInt16) {
        // create
        sockfd = CFSocketCreate(kCFAllocatorDefault,
                                AF_INET,
                                SOCK_STREAM,
                                IPPROTO_IP,
                                0,
                                nil,
                                nil)
        if sockfd == nil {
            errCode = .socketError
            return
        }
        
        // connect
        var serverAdr: sockaddr_in = sockaddr_in()
        serverAdr.sin_family = sa_family_t(AF_INET)
        serverAdr.sin_len = __uint8_t(MemoryLayout<sockaddr_in>.size)
        serverAdr.sin_port = CFSwapInt16(port)
        inet_pton(AF_INET, ip.cString(using: .ascii), &(serverAdr.sin_addr))
        
        // too inconvenient(tricky)
        _ = withUnsafePointer(to: &serverAdr) {
            $0.withMemoryRebound(to: UInt8.self, capacity: 1) {
                guard let adrDataRef = CFDataCreate(kCFAllocatorDefault, $0, MemoryLayout<sockaddr_in>.size) else {
                    errCode = .connectError
                    return
                }
                
                guard CFSocketConnectToAddress(sockfd!, adrDataRef, 30) == .success else {
                    errCode = .connectError
                    return
                }
            }
        }
        
    }
    
    open func write(text: String) -> Int {
        
        return 0
    }
}
