//
//  Issue.swift
//  Dashboard
//
//  Created by Timothy Barnard on 28/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

//class func parseJSONConfig<T>(data: Data ) -> T {
//    
//    var returnData : T?
//    
//    do {
//        
//        let parsedData = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! [String:Any]
//        
//        returnData = T(dict: parsedData)
//        
//    } catch let error as NSError {
//        print(error)
//    }
//    
//    return returnData!
//}

enum IssueType : String {
    
    case Bug = "Bug"
    case Feature = "Feature"
    case Improvement = "Improvement"
}

enum IssuePriority: String {
    case Low = "Low"
    case High = "High"
    case Critical = "Critical"
    case SystemDown = "System Down"
    
}

enum IssueStatus: String {
    case TODO = "TODO"
    case InProgress = "In Progress"
    case Complete = "Complete"
    case OnHold = "On Hold"
    
}

struct MBOjectID {
    var objectID : String = ""
}

struct Issue: JSONSerializable {
    
    var issueID: MBOjectID = MBOjectID.init(objectID: "")
    var name: String!
    var status: String!
    var type: String!
    var assingee: String!
    var timeSpent: String!
    var prioity: String!
    var version: String!
    var exceptionID: String!
    
    init(dict: String){}
    
    init() {
        self.name = ""
        self.status = ""
        self.type = ""
        self.assingee = ""
        self.timeSpent = ""
        self.prioity = ""
        self.version = ""
        self.exceptionID = ""
    }
    
    init(name: String, status: String, type: String, assignee: String, timeSpent: String, priority: String, version: String, exeception: String = "") {
        self.name = name
        self.status = status
        self.type = type
        self.assingee = assignee
        self.timeSpent = timeSpent
        self.prioity = priority
        self.version = version
        self.exceptionID = exeception
    }
    
    init(dict: [String]){}
    
    init( dict: [String:Any] ) {
        self.name = dict["name"] as! String
        self.version = dict.tryConvert(forKey: "version","1.2.2")
        self.status = dict.tryConvert(forKey: "status")
        self.assingee = dict.tryConvert(forKey: "assingee")
        self.timeSpent = dict.tryConvert(forKey: "timeSpent")
        self.type = dict.tryConvert(forKey: "type")
        self.prioity = dict.tryConvert(forKey: "prioity")
        self.issueID = MBOjectID.init(objectID: dict.tryConvert(forKey: "_id") )
        self.exceptionID = dict.tryConvert(forKey: "exceptionID")
    }

}

class IssueJSON {
    
    class func parseJSONConfig(data: Data ) -> [Issue] {
        
        var returnData =  [Issue]()
        
        do {
            
            let issues = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! [String:Any]
            
            let issueArray = issues["data"] as? NSArray
            
            for issue in issueArray! {
                
                returnData.append(Issue(dict: issue as! [String:Any]))
            }
            
        } catch let error as NSError {
            print(error)
        }
        
        return returnData
    }

}
