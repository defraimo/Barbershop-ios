//
//  PickerDates.swift
//  BarberShop
//
//  Created by Daniel Radshun on 24/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

struct DayData:CustomStringConvertible {
    var dayOfWeek:Int
    var namedDayOfWeek:String
    var date:MyDate
    var timeAvialible:TimeManage?
    
    var description:String{
        return "\(namedDayOfWeek) (\(date.description))"
    }
}