//
//  ViewController.swift
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 05/04/2017.
//  Copyright © 2017 hzyuxiaohua. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if ByteOrder.order() == .big {
            print("byte order is big")
        }
        else if ByteOrder.order() == .little {
            print("byte order is little")
        }
        else {
            print ("byte order is unknown")
        }
        
        print("num 256's representation \(Int(littleEndian: 256))")
    }


}

