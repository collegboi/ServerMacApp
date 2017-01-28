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
    
    init(_ object: AnyObject ) {
        guard let newObjectID = object["$oid"] as? String else {
            return
        }
        self.objectID = newObjectID
    }
}

struct Issue: JSONSerializable {
    
    var issueID: MBOjectID = MBOjectID.init("" as AnyObject)
    let name: String!
    let status: String!
    let type: String!
    let assingee: String!
    let prioity: String!
    
    
    init(name: String, status: String, type: String, assignee: String, priority: String) {
        self.name = name
        self.status = status
        self.type = type
        self.assingee = assignee
        self.prioity = priority
    }
    
    
    init( dict: [String:Any] ) {
        self.name = dict["name"] as! String
        self.status = dict["status"] as! String
        self.assingee = dict["assingee"] as! String
        self.type = dict["type"] as! String
        self.prioity = dict["prioity"] as! String
        self.issueID = MBOjectID.init(dict["_id"] as AnyObject)
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
