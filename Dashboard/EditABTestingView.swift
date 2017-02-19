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
    
    @IBOutlet weak var comboBoxApp: NSComboBox!
    @IBOutlet weak var comboBoxVersion: NSComboBox!
    @IBOutlet weak var comboxBoxVersionA: NSComboBox!
    @IBOutlet weak var comboBoxVersionB: NSComboBox!
    
    @IBOutlet weak var datePickerStart: NSDatePicker!
    @IBOutlet weak var datePickerEnd: NSDatePicker!
    
    var allApps = [TBApplication]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.comboBoxApp.delegate = self
        self.getAllApps()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        let application = NSApplication.shared()
        application.stopModal()
    }
    
    private func stringDateTime( date: Date ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        
        return dateFormatter.string(from: date)
    }

    
    @IBAction func pushButton(_ sender: Any) {
        
        
        let fromDate = self.datePickerStart.dateValue
        let toDate = self.datePickerEnd.dateValue
        
        
        let abTesting = ABTesting(name: self.abTestingNameField.stringValue,
                                  version: self.comboBoxVersion.stringValue,
                                  versionA: self.comboxBoxVersionA.stringValue,
                                  versionB: self.comboBoxVersionB.stringValue,
                                  startDateTime: self.stringDateTime(date: fromDate),
                                  endDateTime: self.stringDateTime(date: toDate) )
        
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

extension EditABTestingView: NSComboBoxDelegate {
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        
        guard let comboBox = notification.object as? NSComboBox else {
            return
        }
        let selectedRow = comboBox.indexOfSelectedItem
        let item = self.allApps[selectedRow]
        
        self.getAllAppVersions(item.objectID!.objectID)
        
        self.getAllConfigVersions(item.objectID!.objectID)
    }
}


//Getting Records
extension EditABTestingView {
    
    func getAllConfigVersions(_ appID: String ) {
        
        var allVersions = [RemoteConfig]()
        
        allVersions.getFilteredInBackground(ofType: RemoteConfig.self, query: ["applicationID": appID as AnyObject ]) { (retrieved, versions) in
            DispatchQueue.main.async {
                if retrieved {
                    allVersions = versions
                    
                    for version in versions {
                        self.comboxBoxVersionA.addItem(withObjectValue: version.version)
                        self.comboBoxVersionB.addItem(withObjectValue: version.version)
                    }
                }
            }
        }
    }
    
    func getAllAppVersions(_ appID: String ) {
        
        var allVersions = [TBAppVersion]()
        
        allVersions.getFilteredInBackground(ofType: TBAppVersion.self, query: ["applicationID": appID as AnyObject ]) { (retrieved, versions) in
            DispatchQueue.main.async {
                if retrieved {
                    allVersions = versions
                    
                    for version in versions {
                        self.comboBoxVersion.addItem(withObjectValue: version.version)
                    }
                }
            }
        }
    }
    
    func getAllApps() {
        
        self.allApps.getAllInBackground(ofType: TBApplication.self) { (retrieved, apps) in
            DispatchQueue.main.async {
                if retrieved {
                    self.allApps = apps
                    
                    for app in apps {
                        self.comboBoxApp.addItem(withObjectValue: app.name)
                    }
                }
            }
        }
    }
}
