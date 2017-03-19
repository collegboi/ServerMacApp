//
//  SendNotificationView.swift
//  Dashboard
//
//  Created by Timothy Barnard on 07/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class SendNotificationView: NSViewController, NSWindowDelegate {

    
    
    @IBOutlet weak var messageTextField: NSTextField!
    @IBOutlet weak var columnComboBox: NSPopUpButton!
    @IBOutlet weak var conditionComboBox: NSPopUpButton!
    
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var badgeNoTextField: NSTextField!
    @IBOutlet weak var soundTextField: NSTextField!
    @IBOutlet weak var valueTextField: NSTextField!

    
    @IBOutlet weak var development: NSButton!
    
    @IBOutlet weak var sendButton: NSButton!
    
    var notifcation: TBNotification?
    var delegate: ReturnDelegate?
    var appKey: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.sendButton.isEnabled = false
    }
    
    func windowShouldClose(_ sender: Any) -> Bool {
        let application = NSApplication.shared()
        application.stopModal()
        return true
        
    }
    
    override func viewDidAppear() {
        
        self.view.window?.delegate = self

        
        if self.notifcation != nil {
            
        }
    }
    @IBAction func sendButton(_ sender: Any) {
        
        let newNotification = TBNotification()
        newNotification.message = self.messageTextField.stringValue
        newNotification.deviceID = self.valueTextField.stringValue
        newNotification.setDevelopment(self.development.state)
        
        newNotification.sendNotification(self.appKey) { (completed, returnStr ) in
         
            DispatchQueue.main.async {
                if (completed) {
                    self.delegate?.sendBackData(data: newNotification )
                    print("completed")
                } else {
                    print("error")
                }
            }

        }
        
    }
    
}
