//
//  Date.swift
//  BarberShop
//
//  Created by Daniel Radshun on 14/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

struct MyDate:CustomStringConvertible, Equatable {
    var day:Int
    var month:Int
    var year:Int
    
    var description:String{
        return "\(day).\(month)"
    }
    
    //comparing func
    public static func ==(lhs: MyDate, rhs: MyDate) -> Bool{
        return
            lhs.day == rhs.day &&
                lhs.month == rhs.month &&
                lhs.year == rhs.year
    }
}
