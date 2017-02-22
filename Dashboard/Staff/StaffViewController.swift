//
//  StaffViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class StaffViewController: NSViewController {

    @IBOutlet weak var staffAnalyticsView: StaffStatsView!
    @IBOutlet weak var staffTableView: NSTableView!
    
    fileprivate var staffViewDelegate: StaffViewDelegate!
    fileprivate var staffViewDataSource: GenericDataSource!
    
    var allStaff = [Staff]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.staffAnalyticsView.setBackgroundColor(NSColor.white)
        let strings4 : [String] = ["Used", "Left"]
        let double4 : [Double] = [90, 10]
        self.staffAnalyticsView.setBarChart(dataPoints: strings4, values: double4, label: "Test")
        self.staffAnalyticsView.updateChartWithData()
        
        self.staffViewDataSource = GenericDataSource(tableView: self.staffTableView)
        self.staffViewDelegate = StaffViewDelegate(tableView: self.staffTableView, selectionBlock: { (staff) in
            self.editStaffMember(staff)
        })
        
        self.getAllStaffMembers()
    }
    
    func getAllStaffMembers() {
        
        self.allStaff.getAllInBackground(ofType: Staff.self) { (got, staffMembers) in
            DispatchQueue.main.async {
                if got {
                    self.allStaff = staffMembers
                    self.reloadStaffTableView()
                }
            }
        }
    }
    
    @IBAction func newStaffMember(_ sender: Any) {
        
        let storyboard = NSStoryboard(name: "Staff", bundle: nil)
        let staffWindowController = storyboard.instantiateController(withIdentifier: "EditStaff") as! NSWindowController
        
        if let staffWindow = staffWindowController.window {
            
            let editStaffViewController = staffWindow.contentViewController as! EditStaffView
            editStaffViewController.returnDelegate = self
            
            let application = NSApplication.shared()
            application.runModal(for: staffWindow)
        }
    }
    
    func editStaffMember(_ staff: Staff ) {
        
        let storyboard = NSStoryboard(name: "Staff", bundle: nil)
        let staffWindowController = storyboard.instantiateController(withIdentifier: "EditStaff") as! NSWindowController
        
        if let staffWindow = staffWindowController.window {
            
            let editStaffViewController = staffWindow.contentViewController as! EditStaffView
            editStaffViewController.returnDelegate = self
            editStaffViewController.staffMember = staff
      
            let application = NSApplication.shared()
            application.runModal(for: staffWindow)
        }
    }
    
    func reloadStaffTableView() {
        
        self.staffViewDelegate.reload(self.allStaff)
        self.staffViewDataSource.reload(count: self.allStaff.count)
    }
    
}

extension StaffViewController: ReturnDelegate {
    
    func sendBackData(data: Any) {
        
        guard let staffMember = data as? Staff else {
            return
        }
        
        self.allStaff.append(staffMember)
    }
}
