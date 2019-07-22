//
//  ManageTime.swift
//  BarberShop
//
//  Created by Daniel Radshun on 14/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class TimeManager{
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
        
        let current = CurrentDate()
        
        if date.day == current.currentMonthDay && date.month == current.currentMonth && date.year == current.currentYear{
            minutes = current.currentMinutes
            hours = current.currentHours
        }
        
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
