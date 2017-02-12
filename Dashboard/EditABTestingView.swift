//
//  EditABTestingView.swift
//  Dashboard
//
//  Created by Timothy Barnard on 12/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class EditABTestingView: NSViewController {

    @IBOutlet weak var abTestingNameField: NSTextField!
    
    @IBOutlet weak var comboxBoxVersionA: NSComboBox!
    @IBOutlet weak var comboBoxVersionB: NSComboBox!
    
    @IBOutlet weak var datePickerStart: NSDatePicker!
    @IBOutlet weak var datePickerEnd: NSDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        let application = NSApplication.shared()
        application.stopModal()
    }
    
    @IBAction func pushButton(_ sender: Any) {
        
        let abTesting = ABTesting(name: self.abTestingNameField.stringValue,
                                  versionA: self.comboxBoxVersionA.stringValue,
                                  versionB: self.comboBoxVersionB.stringValue,
                                  startDateTime: self.datePickerStart.stringValue,
                                  endDateTime: self.datePickerEnd.stringValue)
        
        abTesting.sendInBackground("") { ( sent, data) in
            DispatchQueue.main.async {
                if sent {
                    print("sent")
                    
                    let application = NSApplication.shared()
                    application.stopModal()
                    
                } else {
                    print("not sent")
                }
            }
        }
        
    }
}
