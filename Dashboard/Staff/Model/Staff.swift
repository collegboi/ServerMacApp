//
//  Staff.swift
//  Dashboard
//
//  Created by Timothy Barnard on 22/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import Cocoa

enum StaffType: String {
    case Manager = "Manager"
    case Employee = "Employee"
}

struct Staff: JSONSerializable {
    
    var staffID: MBOjectID?
    var username: String!
    var email: String!
    var password: String!
    var firstName: String!
    var lastName: String!
    var staffType: StaffType!
    var databasePerms: String!
    var servicesPerms: String!
    var resetPassword: Int!
    var userID: String!
    
    init(username:String, password:String) {
        self.username = username
        self.password = password
    }
    
    init(username:String, password:String, firstName:String, lastName:String, email: String, staffType: StaffType, databasePerms:String, servicesPerms:String, userID: String = "", resetPassword: Int = 0 ) {
        self.staffID = MBOjectID(objectID: "")
        self.username = username
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.staffType = staffType
        self.databasePerms = databasePerms
        self.servicesPerms = servicesPerms
        self.resetPassword = resetPassword
        self.userID = userID
    }
    
    init() {}
    init(dict: String) {}
    init(dict: [String]) {}
    
    init(dict: [String : Any]) {
        self.staffID = MBOjectID(objectID: dict.tryConvert(forKey: "_id"))
        self.username = dict.tryConvert(forKey: "username")
        self.password = dict.tryConvert(forKey: "password")
        self.firstName = dict.tryConvert(forKey: "firstName")
        self.lastName = dict.tryConvert(forKey: "lastName")
        self.email = dict.tryConvert(forKey: "email")
        self.databasePerms = dict.tryConvert(forKey: "databasePerms")
        self.servicesPerms = dict.tryConvert(forKey: "servicesPerms")
        self.resetPassword = dict.tryConvert(forKey: "resetPassword")
        self.userID = dict.tryConvert(forKey: "userID")
        let staffType: String = dict.tryConvert(forKey: "staffType")
        
        switch staffType {
        case "Manager":
            self.staffType = .Manager
        default:
            self.staffType = .Employee
        }
    }
    
    /**
     Logs in an account. This method also stores the account access tokens for later
     use.
     
     - parameters:
     - username: Account's email or username.
     - password: Account password.
     - callback: The completion block to be invoked after the API
     request is finished. If the method fails, the error will be passed in
     the completion.
     */
    
    static func login(username: String, password: String, postCompleted : @escaping (_ succeeded: Bool, _ result: HTTPResult, _ staffMember: Staff? ) -> ()) {
        
        let urlPath: String = HTTPSConnection.readPlistURL() + "/api/JKHSDGHFKJGH454645GRRLKJF/serverLogin/" + username + "/" + password
        
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue("123456", forHTTPHeaderField: "authen_key")
        //if let token = _currentUser?.currentToken {
        //    request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
        // }
        
        var currentStaff: Staff?
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if ((error) != nil) {
                print(error!.localizedDescription)
                postCompleted(false, .Error, nil)
            }
            
            guard let data = data else {
                return
            }
            
            do {
                guard let responseDictionary = try JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                    return
                }
                
                guard let allObjects = responseDictionary["data"] as? NSArray else {
                    return
                }

                
                if allObjects.count > 0 {
                    
                    guard let staffObject = allObjects[0] as? [String:Any] else {
                        return
                    }
                    
                    currentStaff = Staff(
                                    username: staffObject.tryConvert(forKey: "username"),
                                    password: "",
                                    firstName: staffObject.tryConvert(forKey: "firstName"),
                                    lastName: staffObject.tryConvert(forKey: "lastName"),
                                    email: staffObject.tryConvert(forKey: "email"),
                                    staffType: StaffType.Manager , //staffObject.tryConvert(forKey: "staffType")
                                    databasePerms: staffObject.tryConvert(forKey: "databasePerms"),
                                    servicesPerms: staffObject.tryConvert(forKey: "servicesPerms"),
                                    resetPassword: staffObject.tryConvert(forKey: "resetPassword")
                    )
                    
                    
                } else {
                    
                    postCompleted(true, .Error, nil )
                }
                
                
            } catch {
                print("parsing error")
                postCompleted(false, .Error, nil )
            }
            
            postCompleted(true, .Success, currentStaff )
            
        }.resume()
    }
    
    /**
     Reset password in an account.
     use.
     
     - parameters:
     - username: Account's email or username.
     - password: Account password.
     - callback: The completion block to be invoked after the API
     request is finished. If the method fails, the error will be passed in
     the completion.
     */
    static func resetPassword( username: String, password: String, postCompleted : @escaping (_ succeeded: Bool, _ result: HTTPResult, _ messsage: String ) -> ()) {
        
        let urlPath: String = HTTPSConnection.readPlistURL() + "/api/JKHSDGHFKJGH454645GRRLKJF/serverReset/" + "/" + username + "/" + password
        
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue("123456", forHTTPHeaderField: "authen_key")
        //if let token = _currentUser?.currentToken {
        //    request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
        // }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if ((error) != nil) {
                print(error!.localizedDescription)
                postCompleted(false, .Error, "error loggin in")
            }
            
            guard let data = data else {
                return
            }
            
            let (_, message) = HTTPSConnection.parseResult(data: data as Data)
            
            postCompleted(true, .Success , message)
            
            //} catch let err as NSError {
            //  print(err.debugDescription)
            //}
        }.resume()
    }
    
    /**
     Register password in an account.
     use.
        - callback: The completion block to be invoked after the API
     request is finished. If the method fails, the error will be passed in
     the completion.
     */
    static func registerPassword( staff: Staff, postCompleted : @escaping (_ succeeded: Bool, _ result: HTTPResult, _ messsage: String ) -> ()) {
        
        if let json = staff.toJSON() {
            
            let data = HTTPSConnection.convertStringToDictionary(text: json)
            
            var newData = [String:AnyObject]()
            newData = data!
            
            let urlPath: String = HTTPSConnection.readPlistURL() + "/api/JKHSDGHFKJGH454645GRRLKJF/register/"
            
            let dic = newData
            
            let request = NSMutableURLRequest(url: NSURL(string: urlPath)! as URL)
            let session = URLSession.shared
            request.httpMethod = "POST"
            request.setValue("123456", forHTTPHeaderField: "authen_key")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: dic, options: [])
            } catch {
                //err = error
                request.httpBody = nil
            }
            
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
                
                if ((error) != nil) {
                    print(error!.localizedDescription)
                    postCompleted(false, .Error , "")
                } else {
                    
                     let (_, message) = HTTPSConnection.parseResult(data: data! as Data)
                    
                    postCompleted(true, .Success , message)
                }
            })
            
            task.resume()
        }
    }
}
