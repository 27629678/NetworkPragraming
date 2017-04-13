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
        
        UnsafeMutablePointer(&serverAdr).withMemoryRebound(to: UInt8.self, capacity: 1) {
            guard let adrDataRef = CFDataCreate(kCFAllocatorDefault, $0, MemoryLayout<sockaddr_in>.size) else {
                errCode = .connectError
                return
            }
            
            guard CFSocketConnectToAddress(sockfd!, adrDataRef, 30) == .success else {
                errCode = .connectError
                return
            }
        }
        
        print("Connect to \(ip):\(port)")
    }

    open func write(text: String) -> Int {
        if text.characters.count == 0 || errCode != .noError {
            return -1
        }
        
        let buf = text.cString(using: .ascii)
        
        // WARN: can not use this size(CChar type size) always return 8
//        MemoryLayout.size(ofValue: buf)
        UnsafeMutablePointer(mutating: buf)?.withMemoryRebound(to: UInt8.self, capacity: 1, { (pointer) -> Void in
            let data = CFDataCreate(kCFAllocatorDefault, pointer, text.characters.count)
            guard CFSocketSendData(sockfd!, nil, data, 30) == .success else {
                errCode = .writeError
                return
            }
        })
        
//        send(CFSocketGetNative(sockfd!), UnsafeMutablePointer(mutating: buf), text.characters.count, 0)
        
        // read, have not find CFSocketRead method, use bsd socket recv method instead
        let MAXLINE = 10000
        let buff = Array<CChar>()
        recv(CFSocketGetNative(sockfd!), UnsafeMutableRawPointer(mutating: buff), MAXLINE, 0)
        print("Echo:\(String(describing: String.init(utf8String: buff)))")
        
        return errCode == .noError ? text.characters.count : -1
    }
}
