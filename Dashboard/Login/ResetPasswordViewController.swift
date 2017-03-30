//
//  ResetPasswordViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class ResetPasswordViewController: NSViewController, NSWindowDelegate {

    @IBOutlet weak var password1TextField: NSSecureTextField!
    @IBOutlet weak var password2TextField: NSSecureTextField!
    
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.window?.delegate = self
    }
    
    func windowShouldClose(_ sender: Any) -> Bool {
        let application = NSApplication.shared()
        application.stopModal()
        return true
    }
    
    func closeWindow() {
        self.view.window?.close()
        let application = NSApplication.shared()
        application.stopModal()
    }

    @IBAction func cancelButton(_ sender: Any) {
        self.view.window?.close()
        let application = NSApplication.shared()
        application.stopModal()
    }
    
    @IBAction func resetPasswordButton(_ sender: Any) {
        
        if self.password1TextField.stringValue != self.password2TextField.stringValue {
            return
        }
        
        //let staff = Staff(username: self.username!, password: self.password1TextField.stringValue)
        Staff.resetPassword(username: self.username!, password: self.password1TextField.stringValue) { (completed, result, message) in
        
            DispatchQueue.main.async {
                
                if completed {
                    if result == .Success {
                       self.closeWindow()
                    } else {
                        self.dialogOKCancel(message: "Error", text: "try again")
                    }
                    
                } else {
                    print("error")
                    self.dialogOKCancel(message: "Error", text: "try again")
                }
            }
        }

    }
    
    @discardableResult
    func dialogOKCancel(message: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = message
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.warning
        myPopup.addButton(withTitle: "OK")
        return myPopup.runModal() == NSAlertFirstButtonReturn
    }
    
}
