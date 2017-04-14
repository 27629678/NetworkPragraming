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

enum NetworkConnectType: Int8 {
    case none = 0, wlan, wifi
}

class NetworkDetect: NSObject {
    
    open class func connectType() -> NetworkConnectType {
        var type: NetworkConnectType = .none
        var address = sockaddr_in()
        address.sin_len = __uint8_t(MemoryLayout<sockaddr_in>.stride)
        address.sin_family = sa_family_t(AF_INET)
        UnsafeMutablePointer(&address).withMemoryRebound(to: sockaddr.self, capacity: 1) { (socket) in
            let reachabilityRef = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, socket)
            var flags = SCNetworkReachabilityFlags()
            SCNetworkReachabilityGetFlags(reachabilityRef!, &flags)
            
            let reachable = flags.contains(SCNetworkReachabilityFlags.reachable)
            let connectReq = flags.contains(SCNetworkReachabilityFlags.connectionRequired)
            
            if reachable && !connectReq {
                #if os(iOS)
                    if flags.contains(SCNetworkReachabilityFlags.isWWAN) {
                        type = .wlan
                    }
                    else {
                        type = .wifi
                    }
                #else
                    type = .wifi
                #endif
            }
        }
        
        return type
    }

}
