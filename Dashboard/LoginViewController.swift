//
//  LoginViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 02/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {

    @IBOutlet weak var ipAddress: NSTextField!
    @IBOutlet weak var username: NSTextField!
    @IBOutlet weak var password: NSSecureTextField!
    @IBOutlet weak var rememberMe: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.setBackgroundColor(NSColor.lightGray)
    }
    
    override func viewDidAppear() {
        
        self.ipAddress.stringValue = UserDefaults.standard.string(forKey: "URL") ?? ""
        
        if UserDefaults.standard.bool(forKey: "login") {
            self.ipAddress.stringValue = UserDefaults.standard.string(forKey: "URL") ?? ""
            self.username.stringValue = UserDefaults.standard.string(forKey: "username") ?? ""
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        UserDefaults.standard.set(self.ipAddress.stringValue, forKey: "URL")
        
        //self.loadResetPasswordView()
        
        if UserDefaults.standard.bool(forKey: "login") {
            self.view.window?.close()
            self.loadMainView()
        } else {
            self.tryLogin(username.stringValue, password: password.stringValue)
        }
    }
    
    func loadMainView() {
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let mainWindowController = storyboard.instantiateController(withIdentifier: "MainViewController") as! NSWindowController
        
        if let mainWindow = mainWindowController.window{
            
            let application1 = NSApplication.shared()
            application1.runModal(for: mainWindow)
        }
    }
    
    func loadResetPasswordView() {
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let mainWindowController = storyboard.instantiateController(withIdentifier: "ResetPassword") as! NSWindowController
        
        if let mainWindow = mainWindowController.window{
            
            let resetPasswordVview = mainWindow.contentViewController as! ResetPasswordViewController
            resetPasswordVview.username = self.username.stringValue
            
            let application1 = NSApplication.shared()
            application1.runModal(for: mainWindow)
        }
    }

    
    func tryLogin(_ username: String, password: String ) {
        
        
        let staff = Staff(username: self.username.stringValue, password: self.password.stringValue)
       
        staff.login { (completed, result, message) in
            
            DispatchQueue.main.async {
                
                if completed {
                    
                    if result == .Success {
                        
                        if message == "1" {
                            self.loadResetPasswordView()
                        } else {
                            
                            UserDefaults.standard.set(self.ipAddress.stringValue, forKey: "URL")
                            
                            UserDefaults.standard.set(self.username.stringValue, forKey: "username")
                            
                            if self.rememberMe.state == 1 {
                            
                                UserDefaults.standard.set(true, forKey: "login")
                        
                            }
                            self.view.window?.close()
                            
                            self.loadMainView()
                        }
                    } else {
                        
                        self.dialogOKCancel(message: "Error", text: "Your credentials are incorrect")
                    }
                    
                } else {
                    print("error")
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
