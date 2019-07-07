//
//  TimeManager.swift
//  BarberShop
//
//  Created by Daniel Radshun on 27/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class TimeManager{
    var minHour:Int
    var maxHour:Int
    var minMinutes:Int
    var maxMinutes:Int
    var intervals:Int
    var freeTime:[TimeRange]?
    var serviesDuration:Int?
    
    func defineGlobalProperties(minHours:Int, minMinutes:Int, maxHours:Int, maxMinutes:Int){
        self.minHour = minHours
        self.maxHour = maxHours
        self.minMinutes = minMinutes
        self.maxMinutes = maxMinutes
    }
    
    func defineGlobalInterval(minutes:Int){
        self.intervals = minutes
    }
    
    var workingHours:[Time]{
        return getWorkingHours(withIntervals: intervals)
    }
    
    private func getWorkingHours(withIntervals intervals:Int) -> [Time]{
        var workingTime:[Time] = []
        var minutes = minMinutes
        var hours = minHour
        
//        for _ in 0..<index{
//            minutes = (minutes + intervals)%60
//            hours += Int((minutes + intervals)/60)
//        }
        
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
    
    /*
    var hoursForServies:[Time]{
        let normalIntervals = getWorkingHours(withIntervals: intervals, startFromIndex: 0)
        
        var timesToLoop = Int(serviesDuration! / intervals)
        if serviesDuration! / intervals - Int(serviesDuration! / intervals) > 0{
            timesToLoop += 1
        }
        
        var containsTime:[[Time]] = [[]]
        
        for index in 0..<timesToLoop{
            let serviesTimeIntervals = getWorkingHours(withIntervals: serviesDuration!, startFromIndex: index)
            containsTime.append(normalIntervals.filter{serviesTimeIntervals.contains($0)})
        }
        
//        let serviesTimeIntervals0 = getWorkingHours(withIntervals: serviesDuration!, startFromIndex: 0)
//        let serviesTimeIntervals1 = getWorkingHours(withIntervals: serviesDuration!, startFromIndex: 1)
//
//        let containsTime0 = normalIntervals.filter{serviesTimeIntervals0.contains($0)}
//        let containsTime1 = normalIntervals.filter{serviesTimeIntervals1.contains($0)}
        
//        var unique = Array(Set(containsTime0 + containsTime1))
        
        var unique:[Time] = []
        
        for time in containsTime{
            unique = Array(Set(unique + time))
        }
        
        unique.sort { (t1, t2) -> Bool in
            if t1.hours == t2.hours{
                return t1.minutes < t2.minutes
            }
            return t1.hours < t2.hours
        }
        
        return unique
    }
 
    
    func setServiesDuration(_ duration:Int) -> [Time]{
        self.serviesDuration = duration
        return hoursForServies
    }
 
 */
    
    init(minHour:Int, minMinutes:Int, maxHour:Int, maxMinutes:Int, intervals:Int, freeTime:[TimeRange]?) {
        self.minHour = minHour
        self.minMinutes = minMinutes
        self.maxHour = maxHour
        self.maxMinutes = maxMinutes
        self.intervals = intervals
        self.freeTime = freeTime
    }
    
}
