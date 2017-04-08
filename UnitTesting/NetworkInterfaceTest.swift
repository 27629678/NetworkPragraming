//
//  NetworkInterfaceTest.swift
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/5.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

import XCTest

class NetworkInterfaceTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        let adds = NetworkInterfaceUtil.allActiveInterfaceAddresses();
        
        for add: NetworkInterfaceAddress in adds {
            print("\(add)")
        }
    }
    
    func testAddrInfo() {
        AddrInfo.test(withHost: "imap.163.com", service: "993")
        AddrInfo.test(withHost: "www.163.com", service: "80")
        AddrInfo.test(withHost: "www.baidu.com", service: "443")
        AddrInfo.test(withHost: "www.google.com", service: "443")
    }

}
