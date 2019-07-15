//
//  TimeUnit.swift
//  BarberShop
//
//  Created by Daniel Radshun on 14/07/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

struct TimeUnit:CustomStringConvertible {
    var user:String?
    var index:Int
    var startTime:Time
    var duration:Int
    var isAvailible:Bool
    
    var description: String{
        return startTime.description
    }
}
