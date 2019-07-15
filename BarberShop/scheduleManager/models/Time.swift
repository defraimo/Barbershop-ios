//
//  Time.swift
//  BarberShop
//
//  Created by Daniel Radshun on 28/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

struct Time:CustomStringConvertible,Hashable {
    var hours:Int
    var minutes:Int
    
    var description: String{
        if minutes < 10{
            return "\(hours) : 0\(minutes)"
        }
        return "\(hours) : \(minutes)"
    }
    
}

struct TimeRange {
    var fromTime:Time
    var toTime:Time
}
