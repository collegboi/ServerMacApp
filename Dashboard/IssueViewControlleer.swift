//
//  IssueViewControlleer.swift
//  Dashboard
//
//  Created by Timothy Barnard on 28/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class IssueViewControlleer: NSViewController {
    
    @IBOutlet var issuesTableView: NSTableView!
    
    @IBOutlet var newIssueButton: NSButton!
    
    fileprivate var issueViewDelegate: IssueViewDelegate!
    fileprivate var issueViewDataSource: IssueViewDataSource!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        issueViewDataSource = IssueViewDataSource(tableView: issuesTableView)
        issueViewDelegate = IssueViewDelegate(tableView: issuesTableView) { issue in
            
        }
        
        self.getAllIssues()
    }
    
    
    @IBAction func newIssueButton(_ sender: Any) {
        
    }
    
    func getAllIssues() {
        
        let apiEndpoint = "http://0.0.0.0:8181/"
        
        print("sendRawTimetable")
        let networkURL = apiEndpoint + "tracker/issue"
        let dic = [String:AnyObject]()
        HTTPSConnection.httpGetRequest(params: dic, url: networkURL) { (succeeded: Bool, data: NSData) -> () in
            // Move to the UI thread
            
            DispatchQueue.main.async {
                if (succeeded) {
                    print("Succeeded")
                    let issues = IssueJSON.parseJSONConfig(data: data as Data)
                    
                    self.issueViewDelegate.reload(issues)
                    self.issueViewDataSource.reload(count: issues.count)
                    
                } else {
                    print("Error")
                }
            }
        }
    }
    


    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }


    func sendNewIssue( issue: Issue ) {
        // Correct url and username/password
        
        if let json = issue.toJSON() {
            let data = self.convertStringToDictionary(text: json)
            
            let apiEndpoint = "http://0.0.0.0:8181/"
            
            print("sendRawTimetable")
            let networkURL = apiEndpoint + "tracker"
            let dic = data
            HTTPSConnection.httpRequest(params: dic!, url: networkURL, httpMethod: "POST") { (succeeded: Bool, data: NSData) -> () in
                // Move to the UI thread
                
                DispatchQueue.main.async {
                    if (succeeded) {
                        print("Succeeded")
                        //self.config = HTTPSConnection.parseJSONConfig(data: data)
                        
                        
                        //                    if let json = self.config!.toJSONObjects() {
                        //                        print(json)
                        //                        self.sendRemoteConfigFiles(json: json)
                        //                    }
                        
                        //self.reloadAllData()
                        
                    } else {
                        print("Error")
                    }
                }
            }
        }
    }

    
}
