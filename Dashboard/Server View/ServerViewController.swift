//
//  ServerViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

@IBDesignable class ServerViewController: NSViewController {
    
    @IBOutlet weak var systemsView1: SystemsView!
    @IBOutlet weak var systemsView2: SystemsView!
    @IBOutlet weak var systemsView3: SystemsView!
    @IBOutlet weak var systemsView4: SystemsView!
    
    @IBOutlet weak var databaseStatusLabel: NSTextField!
    @IBOutlet weak var restartDatabase: NSButton!
    
    
    @IBOutlet weak var userView: UserView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDatabaseLabel(1)
        self.getSystemStatus()
        
        self.userView.setBackgroundColor(NSColor.white)
        self.systemsView1.setBackgroundColor(NSColor.white)
        self.systemsView2.setBackgroundColor(NSColor.white)
        self.systemsView3.setBackgroundColor(NSColor.white)
        self.systemsView4.setBackgroundColor(NSColor.white)
    }
    
    @IBAction func restartDatabase(_ sender: Any) {
        self.restartDatabase.isEnabled = false
        self.setDatabaseLabel(1)
        self.restartDatabaseHTTP()
    }
    
    func setDatabaseLabel(_ status: Int ) {
        
        self.databaseStatusLabel.drawsBackground = true
        self.databaseStatusLabel.alignment = .center
        
        switch status {
        case 0:
            self.databaseStatusLabel.stringValue = "Not Running"
            self.databaseStatusLabel.backgroundColor = NSColor.red
            self.databaseStatusLabel.textColor = NSColor.white
        case 1:
            self.databaseStatusLabel.stringValue = "Pending"
            self.databaseStatusLabel.backgroundColor = NSColor.yellow
            self.databaseStatusLabel.textColor = NSColor.white
            break
        case 2:
            self.databaseStatusLabel.stringValue = "Restarting"
            self.databaseStatusLabel.backgroundColor = NSColor.orange
            self.databaseStatusLabel.textColor = NSColor.white
            break
        case 3:
            self.databaseStatusLabel.stringValue = "Running"
            self.databaseStatusLabel.backgroundColor = NSColor.green
            self.databaseStatusLabel.textColor = NSColor.white
            break
        default:
            self.databaseStatusLabel.stringValue = "Not Running"
            self.databaseStatusLabel.backgroundColor = NSColor.yellow
            self.databaseStatusLabel.textColor = NSColor.white
            break
        }
    }
    
    func setStatsViews(_ systemStatus: SystemStatus  ) {
        
        let strings1 : [String] = ["Idle", "System", "User"]
        let double1 : [Double] = [systemStatus.cpu.idle, systemStatus.cpu.system, systemStatus.cpu.user ]
        self.systemsView1.setPieChart(dataPoints: strings1, values: double1, label: "CPU")
        
        let free = ( systemStatus.memory.avialable / systemStatus.memory.total ) * 100
        let used = ( systemStatus.memory.used / systemStatus.memory.total ) * 100
        
        let strings2 : [String] = ["Free", "Used"]
        let double2 : [Double] = [free, used]
        self.systemsView2.setPieChart(dataPoints: strings2, values: double2, label: "Memory")
        
        let availS = ( systemStatus.storage.avialable / systemStatus.storage.total ) * 100
        let usedS = ( systemStatus.storage.used / systemStatus.storage.total ) * 100
        
        let strings3 : [String] = ["Avail", "Used"]
        let double3 : [Double] = [availS, usedS]
        self.systemsView3.setPieChart(dataPoints: strings3, values: double3, label: "Storage")
        
        let strings4 : [String] = ["Used", "Left"]
        let double4 : [Double] = [90, 10]
        self.systemsView4.setPieChart(dataPoints: strings4, values: double4, label: "CPU")
    }
    
    func restartDatabaseHTTP() {
        
        HTTPSConnection.httpGetRequest(params: [:], url: "/system/restart") { ( complete, data) in
            
            DispatchQueue.main.async {
                
                self.restartDatabase.isEnabled = true
                
                if complete {
                    
                    self.getSystemStatus()
                } else {
                    self.setDatabaseLabel(0)
                }
            }
        }

    }
    
    func getSystemStatus() {
        
        HTTPSConnection.httpGetRequest(params: [:], url: "/system/") { ( complete, data) in
            
            DispatchQueue.main.async {
                
                if complete {
                    
                    do {
                        
                        let data = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? [String:Any]
                        
                        guard let objects = data?["data"] as? [String:Any] else {
                            return
                        }
                        let systemStats = SystemStatus(dict: objects)
                        self.setStatsViews(systemStats)
                        
                    } catch let error {
                        print(error)
                    }
                }
            }
        }
    }
}
