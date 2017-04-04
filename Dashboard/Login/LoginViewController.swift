//
//  LoginViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 02/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa
import Quartz
import OAuth2

let OAuth2CallbackNotification = NSNotification.Name(rawValue: "OAuth2CallbackNotification")


class LoginViewController: NSViewController {

    @IBOutlet weak var ipAddress: NSTextField!
    @IBOutlet weak var rememberMe: NSButton!
    
    var openController: NSWindowController?

    var loginSuccessful: Bool = false
    var loginTimer : Timer?
    var loader: DataLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.loadMainView), userInfo: nil, repeats: false)
        self.view.setBackgroundColor(NSColor.lightGray)
    }
    
    override func viewDidAppear() {
        
        self.ipAddress.stringValue = UserDefaults.standard.string(forKey: "URL") ?? ""
        
        if UserDefaults.standard.bool(forKey: "login")  &&
            self.ipAddress.stringValue == UserDefaults.standard.string(forKey: "URL") ?? "" {
            
            self.loginTimer?.fire()
        }
    }
    
    @IBAction func githubLoginButton(_ sender: NSButton) {
        self.openViewControllerWithLoader(GitHubLoader(), sender: sender)
    }
    
    @IBAction func redditLoginButton(_ sender: NSButton) {
        self.openViewControllerWithLoader(RedditLoader(), sender: sender)
    }
    
    @IBAction func bitBucketLoginButton(_ sender: NSButton) {
        self.openViewControllerWithLoader(BitBucketLoader(), sender: sender)
    }
    
    @IBAction func loginButton(_ sender: NSButton) {
        self.openViewControllerWithLoader(GoogleLoader(), sender: sender)
    }
    
    func handleRedirect(_ notification: Notification) {
        if let url = notification.object as? URL {
            do {
                try loader?.oauth2.handleRedirectURL(url)
            }
            catch let error {
               show(error)
            }
        }
        else {
            show(NSError(domain: NSCocoaErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid notification: did not contain a URL"]))
        }
    }
    
    // MARK: - Error Handling
    
    /** Forwards to `display(error:)`. */
    func show(_ error: Error) {
        if let error = error as? OAuth2Error {
            let err = NSError(domain: "OAuth2ErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: error.description])
            display(err)
        }
        else {
            display(error as NSError)
        }
    }

    /** Alert or log the given NSError. */
    func display(_ error: NSError) {
        if let window = self.view.window {
            NSAlert(error: error).beginSheetModal(for: window, completionHandler: nil)
        }
        else {
            NSLog("Error authorizing: \(error.description)")
        }
    }
    
    func openViewControllerWithLoader(_ loader: DataLoader, sender:  NSButton) {
       
        loader.oauth2.forgetTokens()
        
        UserDefaults.standard.set(self.ipAddress.stringValue, forKey: "URL")
        UserDefaults.standard.set(false, forKey: "login")
        // config OAuth2
        self.loader = loader
        loader.oauth2.authConfig.authorizeContext = view.window
        NotificationCenter.default.removeObserver(self, name: OAuth2CallbackNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleRedirect(_:)), name: OAuth2CallbackNotification, object: nil)
        
        // load user data
        loader.requestUserdata() { dict, error in
            if let error = error {
                switch error {
                case OAuth2Error.requestCancelled:
                    self.dialogOKCancel(message: "Error", text: "Your credentials are incorrect")
                    break
                default:
                    self.show(error)
                    break
                }
            }
            else {
                
                var staffUsername: String = ""
                var staffID: String = ""
                
                if self.rememberMe.state == 1 {
                    UserDefaults.standard.set(true, forKey: "login")
                }
                
                if let imgURL = dict?["avatar_url"] as? String {
                    UserDefaults.standard.set(imgURL, forKey: "username_img")
                }
                if let username = dict?["name"] as? String {
                    staffUsername = username
                    UserDefaults.standard.set(username, forKey: "username")
                }
                if let user_id = dict?["user_id"] as? String {
                    staffID = user_id
                    UserDefaults.standard.set(user_id, forKey: "user_id")
                }
                else {
                    NSLog("Fetched: \(String(describing: dict))")
                }
                
                self.getStaffDetails(staffID, staffUsername)
                
                self.loadMainView(sender: sender)
            }
        }
    }
    
    func loadMainView(sender: NSButton?) {
        
        self.view.window?.close()
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        if let wc = storyboard.instantiateController(withIdentifier: "MainViewController") as? NSWindowController {
            if let vc = wc.contentViewController as? ViewController {
                vc.oAuthLoader = self.loader
                
                wc.showWindow(sender)
                openController = wc
                return
            }
            
        }
    }
    
    func getStaffDetails(_ userID: String, _ username: String) {
        
        let staffMembers = [Staff]()
        staffMembers.getFilteredInBackground(ofType: Staff.self, query: ["userID":userID as AnyObject]) { ( complete, allStaff) in
            
            DispatchQueue.main.async {
                if complete {
                    
                    if allStaff.count > 0 {
                        
                        guard let currentStaff = allStaff.first else {
                            return
                        }
                        
                        UserDefaults.standard.set(username, forKey: "username")
                        UserDefaults.standard.set(currentStaff.databasePerms, forKey: "database")
                        UserDefaults.standard.set(currentStaff.servicesPerms, forKey: "services")
                        UserDefaults.standard.set(currentStaff.staffType.rawValue, forKey: "staff_type")
                    }
                    
                    else {
                        
                        let newStaff = Staff(username: username, password: "", firstName: "", lastName: "", email: "", staffType: StaffType.Manager, databasePerms: "1,1,1,1", servicesPerms: "1,1,1,1,1,1,1,1", userID: userID)
                        
                        newStaff.sendInBackground("", postCompleted: { (complete, data) in
                            DispatchQueue.main.async {
                                print("new user")
                            }
                        })
                        
                        UserDefaults.standard.set(username, forKey: "username")
                        UserDefaults.standard.set(newStaff.databasePerms, forKey: "database")
                        UserDefaults.standard.set(newStaff.servicesPerms, forKey: "services")
                        UserDefaults.standard.set(newStaff.staffType.rawValue, forKey: "staff_type")

                    }
                    
                }
            }
        }
        
        
        
//        Staff.login(username: self.username.stringValue, password: self.password.stringValue) { (completed, result, staff) in
//            
//            if completed {
//                
//                if result == .Success && staff != nil {
//                    
//                    if staff!.resetPassword == 1 {
//                        DispatchQueue.main.async(execute: {
//                            self.loadResetPasswordView()
//                        })
//                    } else {
//                        
//                        UserDefaults.standard.set(self.username.stringValue, forKey: "username")
//                        
//                        UserDefaults.standard.set(staff!.databasePerms, forKey: "database")
//                        UserDefaults.standard.set(staff!.servicesPerms, forKey: "services")
//                        
//                        if self.rememberMe.state == 1 {
//
//                            UserDefaults.standard.set(true, forKey: "login")
//
//                        }
//                        self.loginSuccessful = true
//                        
//                        if Thread.isMainThread {
//                            print("Main Thread")
//                        }
//                        
//                        //self.loadMainView()
//                        //self.checkLoggedIn()
//                        DispatchQueue.main.async(execute: {
//                            self.loadMainView()
//                        })
//                    }
//                } else {
//                    
//                    self.dialogOKCancel(message: "Error", text: "Your credentials are incorrect")
//                }
//                
//            } else {
//                print("error")
//            }
//        }
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

//self.loadResetPasswordView()

//self.loadResetPasswordView()
//        if self.ipAddress.stringValue == UserDefaults.standard.string(forKey: "URL") ?? "" {
//
//            if UserDefaults.standard.bool(forKey: "login") {
//
//                self.loadMainView()
//
//            } else {
//                // self.loadResetPasswordView()
//                UserDefaults.standard.set(self.ipAddress.stringValue, forKey: "URL")
//                self.tryLogin(username.stringValue, password: password.stringValue)
//            }
//
//        } else {
//            UserDefaults.standard.set(self.ipAddress.stringValue, forKey: "URL")
//            UserDefaults.standard.set(false, forKey: "login")

//self.tryLogin(username.stringValue, password: password.stringValue)
