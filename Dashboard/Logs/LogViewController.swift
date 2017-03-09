//
//  LogViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class LogViewController: NSViewController {
    
    @IBOutlet weak var logsTableView: NSTableView!
    @IBOutlet weak var comboBoxLogs: NSComboBox!
    
    var allLogs = [String]()
    
    var lognames: [String] = ["requests","database","languages"]
    
    fileprivate var logsViewDelegate: GenericTableViewDelegate!
    fileprivate var logsViewDataSource: GenericDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.comboBoxLogs.delegate = self
        self.logsViewDataSource = GenericDataSource(tableView: self.logsTableView)
        self.logsViewDelegate = GenericTableViewDelegate(tableView: self.logsTableView)
    }
    
    func reloadLogsTableView() {
        self.logsViewDelegate.reload(self.allLogs)
        self.logsViewDataSource.reload(count: self.allLogs.count)
    }
    
    func getAllLogs(name: String ) {
        
        HTTPSConnection.httpGetRequest(params: [:], url: "/api/JKHSDGHFKJGH454645GRRLKJF/logs/" + name ) { ( retrieved, data) in
            
            DispatchQueue.main.async {
                if retrieved {
                    
                    do {
                        
                        guard let responseDictionary = try JSONSerialization.jsonObject(with: data as Data) as? [String:Any] else {
                            return
                        }
                        
                        self.allLogs = responseDictionary.tryConvert(forKey: "data")
                        self.reloadLogsTableView()
                    } catch {
                        
                    }
                    
                }
            }
        }
    }
}

extension LogViewController: NSComboBoxDelegate {
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        
        guard let comboBox = notification.object as? NSComboBox else {
            return
        }
        let selectedRow = comboBox.indexOfSelectedItem
        if selectedRow >= 0 {
            let item = self.lognames[selectedRow]
            self.getAllLogs(name: item)
        }
    }

    
}
