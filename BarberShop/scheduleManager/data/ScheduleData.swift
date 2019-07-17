//
//  DatesAndTimeData.swift
//  BarberShop
//
//  Created by Daniel Radshun on 14/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class ScheduleData{
    var allDates:AllDates?
    var displayedDates:[AppointmentDate]?
    var barber:Barber?
    var avialibleDaysCount:Int = 0
    var notificationDaysCount:Int = 0
    
    var numberOfUnitsNeeded = 1
    
    init(barber:Barber) {
        var avialibleDays:[AppointmentDate] = []
        var notificationDays:[AppointmentDate] = []
        let currentDay = CurrentDate().currentMonthDay
        
        for i in 0..<7{
            //after getting from data base
            let timeAvailible = TimeManager(id: 14072019, minTime: Time(hours: 11, minutes: 30), maxTime: Time(hours: 19, minutes: 0), intervals: 20, freeTime: [TimeRange(fromTime: Time(hours: 13, minutes: 0), toTime: Time(hours: 14, minutes: 0))])
            
            
            avialibleDays.append(AppointmentDate(id: 14072019, date: MyDate(day: currentDay+i, month: 7, year: 2019), dayOfWeek: i, namedDayOfWeek: CurrentDate.namedDays[i%7], time:timeAvailible))
        }
        
        for i in 7..<12{
            //after getting from data base
            notificationDays.append(AppointmentDate(id: 14072019, date: MyDate(day: currentDay+i, month: 7, year: 2019), dayOfWeek: i, namedDayOfWeek: CurrentDate.namedDays[i%7], time:nil))
        }
        
        //get the barber from the data base
        allDates = AllDates(barber: barber.id, availebleDays: avialibleDays, notificationDays: notificationDays)
        
        displayedDates = allDates?.getDisplayedDates()
        
        
        avialibleDaysCount = avialibleDays.count
        notificationDaysCount = notificationDays.count
        
        
        let units = displayedDates?[0].time?.getDailyUnits()
        
    }
    
    func getDisplayedDates() -> [AppointmentDate]{
        return displayedDates ?? []
    }
    
    func getDisplayTimeFor(dateIndex index:Int) -> [TimeUnit]{
        //-------------------
        //change index to id
        //-------------------
        guard let allUnits = displayedDates?[index].time?.getDailyUnits() else {return []}
        
        var customDisplayedUnits:[TimeUnit] = []
        
        for i in 0..<allUnits.count{
            if allUnits[i].isAvailible{
                customDisplayedUnits.append(allUnits[i])
            }
        }
        
        return customDisplayedUnits
    }
    
    func getUnitByIndex(timeUnits:[TimeUnit], index:Int) -> TimeUnit?{
        let dict = Dictionary(uniqueKeysWithValues: timeUnits.map{ ($0.index, $0) })
        return dict[index]
    }
    
    func getDisplayTimeUnitsWith(intervals:Int, forDateIndex index:Int) -> [TimeUnit]{
        //get all the units
        guard let allUnits = displayedDates?[index].time?.getDailyUnits(),
                let unitDuration = allUnits.first?.duration
            else {return []}
        
        var customDisplayedUnits:[TimeUnit] = []
        
        //calc the number of units the new interval takes
        numberOfUnitsNeeded = Int(intervals / unitDuration)
        if numberOfUnitsNeeded == 0{
            numberOfUnitsNeeded = 1
        }
        
        for i in 0..<allUnits.count{
            //check if there are enough units left
            if i + numberOfUnitsNeeded-1 < allUnits.count{
                //make a var to check the next units
                var num = i
                //if isAvailible become false so the unit is accupaid
                var isAvailible = true
                //iterate to check forward all the units
                for _ in 0..<numberOfUnitsNeeded{
                    //check if the units are in the array limit and if the difference indexes between two following units is 1
                    if num+1 < allUnits.count &&
                        allUnits[num+1].index - allUnits[num].index != 1{
                        
                        isAvailible = false
                    }
                    //if the unit is availible so make isAvailible false
                    else if allUnits[num].isAvailible == false{
                        isAvailible = false
                    }
                    //if the units needed are out of time range make isAvailible false
                    else if num == allUnits.count-1{
                        isAvailible = false
                    }
                    num += 1
                }
                //if the isAvailible stayed true so add it to the array of the units
                if isAvailible{
                    customDisplayedUnits.append(allUnits[i])
                }
            }
        }
        
        return customDisplayedUnits
    }
    
    func getUnitsNeededForServies(date:Int ,chosenUnit:TimeUnit, unitsNeededNum:Int) -> [TimeUnit]{
        //get all the units before removing the ones that don't have enought intervals
        let allUnits = getDisplayTimeFor(dateIndex: date)
        var neededUnits:[TimeUnit] = []
        //bool to know if it needs to append the next units after the chosen one
        var include = false
        //to count until unitsNeededNum so the currect num of units will be added
        var counter = 0
        for unit in allUnits{
            //check to which unit the chosen unit equals
            if unit == chosenUnit{
                //if equals append to neededUnits array
                neededUnits.append(unit)
                //know to include the next units by the needed number
                include = true
            }
            //if the unit before was equal so included bool is true
            else if include{
                //if the unitsNeededNum so it doesn't need to append more
                if unitsNeededNum != 1{
                    neededUnits.append(unit)
                }
                //promote the counter
                counter += 1
                //if the counter go to the unitsNeededNum break the for loop
                if counter == unitsNeededNum{
                    break
                }
            }
        }
        //return the needed units
        return neededUnits
    }
    
    //when pressing the last "הזמן"
    func checkIfUnitsStillAvailible(barber:Barber, dateId:Int, unitsIndex:[Int]) -> Bool{
        //check from the data base
        return true
    }
    
    func makeAnAppoinment(_ appointment:Appointment){
        //write it to the data base
    }
    
}
