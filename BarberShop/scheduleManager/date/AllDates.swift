//
//  APDate.swift
//  BarberShop
//
//  Created by Daniel Radshun on 14/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class AllDates:DictionaryConvertible {
    var barberId:Int
    var dates:[AppointmentDate]
    var availableDays:[AppointmentDate]
    var notificationDays:[AppointmentDate]?
    
    var daysToShow:Int{
        return availableDays.count + (notificationDays?.count ?? 0)
    }
    
    init(barberId:Int, availableDays:[AppointmentDate], notificationDays:[AppointmentDate]?) {
        self.barberId = barberId
        dates = []
        self.availableDays = availableDays
        if notificationDays != nil{
            self.notificationDays = notificationDays
        }
        
        dates += availableDays

        if notificationDays != nil{
            dates += notificationDays!
        }
    }
    
    // DictionaryConvertible protocol methods
    required convenience init?(dict: NSDictionary) {
        guard let barberId = dict["barberId"] as? Int,
            let availableDaysDictArr = dict["availableDays"] as? [String:NSDictionary]
            else {
                return nil
        }
        
        var availableDaysArr:[AppointmentDate] = []
        for availableDaysDict in availableDaysDictArr.values{
            if let availableDays = AppointmentDate(dict: availableDaysDict){
                availableDaysArr.append(availableDays)
            }
            availableDaysArr = AllDates.sortDates(availableDaysArr)
        }
        
        var notificationDaysArr:[AppointmentDate]?
        if let notificationDaysDictArr = dict["notificationDays"] as? [String:NSDictionary]{
            notificationDaysArr = []
            for notificationDaysDict in notificationDaysDictArr.values{
                if let notificationDays = AppointmentDate(dict: notificationDaysDict){
                    notificationDaysArr!.append(notificationDays)
                }
            }
            notificationDaysArr = AllDates.sortDates(notificationDaysArr!)
        }
        
        self.init(barberId: barberId, availableDays: availableDaysArr, notificationDays: notificationDaysArr)
    }
    
    var dict:NSDictionary {
        var dictionary:[String:Any] = ["barberId":barberId]
        
        var availableDaysDict:[String:Any] = [:]
        for day in availableDays{
            availableDaysDict["\(day.id)"] = day.dict
        }
        dictionary["availableDays"] = NSDictionary(dictionary: availableDaysDict)
        
        if self.notificationDays != nil{
            var notificationDaysDict:[String:Any] = [:]
            for day in notificationDays!{
                notificationDaysDict["\(day.id)"] = day.dict
            }
            dictionary["notificationDays"] = NSDictionary(dictionary: notificationDaysDict)
        }
        
        return NSDictionary(dictionary: dictionary)
    }
    
    func setTimeForNotificationDay(dateIndex:Int, timeAvailible:TimeManager){
        guard let notificationDay = notificationDays?[dateIndex] else {return}
        notificationDay.time! = timeAvailible
        
        availableDays.append(notificationDay)
        notificationDays!.remove(at: dateIndex)
    }
    
    public static func sortDates(_ dates:[AppointmentDate]) -> [AppointmentDate]{
        return dates.sorted(by: { $0.date < $1.date })
    }
    
    func getDisplayedDates() -> [AppointmentDate]{
        return dates
    }
}
