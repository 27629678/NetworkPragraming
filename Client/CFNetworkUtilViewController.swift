//
//  CFNetworkUtilViewController.swift
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/12.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

import UIKit

class CFNetworkUtilViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "CFNetworkUtil"
        textView.text = ""
        textField.placeholder = "www.163.com"
    }
    
    @IBAction func lookupBtnAction(_ sender: Any) {
        guard let text = textField.text, text.characters.count > 0 else {
            return
        }
        
        var errCode: CFNetworkErrorCode = .noError
        let adrs = CFNetworkUtil.addresses(forHost: text, errCode: &errCode)
        
        if errCode != .noError {
            textView.text = "invalid host name"
            return
        }
        
        if adrs?.count == 0 {
            textView.text = "no address was resoluted"
            return
        }
        
        textView.text = String(describing: adrs!)
    }
}
