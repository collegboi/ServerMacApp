//
//  JSONRepresentable.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 30/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Cocoa

protocol JSONRepresentable {
    var JSONRepresentation: AnyObject { get }
}

protocol JSONSerializable: JSONRepresentable {
    
}

//: ### Implementing the functionality through protocol extensions
extension JSONSerializable {
    var JSONRepresentation: AnyObject {
        var representation = [String: AnyObject]()
        //print(self)
        for case let (label?, value) in Mirror(reflecting: self).children {
            
            
            switch value {
                
            case let value as Dictionary<String, AnyObject>:
                representation[label] = value as AnyObject?
                
            case let value as Array<CGFloat>:
                representation[label] = value as AnyObject?
                
            case let value as Array<String>:
                representation[label] = value as AnyObject?
                
            case let value as Array<AnyObject>:
                var anyObject = [AnyObject]()
                for ( _, objectVal ) in value.enumerated() {
                    var dict = [String:AnyObject]()
                    //print(objectVal)
                    if let jsonVal = objectVal as? JSONRepresentable {
                        
                        let jsonTest = jsonVal as! JSONSerializable
                        //print(jsonTest)
                        if let jsonData = jsonTest.toJSON() {
                            
                            for (index, value) in convertStringToDictionary(text: jsonData) ?? [String: AnyObject]() {
                                
                                dict[index] = value
                            }
                            
                            anyObject.append(dict as AnyObject)
                        }
                    }
                }
                representation[label] = anyObject as AnyObject?
                
                
            case let value as AnyObject:
                if let myVal = convertToStr(name: value) {
                    representation[label] = myVal
                } else {
                    if let jsonVal = value as? JSONRepresentable {
                        var dict = [String:AnyObject]()
                        //print(objectVal)
                        let jsonTest = jsonVal as! JSONSerializable
                        if let jsonData = jsonTest.toJSON() {
                            
                            for (index, value) in convertStringToDictionary(text: jsonData) ?? [String: AnyObject]() {
                                
                                dict[index] = value
                            }
                        }
                        representation[label] = dict as AnyObject
                    }
                }
                
                
            default:
                
                break
            }
        }
        //print(representation)
        return representation as AnyObject
    }
}

extension JSONSerializable {
    func toJSON() -> String? {
        let representation = JSONRepresentation
        
        guard JSONSerialization.isValidJSONObject(representation) else {
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: representation, options: [])
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    func objtToJSON( jsonObj : AnyObject ) -> String? {
        
        guard JSONSerialization.isValidJSONObject(jsonObj) else {
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObj, options: [])
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    func toJSONObjects() -> [String : AnyObject]? {
        let representation = JSONRepresentation
        
        guard JSONSerialization.isValidJSONObject(representation) else {
            return nil
        }
        
        return self.convertStringToDictionary(text: objtToJSON(jsonObj: representation)!)
    }
    
    func convertStringToJSONObject(text: String) -> ( String, AnyObject ) {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                
                return json!.getObjectAtIndex(index: 0)
                
            } catch let error as NSError {
                print(error)
            }
        }
        return ("", "" as AnyObject)
    }
    
    func convertStringToDictionary(text: String) -> [ String: AnyObject ]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func convertToStr( name: Any ) -> AnyObject? {
        
        var returnObject: AnyObject?
        
        if name is String {
            returnObject = name as AnyObject
        }
        
        if name is Int {
            returnObject = name as AnyObject
        }
        
        if name is Float {
            returnObject = name as AnyObject
        }
        
        if name is Double {
            returnObject = name as AnyObject
        }
        
        if name is CGFloat {
            returnObject = name as AnyObject
        }
        
        return returnObject
    }
    
}

