//
//  APDate.swift
//  BarberShop
//
//  Created by Daniel Radshun on 14/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class AllDates {
    var barber:Int
    var dates:[AppointmentDate]
    var availebleDays:[AppointmentDate]
    var notificationDays:[AppointmentDate]?
    
    var daysToShow:Int{
        return availebleDays.count + (notificationDays?.count ?? 0)
    }
    
    init(barber:Int, availebleDays:[AppointmentDate], notificationDays:[AppointmentDate]?) {
        self.barber = barber
        dates = []
        self.availebleDays = availebleDays
        if notificationDays != nil{
            self.notificationDays = notificationDays
        }
        
        dates += availebleDays

        if notificationDays != nil{
            dates += notificationDays!
        }
    }
    
    func setTimeForNotificationDay(dateIndex:Int, timeAvailible:TimeManager){
        guard let notificationDay = notificationDays?[dateIndex] else {return}
        notificationDay.time! = timeAvailible
        
        availebleDays.append(notificationDay)
        notificationDays!.remove(at: dateIndex)
    }
    
    
    func getDisplayedDates() -> [AppointmentDate]{
        return dates
    }
}
