//
//  ManageTime.swift
//  BarberShop
//
//  Created by Daniel Radshun on 14/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class TimeManager:DictionaryConvertible{
    var id:Int
    var minTime:Time
    var maxTime:Time
    var intervals:Int
    var freeTime:[TimeRange]?
    
    init(id:Int, minTime:Time, maxTime:Time, intervals:Int, freeTime:[TimeRange]?) {
        self.id = id
        self.minTime = minTime
        self.maxTime = maxTime
        self.intervals = intervals
        self.freeTime = freeTime
    }
    
    
    // DictionaryConvertible protocol methods
    required convenience init?(dict: NSDictionary) {
        guard let id = dict["id"] as? Int,
            let minTimeDict = dict["minTime"] as? NSDictionary,
            let maxTimeDict = dict["maxTime"] as? NSDictionary,
            let intervals = dict["intervals"] as? Int else {return nil}
        
        guard let minTime = Time(dict: minTimeDict),
            let maxTime = Time(dict: maxTimeDict) else {return nil}
        
        var freeTime:[TimeRange]?
        if let freeTimeDictArray = dict["freeTime"] as? [NSDictionary] {
            freeTime = []
            for freeTimeDict in freeTimeDictArray{
                if let timeRange = TimeRange(dict: freeTimeDict){
                    freeTime?.append(timeRange)
                }
            }
        }
        
        self.init(id: id, minTime: minTime, maxTime: maxTime, intervals: intervals, freeTime: freeTime)
    }
    
    var dict:NSDictionary {
        var dictionary:[String:Any] = ["id": id,
                                       "minTime":minTime.dict,
                                       "maxTime":maxTime.dict,
                                       "intervals":intervals]
        
        if self.freeTime != nil{
            var freeTimeDict:[NSDictionary] = []
            for timeRange in freeTime!{
                freeTimeDict.append(timeRange.dict)
            }
            dictionary["freeTime"] = freeTimeDict
        }
        
        return NSDictionary(dictionary: dictionary)
    }
 
    
    func defineGlobalProperties(minTime:Time, maxTime:Time){
        self.minTime = minTime
        self.maxTime = maxTime
    }
    
    func defineGlobalInterval(minutes:Int){
        self.intervals = minutes
    }
    
    var workingHours:[Time]{
        return getWorkingHours()
    }
    
    private func getWorkingHours() -> [Time]{
        var workingTime:[Time] = []
        var minutes = minTime.minutes
        var hours = minTime.hours
        let maxMinutes = maxTime.minutes
        let maxHour = maxTime.hours
        
        var isInRange = true
        workingTime.append(Time(hours: hours, minutes: minutes))
        while true {
            minutes += intervals
            let additionalHours = Int(minutes / 60)
            minutes = minutes % 60
            if additionalHours + hours < maxHour{
                if additionalHours > 0{
                    hours += additionalHours
                }
                isInRange = true
            }
            else if additionalHours + hours == maxHour && minutes <= maxMinutes{
                hours += additionalHours
                isInRange = true
            }
            else{
                break
            }
            if freeTime != nil{
                for time in freeTime!{
                    if hours == time.fromTime.hours &&
                        minutes >= time.fromTime.minutes &&
                        hours <= time.toTime.hours{
                        isInRange = false
                    }
                    else if hours > time.fromTime.hours &&
                        hours < time.toTime.hours{
                        isInRange = false
                    }
                    else if hours == time.toTime.hours &&
                        minutes <= time.toTime.minutes{
                        isInRange = false
                    }
                }
            }
            if isInRange{
                workingTime.append(Time(hours: hours, minutes: minutes))
            }
        }
        
        return workingTime
    }
    
    func getDailyUnitsFor(date:MyDate) -> [TimeUnit]{
        var workingTime:[TimeUnit] = []
        var minutes = minTime.minutes
        var hours = minTime.hours
        let maxMinutes = maxTime.minutes
        let maxHour = maxTime.hours
        
        /*
        let current = CurrentDate()
        
        //check if the checked day if the current day
        if current.isCurrentDateEqauls(date: date){
            if current.currentHours > hours || current.currentHours == hours && current.currentMinutes > minutes{
                //set the min minutes and hours to the current time
                /*
                if (current.currentMinutes % intervals) * current.currentMinutes != current.currentMinutes{
                    minutes = ((current.currentMinutes % intervals) + 1) * intervals
                }
                else{
                    minutes = current.currentMinutes
                }
                */
                 minutes = current.currentMinutes
                hours = current.currentHours
            }
        }
        */
        
        var unitIndex = 0
        var isInRange = true
        workingTime.append(TimeUnit(user: nil, index: unitIndex, startTime: Time(hours: hours, minutes: minutes), duration: intervals, isAvailible: checkIfAvailible(unitIndex: unitIndex)))
        while true {
            unitIndex += 1
            minutes += intervals
            let additionalHours = Int(minutes / 60)
            minutes = minutes % 60
            if additionalHours + hours < maxHour{
                if additionalHours > 0{
                    hours += additionalHours
                }
                isInRange = true
            }
            else if additionalHours + hours == maxHour && minutes <= maxMinutes{
                hours += additionalHours
                isInRange = true
            }
            else{
                break
            }
            if freeTime != nil{
                for time in freeTime!{
                    if hours == time.fromTime.hours &&
                        minutes >= time.fromTime.minutes &&
                        hours <= time.toTime.hours{
                        isInRange = false
                    }
                    else if hours > time.fromTime.hours &&
                        hours < time.toTime.hours{
                        isInRange = false
                    }
                    else if hours == time.toTime.hours &&
                        minutes <= time.toTime.minutes{
                        isInRange = false
                    }
                }
            }
            if isInRange{
                workingTime.append(TimeUnit(user: nil, index: unitIndex, startTime: Time(hours: hours, minutes: minutes), duration: intervals, isAvailible: checkIfAvailible(unitIndex: unitIndex)))
            }
        }
        
        return workingTime
    }
    
    private func checkIfAvailible(unitIndex:Int) -> Bool{
        
        //------------------------
        //get it by id
        //------------------------
        //get from the data base
        //------------------------

        return true
    }
    
}
