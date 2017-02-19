//
//  EditTextViewControlller.swift
//  Dashboard
//
//  Created by Timothy Barnard on 11/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class EditTextViewControlller: NSViewController {
    
    var rcProperty: RCProperty?
    
    var delegate: ReturnDelegate?
    
    @IBOutlet weak var keyTextField: NSTextField!
    @IBOutlet weak var valueTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear() {
        self.keyTextField.stringValue = rcProperty?.key ?? ""
        self.valueTextField.stringValue = rcProperty?.valueStr ?? ""
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        let application = NSApplication.shared()
        application.stopModal()
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
        
        let application = NSApplication.shared()
        application.stopModal()
    }
}
