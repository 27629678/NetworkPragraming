//
//  ViewController.swift
//  Server
//
//  Created by hzyuxiaohua on 2017/4/8.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        startSocketServer()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    private func startSocketServer() {
        let server = BSDSocketServer.listen(onPort: 2017)
        guard server?.errCode == .noERROR else {
            return
        }
        
        server?.startEcho()
    }
}

