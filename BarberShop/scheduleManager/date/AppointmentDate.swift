//
//  AppDates.swift
//  BarberShop
//
//  Created by Daniel Radshun on 14/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

class AppointmentDate:CustomStringConvertible {
    var id:Int
    var date:MyDate
    var dayOfWeek:Int
    var namedDayOfWeek:String
    var time:TimeManager?
    
    init(id:Int, date:MyDate, dayOfWeek:Int, namedDayOfWeek:String, time:TimeManager?) {
        self.id = id
        self.date = date
        self.dayOfWeek = dayOfWeek
        self.namedDayOfWeek = namedDayOfWeek
        
        if time != nil{
            self.time = time
        }
        else{
            self.time = nil
        }
    }
    
    var description:String{
        return "\(namedDayOfWeek) (\(date.description))"
    }
}
