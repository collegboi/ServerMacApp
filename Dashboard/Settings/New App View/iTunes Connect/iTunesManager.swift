//
//  iTunesManager.swift
//  Dashboard
//
//  Created by Timothy Barnard on 21/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

import Cocoa

struct iTunesRequestManager {
    
    static func getSearchResults(_ appID: String, completionHandler: @escaping ([[String : AnyObject]], NSError?) -> Void) {
        var urlComponents = URLComponents(string: "https://itunes.apple.com/lookup")
        let termQueryItem = URLQueryItem(name: "id", value: appID)
        urlComponents?.queryItems = [termQueryItem]
        
        guard let url = urlComponents?.url else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            guard let data = data else {
                completionHandler([], nil)
                return
            }
            do {
                guard let itunesData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : AnyObject] else {
                    completionHandler([], nil)
                    return
                }
                if let results = itunesData["results"] as? [[String : AnyObject]] {
                    completionHandler(results, nil)
                } else {
                    completionHandler([], nil)
                }
            } catch _ {
                completionHandler([], error as NSError?)
            }
            
        })
        task.resume()
    }
    
    static func downloadImage(_ imageURL: URL, completionHandler: @escaping (NSImage?, NSError?) -> Void) {
        let task = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) -> Void in
            guard let data = data , error == nil else {
                completionHandler(nil, error as NSError?)
                return
            }
            let image = NSImage(data: data)
            completionHandler(image, nil)
        })
        task.resume()
    }
}
