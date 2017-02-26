//
//  ConfigSettings.swift
//  Dashboard
//
//  Created by Timothy Barnard on 25/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

class ConfigSettings {
    
    var secretServerKey: String = ""
    var dbUsername: String = ""
    var dbPassword: String = ""
    
    init(secretServerkey:String, dbUsername:String, dbPassword: String) {
        self.secretServerKey = secretServerkey
        self.dbPassword = dbPassword
        self.dbUsername = dbUsername
    }
    
    func sendConfigSettings( notificationCompleted : @escaping (_ succeeded: Bool, _ data: String) -> ()) {
        
        var url: String = ""
        url = url.readPlistString(value: "URL", "http://0.0.0.0:8181")
        
        let apiEndpoint = "/api/"
        
        let networkURL =  url + apiEndpoint + "/configSettings/" //"http://Timothys-MacBook-Pro.local:8181/notification/"
        
        guard let endpoint = NSURL(string: networkURL) else {
            print("Error creating endpoint")
            notificationCompleted(false, "url incorrect")
            return
        }
        let request = NSMutableURLRequest(url: endpoint as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let dict : [String:AnyObject] = [
            "secretServerKey":self.secretServerKey as AnyObject,
            "dbUsername":self.dbUsername as AnyObject,
            "dbPassword":self.dbPassword as AnyObject
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
    
    func getConfigSettings( configCompleted : @escaping (_ succeeded: Bool) -> ()) {
        
        var url: String = ""
        url = url.readPlistString(value: "URL", "http://0.0.0.0:8181")
        
        let apiEndpoint = "/api/"
        
        let networkURL =  url + apiEndpoint + "configSettings/" //"http://Timothys-MacBook-Pro.local:8181/notification/"
        
        guard let endpoint = URL(string: networkURL) else {
            print("Error creating endpoint")
            return
        }
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        //if let token = _currentUser?.currentToken {
        //    request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
        // }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if ((error) != nil) {
                configCompleted(false)
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                guard let dataObjects = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? [String:Any] else {
                    return
                }
                
                guard let allObjects = dataObjects["data"] as? [String:Any] else {
                    return
                }
                
//                let configSetting = ConfigSettings(secretServerkey: allObjects.tryConvert(forKey: "secretServerKey"),
//                                                   dbUsername: allObjects.tryConvert(forKey: "dbUsername"),
//                                                   dbPassword: allObjects.tryConvert(forKey: "dbPassword"))
//                
//                configCompleted(true, configSetting)
                
                self.secretServerKey = allObjects.tryConvert(forKey: "secretServerKey")
                self.dbPassword = allObjects.tryConvert(forKey: "dbPassword")
                self.dbUsername = allObjects.tryConvert(forKey: "dbUsername")
                
            } catch let error as NSError {
                print(error)
            }
            
            configCompleted(true)
            
        }.resume()
        
    }

}
