//
//  AppointmentDay.swift
//  BarberShop
//
//  Created by Daniel Radshun on 23/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

struct AppDate:CustomStringConvertible, Equatable {
    var day:Int
    var month:Int
    var year:Int
    
    var description:String{
        return "\(day).\(month)"
    }
    
    //comparing func
    public static func ==(lhs: AppDate, rhs: AppDate) -> Bool{
        return
            lhs.day == rhs.day &&
            lhs.month == rhs.month &&
            lhs.year == rhs.year
    }
}
