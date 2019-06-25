//
//  BarbersSchedule.swift
//  BarberShop
//
//  Created by Daniel Radshun on 25/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class BarbersSchedule{
    var danielDays:DatesManager
    
    var avialibleDays:Int{
        return danielDays.getAvialibleDays()
    }
    
    var allDays:[PickerDates]{
        return danielDays.namedDays
    }
    
    init() {
        danielDays =
        DatesManager(barberName: "daniel", daysAvailable: 10, additionalDays: 7)
        danielDays.setDaysOff(days: [6,7])
        danielDays.addDatesOff(dates: [AppointmentDate(day: 26, month: 6, year: 2019)])
    }
}
