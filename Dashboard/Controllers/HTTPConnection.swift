//
//  HTTPSConnection.swift
//  Remote Config
//
//  Created by Timothy Barnard on 29/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation

enum HTTPResult: String {
    case Success = "success"
    case Error = "error"
    
    static func parse( result: String ) -> HTTPResult {
        
        switch result {
        case "success":
            return .Success
        default:
            return .Error
        }
        return .Success
    }
}

public class HTTPSConnection {
    
    class func readPlistURL() -> String {
        var defaultURL = UserDefaults.standard.string(forKey: "URL") ?? "http://0.0.0.0:8181"
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            
            guard let url = dict["URL"] as? String else {
                return defaultURL
            }
            
            defaultURL = url
        }
        return defaultURL
    }
    
    class func httpRequest(params : Dictionary<String, AnyObject>, url : String, httpMethod: String, postCompleted : @escaping (_ succeeded: Bool, _ data: NSData) -> ()) {
        
        let urlPath = url
        
        let request = NSMutableURLRequest(url: NSURL(string: urlPath)! as URL)
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
    
    
    class func httpPostFileRequest(path : String, endPoint : String, name: String, postCompleted : @escaping (_ succeeded: Bool, _ data: String) -> ()) {
        
        let url = UserDefaults.standard.string(forKey: "URL") ?? "http://0.0.0.0:8181"
        
        let key = UniqueSting.apID()
        
        let apiEndpoint = "/api/"+key
        
        let urlPath = url + apiEndpoint + endPoint
        
        let request: URLRequest
        
        do {
            request = try createRequest(filePath: path, url: urlPath, name: name)
        } catch {
            print(error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                // handle error here
                postCompleted(false, (error?.localizedDescription)! )
                return
            }
            
            // if response was JSON, then parse it
            
            do {
                let responseDictionary = try JSONSerialization.jsonObject(with: data!)
                print("success == \(responseDictionary)")
                postCompleted(true, "success" )
                // note, if you want to update the UI, make sure to dispatch that to the main queue, e.g.:
                //
                // DispatchQueue.main.async {
                //     // update your UI and model objects here
                // }
            } catch {
                postCompleted(false, (error.localizedDescription) )
                let responseString = String(data: data!, encoding: .utf8)
                print("responseString = \(responseString)")
            }
        }
        task.resume()
    }
    
    /// Create request
    ///
    /// - parameter userid: The userid to be passed to web service
    /// - parameter password: The password to be passed to web service
    /// - parameter email: The email address to be passed to web service
    ///
    /// - returns:            The NSURLRequest that was created
    
    private class func createRequest(filePath: String, url: String, name: String) throws -> URLRequest {
        //let parameters = nil
        
        let boundary = generateBoundaryString()
        
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
        request.httpBody = try createBody(with: nil, filePathKey: name, paths: [filePath], boundary: boundary)
        
        return request
    }
    
    /// Create body of the multipart/form-data request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter paths:        The optional array of file paths of the files to be uploaded
    /// - parameter boundary:     The multipart/form-data boundary
    ///
    /// - returns:                The NSData of the body of the request
    
    private class func createBody(with parameters: [String: String]?, filePathKey: String, paths: [String], boundary: String) throws -> Data {
        var body = Data()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        for path in paths {
            let url = URL(fileURLWithPath: path)
            let filename = url.lastPathComponent
            let data = try Data(contentsOf: url)
            let mimetype = mimeType(for: path)
            
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n")
            body.append(data)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    class func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires MobileCoreServices framework.
    ///
    /// - parameter path:         The path of the file for which we are going to determine the mime type.
    ///
    /// - returns:                Returns the mime type if successful. Returns application/octet-stream if unable to determine mime type.
    
    class func mimeType(for path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream";
    }
    
    
    class func httpPostRequest(params : Any, endPoint : String, appKey: String = "", postCompleted : @escaping (_ succeeded: Bool, _ data: String) -> ()) {
        
        let url = UserDefaults.standard.string(forKey: "URL") ?? "http://0.0.0.0:8181"
        
        var key = UniqueSting.apID()
        
        if appKey != "" {
            key = appKey
        }
    
        let apiEndpoint = "/api/"+key + "/"
        
        let urlPath = url + apiEndpoint + endPoint
        
        let request = NSMutableURLRequest(url: NSURL(string: urlPath)! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            //err = error
            request.httpBody = nil
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            //PrintLn.strLine(functionName: "httpRequest", message: "Response: \(response)")
            //print(error)
            //let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            if ((error) != nil) {
                print(error!.localizedDescription)
                postCompleted(false, "error")
            } else {
                postCompleted(true, "completed")
            }
        })
        
        task.resume()
    }

    class func parseResult(data: Data) -> ( HTTPResult, String )  {
        
        do {
            guard let responseDictionary = try JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                return (.Error , "parsing")
            }
        
            let result: String =  responseDictionary.tryConvert(forKey: "result")
            let message: String = responseDictionary.tryConvert(forKey: "message")
            let resultHTTP: HTTPResult = HTTPResult.parse(result: result)
            
            return ( resultHTTP, message)
            
        } catch {
            return ( .Error , "parsing")
        }
    }

    
    
    class func httpGetRequest(params : Dictionary<String, AnyObject>, url : String, postCompleted : @escaping (_ succeeded: Bool, _ data: NSData) -> ()) {
        
        let urlPath = readPlistURL()+url
       
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
//        } catch {
//            //err = error
//            request.httpBody = nil
//        }
        
        //if let token = _currentUser?.currentToken {
        //    request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
       // }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if ((error) != nil) {
                print(error!.localizedDescription)
                postCompleted(false, NSData())
            }
            
                guard let data = data else {
                    return
                }
            
                postCompleted(true, data as NSData)
                
            //} catch let err as NSError {
              //  print(err.debugDescription)
            //}
        }.resume()
    }
    
    class func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    class func parseJSONConfig(data : NSData) -> Config? {
        
        var returnData : Config?
        
        do {
            
            guard let parsedData = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? [String:Any] else {
                return returnData
            }
            
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
