//
//  Day.swift
//  BarberShop
//
//  Created by Daniel Radshun on 09/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

struct Day:CustomStringConvertible {
    var date:DayData
    var units:[AppointmentUnit]
    
    var description: String{
        return "\(date.date) -> \(units)"
    }
}
