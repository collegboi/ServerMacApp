//
//  Controllers.swift
//  Dashboard
//
//  Created by Timothy Barnard on 20/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

//
//  Config.swift
//  CMS Remote Config
//
//  Created by Timothy Barnard on 30/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation

class KeyValuePair {
    
    let key: String
    let value: String
    
    init(key: String, value:String) {
        self.key = key
        self.value = value
    }
    
}


enum RCObjectType : String {
    
    case Button = "UIButton"
    case Label = "UILabel"
    case ImageView = "UIImageView"
    case TextField = "UITextField"
    case Object = "Object"
}

enum ListType {
    case LanguageType
    case ColorType
    case ControllerType
    case MainSettingType
}

struct RCColor: JSONSerializable {
    
    var blue : CGFloat!
    var green : CGFloat!
    var red : CGFloat!
    var alpha : CGFloat!
    var name : String!
    
    
    init(blue: CGFloat, green: CGFloat, red: CGFloat, alpha: CGFloat, name: String) {
        self.blue = blue
        self.green = green
        self.red = red
        self.alpha = alpha
        self.name = name
    }
    
    init(dict : [String:Any]) {
        self.blue = dict["blue"] as! CGFloat
        self.green = dict["green"] as! CGFloat
        self.red = dict["red"] as! CGFloat
        self.alpha = dict["alpha"] as! CGFloat
        self.name = dict["name"] as! String
    }
}

struct RCObject: JSONSerializable {
    
    var objectType : RCObjectType!
    var objectName : String!
    var objectProperties : [String: Any]!
    
    init( objectName: String, objectType: RCObjectType) {
        self.objectName = objectName
        self.objectType = objectType
        self.objectProperties = [String:Any]()
        self.objectProperties["type"] = objectType.rawValue
    }
    
    init( dict: [String:Any] ) {
        self.objectName = dict["objectName"] as! String
        self.objectProperties = dict["objectProperties"] as! [String: Any]!
        
        switch objectProperties["type"] as! String {
        case "UIButton":
            self.objectType = .Button
            break
        case "UILabel":
            self.objectType = .Label
            break
        case "UIImageView":
            self.objectType = .ImageView
            break
        case "UITextField":
            self.objectType = .TextField
        default:
            self.objectType = .Object
        }
    }
}

struct RCController: JSONSerializable {
    
    var objectsList: [RCObject]!
    var name : String!
    
    init(name: String) {
        self.name = name
        self.objectsList = [RCObject]()
    }
    
    init( dict : [String:Any] ) {
        
        self.name = dict["name"] as! String
        
        self.objectsList = [RCObject]()
        
        for ( value) in dict["objectsList"] as! NSArray {
            
            let newObject = RCObject( dict: value as! [String: Any])
            self.objectsList.append(newObject)
        }
    }
}

struct Config : JSONSerializable {
    
    var colors : [RCColor]!
    var controllers : [RCController]!
    var mainSettings: [String:String]!
    var languagesList : [String]!
    
    init( dict : [String:Any] ) {
        
        self.colors = [RCColor]()
        
        for ( color ) in dict["colors"] as! NSArray {
            let newColor = RCColor(dict: color as! [String:Any])
            self.colors.append(newColor)
        }
        
        self.controllers = [RCController]()
        
        for( value ) in dict["controllers"] as! NSArray {
            
            let newController = RCController(dict: (value as! [String:Any]) )
            self.controllers.append(newController)
        }
        
        self.languagesList = [String]()
        self.languagesList = dict["languagesList"] as! [String]!
        
        self.mainSettings = [String:String]()
        
        guard let settings =  dict["mainSettings"] as? [String:String] else {
            return
        }
        self.mainSettings = settings
    }
}

struct Translations: JSONSerializable {
    
    var translationList: [String:AnyObject]!
    
    init(dict: [String:Any] ) {
        
        guard let translationDict = dict["translationList"] as? [String:AnyObject] else {
            self.translationList = dict as [String : AnyObject]!
            return
        }
        
        self.translationList = translationDict
        
    }
    
}

