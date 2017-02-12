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
    
    func tryLogin(_ username: String, password: String ) {
    
        
        HTTPSConnection.httpGetRequest(params: ["username": username as AnyObject, "password": password as AnyObject], url: "/serverlogin") { ( completed, data) in
            
            DispatchQueue.main.async {
                
                if completed {
                    
                    do {
                        
                        //let responseDictionary = try JSONSerialization.jsonObject(with: data as Data)
                        //print("success == \(responseDictionary)")
                        
                        UserDefaults.standard.set(true, forKey: "login")
                        
                        UserDefaults.standard.set(self.ipAddress.stringValue, forKey: "URL")
                        
                        UserDefaults.standard.set(self.username.stringValue, forKey: "username")
                        
                        self.view.window?.close()
                        
                        self.loadMainView()


                    } catch let error {
                        print( error)
                    }
                } else {
                    print("error")
                }
            }
            
        }
        
    }
}
