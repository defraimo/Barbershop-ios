//
//  Appointment.swift
//  BarberShop
//
//  Created by Daniel Radshun on 23/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

struct Appointment:CustomStringConvertible {
    var barber:Barber?
    var client:String? //TO CHANGE!!!!!!
    var date:AppointmentDate?
    var units:[TimeUnit]?
    var servies:PriceModel?
    
    //empty init so we could set all the params by steps
    init() {}
    
    var description: String{
        return "\(barber?.name), \(client), \(date?.description), \(units?.description), \(servies?.servies) \(servies?.priceRange)"
    }
}
