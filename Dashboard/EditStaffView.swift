//
//  EditStaffView.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class EditStaffView: NSViewController, NSWindowDelegate {
    
    @IBOutlet weak var usernameTextField: NSTextField!
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var firstNameTextField: NSTextField!
    @IBOutlet weak var lastNameTextField: NSTextField!

    @IBOutlet weak var resetPasswordTick: NSButton!
    @IBOutlet weak var staffTypeComboBox: NSComboBox!
    
    @IBOutlet weak var checkAll: NSButton!
    
    @IBOutlet weak var storageTickBox: NSButton!
    @IBOutlet weak var notifiicationsTickBox: NSButton!
    @IBOutlet weak var remoteConfigTickBox: NSButton!
    @IBOutlet weak var abTestingTickBox: NSButton!
    @IBOutlet weak var analyticsTickBox: NSButton!
    @IBOutlet weak var backupTickBox: NSButton!
    @IBOutlet weak var crashesTickBox: NSButton!
    @IBOutlet weak var langugesTickBox: NSButton!
    
    @IBOutlet weak var createTickBox: NSButton!
    @IBOutlet weak var readTickBox: NSButton!
    @IBOutlet weak var updateTickBox: NSButton!
    @IBOutlet weak var deleteTickBox: NSButton!
    
    var staffMember: Staff?
    var returnDelegate: ReturnDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.window?.delegate = self
    }
    
    func windowShouldClose(_ sender: Any) -> Bool {
        let application = NSApplication.shared()
        application.stopModal()
        return true
    }
    
    @IBAction func checkAll(_ sender: Any) {
        self.storageTickBox.state = self.checkAll.state
        self.notifiicationsTickBox.state = self.checkAll.state
        self.remoteConfigTickBox.state = self.checkAll.state
        self.abTestingTickBox.state = self.checkAll.state
        self.analyticsTickBox.state = self.checkAll.state
        self.backupTickBox.state = self.checkAll.state
        self.crashesTickBox.state = self.checkAll.state
        self.langugesTickBox.state = self.checkAll.state
        self.createTickBox.state = self.checkAll.state
        self.readTickBox.state = self.checkAll.state
        self.updateTickBox.state = self.checkAll.state
        self.deleteTickBox.state  = self.checkAll.state
    }
    
    override func viewDidAppear() {
        
        if self.staffMember != nil {
            self.usernameTextField.stringValue = self.staffMember!.username
            self.emailTextField.stringValue = self.staffMember!.email
            self.firstNameTextField.stringValue = self.staffMember!.firstName
            self.lastNameTextField.stringValue = self.staffMember!.lastName
            self.resetPasswordTick.state = self.staffMember!.resetPassword
            
            let databasePerms = self.staffMember!.databasePerms.components(separatedBy: ",")
            
            if databasePerms.count >= 4 {
                self.createTickBox.state = Int(databasePerms[0]) ?? 0
                self.readTickBox.state = Int(databasePerms[1]) ?? 0
                self.updateTickBox.state = Int(databasePerms[2]) ?? 0
                self.deleteTickBox.state = Int(databasePerms[3]) ?? 0
            }
            
            let servicesPerms = self.staffMember!.servciesPerms.components(separatedBy: ",")
            
            if servicesPerms.count >= 8 {
                self.storageTickBox.state = Int(servicesPerms[0]) ?? 0
                self.notifiicationsTickBox.state = Int(servicesPerms[1]) ?? 0
                self.remoteConfigTickBox.state = Int(servicesPerms[2]) ?? 0
                self.abTestingTickBox.state = Int(servicesPerms[3]) ?? 0
                self.analyticsTickBox.state = Int(servicesPerms[4]) ?? 0
                self.backupTickBox.state = Int(servicesPerms[5]) ?? 0
                self.crashesTickBox.state = Int(servicesPerms[6]) ?? 0
                self.langugesTickBox.state = Int(servicesPerms[7]) ?? 0
            }
        }
    }
    
    @IBAction func sendStaffMember(_ sender: Any) {
        
        let databasePermissions = "\(self.createTickBox.state),\(self.readTickBox.state),\(self.updateTickBox.state),\(self.deleteTickBox.state)"
        var servicePermissions = "\(self.storageTickBox.state),\(self.notifiicationsTickBox.state),\(self.remoteConfigTickBox.state),\(self.abTestingTickBox.state),"
        servicePermissions = servicePermissions + "\(self.analyticsTickBox.state),\(self.backupTickBox.state),\(self.crashesTickBox.state),\(self.langugesTickBox.state)"
        
        let staffID = self.staffMember?.staffID?.objectID ?? ""
        let password = self.staffMember?.password ?? ""
        
        let staffMember = Staff(username: self.usernameTextField.stringValue,
                                password: password,
                                firstName: self.firstNameTextField.stringValue,
                                lastName: self.lastNameTextField.stringValue,
                                email: self.emailTextField.stringValue,
                                staffType: StaffType(rawValue: self.staffTypeComboBox.stringValue)!,
                                databasePerms: databasePermissions,
                                servicesPerms: servicePermissions,
                                resetPassword: self.resetPasswordTick.state)
        
        staffMember.sendInBackground(staffID) { (sent, data) in
            DispatchQueue.main.async {
                if sent {
                    self.returnDelegate?.sendBackData(data: staffMember)
                    print("staff member sent")
                    self.view.window?.close()
                    let application = NSApplication.shared()
                    application.stopModal()
                }
            }
        }
    }
    
    
    @IBAction func cancelEditStaffMember(_ sender: Any) {
        self.view.window?.close()
        let application = NSApplication.shared()
        application.stopModal()
    }
    
    
}
