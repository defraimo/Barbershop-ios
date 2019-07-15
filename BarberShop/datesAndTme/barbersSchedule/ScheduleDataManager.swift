//
//  ScheduleDataManager.swift
//  BarberShop
//
//  Created by Daniel Radshun on 08/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class ScheduleDataManager {
    
    var availableUnits:[[AppointmentUnit]] = [[]]
    
    var days:[Day] = []
    
    init() {
        let barber1Dates = DatesManager(daysAvailable: 10, additionalDays: 7)
        barber1Dates.setDaysOff(days: [6,7])
        
        let barber1Time = TimeManage(minTime: Time(hours: 11, minutes: 30), maxTime: Time(hours: 19, minutes: 20), intervals: 20, freeTime: [TimeRange(fromTime: Time(hours: 13, minutes: 00), toTime: Time(hours: 14, minutes: 00))])
        
        for day in barber1Dates.namedDays{
            availableUnits.append(barber1Time.getDailyUnits(forDay: day))
        }
    }
    
    func printUnits(){
        for unit in availableUnits{
            for param in unit{
                print("\(param.duration) \(param.isAvailable)")
            }
        }
    }
    
    
    func initBarberSchedule(barberIndex index:Int, dates:DatesManager, availableTime:TimeManage){
        let barberDates = dates
        var allBarbers = AllBarbers.shared.allBarbers
        var days:[Day] = []
                
        let barberTime = availableTime
        
        for day in barberDates.namedDays{
            let availableUnits = barberTime.getDailyUnits(forDay: day)
            let day = Day(date: day, units: availableUnits)
            days.append(day)
        }
        
        allBarbers[index].daysSchedule = days
        }
}
