//
//  AppDates.swift
//  BarberShop
//
//  Created by Daniel Radshun on 14/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class AppointmentDate:CustomStringConvertible,DictionaryConvertible {
    var id:Int
    var date:MyDate
    var dayOfWeek:Int
    var namedDayOfWeek:String
    var time:TimeManager?
    var units:[TimeUnit]?
    
    init(id:Int, date:MyDate, dayOfWeek:Int, namedDayOfWeek:String, time:TimeManager?) {
        self.id = id
        self.date = date
        self.dayOfWeek = dayOfWeek
        self.namedDayOfWeek = namedDayOfWeek
        
        if time != nil{
            self.time = time
            self.units = time?.getDailyUnitsFor(date: date)
        }
        else{
            self.time = nil
            self.units = nil
        }
    }
    
    init(id:Int, date:MyDate, dayOfWeek:Int, namedDayOfWeek:String, time:TimeManager?, units:[TimeUnit]?) {
        self.id = id
        self.date = date
        self.dayOfWeek = dayOfWeek
        self.namedDayOfWeek = namedDayOfWeek
        
        if time != nil{
            self.time = time
        }
        else{
            self.time = nil
        }
        
        if units != nil{
            self.units = units
        }
        else{
            self.units = nil
        }
    }
    
    var description:String{
        return "\(namedDayOfWeek) (\(date.description))"
    }
    
    // DictionaryConvertible protocol methods
    required convenience init?(dict: NSDictionary) {
        guard let id = dict["id"] as? Int,
            let dateDict = dict["date"] as? NSDictionary,
            let dayOfWeek = dict["dayOfWeek"] as? Int,
            let namedDayOfWeek = dict["namedDayOfWeek"] as? String
            else {
                return nil
        }
        
        guard let date = MyDate(dict: dateDict) else {return nil}
        
        var time:TimeManager?
        if let timeDict = dict["time"] as? NSDictionary{
            time = TimeManager(dict: timeDict)
        }
        
//        var units:[TimeUnit]?
//        if let unitsDictArray = dict["units"] as? [String:NSDictionary]{
//            units = []
//            for unitDict in unitsDictArray.values{
//                units?.append(TimeUnit(dict: unitDict)!)
//            }
//        }
        
        var units:[TimeUnit]?
        if let unitsDictArray = dict["units"] as? [NSDictionary]{
            units = []
            for unitDict in unitsDictArray{
                if let unit = TimeUnit(dict: unitDict){
                    units?.append(unit)
                }
            }
        }
        
        self.init(id: id, date: date, dayOfWeek: dayOfWeek, namedDayOfWeek: namedDayOfWeek, time: time, units: units)
    }
    
    var dict:NSDictionary {
        var dictionary:[String:Any] = ["id":id,
                                       "date": date.dict,
                                       "dayOfWeek":dayOfWeek,
                                       "namedDayOfWeek":namedDayOfWeek]
        
        if self.time != nil{
            dictionary["time"] = time?.dict
        }
        
        
//        if self.units != nil{
//            var unitsDict:[String:Any] = [:]
//            for unit in units!{
//                unitsDict["\(unit.index)"] = unit.dict
//            }
//            dictionary["units"] = NSDictionary(dictionary: unitsDict)
//        }
        
        
        if self.units != nil{
            var unitsDict:[NSDictionary] = []
            for unit in units!{
                unitsDict.append(unit.dict)
            }
            dictionary["units"] = unitsDict
        }
        
        return NSDictionary(dictionary: dictionary)
    }
}
