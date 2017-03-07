//
//  EditTextViewControlller.swift
//  Dashboard
//
//  Created by Timothy Barnard on 11/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class EditTextViewControlller: NSViewController, NSWindowDelegate {
    
    var rcProperty: RCProperty?
    
    var delegate: ReturnDelegate?
    
    @IBOutlet weak var keyTextField: NSTextField!
    @IBOutlet weak var valueTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.window?.delegate = self
        
    }
    
    override func viewDidAppear() {
        self.keyTextField.stringValue = rcProperty?.key ?? ""
        self.valueTextField.stringValue = rcProperty?.valueStr ?? ""
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.view.window?.close()
        let application = NSApplication.shared()
        application.stopModal()
    }
    
    func windowShouldClose(_ sender: Any) -> Bool {
        let application = NSApplication.shared()
        application.stopModal()
        return true
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
        let rc1Property = RCProperty(key: self.keyTextField.stringValue,
                                    valueStr: self.valueTextField.stringValue,
                                    valueNo: self.rcProperty?.valueNo ?? -1,
                                    row: self.rcProperty?.row ?? 0,
                                    type: "Text",
                                    parent: self.rcProperty?.parent ?? 0,
                                    settingPart: self.rcProperty?.settingPart ?? .MainSetting )
        
        self.delegate?.sendBackData(data: rc1Property)
        
        self.view.window?.close()
        let application = NSApplication.shared()
        application.stopModal()
    }
}
