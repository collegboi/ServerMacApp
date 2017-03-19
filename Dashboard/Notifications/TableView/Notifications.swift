//
//  Notifications.swift
//  Dashboard
//
//  Created by Timothy Barnard on 07/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

class TBNotification {
    
    var objectID: String = ""
    var deviceID: String = "Dashboard"
    var message: String = ""
    var userID: String = ""
    var badgeNo: String = ""
    var contentAvailable: String = ""
    var title:String = ""
    var timestamp:String = ""
    var status:String = "Sent"
    var development: String = "0"
    
    init(){}
    
    func setDeviceID(_ deviceID:String) {
        self.deviceID = deviceID
    }
    func setMessage(_ message:String) {
        self.message = message
    }
    func setUserID(_ userID:String) {
        self.userID = userID
    }
    func setTitle(_ title:String) {
        self.title = title
    }
    func setBadgeNo(_ no: Int) {
        self.badgeNo = "\(no)"
    }
    func setDevelopment(_ no: Int) {
        self.development = "\(no)"
    }
    func setContentAvailable(_ set: Bool) {
        switch set {
        case true:
            self.contentAvailable = "1"
        default:
            self.contentAvailable = "0"
        }
    }
    func setTimeStamp(_ timeStamp:String) {
        self.timestamp = timeStamp
    }
    
    
    /**
     - parameters:
     - type: struct name
     - getCompleted: return value of success state
     - data: return array of objects
     */
    func sendNotification(_ appKey: String, notificationCompleted : @escaping (_ succeeded: Bool, _ data: String) -> ()) {
        
        let url = UserDefaults.standard.string(forKey: "URL") ?? "http://0.0.0.0:8181"
        
        //let key = UniqueSting.apID()
        
        let apiEndpoint = "/api/"+appKey+"/notification/"
        let networkURL = url + apiEndpoint
        
        if (self.deviceID == "" && self.message == "") || (self.userID == "" && self.message == "") {
            notificationCompleted(false, "values not set")
            return
        }
        
        guard let endpoint = NSURL(string: networkURL) else {
            print("Error creating endpoint")
            notificationCompleted(false, "url incorrect")
            return
        }
        let request = NSMutableURLRequest(url: endpoint as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let dict : [String:AnyObject] = [
            "deviceId":self.deviceID as AnyObject,
            "message":self.message as AnyObject,
            "userID":self.userID as AnyObject,
            "badgeNo":self.badgeNo as AnyObject,
            "contentAvailable":self.contentAvailable as AnyObject,
            "title":self.title as AnyObject,
            "timestamp":self.timestamp as AnyObject,
            "development": self.development as AnyObject
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dict, options: [])
        } catch {
            //err = error
            request.httpBody = nil
        }
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            
            if ((error) != nil) {
                print(error!.localizedDescription)
                
                notificationCompleted(false, "not sent")
                
            } else {
                
                notificationCompleted(true, "sent")
            }
        })
        task.resume()
        
    }
}

extension Array where Element:TBNotification {
    
    func getAllNotifications(_ appKey: String, notificationGot : @escaping (_ succeeded: Bool, _ notications: [TBNotification] ) -> ()) {
        
    
        let url = UserDefaults.standard.string(forKey: "URL") ?? "http://0.0.0.0:8181"
        
        //let key = UniqueSting.apID()
        
        let apiEndpoint = "/api/"+appKey+"/notification/"
        let networkURL = url + apiEndpoint
        
        guard let endpoint = URL(string: networkURL) else {
            print("Error creating endpoint")
            return
        }
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        //if let token = _currentUser?.currentToken {
        //    request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
        // }
        
        var allNotification = [TBNotification]()
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if ((error) != nil) {
                notificationGot(false, allNotification)
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                guard let dataObjects = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? [String:Any] else {
                    return
                }
                
                let allObjects = dataObjects["data"] as? NSArray
                
                for object in allObjects! {
                    
                    let newNotificationObj = TBNotification()
                    
                    if let noticationObj = object as? [String:Any] {
                        
                        newNotificationObj.objectID = noticationObj.tryConvert(forKey: "_id")
                        newNotificationObj.setTitle(noticationObj.tryConvert(forKey: "title"))
                        newNotificationObj.setUserID(noticationObj.tryConvert(forKey: "userID"))
                        newNotificationObj.setBadgeNo(noticationObj.tryConvert(forKey: "badgeNo"))
                        newNotificationObj.setMessage(noticationObj.tryConvert(forKey: "message"))
                        newNotificationObj.setDeviceID(noticationObj.tryConvert(forKey: "deviceID"))
                        newNotificationObj.setContentAvailable(noticationObj.tryConvert(forKey: "contentAvailable"))
                        newNotificationObj.setTimeStamp(noticationObj.tryConvert(forKey: "timestamp"))
                        newNotificationObj.status = noticationObj.tryConvert(forKey: "status", "Sent")
                    }
                    
                    allNotification.append(newNotificationObj)
                }
                
            } catch let error as NSError {
                print(error)
            }
            
            notificationGot(true, allNotification)
            
        }.resume()
    }
    
}
