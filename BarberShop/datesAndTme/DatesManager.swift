//
//  DatesOfBarber.swift
//  BarberShop
//
//  Created by Daniel Radshun on 23/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class DatesManager {
    private let barberName:String
    private let daysAvailable:Int
    private let additionalDays:Int
    private (set) var daysOff:[Int]?
    private (set) var datesOff:[Date]?
    
    init(barberName:String, daysAvailable:Int, additionalDays:Int) {
        self.daysAvailable = daysAvailable
        self.additionalDays = additionalDays
        self.barberName = barberName
    }
    
    var daysToShow:Int{
        return daysAvailable + additionalDays
    }
    
    func setDaysOff(days:[Int]){
        daysOff = days
    }
    
    func setDatesOff(dates:[Date]){
        datesOff = dates
    }
    
    func addDatesOff(dates:[Date]){
        if datesOff == nil{
            datesOff = []
        }
        datesOff! += dates
    }
    
    var namedAvialibleDays:[String]{
        let currentDate = CurrentDate()
        let currentDay = currentDate.currentDay - 1
        
        var allDays:[Int] = []
        
        //puts all the avialible days into array
        for day in currentDay..<(daysAvailable + currentDay){
            allDays.append(day % 7)
        }
        
        //takes out the off days from the avialible days array
        if daysOff != nil{
            allDays = Array(Set(allDays).subtracting(daysOff!))
//            for dayIndex in 0..<allDays.count{
//                for offday in daysOff!{
//                    if offday == allDays[dayIndex]{
//                        print(offday)
//                        allDays.remove(at: dayIndex)
//                    }
//                }
//            }
        }
        
        
        let namedDays = currentDate.namedDays
        
        var allDaysNamed:[String] = []
        for day in allDays{
            allDaysNamed.append(namedDays[day])
        }
        
        if allDays[0] == currentDay{
            allDaysNamed[0] = "היום"
        }
        if allDaysNamed.count > 1{
            if allDays[1] == currentDay+1{
                allDaysNamed[1] = "מחר"
            }
        }
        
        return allDaysNamed
    }
}
