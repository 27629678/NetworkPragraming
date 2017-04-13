//
//  NetworkDetect.swift
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/13.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

import Darwin
import Foundation
import SystemConfiguration

class NetworkDetect: NSObject {
    
    open class func connected() -> Bool {
        var isConnected = false
        var url = "www.google.com".cString(using: .ascii)
        
        UnsafeMutablePointer(&url).withMemoryRebound(to: Int8.self, capacity: 1) { (pointer) -> Void in
            let netRef = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, pointer)
            var flags = SCNetworkReachabilityFlags()
            SCNetworkReachabilityGetFlags(netRef!, &flags)
            
            let reachable = flags.rawValue & SCNetworkReachabilityFlags.reachable.rawValue != 0
            let connectReq = flags.rawValue & SCNetworkReachabilityFlags.connectionRequired.rawValue != 0
            
            if reachable && !connectReq {
                isConnected = true
            }
        }
        
        return isConnected
    }

}
