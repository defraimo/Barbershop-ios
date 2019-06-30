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
    var freeTime:[TimeRange]
    
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
        var workingTime:[Time] = []
        var minutes = minMinutes
        var hours = minHour
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
            for time in freeTime{
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
            if isInRange{
                workingTime.append(Time(hours: hours, minutes: minutes))
            }
        }
        
        return workingTime
    }
    
//    init() {
//        barberTime = AppointmentTime()
//    }
    
    init() {
        minHour = 11
        maxHour = 19
        minMinutes = 30
        maxMinutes = 50
        intervals = 14
        freeTime = [TimeRange(fromTime: Time(hours: 12, minutes: 20), toTime: Time(hours: 13, minutes: 10)),
                    TimeRange(fromTime: Time(hours: 16, minutes: 0), toTime: Time(hours: 17, minutes: 0))]
    }
}
