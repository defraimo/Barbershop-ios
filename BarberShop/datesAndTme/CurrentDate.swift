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
    
    let namedDays = [
                                            "ראשון",
                                            "שני",
                                            "שלישי",
                                            "רביעי",
                                            "חמישי",
                                            "שישי",
                                            "שבת"
                    ]
    
    init() {
        date = Date()
        calendar = Calendar.current
    }
}
