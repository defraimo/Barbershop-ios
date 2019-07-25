//
//  Time.swift
//  BarberShop
//
//  Created by Daniel Radshun on 28/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class Time:NSObject,DictionaryConvertible {
    var hours:Int
    var minutes:Int
    
    init(hours:Int, minutes:Int) {
        self.hours = hours
        self.minutes = minutes
    }
    
    override var description: String{
        if minutes < 10{
            return "\(hours) : 0\(minutes)"
        }
        return "\(hours) : \(minutes)"
    }
    
    static func == (lhs: Time, rhs: Time) -> Bool {
        return lhs.hours == rhs.hours && lhs.minutes == rhs.minutes
    }
    
    // DictionaryConvertible protocol methods
    required convenience init?(dict: NSDictionary) {
        guard let hours = dict["hours"] as? Int,
            let minutes = dict["minutes"] as? Int
            else {
                return nil
        }
        
        self.init(hours: hours, minutes: minutes)
    }
    
    var dict:NSDictionary {
        return NSDictionary(dictionary: ["hours":hours,
                                         "minutes": minutes])
    }
    
}

class TimeRange:DictionaryConvertible {
    var fromTime:Time
    var toTime:Time
    
    init(fromTime:Time, toTime:Time) {
        self.fromTime = fromTime
        self.toTime = toTime
    }
    
    // DictionaryConvertible protocol methods
    required convenience init?(dict: NSDictionary) {
        guard let fromTimeDict = dict["fromTime"] as? NSDictionary,
            let toTimeDict = dict["toTime"] as? NSDictionary
            else {
                return nil
        }
        
        guard let fromTime = Time(dict: fromTimeDict),
            let toTime = Time(dict: toTimeDict) else {return nil}
        
        self.init(fromTime: fromTime, toTime: toTime)
    }
    
    var dict:NSDictionary {
        return NSDictionary(dictionary: ["fromTime":fromTime.dict,
                                         "toTime": toTime.dict])
    }
}
