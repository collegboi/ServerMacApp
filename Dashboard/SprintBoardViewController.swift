//
//  SprintBoardViewController.swift
//  Dashboard
//
//  Created by Timothy Barnard on 27/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa

class SprintBoardViewController: NSViewController {
    
    @IBOutlet weak var todoListTableView: NSTableView!
    @IBOutlet weak var inProgressTableView: NSTableView!
    @IBOutlet weak var completeTableView: NSTableView!
    @IBOutlet weak var onHoldTableView: NSTableView!
    
    var allIssues = [Issue]()
    var todoListDataArr = [Issue]()
    var inProgressDataArr = [Issue]()
    var completeDataArr = [Issue]()
    var onHoldDataArr = [Issue]()

//    var todoListDataArray:[String] = []
//    var inProgressDataArray:[String] = []
//    var completeDataArray:[String] = []
//    var onHoldDataArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let registeredTypes:[String] = [NSStringPboardType]
        todoListTableView.register(forDraggedTypes: registeredTypes)
        inProgressTableView.register(forDraggedTypes: registeredTypes)
        completeTableView.register(forDraggedTypes: registeredTypes)
        onHoldTableView.register(forDraggedTypes: registeredTypes)

        
        self.todoListTableView.delegate = self
        self.todoListTableView.dataSource = self
        
        self.inProgressTableView.delegate = self
        self.inProgressTableView.dataSource = self
        
        self.completeTableView.delegate = self
        self.completeTableView.dataSource = self
        
        self.onHoldTableView.delegate = self
        self.onHoldTableView.dataSource = self
        
        self.getAllIssues()
        
    }
    
    func getAllIssues() {
        
        let apiEndpoint = "http://0.0.0.0:8181/"
        
        print("sendRawTimetable")
        let networkURL = apiEndpoint + "tracker/Issue"
        let dic = [String:AnyObject]()
        HTTPSConnection.httpGetRequest(params: dic, url: networkURL) { (succeeded: Bool, data: NSData) -> () in
            // Move to the UI thread
            
            DispatchQueue.main.async {
                if (succeeded) {
                    print("Succeeded")
                    self.allIssues = IssueJSON.parseJSONConfig(data: data as Data)
            
                    self.sortIssuesByType()
                    
                } else {
                    print("Error")
                }
            }
        }
    }
    
    func sortIssuesByType() {
        
        for issue in self.allIssues {
            
            switch issue.status {
            case "TODO":
                self.todoListDataArr.append(issue)
            case "On Hold":
                self.onHoldDataArr.append(issue)
            case "Complete":
                self.completeDataArr.append(issue)
            case "In Progress":
                self.inProgressDataArr.append(issue)
            default:
                print("wrong type")
            }
        }
        
        self.todoListTableView.reloadData()
        self.inProgressTableView.reloadData()
        self.completeTableView.reloadData()
        self.onHoldTableView.reloadData()
    }
    
    func sendIssue(_ issue: Issue) {
        // Correct url and username/password
        
        if let json = issue.toJSON() {
            let data = HTTPSConnection.convertStringToDictionary(text: json)
            
            var newData = [String:AnyObject]()
            newData = data!
            
            if issue.issueID.objectID != "" {
                newData["_id"] = issue.issueID.objectID as AnyObject?
            }
            
            
            let apiEndpoint = "http://0.0.0.0:8181/"
            let networkURL = apiEndpoint + "tracker/Issue/"
            
            let dic = newData
            HTTPSConnection.httpRequest(params: dic, url: networkURL, httpMethod: "POST") { (succeeded: Bool, data: NSData) -> () in
                // Move to the UI thread
                
                DispatchQueue.main.async {
                    if (succeeded) {
                        print("scucess")
                    } else {
                        print("error")
                    }
                }
            }
        }
    }


    
}

extension SprintBoardViewController: NSTableViewDelegate,NSTableViewDataSource {
    
    func numberOfRows(in aTableView: NSTableView) -> Int {
        
        var numberOfRows:Int = 0;
        if (aTableView == todoListTableView) {
            numberOfRows = todoListDataArr.count
        }
        else if (aTableView == inProgressTableView) {
            numberOfRows = inProgressDataArr.count
        }
        else if (aTableView == completeTableView) {
            numberOfRows = completeDataArr.count
        }
        else if ( aTableView == onHoldTableView) {
            numberOfRows = onHoldDataArr.count
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?
    {
        var newString:String = ""
        if (tableView == todoListTableView) {
            newString = todoListDataArr[row].name
        }
        else if (tableView == inProgressTableView) {
            newString = inProgressDataArr[row].name
        }
        else if (tableView == completeTableView) {
            newString = completeDataArr[row].name
        }
        else if(tableView == onHoldTableView) {
            newString = onHoldDataArr[row].name
        }
        return newString;
    }
    
    
    func tableView(_ aTableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool
    {
        if ((aTableView == todoListTableView) || (aTableView == inProgressTableView)
            || (aTableView == completeTableView) || (aTableView == onHoldTableView)) {
            let data:Data = NSKeyedArchiver.archivedData(withRootObject: rowIndexes)
            let registeredTypes:[String] = [NSStringPboardType]
            pboard.declareTypes(registeredTypes, owner: self)
            pboard.setData(data, forType: NSStringPboardType)
            return true
            
        }
        else
        {
            return false
        }
    }
    
    
    func tableView(_ aTableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int,
                   proposedDropOperation operation: NSTableViewDropOperation) -> NSDragOperation
    {
        
        if operation == .above {
            return .move
        }
        return NSDragOperation.every
        
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool
    {
        let data:Data = info.draggingPasteboard().data(forType: NSStringPboardType)!
        let rowIndexes:IndexSet = NSKeyedUnarchiver.unarchiveObject(with: data) as! IndexSet
        
    
        
        if ((tableView == todoListTableView) || (tableView == inProgressTableView)
            || (tableView == completeTableView) || (tableView == onHoldTableView)) {
            
            if ( (info.draggingSource() as! NSTableView) == tableView ) {
                print("draggin on same tableview")
                
                guard let newStr = self.removeFromTable(tableView: info.draggingSource() as! NSTableView, row: rowIndexes.first!) else {
                    return false
                }
                self.updateSameTable(tableView: tableView, row: rowIndexes.first!, value: newStr)
                
            }
            else {
            
                guard let newStr = self.removeFromTable(tableView: info.draggingSource() as! NSTableView, row: rowIndexes.first!) else {
                    return false
                }
            
                let issue = self.addToTable(tableView: tableView, value: newStr)
                
                self.sendIssue(issue)
            }
            
            self.reloadAllTable()
            
            return true
        } else {
            return false
        }
        
    }
    
    func updateSameTable(tableView: NSTableView, row: Int, value: Issue) {
        
        switch tableView {
        case todoListTableView:
            if (row > todoListDataArr.count) {
                todoListDataArr.insert(value, at: row-1)
            }
            else {
                todoListDataArr.insert(value, at: row)
            }
            break
        case inProgressTableView:
            if (row > inProgressDataArr.count) {
                inProgressDataArr.insert(value, at: row-1)
            }
            else {
                inProgressDataArr.insert(value, at: row)
            }
            break
        case completeTableView:
            if (row > completeDataArr.count) {
                completeDataArr.insert(value, at: row-1)
            }
            else {
                completeDataArr.insert(value, at: row)
            }
            break
        case onHoldTableView:
            if (row > onHoldDataArr.count) {
                onHoldDataArr.insert(value, at: row-1)
            }
            else {
                onHoldDataArr.insert(value, at: row)
            }
            break
        default:
            print("Error with NSTableView")
        }
    
    }
    
    
    func addToTable( tableView: NSTableView, value: Issue ) -> Issue {
        
        var issue = value
        
        switch tableView {
        case todoListTableView:
            issue.status = "TODO"
            self.todoListDataArr.append(value)
            break
        case inProgressTableView:
            issue.status = "In Progress"
            self.inProgressDataArr.append(value)
            break
        case completeTableView:
            issue.status = "Complete"
            self.completeDataArr.append(value)
            break
        case onHoldTableView:
            issue.status = "On Hold"
            self.onHoldDataArr.append(value)
            break
        default:
            print("Error with NSTableView")
        }
        return issue
        
    }

    
    func removeFromTable( tableView: NSTableView, row: Int) -> Issue? {
        
        var returnStr: Issue?
        
        switch tableView {
        case todoListTableView:
            returnStr = self.todoListDataArr[row]
            self.todoListDataArr.remove(at: row)
            break
        case inProgressTableView:
            returnStr = self.inProgressDataArr[row]
            self.inProgressDataArr.remove(at: row)
            break
        case completeTableView:
            returnStr = self.completeDataArr[row]
            self.completeDataArr.remove(at: row)
            break
        case onHoldTableView:
            returnStr = self.onHoldDataArr[row]
            self.onHoldDataArr.remove(at: row)
            break
        default:
            print("Error with NSTableView")
        }
        
        return returnStr
        
    }
    
    func reloadAllTable() {
        self.inProgressTableView.reloadData()
        self.todoListTableView.reloadData()
        self.completeTableView.reloadData()
        self.onHoldTableView.reloadData()
    }
}
