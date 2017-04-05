//
//  ByteOrderTest.swift
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 05/04/2017.
//  Copyright © 2017 hzyuxiaohua. All rights reserved.
//

import XCTest

class ByteOrderTest: XCTestCase {

    func testExample() {
        if Int(bigEndian:256) == 256 {
            XCTAssertEqual(ByteOrder.order(), .big)
        }
        
        if Int(littleEndian:256) == 256 {
            XCTAssertEqual(ByteOrder.order(), .little)
        }
    }

}
