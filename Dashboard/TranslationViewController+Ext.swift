//
//  TranslationViewController+Ext.swift
//  Dashboard
//
//  Created by Timothy Barnard on 04/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Cocoa


extension TranslationViewController {
    
    
    func sendInBackground(_ data:  [String:AnyObject], postCompleted : @escaping (_ succeeded: Bool, _ data: NSData) -> ()) {
        
        let url = UserDefaults.standard.string(forKey: "URL") ?? "http://0.0.0.0:8181"
        
        let apiEndpoint = "/translation/"
        let networkURL = url + apiEndpoint
        
        let request = NSMutableURLRequest(url: NSURL(string: networkURL)! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: [])
        } catch {
            //err = error
            request.httpBody = nil
        }
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            
            if ((error) != nil) {
                print(error!.localizedDescription)
                postCompleted(false, NSData())
            } else {
                postCompleted(true, data! as NSData)
            }
        })
        
        task.resume()
    }
    
}

extension TranslationViewController {
    
    func getTranslationFile(filePath: String, getCompleted : @escaping (_ succeeded: Bool, _ data: [String:String] ) -> ()) {
        
        //let className = ("\(type(of: T()))")
        
        let url = UserDefaults.standard.string(forKey: "URL") ?? "http://0.0.0.0:8181"
        
        let apiEndpoint = "/translation"
        let networkURL = url + apiEndpoint + filePath
        
        guard let endpoint = URL(string: networkURL) else {
            print("Error creating endpoint")
            return
        }
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        //if let token = _currentUser?.currentToken {
        //    request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
        // }
        
        var translationData = [String:String]()
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if ((error) != nil) {
                getCompleted(false, translationData)
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                let dataObjects = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as AnyObject
                
                if let tranlationList = dataObjects["translationList"] as? [String:String] {
                    
                    translationData = tranlationList
                }
                
                
            } catch let error as NSError {
                print(error)
            }
            
            getCompleted(true, translationData)
            
            }.resume()
    }
    
    
}
