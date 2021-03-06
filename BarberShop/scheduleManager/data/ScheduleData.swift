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
    
    init() {}
    
    func fetchScheduleFor(barber:Barber, complition: @escaping (_ schedule:ScheduleData) -> Void){
        var avialibleDays:[AppointmentDate] = []
        var notificationDays:[AppointmentDate] = []
        
        DAO.shared.loadScheduleFor(barberId: barber.id) { (allDates) in
            self.allDates = allDates
            avialibleDays = allDates.availableDays
            if let notifications = allDates.notificationDays{
                notificationDays = notifications
            }
            print("Schedule is loaded for barber number: ",barber.id)
            
            self.displayedDates = allDates.getDisplayedDates()
            
            self.avialibleDaysCount = avialibleDays.count
            self.notificationDaysCount = notificationDays.count
            
            complition(self)
        }

    }
    
    func getDisplayedDates() -> [AppointmentDate]{
        return displayedDates ?? []
    }
    
    func getDisplayTimeFor(dateIndex index:Int) -> [TimeUnit]{

        guard let date = displayedDates?[index].date else {return []}
        guard let allUnits = displayedDates?[index].units else {return []}
        
        var customDisplayedUnits:[TimeUnit] = []
        
        let current = CurrentDate()
        let currentTime = current.currentTime
        let isDateEquals = current.isCurrentDateEqauls(date: date)
        
        for i in 0..<allUnits.count{
            let unit = allUnits[i]
            if !isDateEquals && unit.isAvailable{
                customDisplayedUnits.append(unit)
            }
            else if unit.startTime > currentTime && isDateEquals && unit.isAvailable{
                customDisplayedUnits.append(unit)
            }
        }
        
        return customDisplayedUnits
    }
    
    func getUnitByIndex(timeUnits:[TimeUnit], index:Int) -> TimeUnit?{
        let dict = Dictionary(uniqueKeysWithValues: timeUnits.map{ ($0.index, $0) })
        return dict[index]
    }
    
    func getDisplayTimeUnitsWith(intervals:Int, forDateIndex index:Int) -> [TimeUnit]{
        guard let date = displayedDates?[index].date else {return []}
        //get all the units
        guard let allUnits = displayedDates?[index].units,
            let unitDuration = allUnits.first?.duration
            else {return []}
        
        var availableUnits:[TimeUnit] = []
        
        let current = CurrentDate()
        let currentTime = current.currentTime
        let isDateEquals = current.isCurrentDateEqauls(date: date)
        
        for i in 0..<allUnits.count{
            let unit = allUnits[i]
            if !isDateEquals && unit.isAvailable{
                availableUnits.append(unit)
            }
            else if unit.startTime > currentTime && isDateEquals && unit.isAvailable{
                availableUnits.append(unit)
            }
        }
        
        var customDisplayedUnits:[TimeUnit] = []
        
        //calc the number of units the new interval takes
        numberOfUnitsNeeded = Int(intervals / unitDuration)
        if numberOfUnitsNeeded == 0{
            numberOfUnitsNeeded = 1
        }
        
        for i in 0..<availableUnits.count{
            //check if there are enough units left
            if i + numberOfUnitsNeeded-1 < availableUnits.count{
                //make a var to check the next units
                var num = i
                //if isAvailible become false so the unit is accupaid
                var isAvailible = true
                
                //iterate to check forward all the units
                for _ in 0..<numberOfUnitsNeeded{
                    //check if the units are in the array limit and if the difference indexes between two following units is 1
                    if numberOfUnitsNeeded > 1 && num+1 < availableUnits.count &&
                        availableUnits[num+1].index - availableUnits[num].index != 1{
                        
                        isAvailible = false
                    }
                        
                    //if the units needed are out of time range make isAvailible false
                    else if num == availableUnits.count-1{
                        isAvailible = false
                    }
                    num += 1
                }
                //if the isAvailible stayed true so add it to the array of the units
                if isAvailible{
                    customDisplayedUnits.append(availableUnits[i])
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
                //if the counter go to the unitsNeededNum break the for lScheduleData        if counter == unitsNeededNum{
                    break
                }
            }
        
        //return the needed units
        return neededUnits
    }
    
}

