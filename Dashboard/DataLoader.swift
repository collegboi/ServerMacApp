//
//  DataLoader.swift
//  Dashboard
//
//  Created by Timothy Barnard on 04/04/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//
//  DataLoader.swift
//  OAuth2App
//
//  Created by Pascal Pfiffner on 11/6/15.
//  Copyright © 2015 Ossus. All rights reserved.
//https://github.com/p2/OAuth2App


import Foundation

import Cocoa
import OAuth2


/**
 Protocol for loader classes.
 */
public protocol DataLoader {
    
    var oauth2: OAuth2 { get }
    
    /** Call that is supposed to return user data. */
    func requestUserdata(callback: @escaping ((_ dict: OAuth2JSON?, _ error: Error?) -> Void))
}

