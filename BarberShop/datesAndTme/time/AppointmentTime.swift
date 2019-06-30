//
//  AppointmentTime.swift
//  BarberShop
//
//  Created by Daniel Radshun on 23/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

struct AppointmentTime {
    var minHour:Int
    var maxHour:Int
    var minMinutes:Int
    var maxMinutes:Int
    var intervals:Int
    var workingTime:[String]
    
    init() {
        minHour = 0
        maxHour = 0
        minMinutes = 0
        maxMinutes = 0
        intervals = 0
        workingTime = []
    }
}
