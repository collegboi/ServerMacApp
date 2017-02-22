//
//  iTunesResults.swift
//  Dashboard
//
//  Created by Timothy Barnard on 21/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

import Cocoa

class Result : NSObject {
    dynamic var rank = 0
    dynamic var artistName = ""
    dynamic var trackName = ""
    dynamic var bundleID = ""
    dynamic var version = ""
    dynamic var releaseNotes = ""
    dynamic var trackContentRating = ""
    dynamic var averageUserRating = 0.0
    dynamic var averageUserRatingForCurrentVersion = 0.0
    dynamic var itemDescription = ""
    dynamic var price = 0.00
    dynamic var releaseDate = Date()
    dynamic var artworkURL = ""
    dynamic var artworkImage: NSImage?
    dynamic var screenShotURLs: [String] = []
    dynamic var screenShots = [String]()
    dynamic var userRatingCount = 0
    dynamic var userRatingCountForCurrentVersion = 0
    dynamic var primaryGenre = ""
    dynamic var fileSizeInBytes = 0
    dynamic var cellColor = NSColor.white
    
    init(dictionary: Dictionary<String, AnyObject>) {
        
        artistName = dictionary["artistName"] as! String
        trackName = dictionary["trackName"] as! String
        itemDescription = dictionary["description"] as! String
        bundleID = dictionary["bundleId"] as! String
        trackContentRating = dictionary["trackContentRating"] as! String
        artworkURL = dictionary["artworkUrl512"] as! String
        version = dictionary["version"] as! String
        releaseNotes = dictionary["releaseNotes"] as! String
        
        
        primaryGenre = dictionary["primaryGenreName"] as! String
        if let uRatingCount = dictionary["userRatingCount"] as? Int {
            userRatingCount = uRatingCount
        }
        
        if let uRatingCountForCurrentVersion = dictionary["userRatingCountForCurrentVersion"] as? Int {
            userRatingCountForCurrentVersion = uRatingCountForCurrentVersion
        }
        
        if let averageRating = (dictionary["averageUserRating"] as? Double) {
            averageUserRating = averageRating
        }
        
        if let averageRatingForCurrent = dictionary["averageUserRatingForCurrentVersion"] as? Double {
            averageUserRatingForCurrentVersion = averageRatingForCurrent
        }
        
        if let fileSize = dictionary["fileSizeBytes"] as? String {
            if let fileSizeInt = Int(fileSize) {
                fileSizeInBytes = fileSizeInt
            }
        }
        
        if let appPrice = dictionary["price"] as? Double {
            price = appPrice
        }
        
        let formatter = DateFormatter()
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.locale = enUSPosixLocale as Locale!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        if let releaseDateString = dictionary["releaseDate"] as? String {
            releaseDate = formatter.date(from: releaseDateString)!
        }

        
        if let screenShotsArray = dictionary["screenshotUrls"] as? [String] {
            for screenShotURLString in screenShotsArray {
                self.screenShotURLs.append(screenShotURLString)
            }
        }
        
        super.init()
    }
    
    
    override var description: String {
        get {
            return "artist: \(artistName) track: \(trackName) average rating: \(averageUserRating) price: \(price) release date: \(releaseDate)"
        }
    }
}

// Create a string with currency formatting based on the device locale
//
extension Double {
    var asLocaleCurrency:String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = NSLocale.current
        return formatter.string(from: NSNumber(value: self))!
    }
}
