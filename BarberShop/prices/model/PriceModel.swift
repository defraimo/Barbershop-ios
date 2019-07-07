//
//  PriceModel.swift
//  BarberShop
//
//  Created by Daniel Radshun on 17/06/2019.
//  Copyright © 2019 Neighbors. All rights reserved.
//

import Foundation

struct PriceModel {
    var servies:String
    var priceRange:PriceRange
    var duration:Int?
    var barbers:[Barber]
    
    init(servies:String, priceRange:PriceRange, duration:Int?, barbers:[Barber]?) {
        self.servies = servies
        self.priceRange = priceRange
        self.duration = duration
        if barbers != nil{
            self.barbers = barbers!
        }
        else{
            self.barbers = AllBarbers.shared.allBarbers
        }
    }
}

struct PriceRange:CustomStringConvertible {
    var lowestPrice:Int
    var heighestPrice:Int?
    
    var description: String{
        if heighestPrice != nil{
            return "\(lowestPrice)₪ - \(heighestPrice!)₪"
        }
        else{
            return "\(lowestPrice)₪"
        }
    }
}
