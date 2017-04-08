//
//  SocketClientViewController.swift
//  NetworkPragramming
//
//  Created by hzyuxiaohua on 2017/4/8.
//  Copyright © 2017年 hzyuxiaohua. All rights reserved.
//

import UIKit

class SocketClientViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var recvTextView: UITextView!
    
    var socket: BSDSocketClient? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "socket client"
        
        recvTextView.text = ""
        textField.placeholder = "waiting for send"
        
        connectToSocketServer()
    }
    
    private func connectToSocketServer() {
        socket = BSDSocketClient.connect(to: "0.0.0.0", port: 2017)
        
        guard socket?.error_code == .noError else {
            showAlertWithMessage("connect to server failed")
            
            return
        }
        
        showAlertWithMessage("connected")
    }
    
    @IBAction func sendBtnAction(_ sender: Any) {
        guard (textField.text?.characters.count)! > 0 && socket?.error_code == .noError else {
            showAlertWithMessage("text is empty or connect to socket first")
            return
        }
        
        sendBtn.isEnabled = false
        socket?.sendMessage(textField.text)
        
        guard socket?.error_code == .noError else {
            showAlertWithMessage("send message error")
            sendBtn.isEnabled = true
            return
        }
        
        let echo = socket?.recvMessage(withMaxChar: MAXLINE * 2)
        guard socket?.error_code == .noError else {
            showAlertWithMessage("recieve meesage error")
            sendBtn.isEnabled = true
            return
        }
        
        sendBtn.isEnabled = true
        recvTextView.text = recvTextView.text.appending(echo!)
    }
    
    // MARK: - private
    
    private func showAlertWithMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
