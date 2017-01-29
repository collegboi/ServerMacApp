//
//  IssueActivity.swift
//  Dashboard
//
//  Created by Timothy Barnard on 28/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

struct IssueActivity: JSONSerializable {
    
    var commentID: MBOjectID = MBOjectID.init(objectID: "")
    var issueID: String!
    var issueComments: String!
    var user: String!
    var timeStamp: String!
    
    
    init() {
        
    }
    
    init(issueID: String, issueComments: String, user: String, timeStamp: String) {
        self.issueID = issueID
        self.issueComments = issueComments
        self.user = user
        self.timeStamp = timeStamp
    }
    
    
    init( dict: [String:Any] ) {
        self.issueID = ""
        self.issueComments = ""
        self.user = ""
        self.timeStamp = ""
        
        if let issueID = dict["issueID"] as? String {
            self.issueID = issueID
        }
        if let issueComments = dict["issueComments"] as? String {
            self.issueComments = issueComments
        }
        if let user = dict["user"] as? String {
                self.user = user
        }
        if let timeStamp = dict["timeStamp"] as? String {
                self.timeStamp = timeStamp
        }
        if let commentID = dict["_id"] as? String {
            self.commentID = MBOjectID.init(objectID: commentID)
        }
    }
}

class IssueActivityJSON {
    
    class func parseJSONConfig(data: Data ) -> [IssueActivity] {
        
        var returnData =  [IssueActivity]()
        
        do {
            
            let issues = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! [String:Any]
            
            let issueArray = issues["data"] as? NSArray
            
            for issue in issueArray! {
                
                returnData.append(IssueActivity(dict: issue as! [String:Any]))
            }
            
        } catch let error as NSError {
            print(error)
        }
        
        return returnData
    }
    
}
