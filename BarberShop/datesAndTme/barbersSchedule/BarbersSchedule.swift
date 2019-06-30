//
//  BarbersSchedule.swift
//  BarberShop
//
//  Created by Daniel Radshun on 25/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class BarbersSchedule{
    var allBarbersShedule:[DatesManager] = []
    
    init() {
        for barber in AllBarbers().allBarbers{
            allBarbersShedule.append((barber.schedule ?? nil)!)
        }
    }
}
