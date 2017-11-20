//
//  UserDefaults.swift
//  Watcher
//
//  Created by Rj on 03/11/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit

class Default: NSObject {

    static let isSeriesKey = "isSeriesKey"
    static let yearKey = "yearKey"
    static let adultKey = "adultKey"
    static let sortKey = "sortKey"
    static let recordKey = "recordKey"
    static let nameKey = "nameKey"
    
    // Filter
    
    class func isSeries() -> Bool {
        return UserDefaults.standard.bool(forKey: isSeriesKey)
    }
    
    class func setIsSeries(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: isSeriesKey)
    }
    
    // Year
    class func year() -> String {
        if let value = UserDefaults.standard.string(forKey: yearKey) {
            return value
        }
        return "None"
    }
    
    class func setYear(_ value: String) {
        UserDefaults.standard.set(value, forKey: yearKey)
    }
    
    // Adult
    class func adult() -> String {
        if let value = UserDefaults.standard.string(forKey: adultKey) {
            return value
        }
        return "No"
    }
    
    class func setAdult(_ value: String) {
        UserDefaults.standard.set(value, forKey: adultKey)
    }
    
    // Sort
    class func sortBy() -> String {
        if let value = UserDefaults.standard.string(forKey: sortKey) {
            return value
        }
        return "Popularity Descending"
    }
    
    class func setSortBy(_ value: String) {
        UserDefaults.standard.set(value, forKey: sortKey)
    }
    
//    class func genres() -> [String] {
//
//    }
//
//    class func setGenres(_ value: [String]) {
//
//    }
    
    
}
