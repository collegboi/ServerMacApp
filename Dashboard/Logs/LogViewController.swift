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
    
    var allLogs = [String]()
    
    fileprivate var logsViewDelegate: GenericTableViewDelegate!
    fileprivate var logsViewDataSource: GenericDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logsViewDataSource = GenericDataSource(tableView: self.logsTableView)
        self.logsViewDelegate = GenericTableViewDelegate(tableView: self.logsTableView)
        
        self.getAllLogs()
    }
    
    func reloadLogsTableView() {
        self.logsViewDelegate.reload(self.allLogs)
        self.logsViewDataSource.reload(count: self.allLogs.count)
    }
    
    func getAllLogs() {
        
        HTTPSConnection.httpGetRequest(params: [:], url: "/api/JKHSDGHFKJGH454645GRRLKJF/logs") { ( retrieved, data) in
            
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
