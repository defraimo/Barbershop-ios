//
//  CurrentDate.swift
//  BarberShop
//
//  Created by Daniel Radshun on 23/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class CurrentDate{
    private let date:Date
    private let calendar:Calendar
    var currentYear:Int{
        return calendar.component(.year, from: date)
    }
    var currentMonth:Int{
        return calendar.component(.month, from: date)
    }
    var currentMonthDay:Int {
        return calendar.component(.day, from: date)
    }
    var currentDay:Int{
        return calendar.component(.weekday, from: date)
    }
    func addToCurrentDate(numberOfDays:Int) -> AppointmentDate{
        let newDate = calendar.date(byAdding: .day, value: numberOfDays, to: date)
        return AppointmentDate(day: calendar.component(.day, from:newDate!), month: calendar.component(.month, from:newDate!), year: calendar.component(.year, from:newDate!))
    }
    
    let namedDays = [
                                            "יום ראשון",
                                            "יום שני",
                                            "יום שלישי",
                                            "יום רביעי",
                                            "יום חמישי",
                                            "יום שישי",
                                            "יום שבת"
    ]
    
    init() {
        date = Date()
        calendar = Calendar.current
    }
}
