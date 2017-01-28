//
//  HTTPSConnection.swift
//  Remote Config
//
//  Created by Timothy Barnard on 29/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation

public class HTTPSConnection {
    
    class func httpRequest(params : Dictionary<String, AnyObject>, url : String, httpMethod: String, postCompleted : @escaping (_ succeeded: Bool, _ data: NSData) -> ()) {
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        let session = URLSession.shared
        request.httpMethod = httpMethod
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            //err = error
            request.httpBody = nil
        }
        
        if httpMethod == "POST" {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            //PrintLn.strLine(functionName: "httpRequest", message: "Response: \(response)")
            //print(error)
            //let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            if ((error) != nil) {
                print(error!.localizedDescription)
                postCompleted(false, NSData())
            } else {
                postCompleted(true, data! as NSData)
            }
        })
        
        task.resume()
    }
    
    class func httpGetRequest(params : Dictionary<String, AnyObject>, url : String, postCompleted : @escaping (_ succeeded: Bool, _ data: NSData) -> ()) {
       
        guard let endpoint = URL(string: url) else {
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
                print(error!.localizedDescription)
                postCompleted(false, NSData())
            }
            
            //do {
                guard let data = data else {
                    return
                }
            
                postCompleted(true, data as NSData)
                
            //} catch let err as NSError {
              //  print(err.debugDescription)
            //}
        }.resume()

    }
    
    class func parseJSONConfig(data : NSData) -> Config? {
        
        var returnData : Config?
        
        do {
            
            let parsedData = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! [String:Any]
            
            returnData = Config(dict: parsedData)
            
        } catch let error as NSError {
            print(error)
        }
        
        return returnData
    }
    
    class func parseJSONTranslations(data : NSData) -> Translations? {
        
        var returnData : Translations?
        
        do {
            
            guard let  parsedData = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? [String:Any] else {
                return returnData
            }
            
            returnData = Translations(dict: parsedData)
            
        } catch let error as NSError {
            print(error)
        }
        
        return returnData
    }
    
    
}
