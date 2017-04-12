//
//  UnitTesting.swift
//  UnitTesting
//
//  Created by hzyuxiaohua on 2017/4/8.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

import XCTest

class UnitTesting: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCFNetworkUtil() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var errCode: CFNetworkErrorCode = .noError
        let adrs = CFNetworkUtil.addresses(forHost: "www.baidu.com", errCode: &errCode)
        
        if errCode != .noError {
            XCTAssert(false)
        }
        else {
            print("\(String(describing: adrs))")
        }
        
        let names = CFNetworkUtil.hostNames(forAddress: "14.215.177.37", errCode: &errCode);
        if errCode != .noError {
            // WARN: Can not pass through this unit test
            XCTAssert(false)
        }
        else {
            print("\(String(describing: names))")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
