//
//  TimeUnit.swift
//  BarberShop
//
//  Created by Daniel Radshun on 14/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class TimeUnit:CustomStringConvertible,Equatable,DictionaryConvertible {
    var user:String?
    var index:Int
    var startTime:Time
    var duration:Int
    var isAvailable:Bool
    
    init(user:String?, index:Int, startTime:Time, duration:Int, isAvailable:Bool) {
        self.user = user
        self.index = index
        self.startTime = startTime
        self.duration = duration
        self.isAvailable = isAvailable
    }
    
    var description: String{
        return startTime.description
    }
    
    //comparing func -> find if equals only in the same array
    public static func ==(lhs: TimeUnit, rhs: TimeUnit) -> Bool{
        return
            lhs.index == rhs.index
    }
    
    var generateId:String{
        return startTime.description
    }
    
    // DictionaryConvertible protocol methods
    required convenience init?(dict: NSDictionary) {
        guard let index = dict["index"] as? Int,
            let startTimeDict = dict["startTime"] as? NSDictionary,
            let duration = dict["duration"] as? Int,
            let isAvailable = dict["isAvailable"] as? Bool
            else {
                return nil
        }
        
        guard let startTime = Time(dict: startTimeDict) else {return nil}
        let user = dict["user"] as? String ?? nil
        
        self.init(user: user, index: index, startTime: startTime, duration: duration, isAvailable: isAvailable)
    }
    
    var dict:NSDictionary {
        var dictionary:[String:Any] = ["index":index,
                                       "startTime": startTime.dict,
                                       "duration":duration,
                                       "isAvailable":isAvailable]
        
        if self.user != nil{
            dictionary["user"] = user
        }
        
        return NSDictionary(dictionary: dictionary)
    }
}
