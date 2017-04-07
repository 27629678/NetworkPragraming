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
        
        runBSDSocketServer(onPort: 2004)
    }
    
    func runBSDSocketServer(onPort port: UInt) {
        let server: BSDSocketServer = BSDSocketServer.listen(onPort: port)
        
        guard server.errCode == .noERROR else {
            return
        }
        
        server.startEcho()
    }
    
}

