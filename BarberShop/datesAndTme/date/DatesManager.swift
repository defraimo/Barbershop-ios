//
//  DatesOfBarber.swift
//  BarberShop
//
//  Created by Daniel Radshun on 23/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class DatesManager {
//    private let barberName:String
    private var daysAvailable:Int
    private var additionalDays:Int
    private (set) var daysOff:[Int]?
    private (set) var datesOff:[AppointmentDate]?
    
    init(/*barberName:String, */daysAvailable:Int, additionalDays:Int) {
        self.daysAvailable = daysAvailable
        self.additionalDays = additionalDays
//        self.barberName = barberName
    }
    
    func getAvialibleDays() -> Int{
        return daysAvailable
    }
    
    func setAvialibleDays(numberOfDays:Int){
        daysAvailable = numberOfDays
    }
    
    func setadditionalDays(numberOfDays:Int){
        additionalDays = numberOfDays
    }
    
    var daysToShow:Int{
        return daysAvailable + additionalDays
    }
    
    func setDaysOff(days:[Int]){
        daysOff = days
    }
    
    func addDatesOff(dates:[AppointmentDate]){
        if datesOff == nil{
            datesOff = []
        }
        datesOff! += dates
    }
    
    var namedDays:[PickerDates]{
        let currentDate = CurrentDate()
        let currentDay = currentDate.currentDay - 1
        
        //all the days that shown
        var allDays:[PickerDates] = []
        
        //the array of the days names
        let namedDays = currentDate.namedDays
        
        //puts all the avialible days into array
        for day in currentDay..<(daysToShow + currentDay){
            //divide by 7 to find the current week day
            let dayNumber = day % 7
            //use the func to find the date for the specific day
            let updatedDate = currentDate.addToCurrentDate(numberOfDays: day - currentDay)
            //append the new day to all days array
            allDays.append(PickerDates(dayOfWeek: dayNumber ,namedDayOfWeek: namedDays[dayNumber] , date: updatedDate, timeAvialible: nil))
        }
        
        //removes out the off days from the avialible days array
        if daysOff != nil{
            var dayIndex = 0
            while dayIndex < allDays.count-1{
                for offday in daysOff!{
                    //minus 1 from the day value becuase the method passes values from 1, and not from 0
                    if (offday - 1) == allDays[dayIndex].dayOfWeek{
                        allDays.remove(at: dayIndex)
                        if dayIndex <= daysAvailable{
                            daysAvailable -= 1
                        }
                        else{
                            additionalDays -= 1
                        }
                    }
                }
                dayIndex += 1
            }
        }
        
        //removes out the oof dates all the unavialible dates
        if datesOff != nil{
            var dayIndex = 0
            while dayIndex < allDays.count-1{
                for offdate in datesOff!{
                    if offdate == allDays[dayIndex].date{
                        allDays.remove(at: dayIndex)
                        if dayIndex <= daysAvailable{
                            daysAvailable -= 1
                        }
                        else{
                            additionalDays -= 1
                        }
                    }
                }
                dayIndex += 1
            }
        }
        
        //replacing the first days to "today" and "tommorow"
        if allDays[0].dayOfWeek == currentDay{
            allDays[0].namedDayOfWeek = "היום"
            if allDays.count > 1{
                if allDays[1].dayOfWeek == currentDay+1{
                    allDays[1].namedDayOfWeek = "מחר"
                }
            }
        }
        else if allDays[0].dayOfWeek == currentDay+1{
            allDays[0].namedDayOfWeek = "מחר"
        }
        
        //set the timeManager
        let timeRange = [TimeRange(fromTime: Time(hours: 13, minutes: 00), toTime: Time(hours: 14, minutes: 00))]
        let time = TimeManager(minHour: 11, minMinutes: 30, maxHour: 19, maxMinutes: 20, intervals: 36, freeTime: timeRange)
        
        //DO TO -> CHANGE TO "TIME"
        
        for index in 0..<daysAvailable{
            allDays[index].timeAvialible = time
        }
        
        
        return allDays
    }

}
